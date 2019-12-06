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

using System.Data.SqlClient;
using System.Xml;
using System.Configuration;


using Profiles.Framework.Utilities;

namespace Profiles.Edit.Modules.CustomEditWebsite
{
    public class DataIO : Profiles.Edit.Utilities.DataIO
    {
        public List<WebsiteState> GetWebsiteData(Int64 NodeID, string Predicate)
        {
            string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;

            using (SqlConnection dbconnection = new SqlConnection(connstr))
            {
                SqlParameter[] param = new SqlParameter[2];

                try
                {
                    dbconnection.Open();

                    param[0] = new SqlParameter("@NodeID", NodeID);
                    param[1] = new SqlParameter("@Predicate", Predicate);
                    SqlCommand comm = GetDBCommand(dbconnection, "[Edit.Module].[CustomEditWebsite.GetData]", CommandType.StoredProcedure, CommandBehavior.CloseConnection, param);

                    comm.Connection = dbconnection;

                    using (SqlDataReader dbreader = comm.ExecuteReader(CommandBehavior.CloseConnection))
                    {
                        List<WebsiteState> websiteState = new List<WebsiteState>();

                        while (dbreader.Read())
                        {
                            websiteState.Add(new WebsiteState(dbreader["UrlID"].ToString(), dbreader["URL"].ToString(), dbreader["WebpageTitle"].ToString(), dbreader["PublicationDate"].ToString(), Convert.ToInt32(dbreader["SortOrder"])));
                        }

                        return websiteState;
                    }
                }
                catch (Exception e)
                {
                    Framework.Utilities.DebugLogging.Log(e.Message + e.StackTrace);
                    throw new Exception(e.Message);
                }
            }
        }

        public void EditWebsiteData(string URLID, string URL, string WebPageTitle, string PublicationDate, int SortOrder)
        {
            try
            {
                if (HttpContext.Current.Request.QueryString["subject"] != null)
                {
                    Framework.Utilities.Cache.AlterDependency(HttpContext.Current.Request.QueryString["subject"].ToString());
                }
                string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;
                SqlConnection dbconnection = new SqlConnection(connstr);

                dbconnection.Open();

                SqlCommand dbcommand = new SqlCommand();
                dbcommand.CommandType = CommandType.StoredProcedure;

                dbcommand.CommandText = "[Edit.Module].[CustomEditWebsite.AddEditWebsite]";
                dbcommand.CommandTimeout = base.GetCommandTimeout();

                dbcommand.Parameters.Add(new SqlParameter("@ExistingURLID", URLID));
                dbcommand.Parameters.Add(new SqlParameter("@URL", URL));
                dbcommand.Parameters.Add(new SqlParameter("@WebPageTitle", WebPageTitle));
                dbcommand.Parameters.Add(new SqlParameter("@PublicationDate", PublicationDate));
                if (SortOrder > 0) dbcommand.Parameters.Add(new SqlParameter("@SortOrder", SortOrder));
                dbcommand.Connection = dbconnection;
                dbcommand.ExecuteNonQuery();

            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public void AddWebsite(Int64 NodeID, string predicate, string URL, string WebPageTitle, string PublicationDate)
        {
            try
            {
                if (HttpContext.Current.Request.QueryString["subject"] != null)
                {
                    Framework.Utilities.Cache.AlterDependency(HttpContext.Current.Request.QueryString["subject"].ToString());
                }
                string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;
                SqlConnection dbconnection = new SqlConnection(connstr);

                dbconnection.Open();

                SqlCommand dbcommand = new SqlCommand();
                dbcommand.CommandType = CommandType.StoredProcedure;

                dbcommand.CommandText = "[Edit.Module].[CustomEditWebsite.AddEditWebsite]";
                dbcommand.CommandTimeout = base.GetCommandTimeout();

                dbcommand.Parameters.Add(new SqlParameter("@NodeID", NodeID));
                dbcommand.Parameters.Add(new SqlParameter("@URL", URL));
                dbcommand.Parameters.Add(new SqlParameter("@WebPageTitle", WebPageTitle));
                dbcommand.Parameters.Add(new SqlParameter("@PublicationDate", PublicationDate));
                dbcommand.Parameters.Add(new SqlParameter("@Predicate", predicate));
                dbcommand.Connection = dbconnection;
                dbcommand.ExecuteNonQuery();

            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public void DeleteWebsite(string URLID)
        {
            try
            {
                if (HttpContext.Current.Request.QueryString["subject"] != null)
                {
                    Framework.Utilities.Cache.AlterDependency(HttpContext.Current.Request.QueryString["subject"].ToString());
                }
                string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;
                SqlConnection dbconnection = new SqlConnection(connstr);

                dbconnection.Open();

                SqlCommand dbcommand = new SqlCommand();
                dbcommand.CommandType = CommandType.StoredProcedure;

                dbcommand.CommandText = "[Edit.Module].[CustomEditWebsite.AddEditWebsite]";
                dbcommand.CommandTimeout = base.GetCommandTimeout();

                dbcommand.Parameters.Add(new SqlParameter("@ExistingURLID", URLID));
                dbcommand.Parameters.Add(new SqlParameter("@Delete", 1));
                dbcommand.Connection = dbconnection;
                dbcommand.ExecuteNonQuery();

            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }
    }
}
