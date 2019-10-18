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

namespace Profiles.Edit.Modules.CustomEditAssociatedInformationResource
{
    public class DataIO : Profiles.Edit.Utilities.DataIO
    {
          public void SetGroupPublicationOption(int groupID, Int64 subjectID, int val)
        {
            Cache.AlterDependency(subjectID.ToString());
            SqlCommand comm = new SqlCommand();
            try
            {
                string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;
                SqlConnection dbconnection = new SqlConnection(connstr);

                dbconnection.Open();

                SqlCommand dbcommand = new SqlCommand();
                dbcommand.CommandType = CommandType.StoredProcedure;

                dbcommand.CommandText = "[Profile.Data].[Publication.SetGroupOption]";
                dbcommand.CommandTimeout = base.GetCommandTimeout();

                dbcommand.Parameters.Add(new SqlParameter("@GroupID", groupID));
                dbcommand.Parameters.Add(new SqlParameter("@IncludeMemberPublications", val));

                dbcommand.Connection = dbconnection;
                dbcommand.ExecuteNonQuery();

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
		


        public void EditGroupCustomPublication(Hashtable parameters, long subjectID, XmlDocument PropertyListXML)
        {
            ActivityLog(PropertyListXML, subjectID, "MPID", parameters["@mpid"].ToString());
            string skey = string.Empty;
            string sparam = string.Empty;

            try
            {
                SessionManagement sm = new SessionManagement();
                string connstr = this.GetConnectionString();

                SqlConnection dbconnection = new SqlConnection(connstr);

                SqlCommand comm = new SqlCommand();


                foreach (object key in parameters.Keys)
                {
                    skey = (string)key;
                    sparam = (string)parameters[skey].ToString();
                    comm.Parameters.Add(new SqlParameter(skey, sparam));
                }

                comm.Connection = dbconnection;
                comm.Connection.Open();
                comm.CommandType = CommandType.StoredProcedure;
                comm.CommandText = "[Profile.Data].[Publication.Group.MyPub.UpdatePublication]";
                comm.ExecuteScalar();

                comm.Connection.Close();

                if (dbconnection.State != ConnectionState.Closed)
                    dbconnection.Close();

            }
            catch (Exception e)
            {
                Framework.Utilities.DebugLogging.Log(e.Message + e.StackTrace);
                throw new Exception(e.Message);
            }


        }

        public SqlDataReader GetGroupCustomPub(string mpid)
        {
            SessionManagement sm = new SessionManagement();
            string connstr = this.GetConnectionString();

            SqlConnection dbconnection = new SqlConnection(connstr);
            SqlDataReader reader;

            SqlParameter[] param = null;

            try
            {
                dbconnection.Open();

                //For Output Parameters you need to pass a connection object to the framework so you can close it before reading the output params value.
                reader = GetDBCommand(dbconnection, "exec [Profile.Data].[Publication.Group.MyPub.GetPublication]  '" + mpid.ToString() + "'", CommandType.Text, CommandBehavior.CloseConnection, param).ExecuteReader();
            }
            catch (Exception e)
            {
                Framework.Utilities.DebugLogging.Log(e.Message + e.StackTrace);
                throw new Exception(e.Message);
            }

            return reader;

        }
    }
}
