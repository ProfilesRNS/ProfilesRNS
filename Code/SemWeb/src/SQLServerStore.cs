//#define CATCHEXCEPTIONS

using System;
using System.Collections;
using System.Reflection;

using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Configuration;


[assembly: AssemblyTitle("SQLServerStore - A SQL Server Store for SemWeb")]
[assembly: AssemblyCopyright("Copyright (c) 2008 Khaled Hammouda <khaledh@gmail.com>\n\nBased on other SemWeb SQLStore implementations,\nCopyright (c) 2006 Joshua Tauberer <http://razor.occams.info>\nreleased under the GPL.")]
[assembly: AssemblyDescription("A SQL Server Store for SemWeb")]

namespace SemWeb.Stores
{

    public class SQLServerStore : SQLStore
    {

        const int MAX_URI_LENGTH = 400; // this max is to allow creating an index on the uri value
        // (max key size for index is 900; note that each nvarchar is 2 bytes)

        SqlConnection connection;
        string connectionString;
        Version version;

        static bool Debug = System.Environment.GetEnvironmentVariable("SEMWEB_DEBUG_SQLSERVER") != null;

        public SQLServerStore(string connectionString, string table)
            : base(table)
        {
            this.connectionString = connectionString;
        }

        protected override bool HasUniqueStatementsConstraint { get { return true; } }
        protected override string InsertIgnoreCommand { get { return null; } }
        protected override bool SupportsInsertCombined { get { return false; } }
        protected override bool SupportsSubquery { get { return true; } }
        protected override bool SupportsViews { get { return true; } }
        protected override bool SupportsLimitClause { get { return false; } }
        protected override int MaximumUriLength { get { return MAX_URI_LENGTH; } }

        // SQL Server-specific
        internal protected bool SupportsVarCharMax { get { return version > new Version(8, 0); } }

        protected override void CreateNullTest(string column, System.Text.StringBuilder command)
        {
            command.Append(column);
            command.Append(" IS NULL");
        }

        protected override void CreateLikeTest(string column, string match, int method, System.Text.StringBuilder command)
        {
            command.Append(column);
            command.Append(" LIKE N'");
            if (method == 1 || method == 2) command.Append("%"); // contains or ends-with
            EscapedAppend(command, match, true);
            if (method != 2) command.Append("%"); // contains or starts-with
            command.Append("' ESCAPE '\\'");
        }

        protected override void EscapedAppend(StringBuilder b, string str)
        {
            EscapedAppend(b, str, false);
        }

        private void EscapedAppend(StringBuilder b, string str, bool forLike)
        {
            if (!forLike) { b.Append('N'); b.Append('\''); }
            for (int i = 0; i < str.Length; i++)
            {
                char c = str[i];
                switch (c)
                {
                    case '\'':
                        b.Append(c);
                        b.Append(c);
                        break;

                    case '%':
                    case '_':
                        if (forLike)
                            b.Append('\\');
                        b.Append(c);
                        break;

                    default:
                        b.Append(c);
                        break;
                }
            }
            if (!forLike) b.Append('\'');
        }

        public override void Close()
        {
            base.Close();
            if (connection != null)
                connection.Close();
        }

        private void Open()
        {
            if (connection != null)
                return;
            SqlConnection c = new SqlConnection(connectionString);
            c.Open();
            connection = c; // only set field if open was successful

            using (IDataReader reader = RunReader("SELECT CAST(SERVERPROPERTY('productversion') AS VARCHAR)"))
            {
                reader.Read();
                version = new Version(reader.GetString(0));
            }
        
        }


        public int GetCommandTimeout()
        {
            return Convert.ToInt32(ConfigurationSettings.AppSettings["COMMANDTIMEOUT"]);

        }


#if !CATCHEXCEPTIONS

        protected override void RunCommand(string sql)
        {
            Open();
            if (Debug) Console.Error.WriteLine(sql);
            using (SqlCommand cmd = new SqlCommand(sql, connection))
            {
                cmd.CommandTimeout = this.GetCommandTimeout();
                cmd.ExecuteNonQuery();
            }
        }

        protected override object RunScalar(string sql)
        {
            Open();
            using (SqlCommand cmd = new SqlCommand(sql, connection))
            {
                cmd.CommandTimeout = this.GetCommandTimeout();
                object ret = null;
                using (IDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        ret = reader[0];
                    }
                }
                if (Debug) Console.Error.WriteLine(sql + " => " + ret);
                return ret;
            }
        }

        protected override IDataReader RunReader(string sql)
        {
            if (sql.ToUpper().Contains("GROUP BY"))
            {

                sql = sql.Remove(sql.IndexOf("GROUP BY"));
            }

            Open();
            if (Debug) Console.Error.WriteLine(sql);
            using (SqlCommand cmd = new SqlCommand(sql, connection))
            {

		cmd.CommandTimeout = this.GetCommandTimeout();
                return cmd.ExecuteReader();
            }
        }

#else
        		
