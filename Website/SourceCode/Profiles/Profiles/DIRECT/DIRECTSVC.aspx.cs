using Profiles.Framework.Utilities;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net;
using System.Runtime.InteropServices;
using System.Threading;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;

namespace Profiles.DIRECT
{
    public partial class DIRECTSVC : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            SessionManagement sessionManagement = new SessionManagement();
            Session session = sessionManagement.Session();

            //  http://localhost:55956/DIRECT/DIRECTSVC.aspx/getdata?siteID=5&searchQuery=asthma
            string siteID = string.Empty;
            siteID = Request.QueryString["siteID"].ToString();

            string searchQuery = string.Empty;
            searchQuery = Request.QueryString["searchQuery"].ToString();

            Dictionary<int, string> sites = new Dictionary<int, string>();
            try
            {
                string connstr = ConfigurationHelper.GetConnectionString(session);
                SqlConnection dbconnection = new SqlConnection(connstr);
                SqlCommand dbcommand = new SqlCommand("[Display.].[DIRECT.GetSiteQueryURLs]");
                dbcommand.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["COMMANDTIMEOUT"]);

                SqlDataReader dbreader;
                dbconnection.Open();
                dbcommand.CommandType = CommandType.StoredProcedure;

                dbcommand.Connection = dbconnection;
                dbreader = dbcommand.ExecuteReader(CommandBehavior.CloseConnection);
                while (dbreader.Read())
                {
                    int index = dbreader.GetInt32(dbreader.GetOrdinal("SiteID"));
                    string queryURL = dbreader["QueryURL"].ToString();
                    sites.Add(index, queryURL);
                }

                if (!dbreader.IsClosed)
                    dbreader.Close();

            }
            catch (Exception ex) { Framework.Utilities.DebugLogging.Log($"DIRECT/Display.aspx.cs : {ex.Message}"); }

            string url;
            sites.TryGetValue(Int32.Parse(siteID), out url);
            string x = HttpGet(url + searchQuery);
            XmlDocument objDoc = new XmlDocument();
            //objDoc = new XmlDocument();
            objDoc.LoadXml(x);

            string count = objDoc.SelectSingleNode("aggregation-result/count").InnerText;
            string popType = objDoc.SelectSingleNode("aggregation-result/population-type").InnerText;
            string srURL = objDoc.SelectSingleNode("aggregation-result/search-results-URL").InnerText;
            double cachetimeout = 0;
            string str = string.Empty;

            str = "{\"count\":" + count + ", \"population-type\":\"" + popType + "\", \"search-results-URL\":\""+ srURL + "\"}";



            cachetimeout = Convert.ToInt32(ConfigurationManager.AppSettings["SEARCH_CACHE_EXPIRE"]);

            //int a = new Random().Next(50, 5000) ;
            //Thread.Sleep(a);

            Response.ContentType = "application/json; charset=utf-8";
            //Response.AppendHeader("Access-Control-Allow-Origin", "*");
            Response.AppendHeader("cache-control", "public, max-age=" + cachetimeout);
            Response.Write(str);
        }

        public string HttpGet(string myUri)
        {
            Uri uri = new Uri(myUri);
            ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;
            WebRequest myRequest = WebRequest.Create(uri);
            myRequest.Method = "GET";

            string err = null;

            try
            { // get the response
                WebResponse myResponse = myRequest.GetResponse();
                if (myResponse == null)
                { return null; }
                StreamReader sr = new StreamReader(myResponse.GetResponseStream());
                return sr.ReadToEnd().Trim();
            }
            catch (WebException ex)
            {
                err = "Output=" + ex.Message;
            }
            return err;
        } // end HttpPost 

    }
}