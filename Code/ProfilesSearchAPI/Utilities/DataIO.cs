using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Xml;

using Profiles.Utilities;

namespace ProfilesSearchAPI.Utilities
{
    public class DataIO
    {

        public XmlDocument Search(Search.SearchOptions searchoptions, bool lookup)
        {
            string xmlstr = string.Empty;

            XmlDocument xmlrtn = new XmlDocument();
            SessionManagement sm = new SessionManagement();
            string sessionid = string.Empty;


            xmlstr = Utilities.SerializeXML.SerializeToString(searchoptions);

            xmlstr = xmlstr.Replace("<?xml version=\"1.0\" encoding=\"utf-8\"?>", "");
            xmlstr = xmlstr.Replace("<?xml version=\"1.0\" encoding=\"utf-16\"?>", "");

            try
            {
                string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;
                bool secure = Convert.ToBoolean(ConfigurationManager.AppSettings["IsSecure"]);


                sessionid = sm.SessionCreate();

                SqlConnection dbconnection = new SqlConnection(connstr);
                SqlCommand dbcommand = new SqlCommand();

                SqlDataReader dbreader;
                dbconnection.Open();
                dbcommand.CommandType = CommandType.StoredProcedure;

                dbcommand.CommandText = "[Search.].[GetNodes]";
                dbcommand.CommandTimeout = this.GetCommandTimeout();

                if (secure)
                {
                    dbcommand.Parameters.Add(new SqlParameter("@UseCache", "Private"));
                    User user = new User();
                    user.UserName = ConfigurationSettings.AppSettings["SecureGenericUserName"];
                    user.UserID = Convert.ToInt32(ConfigurationSettings.AppSettings["SecureGenericUserID"]);                    

                    Session session = new Session();
                    session.UserID = user.UserID;
                    session.SessionID = sessionid;
                    this.SessionUpdate(ref session);
                }

                dbcommand.Parameters.Add(new SqlParameter("@SearchOptions", xmlstr));


                dbcommand.Parameters.Add(new SqlParameter("@sessionid", sessionid));

                if (lookup)
                    dbcommand.Parameters.Add(new SqlParameter("@Lookup", 1));

                dbcommand.Connection = dbconnection;

                dbreader = dbcommand.ExecuteReader(CommandBehavior.CloseConnection);

                xmlstr = string.Empty;

                while (dbreader.Read())
                {
                    xmlstr += dbreader[0].ToString();
                }

                xmlrtn.LoadXml(xmlstr);

                if (!dbreader.IsClosed)
                    dbreader.Close();

                Utilities.DebugLogging.Log(xmlstr);

            }
            catch (Exception e)
            {
                Utilities.DebugLogging.Log(e.Message + " " + e.StackTrace);
            }

            return xmlrtn;

        }


        #region "USER MANAGEMENT"


        /// <summary>
        /// For User Authentication 
        /// </summary>
        /// <param name="user"></param>
        /// <param name="session"></param>
        public void UserLogout()
        {
            

        }

        #endregion
        #region "SESSION"
        /// <summary>
        ///     Used to create a custom Profiles Session instance.  This instance is used to track and store user activity as a form of Profiles Network.
        /// </summary>
        /// <param name="session">ref of Framework.Session object that stores the state of a Profiles user session</param>
        public void SessionCreate(ref Session session)
        {
            SqlDataReader dbreader;
            SqlParameter[] param = new SqlParameter[2];
            param[0] = new SqlParameter("@RequestIP", session.RequestIP);
            param[1] = new SqlParameter("@UserAgent", session.UserAgent);

            dbreader = GetSQLDataReader(GetDBCommand("", "[User.Session].[CreateSession]", CommandType.StoredProcedure, CommandBehavior.CloseConnection, param));
            if (dbreader != null)
            {
                if (dbreader.Read()) //Returns a data ready with one row of user Session Info.  {Profiles Session Info, not IIS}
                {
                    session.SessionID = dbreader["SessionID"].ToString();
                    session.CreateDate = dbreader["CreateDate"].ToString();
                    session.LastUsedDate = Convert.ToDateTime(dbreader["LastUsedDate"].ToString());

                    Utilities.DebugLogging.Log("Session object created:" + session.SessionID + " On " + session.CreateDate);
                }
                //Always close your readers
                if (!dbreader.IsClosed)
                    dbreader.Close();

            }
            else
            {
                session = null;
            }

        }



