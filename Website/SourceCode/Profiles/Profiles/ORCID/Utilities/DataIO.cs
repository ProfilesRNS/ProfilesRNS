using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

using Profiles.Framework.Utilities;

namespace Profiles.ORCID.Utilities
{
    public class DataIO : Profiles.Framework.Utilities.DataIO
    {

        public static int GetCommandTimeout()
        {
            return Convert.ToInt32(ConfigurationSettings.AppSettings["COMMANDTIMEOUT"]);

        }
/*
        public SqlDataReader GetPublications(RDFTriple request)
        {
            SessionManagement sm = new SessionManagement();

            string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;
            SqlConnection dbconnection = new SqlConnection(connstr);
            SqlCommand dbcommand = new SqlCommand("[Profile.Module].[CustomViewAuthorInAuthorshipForORCID.GetList]");

            SqlDataReader dbreader;
            dbconnection.Open();
            dbcommand.CommandType = CommandType.StoredProcedure;
            dbcommand.CommandTimeout = base.GetCommandTimeout();
            dbcommand.Parameters.Add(new SqlParameter("@nodeid", request.Subject));
            dbcommand.Parameters.Add(new SqlParameter("@sessionid", sm.Session().SessionID));
            dbcommand.Connection = dbconnection;
            dbreader = dbcommand.ExecuteReader(CommandBehavior.CloseConnection);

            return dbreader;
        }
  
 */ 
        public string GetInternalUserID()
        {
            SessionManagement sm = new SessionManagement();

            string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;
            SqlConnection dbconnection = new SqlConnection(connstr);
            SqlCommand dbcommand = new SqlCommand("SELECT UserID, InternalUserName FROM [User.Account].[User] WHERE (UserID = @userid)");

            SqlDataReader dbreader;
            dbconnection.Open();
            dbcommand.CommandType = CommandType.Text;
            dbcommand.CommandTimeout = GetCommandTimeout();
            dbcommand.Parameters.Add(new SqlParameter("@userid", sm.Session().UserID));
            dbcommand.Connection = dbconnection;
            dbreader = dbcommand.ExecuteReader(CommandBehavior.CloseConnection);

            while (dbreader.Read())
            {
                ORCIDPublication pub = new ORCIDPublication();
                if (dbreader["InternalUserName"] != null)
                {
                    return dbreader["InternalUserName"].ToString();
                }
            }
            throw new Exception("Unable to find Internal Username");
        }
        public string GetInternalUserIDFromSubjectID()
        {
            SessionManagement sm = new SessionManagement();

            string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;
            SqlConnection dbconnection = new SqlConnection(connstr);
            SqlCommand dbcommand = new SqlCommand("SELECT UserID, InternalUserName FROM [User.Account].[User] WHERE (UserID = @userid)");

            SqlDataReader dbreader;
            dbconnection.Open();
            dbcommand.CommandType = CommandType.Text;
            dbcommand.CommandTimeout = base.GetCommandTimeout();
            dbcommand.Parameters.Add(new SqlParameter("@userid", sm.Session().UserID));
            dbcommand.Connection = dbconnection;
            dbreader = dbcommand.ExecuteReader(CommandBehavior.CloseConnection);

            while (dbreader.Read())
            {
                ORCIDPublication pub = new ORCIDPublication();
                if (dbreader["InternalUserName"] != null)
                {
                    return dbreader["InternalUserName"].ToString();
                }
            }
            throw new Exception("Unable to find Internal Username");
        }

        public static long getNodeIdFromInternalUserName(string internalUserName)
        {
            SessionManagement sm = new SessionManagement();

            string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;
            SqlConnection dbconnection = new SqlConnection(connstr);
            SqlCommand dbcommand = new SqlCommand("select nodeID from [RDF.Stage].[InternalNodeMap] m join [Profile.Data].[Person] p on m.internalID= p.PersonID and Class = 'http://xmlns.com/foaf/0.1/Person' and p.internalusername = '" + internalUserName + "'");

            SqlDataReader dbreader;
            dbconnection.Open();
            dbcommand.CommandType = CommandType.Text;
            dbcommand.CommandTimeout = GetCommandTimeout();
            dbcommand.Connection = dbconnection;
            dbreader = dbcommand.ExecuteReader(CommandBehavior.CloseConnection);

            while (dbreader.Read())
            {
                ORCIDPublication pub = new ORCIDPublication();
                if (dbreader["NodeID"] != null)
                {
                    return Convert.ToInt64(dbreader["NodeID"]); 
                }
            }
            return 0;
        }

        public static long getNodeIdFromPersonID(int personID)
        {
            SessionManagement sm = new SessionManagement();

            string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;
            SqlConnection dbconnection = new SqlConnection(connstr);
            SqlCommand dbcommand = new SqlCommand("select nodeID from [RDF.Stage].[InternalNodeMap] where Class = 'http://xmlns.com/foaf/0.1/Person' and internalID = " + personID);

            SqlDataReader dbreader;
            dbconnection.Open();
            dbcommand.CommandType = CommandType.Text;
            dbcommand.CommandTimeout = GetCommandTimeout();
            dbcommand.Connection = dbconnection;
            dbreader = dbcommand.ExecuteReader(CommandBehavior.CloseConnection);

            while (dbreader.Read())
            {
                ORCIDPublication pub = new ORCIDPublication();
                if (dbreader["NodeID"] != null)
                {
                    return Convert.ToInt64(dbreader["NodeID"]);
                }
            }
            return 0;
        }
    }
}