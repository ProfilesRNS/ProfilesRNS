using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Text;

using Profiles.Framework.Utilities;
using System.Text.RegularExpressions;
using static Profiles.Profile.Modules.NetworkMap.NetworkMap;
using System.Web.UI.HtmlControls;

namespace Profiles.Lists.Modules.NetworkMapList
{
    public partial class NetworkMapList : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            LoadAssets();
            DrawProfilesModule();
          

        }
        private void LoadAssets()
        {


            //This should loop the application table or be set based on the contest of the RESTFul URL to know
            //What application is currently being viewed then set the correct asset link.

            HtmlLink Profilescss = new HtmlLink();
            Profilescss.Href = Root.Domain + "/framework/css/profiles.css";
            Profilescss.Attributes["rel"] = "stylesheet";
            Profilescss.Attributes["type"] = "text/css";
            Profilescss.Attributes["media"] = "all";
            Page.Header.Controls.Add(Profilescss);


            HtmlGenericControl jsscript = new HtmlGenericControl("script");
            jsscript.Attributes.Add("type", "text/javascript");
            jsscript.Attributes.Add("src", Root.Domain + "/Framework/JavaScript/profiles.js");
            Page.Header.Controls.Add(jsscript);



            HtmlLink PRNStheme = new HtmlLink();
            PRNStheme.Href = Root.Domain + "/framework/css/prns-theme.css";
            PRNStheme.Attributes["rel"] = "stylesheet";
            PRNStheme.Attributes["type"] = "text/css";
            PRNStheme.Attributes["media"] = "all";
            Page.Header.Controls.Add(PRNStheme);


            HtmlLink PRNSthemeMenusTop = new HtmlLink();
            PRNSthemeMenusTop.Href = Root.Domain + "/framework/css/prns-theme-menus-top.css";
            PRNSthemeMenusTop.Attributes["rel"] = "stylesheet";
            PRNSthemeMenusTop.Attributes["type"] = "text/css";
            PRNSthemeMenusTop.Attributes["media"] = "all";
            Page.Header.Controls.Add(PRNSthemeMenusTop);

            HtmlLink Displaycss = new HtmlLink();
            Displaycss.Href = Root.Domain + "/Profile/CSS/display.css";
            Displaycss.Attributes["rel"] = "stylesheet";
            Displaycss.Attributes["type"] = "text/css";
            Displaycss.Attributes["media"] = "all";
            Page.Header.Controls.Add(Displaycss);



        }
        private void DrawProfilesModule()
        {
            Profiles.Profile.Utilities.DataIO data = new Profiles.Profile.Utilities.DataIO();
            string listid = "";
            if (!string.IsNullOrEmpty(Request.QueryString["listid"]))
            {
                listid = Request.QueryString["listid"].ToString();


                dlGoogleMapLinks.DataSource = data.GetGoogleMapZoomLinks();
                dlGoogleMapLinks.DataBind();

                SqlDataReader reader = null;
                SqlDataReader reader2 = null;

                Profiles.Framework.Utilities.SessionManagement session = new SessionManagement();

                GoogleMapHelper gmh = new GoogleMapHelper();


                reader = Profiles.Lists.Utilities.DataIO.GetGMapList(listid, "0", session.Session().SessionID);
                reader2 = Profiles.Lists.Utilities.DataIO.GetGMapList(listid, "1", session.Session().SessionID);
                litRedMapType.Text = "list members";


                string googleCode;
                gmh.MapPlotPeople(reader, reader2, out googleCode);
                litGoogleCode.Text = googleCode;               


                if (!reader.IsClosed)
                    reader.Close();

                if (!reader2.IsClosed)
                    reader2.Close();
            }
        }
    }

    /// <summary>
    /// Summary description for GoogleMapHelper
    /// </summary>
    public class GoogleMapHelper
    {
        public GoogleMapHelper() { }

        public void MapPlotPeople(SqlDataReader reader, SqlDataReader reader2, out string googleCode)
        {
            
            var htmlBuilder = new StringBuilder();

            htmlBuilder.AppendLine("<script type=\"text/javascript\">");

            try
            {

                string cLat = GetDefaultZoom().Latitude;
                string cLong = GetDefaultZoom().Longitude;
                string sLevel = GetDefaultZoom().ZoomLevel;

                htmlBuilder.Append("longitude = " + cLong + ";");
                htmlBuilder.Append("latitude = " + cLat + ";");


                // PRNS object hiearchy template 
                htmlBuilder.AppendLine("if (typeof ProfilesRNS === \"undefined\") ProfilesRNS = {};");
                htmlBuilder.AppendLine("if (typeof ProfilesRNS.currentPage === \"undefined\") ProfilesRNS.currentPage = {};");
                htmlBuilder.AppendLine("if (typeof ProfilesRNS.currentPage.data === \"undefined\") ProfilesRNS.currentPage.data = {};");



                htmlBuilder.AppendLine(String.Format(" ProfilesRNS.currentPage.data.mapCenter = new google.maps.LatLng({0},{1},{2});", cLat, cLong, sLevel));

               // htmlBuilder.AppendLine(string.Format("zoomMap({0},{1},{2});", sLevel, cLat, cLong));


                Dictionary<string, GoogleMapLocation> gMapLocation = GenerateGMapLocations(reader);
                WriteGMapLocations(gMapLocation, htmlBuilder);
                

                var locArrayIndex = 0;
                htmlBuilder.AppendLine("ProfilesRNS.currentPage.data.network = [");
                while (reader2.Read())
                {
                    htmlBuilder.AppendLine("{p1:[" + reader2["x1"].ToString() + "," + reader2["y1"].ToString() + "], p2:[" + reader2["x2"].ToString() + "," + reader2["y2"].ToString() + "],zm:0},");
                    locArrayIndex = locArrayIndex + 1;
                }

                htmlBuilder.AppendLine("];");



            }
            catch (Exception ex)
            {
                string err = ex.Message;
            }
            finally
            {
                if (reader != null)
                { if (!reader.IsClosed) { reader.Close(); } }
            }



            htmlBuilder.AppendLine("</script>");

            googleCode = htmlBuilder.ToString();
        }        
        private static void WriteGMapLocations(Dictionary<string, GoogleMapLocation> locationsDict, StringBuilder value)
        {
            if (locationsDict == null) throw new ArgumentNullException("locationsDict");
            if (value == null) throw new ArgumentNullException("value");

            var ctr = 0;


            value.AppendLine("ProfilesRNS.currentPage.data.people = [");

            foreach (var location in locationsDict.Values)
            {
                var html = GenerateLocHtml(location);
                value.AppendLine("{lt:" + location.Latitude + ",ln:" + location.Longitude + ",name:'" + location.PersonName.Replace("'", " ") + "', txt:'" + html + "'},");
                //{lt:1,ln:2, name: '3', txt:'4'},
                ctr++;
            }

            value.AppendLine("];");
        }

        private static Dictionary<string, GoogleMapLocation> GenerateGMapLocations(SqlDataReader reader)
        {
            var locationsDict = new Dictionary<string, GoogleMapLocation>();

            while (reader.Read())
            {
                var address = reader["address1"].ToString().Replace("'", "\\'") + "<br />" + reader["address2"].ToString().Replace("'", "\\'");
                var latitude = reader["latitude"].ToString();
                var longitude = reader["longitude"].ToString();
                var latLongHash = latitude + longitude;
                var personname = reader["display_name"].ToString();

                GoogleMapLocation gMapLocation;
                var personATag = GeneratePersonAtag(reader["URI"].ToString(), reader["display_name"].ToString());

                if (locationsDict.ContainsKey(latLongHash))
                {
                    gMapLocation = locationsDict[latLongHash];
                    gMapLocation.PersonsAtagString += personATag;
                }
                else
                {
                    gMapLocation = new GoogleMapLocation
                    {
                        Address = address,
                        Latitude = latitude,
                        Longitude = longitude,
                        PersonsAtagString = personATag,
                        PersonName = personname
                    };
                    locationsDict.Add(latLongHash, gMapLocation);
                }
            }

            reader.Close();

            return locationsDict;
        }

        private static string GeneratePersonAtag(string uri, string displayName)
        {
            return string.Format("<a href=\"{0}\" target=\"_parent\">{1}</a><br>", uri, displayName.Replace("'", "\\'"));
        }

        private static string GenerateLocHtml(GoogleMapLocation mapLoc)
        {
            var htmlBuilder = new StringBuilder();
            htmlBuilder.Append("<div style=\"text-align:left\">");
            htmlBuilder.Append("<div style=\"font-weight:bold;font-size:14px;\">" + mapLoc.Address + "</div>");
            htmlBuilder.Append(mapLoc.PersonsAtagString);
            htmlBuilder.Append("</div><br />");
            return htmlBuilder.ToString().Replace("'", "\'");
        }


        //***************************************************************************************************************************************
        public GoogleMapLocation GetDefaultZoom()
        {
            GoogleMapLocation loc = null;

            loc = Profiles.Lists.Utilities.DataIO.GetGoogleMapZoomLinks().Find(x => x.DefaultLevel == "True");

            return loc;
        }


    }





}