        /// <summary>
        ///     Used to create a custom Profiles Session instance.  This instance is used to track and store user activity as a form of Profiles Network.
        /// </summary>
        /// <param name="session">ref of Framework.Session object that stores the state of a Profiles user session</param>
        public void SessionUpdate(ref Session session)
        {

            string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;
            SessionManagement sm = new SessionManagement();

            SqlConnection dbconnection = new SqlConnection(connstr);

            SqlParameter[] param;

            param = new SqlParameter[6];

            SqlCommand dbcommand = new SqlCommand();

            dbconnection.Open();

            dbcommand.CommandTimeout = this.GetCommandTimeout();

            param[0] = new SqlParameter("@SessionID", session.SessionID);
            param[1] = new SqlParameter("@UserID", session.UserID);

            param[2] = new SqlParameter("@LastUsedDate", DateTime.Now);

            param[3] = new SqlParameter("@SessionPersonNodeID", 0);
            param[3].Direction = ParameterDirection.Output;

            param[4] = new SqlParameter("@SessionPersonURI", SqlDbType.VarChar, 400);
            param[4].Direction = ParameterDirection.Output;

            if (session.LogoutDate > DateTime.Now.AddDays(-5))
            {
                param[5] = new SqlParameter("@LogoutDate", session.LogoutDate.ToString());
            }

            dbcommand.Connection = dbconnection;

            try
            {
                //For Output Parameters you need to pass a connection object to the framework so you can close it before reading the output params value.
                ExecuteSQLDataCommand(GetDBCommand(ref dbconnection, "[User.Session].[UpdateSession]", CommandType.StoredProcedure, CommandBehavior.CloseConnection, param));

            }
            catch (Exception ex) { }

            try
            {
                dbcommand.Connection.Close();
                session.NodeID = Convert.ToInt64(param[3].Value);
                session.PersonURI = param[4].Value.ToString();
            }
            catch (Exception ex)
            {


            }


        }



        #endregion


        #region "DB SQL.NET Methods"

        /// <summary>
        /// returns sqlconnection object
        /// </summary>
        /// <param name="Connectionstring"></param>
        /// <returns></returns>
        public SqlConnection GetDBConnection(string Connectionstring)
        {
            if (Connectionstring.CompareTo("") == 0)
                Connectionstring = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;
            else
            {
                if (Connectionstring.Length < 25)
                    Connectionstring = ConfigurationManager.ConnectionStrings[Connectionstring].ConnectionString;
            }
            SqlConnection dbsqlconnection = new SqlConnection(Connectionstring);
            try
            {
                dbsqlconnection.Open();
            }
            catch (Exception ex)
            {
                Utilities.DebugLogging.Log(ex.Message);
                Utilities.DebugLogging.Log(ex.StackTrace);
            }
            return dbsqlconnection;
        }

        public SqlCommand GetDBCommand(SqlConnection sqlcn, String CmdText, CommandType CmdType, CommandBehavior CmdBehavior, SqlParameter[] sqlParam)
        {
            SqlCommand sqlcmd = null;

            try
            {
                sqlcmd = new SqlCommand(CmdText, sqlcn);
                sqlcmd.CommandType = CmdType;

                sqlcmd.CommandTimeout = GetCommandTimeout();

                Utilities.DebugLogging.Log("CONNECTION STRING " + sqlcn.ConnectionString);
                Utilities.DebugLogging.Log("COMMAND TEXT " + CmdText);
                Utilities.DebugLogging.Log("COMMAND TYPE " + CmdType.ToString());
                if (sqlParam != null)
                    Utilities.DebugLogging.Log("NUMBER OF PARAMS " + sqlParam.Length);

                AddSQLParameters(sqlcmd, sqlParam);

            }
            catch (Exception ex)
            {
                Utilities.DebugLogging.Log(ex.Message);
                Utilities.DebugLogging.Log(ex.StackTrace);
            }
            return sqlcmd;
        }

        public SqlCommand GetDBCommand(string SqlConnectionString, String CmdText, CommandType CmdType, CommandBehavior CmdBehavior, SqlParameter[] sqlParam)
        {

            SqlCommand sqlcmd = null;

            try
            {
                sqlcmd = new SqlCommand(CmdText, GetDBConnection(SqlConnectionString));
                sqlcmd.CommandType = CmdType;
                sqlcmd.CommandTimeout = GetCommandTimeout();
                Utilities.DebugLogging.Log("CONNECTION STRING " + SqlConnectionString);
                Utilities.DebugLogging.Log("COMMAND TEXT " + CmdText);
                Utilities.DebugLogging.Log("COMMAND TYPE " + CmdType.ToString());
                if (sqlParam != null)
                    Utilities.DebugLogging.Log("NUMBER OF PARAMS " + sqlParam.Length);


                if (sqlParam != null)
                    AddSQLParameters(sqlcmd, sqlParam);


            }
            catch (Exception ex)
            {
                Utilities.DebugLogging.Log(ex.Message);
                Utilities.DebugLogging.Log(ex.StackTrace);
            }
            return sqlcmd;
        }

