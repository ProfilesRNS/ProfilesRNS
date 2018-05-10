using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
//using System.Reflection;
using System.Diagnostics;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DevelopmentBase
{
    public abstract class DALBase
    {

        protected abstract string ConnectionStringQuery { get;}
        protected abstract string ConnectionStringEdit { get;}
        protected abstract string ProviderName { get;}

        protected const string FriendlyExceptionMessage = "A database error occurred.";

        public List<DbCommand> cmds { get; set; }

        protected void AddParam(ref DbCommand cmd, string paramName)
        {
            DbParameter Parm;
            Parm = cmd.CreateParameter();
            Parm.ParameterName = paramName;
            cmd.Parameters.Add(Parm);
        }
        protected void AddParam(ref DbCommand cmd, string paramName, object paramValue)
        {
            DbParameter Parm;
            Parm = cmd.CreateParameter();
            Parm.ParameterName = paramName;
            if (paramValue == null) { Parm.Value = DBNull.Value; }
            else { Parm.Value = paramValue; }
            cmd.Parameters.Add(Parm);
        }

        protected int? GetNullableDBIntValue(object DataRowValue)
        {
            if (DBNull.Value.Equals(DataRowValue))
            {
                return default(int?);
            }
            return int.Parse(DataRowValue.ToString()) as int?; 
        }

        protected bool? GetNullableDBBoolValue(object DataRowValue)
        {
            if (DBNull.Value.Equals(DataRowValue))
            {
                return default(bool?);
            }
            return DataRowValue as bool?;
        }

        protected string GetNullableDBStringValue(object DataRowValue)
        {
            if (DBNull.Value.Equals(DataRowValue))
            {
                return default(string);
            }
            return DataRowValue as string;
        }

        protected DateTime? GetNullableDBDateValue(object DataRowValue)
        {
            if (DBNull.Value.Equals(DataRowValue))
            {
                return default(DateTime?);
            }
            return DataRowValue as DateTime?;
        }


        protected DbProviderFactory Provider()
        {
            return DbProviderFactories.GetFactory(ProviderName);
        }
        
        protected DataTable FillTable(string StoredProcedureName)
        {
            DbCommand cmd = Provider().CreateCommand();
            cmd.CommandText = StoredProcedureName;
            return FillTable(cmd, FriendlyExceptionMessage, false);
        }

        protected DataTable FillTable(string StoredProcedureName, string ParamName, object ParamValue)
        {
            DbCommand cmd = GetCommand(StoredProcedureName);
            AddParam(ref cmd, ParamName, ParamValue);
            return FillTable(cmd, FriendlyExceptionMessage, false);
        }

        protected DataTable FillTable(string StoredProcedureName, string ParamName1, object ParamValue1, string ParamName2, object ParamValue2)
        {
            DbCommand cmd = GetCommand(StoredProcedureName);
            AddParam(ref cmd, ParamName1, ParamValue1);
            AddParam(ref cmd, ParamName2, ParamValue2);
            return FillTable(cmd, FriendlyExceptionMessage, false);
        }

        protected DataTable FillTable(DbCommand cmd)
        {
            return FillTable(cmd, FriendlyExceptionMessage, false);
        }

        protected DataTable FillTable(DbCommand cmd, string CustomErrorMsg)
        {
            return FillTable(cmd, CustomErrorMsg, false);
        }

        private DataTable FillTable(DbCommand cmd, string CustomErrorMsg, bool placeHolder)
        {
            DataTable dataTable = new DataTable();

            DbConnection Conn = Provider().CreateConnection();
            Conn.ConnectionString = ConnectionStringQuery;

            using (Conn)
            {
                if ((Conn.State == ConnectionState.Closed))
                {
                    Conn.Open();
                }

                using (cmd)
                {
                    try
                    {
                        cmd.Connection = Conn;
                        DbDataReader rdr = cmd.ExecuteReader();
                        dataTable.Load(rdr, LoadOption.Upsert);
                        rdr.Close();
                    }
                    catch (InvalidOperationException ex)
                    {
                        foreach (DbParameter Param in cmd.Parameters)
                        {
                            if ((Param.Direction == ParameterDirection.Output) || (Param.Direction == ParameterDirection.InputOutput))
                            {
                                HandleError(new StackTrace().GetFrame(2).GetMethod().Name + (":" + cmd.CommandText), CustomErrorMsg, ex);
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        HandleError(new StackTrace().GetFrame(1).GetMethod().Name + (":" + cmd.CommandText), CustomErrorMsg, ex);
                    }
                }
            }
            return dataTable;
        }

        protected DataSet FillDataSet(DbCommand cmd, string CustomErrorMsg, params string[] tables)
        {
            DataSet dataset = new DataSet();

            DbConnection Conn = Provider().CreateConnection();
            Conn.ConnectionString = ConnectionStringQuery;

            using (Conn)
            {
                if ((Conn.State == ConnectionState.Closed))
                {
                    Conn.Open();
                }

                using (cmd)
                {
                    try
                    {
                        cmd.Connection = Conn;
                        //DataSet ds = new DataSet();
                        DbDataReader rdr = cmd.ExecuteReader();
                        dataset.Load(rdr, LoadOption.Upsert, tables);
                        rdr.Close();
                    }
                    catch (InvalidOperationException ex)
                    {
                        foreach (DbParameter Param in cmd.Parameters)
                        {
                            if ((Param.Direction == ParameterDirection.Output) || (Param.Direction == ParameterDirection.InputOutput))
                            {
                                HandleError(new StackTrace().GetFrame(2).GetMethod().Name + (":" + cmd.CommandText), CustomErrorMsg, ex);
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        HandleError(new StackTrace().GetFrame(1).GetMethod().Name + (":" + cmd.CommandText), CustomErrorMsg, ex);
                    }
                }
            }
            return dataset;
        }

        protected int ExecuteNonQueryInTransaction(List<DbCommand> cmds)
        {
            return ExecuteNonQueryInTransaction(cmds, FriendlyExceptionMessage);
        }

        protected int ExecuteNonQueryInTransaction(List<DbCommand> cmds, string CustomErrorMsg)
        {
            int retval = 0;
            
            DbConnection Conn = Provider().CreateConnection();
            Conn.ConnectionString = ConnectionStringEdit;
            using (Conn)
            {
                // Open connection
                if ((Conn.State == ConnectionState.Closed))
                {
                    Conn.Open();
                }
                // Begin transaction and assign it to command to be executed

                DbTransaction trans = Conn.BeginTransaction();
                for (int i=0; i< cmds.Count; i++)
                {
                    cmds[i].Connection = Conn;
                    cmds[i].Transaction = trans;
                    try
                    {
                        retval = cmds[i].ExecuteNonQuery();
                    }
                    catch (Exception ex)
                    {
                        trans.Rollback();
                        HandleError((new StackTrace().GetFrame(1).GetMethod().Name + (":" + cmds[i].CommandText)), CustomErrorMsg, ex);
                    }
                }
                trans.Commit();
            } // End using (Conn)
            return retval;
        }

        protected int ExecuteNonQuery(string storedProcedureName)
        {
            DbCommand cmd = GetCommand();
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = storedProcedureName;
            return ExecuteNonQuery(cmd, FriendlyExceptionMessage);
        }

        protected int ExecuteNonQuery(DbCommand cmd)
        {
            return ExecuteNonQuery(cmd, FriendlyExceptionMessage);
        }
        protected int ExecuteNonQuery(DbCommand cmd, DbTransaction trans)
        {
            return ExecuteNonQuery(cmd, trans, FriendlyExceptionMessage);
        }
        protected int ExecuteNonQuery(DbCommand cmd, string CustomErrorMsg)
        {
            int retval = 0;

            DbConnection Conn = Provider().CreateConnection();
            Conn.ConnectionString = ConnectionStringEdit;

            using (Conn)
            {
                if ((Conn.State == ConnectionState.Closed))
                {
                    Conn.Open();
                }
                using (cmd)
                {
                    try
                    {
                        cmd.Connection = Conn;
                        return cmd.ExecuteNonQuery();
                    }
                    catch (Exception ex)
                    {
                        HandleError((new StackTrace().GetFrame(1).GetMethod().Name + (":" + cmd.CommandText)), CustomErrorMsg, ex);
                    }
                }
            }
            return retval;
        }
        protected int ExecuteNonQuery(DbCommand cmd, DbTransaction trans, string CustomErrorMsg)
        {
            int retval = 0;
                using (cmd)
                {
                    try
                    {
                        cmd.Connection = trans.Connection;
                        cmd.Transaction = trans;
                        return cmd.ExecuteNonQuery();
                    }
                    catch (Exception ex)
                    {
                        HandleError((new StackTrace().GetFrame(1).GetMethod().Name + (":" + cmd.CommandText)), CustomErrorMsg, ex);
                    }
                }

            return retval;
        }
        
        protected object ExecuteScalar(DbCommand cmd)
        {
            return ExecuteScalar(cmd, FriendlyExceptionMessage);
        }
        protected object ExecuteScalar(DbCommand cmd, DbTransaction trans)
        {
            return ExecuteScalar(cmd, FriendlyExceptionMessage);
        }
        protected object ExecuteScalar(DbCommand cmd, string CustomErrorMsg)
        {
            object retval = null;

            DbConnection Conn = Provider().CreateConnection();
            Conn.ConnectionString = ConnectionStringEdit;

            using (Conn)
            {
                if ((Conn.State == ConnectionState.Closed))
                {
                    Conn.Open();
                }
                using (cmd)
                {
                    try
                    {
                        cmd.Connection = Conn;
                        return cmd.ExecuteScalar();
                    }
                    catch (Exception ex)
                    {
                        HandleError((new StackTrace().GetFrame(1).GetMethod().Name + (":" + cmd.CommandText)), CustomErrorMsg, ex);
                    }
                }
            }
            return retval;
        }
        protected object ExecuteScalar(DbCommand cmd, DbTransaction trans, string CustomErrorMsg)
        {
            object retval = null;
            using (cmd)
            {
                try
                {
                    cmd.Connection = trans.Connection;
                    cmd.Transaction = trans;
                    return cmd.ExecuteScalar();
                }
                catch (Exception ex)
                {
                    HandleError((new StackTrace().GetFrame(1).GetMethod().Name + (":" + cmd.CommandText)), CustomErrorMsg, ex);
                }
            }

            return retval;
        }
        protected DbCommand GetCommand()
        {
            return Provider().CreateCommand();
        }

        protected DbCommand GetCommand(string StoredProcedureName)
        {
            DbCommand cmd = Provider().CreateCommand();
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = StoredProcedureName;
            return cmd;
        }

        protected DbTransaction GetEditTransaction()
        {
            DbConnection Conn = Provider().CreateConnection();
            Conn.ConnectionString = ConnectionStringEdit;
            if ((Conn.State == ConnectionState.Closed))
            {
                Conn.Open();
            }
            return Conn.BeginTransaction();
        }
        protected void HandleError(string methodCausingTheError, string msg, Exception ex)
        {
            Exception iex = new Exception(msg, ex);
            iex.Source = methodCausingTheError;
            throw (iex);
        }

        internal static BO.ExceptionSafeToDisplay ProcessAndReturnException(string UID, string MsgToDisplay, Exception ExceptionToLog)
        {
            if (ExceptionToLog != null)
            {
                // Log Error
                try
                {

                }
                catch (Exception x)
                {
                    x.GetType(); // Do nothing if failed to log error
                }
            }
            return new BO.ExceptionSafeToDisplay(MsgToDisplay);
        }
    }
}
