using System;
using System.Collections.Generic;
using System.Web;
using System.Xml;
using System.Data.SqlClient;
using System.Net;
using System.IO;

using Profiles.Framework.Utilities;

namespace Profiles.DIRECT.Modules.DirectSearch
{
    public partial class DirectService : System.Web.UI.Page
    {
        DIRECT.Utilities.DataIO oDataIO;


        int[] SiteIDs;
        string[] URLs;
        string[] FSIDs;


        List<Site> ListOfSites;

        protected void Page_Load(object sender, EventArgs e)
        {
            DrawUIOnLoad();
        }
        protected void DrawUIOnLoad()
        {
            oDataIO = new DIRECT.Utilities.DataIO();

            Profiles.Search.Utilities.DataIO profileDataIO;

            string DirectServiceURL = Root.Domain + "/DIRECT/Modules/DirectSearch/directservice.aspx";// Request.Url.AbsoluteUri.Replace("&", "&amp;");
            string ProfilesURL = Root.Domain;
            string PopulationTypeText = oDataIO.GetDirectConfig().PopulationType;
            int QueryTimeout = oDataIO.GetDirectConfig().Timeout;
            XmlDocument query = new XmlDocument();
            XmlDocument result;

            Framework.Utilities.Namespace rdfnamespaces = new Namespace();
            XmlNamespaceManager namespaces = null;



            string sql = string.Empty;
            string ResultDetailsURL = string.Empty;
            string strResult = "";

            SqlDataReader dr;

            if (Request["Request"] == null) { return; }

            string task = Request["Request"].ToLower();
            switch (task)
            {
                case "getsites":
                    string ResultStr = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>" + "<site-list>";


                    dr = oDataIO.GetSitesOrderBySortOrder();
                    while (dr.Read())
                    {
                        Int64 SiteID = Convert.ToInt64(dr["SiteID"]);
                        string SiteName = dr["SiteName"].ToString();
                        string QueryURL = dr["QueryURL"].ToString();
                        if (SiteName == null) SiteName = "";
                        if (QueryURL == null) QueryURL = "";
                        ResultStr = ResultStr + "<site-description><site-id>" + SiteID + "</site-id><name>" + cx(SiteName) + "</name><aggregate-query>" + cx(QueryURL) + "</aggregate-query></site-description>";
                    }

                    if (!dr.IsClosed)
                        dr.Close();

                    ResultStr += "</site-list>";
                    Response.ContentType = "text/xml";
                    Response.AddHeader("Content-Type", "text/xml;charset=UTF-8");
                    //Response.ContentEncoding.CodePage = 65001;
                    Response.Charset = "UTF-8";

                    Response.Write(ResultStr);


                    break;
                case "incomingcount":

                    string q = Request["SearchPhrase"].Trim();
                    // Enter log record
                    oDataIO.AddLogIncoming(1, cs(Request.ServerVariables["REMOTE_ADDR"]), cs(q));

                    // Execute query
                    string x = "<SearchOptions>" +
                              "<MatchOptions>" +
                              "<SearchString ExactMatch=\"false\">" + cx(q) + "</SearchString> " +
                              "<SearchFiltersList /> " +
                              "<ClassURI>http://xmlns.com/foaf/0.1/Person</ClassURI> " +
                              "</MatchOptions>" +
                              "<OutputOptions>" +
                              "<Offset>0</Offset>" +
                              "<Limit>1</Limit> " +
                              "<SortByList>" +
                              "</SortByList>" +
                              "</OutputOptions>" +
                              "</SearchOptions>";
                    query.LoadXml(x);

                    profileDataIO = new Profiles.Search.Utilities.DataIO();
                    result = profileDataIO.Search(query,false);
                    namespaces = rdfnamespaces.LoadNamespaces(result);

                    string ResultCount = result.SelectSingleNode("rdf:RDF/rdf:Description/prns:numberOfConnections", namespaces).InnerText;

                    // Form result message
                    ResultStr = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
                    ResultStr += "<aggregation-result>";
                    ResultStr += "<count>" + ResultCount + "</count>";
                    ResultStr += "<population-type>" + PopulationTypeText + "</population-type>";
                    ResultStr += "<preview-URL>" + DirectServiceURL + "?Request=IncomingPreview&amp;SearchPhrase=" + cx(q) + "</preview-URL>";
                    ResultStr += "<search-results-URL>" + DirectServiceURL + "?Request=IncomingDetails&amp;SearchPhrase=" + cx(q) + "</search-results-URL>";
                    ResultStr += "</aggregation-result>";

                    // Send result
                    Response.ContentType = "text/xml";
                    Response.AddHeader("Content-Type", "text/xml;charset=UTF-8");
                    //Response.ContentEncoding.CodePage = 65001;
                    Response.Charset = "UTF-8";
                    Response.Write(ResultStr);
                    break;

                case "incomingdetails":

                    if (Session["DIRECTSEARCHREQUEST"] != null)
                    {
                        Session["DIRECTKEYWORD"] = null;
                        Session["DIRECTSEARCHREQUEST"] = null;
                        Session["DIRECTSEARCHTYPE"] = null;
                    }
                    q = Request["SearchPhrase"].Trim();

                    // Enter log record
                    oDataIO.AddLogIncoming(1, cs(Request.ServerVariables["REMOTE_ADDR"]), cs(q));

                    // Execute query                    

                    query.LoadXml("<SearchOptions>" +
                           "<MatchOptions>" +
                           "<SearchString ExactMatch=\"false\">" + cx(q) + "</SearchString> " +
                           "<SearchFiltersList /> " +
                           "<ClassURI>http://xmlns.com/foaf/0.1/Person</ClassURI> " +
                           "</MatchOptions>" +
                           "<OutputOptions>" +
                           "<Offset>0</Offset>" +
                           "<Limit>1</Limit> " +
                           "<SortByList>" +
                           "</SortByList>" +
                           "</OutputOptions>" +
                           "</SearchOptions>");


                    profileDataIO = new Profiles.Search.Utilities.DataIO();
                    result = profileDataIO.Search(query,false);

                    strResult = result.InnerXml;

                    // Parse results                  
                    XmlDocument objDoc = new XmlDocument();
                    objDoc = new XmlDocument();
                    objDoc.LoadXml(strResult);


                    namespaces = rdfnamespaces.LoadNamespaces(result);

                    ResultCount = result.SelectSingleNode("rdf:RDF/rdf:Description/prns:numberOfConnections", namespaces).InnerText;

                    if (ProfilesURL.Substring(ProfilesURL.Length - 1) != "/") { ProfilesURL += "/"; }
                    Response.Redirect(ProfilesURL + "search/default.aspx?searchtype=people&classuri=http://xmlns.com/foaf/0.1/Person&searchfor=" + q + "&exactPhrase=false");



                    break;
                case "incomingpreview":

                    q = Request["SearchPhrase"].Trim();

                    Utilities.DataIO data = new Profiles.DIRECT.Utilities.DataIO();

                    string searchphrase = Request["SearchPhrase"].Trim();
                    
                    Response.Write(data.Search(searchphrase));

                    break;

                case "outgoingcount":

                    if (Request["blank"] == "y")
                    {
                        Response.Write("<html><body></body></html>");
                        Response.End();
                    }

                    string SearchPhrase = Request["SearchPhrase"];


                    Response.Write("<script>parent.dsLoading=1;</script>" + Environment.NewLine);


                    dr = oDataIO.GetSitesOrderBySiteID();

                    SiteIDs = new int[1000];
                    URLs = new string[1000];
                    FSIDs = new string[1000];

                    Site site;
                    ListOfSites = new List<Site>();
                    Int64 sites = 0;

                    List<AsyncProcessing> ListOfThreads = new List<AsyncProcessing>();
                    AsyncProcessing async;
                    while (dr.Read())
                    {
                        SiteIDs[sites] = Convert.ToInt32(dr["SiteID"].ToString());
                        URLs[sites] = dr["QueryURL"] + SearchPhrase;
                        FSIDs[sites] = dr["FSID"].ToString();
                        site = new Site(URLs[sites], SiteIDs[sites], FSIDs[sites], SearchPhrase, HttpContext.Current);
                        ListOfSites.Add(site);
                        async = new AsyncProcessing();
                        async.BeginProcessRequest(site);
                        ListOfThreads.Add(async);
                        sites++;
                    }

                    if (!dr.IsClosed)
                        dr.Close();


                    //eat up the CPU for x number of seconds :) so all the requests can come back.  This is set in the web.config file
                    DateTime end = DateTime.Now.AddSeconds(QueryTimeout);
                    while (DateTime.Now < end)
                    { }

                    //close out anything that did not complete in 5 seconds
                    for (int loop = 0; loop < ListOfThreads.Count; loop++)
                    {

                        if (!ListOfThreads[loop].Site.IsDone)
                        {
                            DIRECT.Utilities.DataIO data2 = new DIRECT.Utilities.DataIO();
                            data2.UpdateLogOutgoing(cs(ListOfThreads[loop].Site.FSID), 1);

                            Response.Write("<script>parent.siteResult(" + ListOfThreads[loop].Site.SiteID + ",1,0,'','','','');</script>");
                            ListOfThreads.Remove(ListOfThreads[loop]);
                        }
                    }

                    try
                    {
                        Response.Flush();
                    }
                    catch { }

                    break;
                case "outgoingdetails":

                    string FSID = Request["fsid"].Trim();
                    string SiteId = string.Empty;
                    if (FSID != "")
                    {
                        dr = oDataIO.GetFsID(cs(FSID));

                        if (dr.Read())
                        {
                            SiteId = dr["SiteID"].ToString();
                            ResultDetailsURL = dr["ResultDetailsURL"].ToString().Replace("\n\t", "");
                        }

                        if (!dr.IsClosed)
                            dr.Close();
                    }
                    if ((FSID != "") && (SiteId != "") && (ResultDetailsURL != ""))
                    {
                        // Enter log record
                        oDataIO.AddLogOutgoing(FSID, Convert.ToInt32(SiteId), 1);

                        Response.Redirect(ResultDetailsURL);

                    }
                    else
                        Response.Redirect(ProfilesURL);
                    break;
            }

            Response.End();
        }