        public SqlCommand GetDBCommand(ref SqlConnection cn, String CmdText, CommandType CmdType, CommandBehavior CmdBehavior, SqlParameter[] sqlParam)
        {

            cn = GetDBConnection("");
            SqlCommand sqlcmd = null;

            try
            {
                sqlcmd = new SqlCommand(CmdText, cn);
                sqlcmd.CommandType = CmdType;
                sqlcmd.CommandTimeout = GetCommandTimeout();
                if (sqlParam != null)
                    AddSQLParameters(sqlcmd, sqlParam);

            }
            catch (Exception ex)
            {
                Utilities.DebugLogging.Log(ex.Message);
                Utilities.DebugLogging.Log(ex.StackTrace);
            }

            return sqlcmd;
        }

        public void AddSQLParameters(SqlCommand sqlcmd, SqlParameter[] sqlParam)
        {
            for (int i = 0; i < sqlParam.GetLength(0); i++)
            {
                sqlcmd.Parameters.Add(sqlParam[i]);
                sqlcmd.Parameters[i].Direction = sqlParam[i].Direction;
                
            }
        }

        public SqlDataReader GetSQLDataReader(SqlCommand sqlcmd)
        {
            SqlDataReader sqldr = null;
            try
            {

                if (sqlcmd.Connection == null)
                {
                    sqlcmd.Connection = this.GetDBConnection("");
                }
                else if (sqlcmd.Connection.State == ConnectionState.Closed)
                {
                    sqlcmd.Connection = this.GetDBConnection("");
                }

                sqldr = sqlcmd.ExecuteReader(CommandBehavior.CloseConnection);

            }
            catch (Exception ex)
            {
                Utilities.DebugLogging.Log("ERROR" + ex.Message);
                Utilities.DebugLogging.Log("ERROR" + ex.StackTrace);
            }
            return sqldr;

        }

        public SqlDataReader GetSQLDataReader(string ConnectionString, String CmdText, CommandType CmdType, CommandBehavior CmdBehavior, SqlParameter[] sqlParam)
        {

            SqlDataReader sqldr = null;
            try
            {

                sqldr = this.GetSQLDataReader(this.GetDBCommand(ConnectionString, CmdText, CmdType, CmdBehavior, sqlParam));


            }
            catch (Exception ex)
            {
                Utilities.DebugLogging.Log("ERROR" + ex.Message);
                Utilities.DebugLogging.Log("ERROR" + ex.StackTrace);
            }
            return sqldr;
        }

        public void ExecuteSQLDataCommand(SqlCommand sqlcmd)
        {
            try
            {
                sqlcmd.ExecuteNonQuery();
                sqlcmd.Dispose();
            }
            catch (Exception ex)
            {
                Utilities.DebugLogging.Log("ERROR" + ex.Message);
                Utilities.DebugLogging.Log("ERROR" + ex.StackTrace);
                throw ex;

            }
        }

        public void ExecuteSQLDataCommand(string sqltext)
        {

            SqlCommand sqlcmd = null;
            try
            {
                sqlcmd = new SqlCommand(sqltext, GetDBConnection(""));
                sqlcmd.CommandType = CommandType.Text;
                sqlcmd.CommandTimeout = GetCommandTimeout();
                sqlcmd.ExecuteNonQuery();

                if (sqlcmd.Connection.State == ConnectionState.Open)
                {
                    sqlcmd.Connection.Close();
                }
            }
            catch (Exception ex)
            {
                //do nothing

            }

        }

        public void ExecuteSQLDataCommand(SqlCommand sqlcmd, object o)
        {

            try
            {
                o = sqlcmd.ExecuteScalar();
            }
            catch (Exception ex)
            {
                Utilities.DebugLogging.Log("ERROR" + ex.Message);
                Utilities.DebugLogging.Log("ERROR" + ex.StackTrace);
            }

            sqlcmd.Dispose();


        }

        public int GetCommandTimeout()
        {
            return Convert.ToInt32(ConfigurationSettings.AppSettings["COMMANDTIMEOUT"]);

        }

        #endregion

    }
}
