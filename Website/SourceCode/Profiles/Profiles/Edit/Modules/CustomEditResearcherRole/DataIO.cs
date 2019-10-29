/*  
 
    Copyright (c) 2008-2011 by the President and Fellows of Harvard College. All rights reserved.  
    Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
    and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
    National Center for Research Resources and Harvard University.


    Code licensed under a BSD License. 
    For details, see: LICENSE.txt 
  
*/
using System;
using System.Collections.Generic;
using System.Collections;
using System.Data;
using System.Web;
using System.Net;
using System.IO;
using System.Text;
using System.Drawing;
using System.Data.SqlClient;
using System.Xml;
using System.Configuration;

using Profiles.Framework.Utilities;
using Profiles.Edit.Utilities;

namespace Profiles.Edit.Modules.CustomEditResearcherRole
{
    public class DataIO : Profiles.Edit.Utilities.DataIO
    {
        public bool GetDisambiguationSettings(int PersonID)
        {
            SessionManagement sm = new SessionManagement();
            string connstr = this.GetConnectionString();

            SqlConnection dbconnection = new SqlConnection(connstr);
            SqlDataReader reader;
            int Enabled = 1;
            SqlParameter[] param = new SqlParameter[1];
            try
            {
                dbconnection.Open();

                param[0] = new SqlParameter("@PersonID", PersonID);

                reader = GetDBCommand("[Profile.Data].[Funding.GetDisambiguationSettings]", CommandType.StoredProcedure, CommandBehavior.CloseConnection, param).ExecuteReader();
                while (reader.Read())
                {
                    Enabled = Convert.ToInt32(reader["Enabled"]);
                }

                reader.Close();

                if (dbconnection.State != ConnectionState.Closed)
                    dbconnection.Close();

            }
            catch (Exception e)
            {
                Framework.Utilities.DebugLogging.Log(e.Message + e.StackTrace);
                throw new Exception(e.Message);
            }

            return Enabled == 1 ? true : false;
        }


        public void UpdateDisambiguationSettings(int PersonID, bool enabled)
        {

            SessionManagement sm = new SessionManagement();
            string connstr = this.GetConnectionString();

            SqlConnection dbconnection = new SqlConnection(connstr);

            SqlParameter[] param = new SqlParameter[2];

            try
            {

                dbconnection.Open();

                param[0] = new SqlParameter("@PersonID", PersonID);

                param[1] = new SqlParameter("@Enabled", enabled);


                //For Output Parameters you need to pass a connection object to the framework so you can close it before reading the output params value.
                ExecuteSQLDataCommand(GetDBCommand(ref dbconnection, "[Profile.Data].[Funding.UpdateDisambiguationSettings]", CommandType.StoredProcedure, CommandBehavior.CloseConnection, param));

                dbconnection.Close();
                SqlConnection.ClearPool(dbconnection);

            }
            catch (Exception e)
            {
                Framework.Utilities.DebugLogging.Log(e.Message + e.StackTrace);
                throw new Exception(e.Message);
            }


        }
	}
}