        #region <Methods/>

        private double Timer()
        {

            TimeSpan sinceMidnight = DateTime.Now - DateTime.Today;
            return sinceMidnight.TotalSeconds;

        }


        private string cs(string temp)
        {
            if (temp == null)
            {
                return "";
            }
            else
            {
                return "'" + temp.Replace("'", "''") + "'";
            }
        }

        string cx(string temp)
        {
            return temp.Replace("&", "&amp;").Replace("<", "&lt;").Replace(">", "&gt;").Replace("\"", "&quot;").Replace("'", "&apos;");
        }

        string ch(string temp)
        {
            return "'" + temp.Replace(@"\", @"\\").Replace("'", "\'") + "'";
        }



        public string GetXMLText(XmlElement tempXML, string tempPath)
        {
            string tempT = string.Empty;
            XmlNode tempX = null;

            if (tempXML != null)
            {
                tempX = tempXML.SelectSingleNode(tempPath);
                if (tempX != null)
                {
                    tempT = tempX.InnerText;
                }
            }
            return tempT;
        }

        #endregion
    }


    public class Site
    {
        public Site(string url, int siteid, string fsid, string searchphrase, HttpContext context)
        {
            this.URL = url;
            this.SiteID = siteid;
            this.FSID = fsid;
            this.SearchPhrase = searchphrase;
            this.Context = context;
        }
        public bool Completed { get; set; }
        public string URL { get; set; }
        public int SiteID { get; set; }
        public string FSID { get; set; }
        public string SearchPhrase { get; set; }
        public string JavaScript { get; set; }
        public bool IsDone { get; set; }
        public HttpContext Context { get; set; }

    }

