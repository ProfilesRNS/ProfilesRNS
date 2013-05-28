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
            string sql = "select page, [view], chromeId, visibility, display_order, opt_params from [ORNG].[AppViews] where appId = " + appId;
            SqlDataReader sqldr = this.GetSQLDataReader("ProfilesDB", sql, CommandType.Text, CommandBehavior.CloseConnection, null);
            return sqldr;
        }

        public SqlDataReader GetRegisteredApps(string uri)
        {
            string sql = "select appId, visibility from [ORNG].[AppRegistry] where uri = '" + uri + "';";
            SqlDataReader sqldr = this.GetSQLDataReader("ProfilesDB", sql, CommandType.Text, CommandBehavior.CloseConnection, null);
            return sqldr;
        }

        public SqlDataReader GetGadgets()
        {
            string sql = "select appId, name, url, enabled from [ORNG].[Apps]";
            SqlDataReader sqldr = this.GetSQLDataReader("ProfilesDB", sql, CommandType.Text, CommandBehavior.CloseConnection, null);
            return sqldr;
        }

        public void ExecuteSQLDataCommand(string sqltext)
        {

            using (SqlConnection conn = GetDBConnection(""))
            {
                SqlCommand sqlcmd = new SqlCommand(sqltext, conn);
                sqlcmd.CommandType = CommandType.Text;
                sqlcmd.CommandTimeout = GetCommandTimeout();
                sqlcmd.ExecuteNonQuery();
            }
        }

    }
}
