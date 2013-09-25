/*  
 
    Copyright (c) 2008-2012 by the President and Fellows of Harvard College. All rights reserved.  
    Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
    and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
    National Center for Research Resources and Harvard University.


    Code licensed under a BSD License. 
    For details, see: LICENSE.txt 
  
*/
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Xml;
using System.Configuration;

using Profiles.Framework.Utilities;

namespace Profiles.ORNG.Utilities
{
    public class DataIO : Framework.Utilities.DataIO
    {

        public SqlDataReader GetGadgetViewRequirements(int appId)
        {
            string sql = "select page, [view], chromeId, visibility, display_order, opt_params from [ORNG.].[AppViews] where appId = " + appId;
            SqlDataReader sqldr = this.GetSQLDataReader("ProfilesDB", sql, CommandType.Text, CommandBehavior.CloseConnection, null);
            return sqldr;
        }

        public SqlDataReader GetRegisteredApps(string uri)
        {
            string sql = "select appId from [ORNG.].[AppRegistry] where nodeId = " + uri.Substring(uri.LastIndexOf('/') + 1);
            SqlDataReader sqldr = this.GetSQLDataReader("ProfilesDB", sql, CommandType.Text, CommandBehavior.CloseConnection, null);
            return sqldr;
        }

        public SqlDataReader GetGadgets()
        {
            string sql = "select appId, name, url, unavailableMessage, enabled from [ORNG.].[Apps]";
            SqlDataReader sqldr = this.GetSQLDataReader("ProfilesDB", sql, CommandType.Text, CommandBehavior.CloseConnection, null);
            return sqldr;
        }

        public Int64 GetNodeId(Int32 personid)
        {
            string sql = "select nodeid from [RDF.Stage].[InternalNodeMap] where Class = 'http://xmlns.com/foaf/0.1/Person' and InternalID = " + personid;
            using (SqlDataReader sqldr = this.GetSQLDataReader("ProfilesDB", sql, CommandType.Text, CommandBehavior.CloseConnection, null))
            {
                if (sqldr.Read())
                {
                    return sqldr.GetInt64(0);
                }
            }
            return -1;
        }

        // the ones below should change
        public bool IsRegistered(string uri, int appId)
        {
            SqlParameter[] param = new SqlParameter[2];

            param[0] = new SqlParameter("@uri", uri);
            param[1] = new SqlParameter("@appId", appId);

            using (SqlDataReader dbreader = GetSQLDataReader(GetDBCommand("", "[ORNG.].[ReadRegistry]", CommandType.StoredProcedure, CommandBehavior.CloseConnection, param)))
            {
                return dbreader.Read();
            }
        }

        public bool IsRegistered(long Subject, int appId)
        {
            SqlParameter[] param = new SqlParameter[2];

            param[0] = new SqlParameter("@Subject", Subject);
            param[1] = new SqlParameter("@appId", appId);

            using (SqlDataReader dbreader = GetSQLDataReader(GetDBCommand("", "[ORNG.].[ReadRegistry]", CommandType.StoredProcedure, CommandBehavior.CloseConnection, param)))
            {
                return dbreader.Read();
            }
        }

        public bool HasPersonalGadget(string uri, int appId)
        {
            SqlParameter[] param = new SqlParameter[2];

            param[0] = new SqlParameter("@uri", uri);
            param[1] = new SqlParameter("@appId", appId);

            using (SqlDataReader dbreader = GetSQLDataReader(GetDBCommand("", "[ORNG.].[ReadRegistry]", CommandType.StoredProcedure, CommandBehavior.CloseConnection, param)))
            {
                if (dbreader.Read())
                    return "Public".Equals(dbreader[0].ToString());
            }
            return false;
        }

        public bool HasPersonalGadget(long Subject, int appId)
        {
            SqlParameter[] param = new SqlParameter[2];

            param[0] = new SqlParameter("@Subject", Subject);
            param[1] = new SqlParameter("@appId", appId);

            using (SqlDataReader dbreader = GetSQLDataReader(GetDBCommand("", "[ORNG.].[ReadRegistry]", CommandType.StoredProcedure, CommandBehavior.CloseConnection, param)))
            {
                if (dbreader.Read())
                    return "Public".Equals(dbreader[0].ToString());
            }
            return false;
        }

        public void AddPersonalGadget(string uri, int appId)
        {
            AddRemovePersonalGadget(uri, appId, true);
        }

        public void RemovePersonalGadget(string uri, int appId)
        {
            AddRemovePersonalGadget(uri, appId, false);
        }

        public void RemovePersonalGadget(long Subject, string propertyURI)
        {
            GadgetSpec spec = OpenSocialManager.GetGadgetByPropertyURI(propertyURI);
            if (spec != null)
            {
                AddRemovePersonalGadget(Subject, spec.GetAppId(), false);
            }
        }

        public void AddPersonalGadget(long Subject, string propertyURI)
        {
            GadgetSpec spec = OpenSocialManager.GetGadgetByPropertyURI(propertyURI);
            if (spec != null)
            {
                AddRemovePersonalGadget(Subject, spec.GetAppId(), true);
            }
        }

        public void AddPersonalGadget(long Subject, int appId)
        {
            AddRemovePersonalGadget(Subject, appId, true);
        }

        public void RemovePersonalGadget(long Subject, int appId)
        {
            AddRemovePersonalGadget(Subject, appId, false);
        }

        private void AddRemovePersonalGadget(string uri, int appId, bool add)
        {
            SqlParameter[] param = new SqlParameter[3];

            param[0] = new SqlParameter("@uri", uri);
            param[1] = new SqlParameter("@appId", appId);
            param[2] = new SqlParameter("@visibility", add ? "Public" : "Nobody");

            using (SqlCommand comm = GetDBCommand("", "[ORNG.].[RegisterAppPerson]", CommandType.StoredProcedure, CommandBehavior.CloseConnection, param))
            {
                ExecuteSQLDataCommand(comm);
            }
        }

        private void AddRemovePersonalGadget(long Subject, int appId, bool add)
        {
            SqlParameter[] param = new SqlParameter[3];

            param[0] = new SqlParameter("@Subject", Subject);
            param[1] = new SqlParameter("@appId", appId);
            param[2] = new SqlParameter("@visibility", add ? "Public" : "Nobody");

            using (SqlCommand comm = GetDBCommand("", "[ORNG.].[RegisterAppPerson]", CommandType.StoredProcedure, CommandBehavior.CloseConnection, param))
            {
                ExecuteSQLDataCommand(comm);
            }
        }
    }
}