    public class AsyncProcessing
    {

        DataIO oDataIO;
        SqlCommand sqlCmd;
        SqlConnection Conn;

        private WebRequest _request;

        public AsyncProcessing()
        {

        }

        public void BeginProcessRequest(Site site)
        {
            string sql = "";
            int iResult = 0;
            this.Site = site;

            site.IsDone = false;
            _request = WebRequest.Create(site.URL);

            // Enter log record
            DIRECT.Utilities.DataIO data = new DIRECT.Utilities.DataIO();
            data.AddLogOutgoing(site.FSID, site.SiteID, 0);

            _request.BeginGetResponse(new AsyncCallback(EndProcessRequest), site);
        }

        public void EndProcessRequest(IAsyncResult result)
        {
            string resultdata = String.Empty;
            Site site = (Site)result.AsyncState;
            XmlElement ResultXML;
            XmlDocument outgoingcount;
            WebResponse response = null;


            try
            {
                response = _request.EndGetResponse(result);
            }
            catch
            {
                return;
            }

            string ResultCount = string.Empty;
            string ResultDetailsURL = string.Empty;
            string ResultPopulationType = string.Empty;
            string ResultPreviewURL = string.Empty;
            string ResultText = string.Empty;
            string sql = string.Empty;

            using (response)
            {
                StreamReader reader = new StreamReader(response.GetResponseStream());
                resultdata = reader.ReadToEnd();
                reader.Close();

                outgoingcount = new XmlDocument();

                if (resultdata != "ERROR")
                {
                    resultdata = this.CRLF(resultdata);
                    try
                    {
                        outgoingcount.LoadXml(resultdata);

                        ResultText = resultdata;
                        ResultXML = outgoingcount.DocumentElement;
                        ResultCount = GetXMLText(ResultXML, "//count");
                        ResultDetailsURL = GetXMLText(ResultXML, "//search-results-URL");
                        ResultPopulationType = GetXMLText(ResultXML, "//population-type");
                        ResultPreviewURL = GetXMLText(ResultXML, "//preview-URL");
                    }
                    catch (Exception ex)
                    {
                        ex = ex;
                    }

                }
                else
                {
                    ResultText = resultdata;
                }

                DIRECT.Utilities.DataIO data = new DIRECT.Utilities.DataIO();
                data.UpdateLogOutgoing(site.FSID, 4, 200, ResultText.Substring(0, ResultText.Length > 3000 ? 3000 : ResultText.Length), ResultCount, ResultDetailsURL);


                //if (Conn.State == System.Data.ConnectionState.Open)
                //    Conn.Close();

                site.JavaScript = "<script language=\"javascript\" type=\"text/javascript\">parent.siteResult(" + site.SiteID + ",0," + ch(ResultCount) + "," + ch(ResultDetailsURL) + "," + ch(ResultPopulationType) + "," + ch(ResultPreviewURL) + ",'" + site.FSID + "');</script>" + Environment.NewLine;
                try
                {
                site.Context.Response.Write(site.JavaScript);
                }
                catch (Exception ex)
                {
                    //do nothing

                }
                try
                {
                    site.Context.Response.Flush();
                }
                catch (Exception ex)
                { ex = ex; }
                site.IsDone = true;
                this.Site = site;
                response.Close();
            }

        }



        public Site Site { get; set; }


        #region <Methods/>

        string cx(string temp)
        {
            return temp.Replace("&", "&amp;").Replace("<", "&lt;").Replace(">", "&gt;").Replace("\"", "&quot;").Replace("'", "&apos;");
        }

        string CRLF(string temp)
        {
            temp = temp.Replace("\n", "");
            temp = temp.Replace("\t", "");
            temp = temp.Replace("\r", "");
            return temp;
        }
        string ch(string temp)
        {
            temp = temp.Replace(@"\", "\\");
            temp = temp.Replace("'", "\'") + "'";
            temp = temp.Replace("\n", "");
            temp = temp.Replace("\t", "");

            return "'" + temp;
        }


        public string GetXMLText(XmlElement tempXML, string tempPath)
        {


            string tempT = string.Empty;
            XmlNode tempX = null;

            if (tempXML != null)
            {
                tempX = tempXML.SelectSingleNode(tempPath);
                if (tempX != null)
                {
                    tempT = tempX.InnerText;
                }
            }
            return tempT;
        }


        #endregion




    }


}