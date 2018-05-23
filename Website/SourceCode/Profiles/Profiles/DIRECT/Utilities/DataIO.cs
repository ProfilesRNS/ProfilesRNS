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
using System.Xml;
using System.Configuration;
using System.Net;
using System.IO;
using System.Text;

using Profiles.Framework.Utilities;

namespace Profiles.DIRECT.Utilities
{
    public class DataIO : Profiles.Framework.Utilities.DataIO
    {


        public string Search(string searchfor)
        {

            string result = string.Empty;



            try
            {


                HttpWebRequest request = null;
                request = (HttpWebRequest)WebRequest.Create(Root.Domain + "/search/default.aspx?searchtype=people&classuri=http://xmlns.com/foaf/0.1/Person&searchfor=" + searchfor + "&exactPhrase=false");
                request.Method = "POST";

                request.ContentType = "application/x-www-form-urlencoded";
                request.ContentLength = (Root.Domain + "/search/default.aspx?searchtype=people&classuri=http://xmlns.com/foaf/0.1/Person&searchfor=" + searchfor + "&exactPhrase=false").Length;

                using (Stream writeStream = request.GetRequestStream())
                {
                    UTF8Encoding encoding = new UTF8Encoding();
                    byte[] bytes = encoding.GetBytes(Root.Domain + "/search/default.aspx?searchtype=people&classuri=http://xmlns.com/foaf/0.1/Person&searchfor=" + searchfor + "&exactPhrase=false");
                    writeStream.Write(bytes, 0, bytes.Length);
                }

                using (HttpWebResponse response = (HttpWebResponse)request.GetResponse())
                {
                    using (Stream responseStream = response.GetResponseStream())
                    {
                        using (StreamReader readStream = new StreamReader(responseStream, Encoding.UTF8))
                        {
                            result = readStream.ReadToEnd();
                            readStream.Close();
                        }
                        responseStream.Close();
                    }
                    response.Close();
                }


            }
            catch (Exception e)
            {
                Framework.Utilities.DebugLogging.Log(e.Message + " " + e.StackTrace);
                throw new Exception(e.Message);
            }


            return result;
        }

        public Profiles.DIRECT.Utilities.DirectConfig GetDirectConfig()
        {
            XmlDocument vals = new XmlDocument();
            Profiles.DIRECT.Utilities.DirectConfig config = new DirectConfig();

            try
            {
                String Filepath = System.Web.HttpContext.Current.Server.MapPath("~/DIRECT/Modules/DirectSearch/Config.xml");
                vals.Load(Filepath);
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }

            config.PopulationType = vals.SelectSingleNode("directconfig/directpopulationtype").InnerText;
            config.Timeout = Convert.ToInt32(vals.SelectSingleNode("directconfig/querytimeout").InnerText);

            return config;
        }


        public SqlDataReader DirectResultset()
        { 
            string sql = "select * from [Direct.].Sites with (NOLOCK) where isactive = 1 order by SortOrder";
            SqlDataReader sqldr = this.GetSQLDataReader("ProfilesDB", sql, CommandType.Text, CommandBehavior.CloseConnection, null);
            return sqldr;

        }

        public SqlDataReader GetSitesOrderBySortOrder()
        {
            string sql = "select * from [Direct.].Sites with (NOLOCK) where isactive = 1 order by sortorder";
            SqlDataReader sqldr = this.GetSQLDataReader("ProfilesDB", sql, CommandType.Text, CommandBehavior.CloseConnection, null);
            return sqldr;
        }

        public SqlDataReader GetSitesOrderBySiteID()
        {
            string sql = "select SiteID, QueryURL, newid() FSID from [Direct.].Sites with (NOLOCK) where isactive = 1 order by SiteID; select count(siteid) from [Direct.].Sites  with (NOLOCK);";
            SqlDataReader sqldr = this.GetSQLDataReader("ProfilesDB", sql, CommandType.Text, CommandBehavior.CloseConnection, null);
            return sqldr;
        }


