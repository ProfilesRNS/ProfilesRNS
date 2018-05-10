/*  
 
    Copyright (c) 2008-2012 by the President and Fellows of Harvard College. All rights reserved.  
    Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
    and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
    National Center for Research Resources and Harvard University.


    Code licensed under a BSD License. 
    For details, see: LICENSE.txt 
  
*/
using System;
using System.Data;
using System.Data.SqlClient;

namespace Profiles.ORNG.Utilities
{
    public class DataIO : Framework.Utilities.DataIO
    {

        public SqlDataReader GetGadgetViewRequirements(int appId)
        {
            string sql = "select Page, [view], ChromeID, Visibility, DisplayOrder, OptParams from [ORNG.].[AppViews] where AppID = " + appId;
            SqlDataReader sqldr = this.GetSQLDataReader("ProfilesDB", sql, CommandType.Text, CommandBehavior.CloseConnection, null);
            return sqldr;
        }

        public SqlDataReader GetGadgets()
        {
            string sql = "select AppID, Name, Url, Enabled from [ORNG.].[Apps]";
            SqlDataReader sqldr = this.GetSQLDataReader("ProfilesDB", sql, CommandType.Text, CommandBehavior.CloseConnection, null);
            return sqldr;
        }

        public Int64 GetNodeId(Int32 personid)
        {
            string sql = "select NodeID from [RDF.Stage].[InternalNodeMap] where Class = 'http://xmlns.com/foaf/0.1/Person' and InternalID = " + personid;
            using (SqlDataReader sqldr = this.GetSQLDataReader("ProfilesDB", sql, CommandType.Text, CommandBehavior.CloseConnection, null))
            {
                if (sqldr.Read())
                {
                    return sqldr.GetInt64(0);
                }
            }
            return -1;
        }

        public void AddPersonalGadget(long Subject, string propertyURI)
        {
            GadgetSpec spec = OpenSocialManager.GetGadgetByPropertyURI(propertyURI);
            if (spec != null)
            {
                AddPersonalGadget(Subject, spec.GetAppId());
            }
        }

        public void AddPersonalGadget(string uri, int appId)
        {
            SqlParameter[] param = new SqlParameter[2];

            param[0] = new SqlParameter("@SubjectURI", uri);
            param[1] = new SqlParameter("@AppID", appId);

            using (SqlCommand comm = GetDBCommand("", "[ORNG.].[AddAppToPerson]", CommandType.StoredProcedure, CommandBehavior.CloseConnection, param))
            {
                ExecuteSQLDataCommand(comm);
            }
        }

        public void AddPersonalGadget(long Subject, int appId)
        {
            SqlParameter[] param = new SqlParameter[2];

            param[0] = new SqlParameter("@SubjectID", Subject);
            param[1] = new SqlParameter("@AppID", appId);

            using (SqlCommand comm = GetDBCommand("", "[ORNG.].[AddAppToPerson]", CommandType.StoredProcedure, CommandBehavior.CloseConnection, param))
            {
                ExecuteSQLDataCommand(comm);
            }
        }

        public void RemovePersonalGadget(long Subject, string propertyURI)
        {
            GadgetSpec spec = OpenSocialManager.GetGadgetByPropertyURI(propertyURI);
            if (spec != null)
            {
                RemovePersonalGadget(Subject, spec.GetAppId());
            }
        }

        public void RemovePersonalGadget(string uri, int appId)
        {
            SqlParameter[] param = new SqlParameter[3];

            param[0] = new SqlParameter("@SubjectURI", uri);
            param[1] = new SqlParameter("@AppID", appId);
            param[2] = new SqlParameter("@DeleteType", "1");

            using (SqlCommand comm = GetDBCommand("", "[ORNG.].[RemoveAppFromPerson]", CommandType.StoredProcedure, CommandBehavior.CloseConnection, param))
            {
                ExecuteSQLDataCommand(comm);
            }
        }

        public void RemovePersonalGadget(long Subject, int appId)
        {
            SqlParameter[] param = new SqlParameter[3];

            param[0] = new SqlParameter("@SubjectID", Subject);
            param[1] = new SqlParameter("@AppID", appId);
            param[2] = new SqlParameter("@DeleteType", "1");

            using (SqlCommand comm = GetDBCommand("", "[ORNG.].[RemoveAppFromPerson]", CommandType.StoredProcedure, CommandBehavior.CloseConnection, param))
            {
                ExecuteSQLDataCommand(comm);
            }
        }

    }
}