        protected override void RunCommand(string sql) {
			Open();
			try {
				if (Debug) Console.Error.WriteLine(sql);
				using (SqlCommand cmd = new SqlCommand(sql, connection))
                    cmd.CommandTimeout = this.GetCommandTimeout();
					cmd.ExecuteNonQuery();
			} catch (Exception e) {
				Console.WriteLine(sql);
				throw e;
			}
		}
		
		protected override object RunScalar(string sql) {
			Open();
			try {
				using (SqlCommand cmd = new SqlCommand(sql, connection)) {
					object ret = null;
                        cmd.CommandTimeout = this.GetCommandTimeout();
					using (IDataReader reader = cmd.ExecuteReader()) {
						if (reader.Read()) {
							ret = reader[0];
						}
					}
					if (Debug) Console.Error.WriteLine(sql + " => " + ret);
					return ret;
				}
			} catch (Exception e) {
				Console.WriteLine(sql);
				throw e;
			}
		}

		protected override IDataReader RunReader(string sql) {
			Open();
			try {
				if (Debug) Console.Error.WriteLine(sql);
				using (SqlCommand cmd = new SqlCommand(sql, connection)) {
					return cmd.ExecuteReader();
				}
			} catch (Exception e) {
				Console.WriteLine(sql);
				throw e;
			}
		}

		
#endif

        protected override void BeginTransaction()
        {
            // disable indexes to speed up bulk inserts
            //RunCommand( "ALTER INDEX [predicate_index] ON " + TableName + "_statements DISABLE" );
            //RunCommand( "ALTER INDEX [object_index] ON " + TableName + "_statements DISABLE" );
            //RunCommand( "ALTER INDEX [meta_index] ON " + TableName + "_statements DISABLE" );
        }

        protected override void EndTransaction()
        {
            // rebuild indexes. note that if bulk insert was aborted before calling EndTransaction(),
            // indexes will remain disabled - not good!
            //RunCommand( "ALTER INDEX [predicate_index] ON " + TableName + "_statements REBUILD" );
            //RunCommand( "ALTER INDEX [object_index] ON " + TableName + "_statements REBUILD" );
            //RunCommand( "ALTER INDEX [meta_index] ON " + TableName + "_statements REBUILD" );
        }

        protected override void CreateTable()
        {
            //foreach( string cmd in GetCreateTableCommands( TableName ) ) {
            //    try {
            //        RunCommand( cmd );
            //    } catch( Exception e ) {
            //        if( Debug )
            //            Console.Error.WriteLine( e );
            //    }
            //}
        }

        protected override void CreateIndexes()
        {
            //foreach( string cmd in GetCreateIndexCommands( TableName ) ) {
            //    try {
            //        RunCommand( cmd );
            //    } catch( Exception e ) {
            //        if( Debug )
            //            Console.Error.WriteLine( e );
            //    }
            //}
        }

        //internal static string[] GetCreateTableCommands(string table) {

        //    //string textColumnType = "NTEXT";
        //    //if( SupportsVarCharMax ) {
        //    //    textColumnType = "NVARCHAR(MAX)";
        //    //}

        //    string textColumnType = "NVARCHAR(4000)";

        //    return new string[] {
        //        "CREATE TABLE " + table + "_statements" +
        //        "(subject INT NOT NULL, predicate INT NOT NULL, objecttype INT NOT NULL, object INT NOT NULL, meta INT NOT NULL);",

        //        "CREATE TABLE " + table + "_literals" +
        //        "(id INT NOT NULL, value " + textColumnType + " COLLATE Latin1_General_BIN2 NOT NULL, language NVARCHAR(255) COLLATE Latin1_General_BIN2, datatype NVARCHAR(255) COLLATE Latin1_General_BIN2, hash NCHAR(28), PRIMARY KEY(id));",

        //        "CREATE TABLE " + table + "_entities" +
        //        "(id INT NOT NULL, value NVARCHAR(" + MAX_URI_LENGTH + ") COLLATE Latin1_General_BIN2 NOT NULL, PRIMARY KEY(id));"
        //    };
        //}

        //internal static string[] GetCreateIndexCommands( string table ) {
        //    return new string[] {
        //        // the "WITH (IGNORE_DUP_KEY = ON)" part in the following index drops duplicate keys during insert operations
        //        // .. it is similar to the "INSERT IGNORE" mechanism in MySQL.
        //        "CREATE UNIQUE CLUSTERED INDEX subject_full_index ON " + table + "_statements(subject, predicate, object, meta, objecttype) WITH (IGNORE_DUP_KEY = ON);",
        //        "CREATE INDEX predicate_index ON " + table + "_statements(predicate, object);",
        //        "CREATE INDEX object_index ON " + table + "_statements(object);",
        //        "CREATE INDEX meta_index ON " + table + "_statements(meta);",

        //        "CREATE UNIQUE INDEX literal_index ON " + table + "_literals(hash);",
        //    //	"CREATE INDEX literal_value_index ON " + table + "_literals(value);",
        //        "CREATE UNIQUE INDEX entity_index ON " + table + "_entities(value) INCLUDE id WITH (IGNORE_DUP_KEY = ON);"
        //        };
        //}

    }
}