        public SqlDataReader GetFsID(string FsID)
        {
            string sql = "select siteid, resultdetailsurl from [Direct.].LogOutgoing with (NOLOCK) where details = 0 and fsid = " + FsID;
            SqlDataReader sqldr = this.GetSQLDataReader("ProfilesDB", sql, CommandType.Text, CommandBehavior.CloseConnection, null);
            return sqldr;
        }

        public void AddLogIncoming(int details, string requestIP, string queryString)
        {
            string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;
            SqlConnection dbconnection = new SqlConnection(connstr);
            SqlParameter[] param = new SqlParameter[3];
            try
            {

                dbconnection.Open();

                param[0] = new SqlParameter("@Details", details);
                param[1] = new SqlParameter("@RequestIP", requestIP);
                param[2] = new SqlParameter("@QueryString", queryString);

                //For Output Parameters you need to pass a connection object to the framework so you can close it before reading the output params value.
                ExecuteSQLDataCommand(GetDBCommand(ref dbconnection, "[Direct.].[AddLogIncoming]", CommandType.StoredProcedure, CommandBehavior.CloseConnection, param));

                dbconnection.Close();
                SqlConnection.ClearPool(dbconnection);

            }
            catch (Exception e)
            {
                Framework.Utilities.DebugLogging.Log(e.Message + e.StackTrace);
                throw new Exception(e.Message);
            }

        }

        public void AddLogOutgoing(string fsid, int siteID, int details)
        {
            string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;
            SqlConnection dbconnection = new SqlConnection(connstr);
            SqlParameter[] param = new SqlParameter[3];
            try
            {

                dbconnection.Open();

                param[0] = new SqlParameter("@FSID", fsid);
                param[1] = new SqlParameter("@SiteID", siteID);
                param[2] = new SqlParameter("@Details", details);
                //For Output Parameters you need to pass a connection object to the framework so you can close it before reading the output params value.
                ExecuteSQLDataCommand(GetDBCommand(ref dbconnection, "[Direct.].[AddLogOutgoing]", CommandType.StoredProcedure, CommandBehavior.CloseConnection, param));

                dbconnection.Close();
                SqlConnection.ClearPool(dbconnection);

            }
            catch (Exception e)
            {
                Framework.Utilities.DebugLogging.Log(e.Message + e.StackTrace);
                throw new Exception(e.Message);
            }

        }

        public void UpdateLogOutgoing(string fsid, int responseState, int responseStatus, string resultText, string resultCount, string resultDetailsURL)
        {
            string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;
            SqlConnection dbconnection = new SqlConnection(connstr);
            SqlParameter[] param = new SqlParameter[6];
            try
            {

                dbconnection.Open();

                param[0] = new SqlParameter("@FSID", fsid);
                param[1] = new SqlParameter("@ResponseState", responseState);
                param[2] = new SqlParameter("@ResponseStatus", responseStatus);
                param[3] = new SqlParameter("@ResultText", resultText);
                param[4] = new SqlParameter("@ResultCount", resultCount);
                param[5] = new SqlParameter("@ResultDetailsURL", resultDetailsURL);
                //For Output Parameters you need to pass a connection object to the framework so you can close it before reading the output params value.
                ExecuteSQLDataCommand(GetDBCommand(ref dbconnection, "[Direct.].[UpdateLogOutgoing]", CommandType.StoredProcedure, CommandBehavior.CloseConnection, param));

                dbconnection.Close();
                SqlConnection.ClearPool(dbconnection);

            }
            catch (Exception e)
            {
                Framework.Utilities.DebugLogging.Log(e.Message + e.StackTrace);
                throw new Exception(e.Message);
            }

        }

        public void UpdateLogOutgoing(string fsid, int responseState)
        {
            string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;
            SqlConnection dbconnection = new SqlConnection(connstr);
            SqlParameter[] param = new SqlParameter[6];
            try
            {

                dbconnection.Open();

                param[0] = new SqlParameter("@FSID", fsid.Replace("'", ""));
                param[1] = new SqlParameter("@ResponseState", responseState);
                //For Output Parameters you need to pass a connection object to the framework so you can close it before reading the output params value.
                ExecuteSQLDataCommand(GetDBCommand(ref dbconnection, "[Direct.].[UpdateLogOutgoing]", CommandType.StoredProcedure, CommandBehavior.CloseConnection, param));

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
