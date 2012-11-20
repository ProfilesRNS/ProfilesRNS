using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Data.Common;
using System.Globalization;
using System.Text;
using System.Xml;
using System.Web.UI.HtmlControls;


using Profiles.Framework.Utilities;
using Profiles.Profile.Utilities;

namespace Profiles.Profile.Modules.NetworkMap
{
    public partial class NetworkMap : BaseModule
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            DrawProfilesModule();
        }
        public NetworkMap() { }
        public NetworkMap(XmlDocument data, List<ModuleParams> moduleparams, XmlNamespaceManager namespaces)
            : base(data, moduleparams, namespaces)
        {

        }


        public void DrawProfilesModule()
        {
            Profiles.Profile.Utilities.DataIO data = new Profiles.Profile.Utilities.DataIO();

            if (Request.QueryString["Subject"] == null)
                return;

            base.RDFTriple = new RDFTriple(Convert.ToInt64(Request.QueryString["Subject"]));



            dlGoogleMapLinks.DataSource = data.GetGoogleMapZoomLinks();
            dlGoogleMapLinks.DataBind();

            SqlDataReader reader = null;
            SqlDataReader reader2 = null;

            Profiles.Framework.Utilities.SessionManagement session = new SessionManagement();

            GoogleMapHelper gmh = new GoogleMapHelper();

            if (base.GetModuleParamString("MapType") == "CoAuthor")
            {

                reader = data.GetGMapUserCoAuthors(base.RDFTriple.Subject, 0, session.Session().SessionID);
                reader2 = data.GetGMapUserCoAuthors(base.RDFTriple.Subject, 1, session.Session().SessionID);

            }

            if (base.GetModuleParamString("MapType") == "SimilarTo")
            {
                reader = data.GetGMapUserSimilarPeople(base.RDFTriple.Subject, false, session.Session().SessionID);
                reader2 = data.GetGMapUserSimilarPeople(base.RDFTriple.Subject, true, session.Session().SessionID);
            }


            


            litGoogleCode.Text =  gmh.MapPlotPeople(base.RDFTriple.Subject, reader, reader2);



            if (!reader.IsClosed)
                reader.Close();

            if (!reader2.IsClosed)
                reader2.Close();


        }

        /// <summary>
        /// Summary description for GoogleMapHelper
        /// </summary>
        public class GoogleMapHelper
        {
            public GoogleMapHelper() { }

            public string MapPlotPeople(Int64 personId, SqlDataReader reader, SqlDataReader reader2)
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



                    if (personId != 0)
                    {

                        WriteGMapLocations(GenerateGMapLocations(reader), htmlBuilder);

                        var locArrayIndex = 0;
                        htmlBuilder.AppendLine("ProfilesRNS.currentPage.data.network = [");
                        while (reader2.Read())
                        {
                            htmlBuilder.AppendLine("{p1:[" + reader2["x1"].ToString() + "," + reader2["y1"].ToString() + "], p2:[" + reader2["x2"].ToString() + "," + reader2["y2"].ToString() + "],zm:0},");
                            locArrayIndex = locArrayIndex + 1;
                        }

                        htmlBuilder.AppendLine("];");


                    }
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

                return htmlBuilder.ToString();
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
                    value.AppendLine("{lt:" + location.Latitude + ",ln:" + location.Longitude + ",name:'" + location.PersonName + "', txt:'" + html + "'},");
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
                return string.Format("<a href=\"{0}\">{1}</a><br>", uri, displayName.Replace("'", "\\'"));
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
            private class GoogleMapLocation
            {
                public string Address { get; set; }
                public string Latitude { get; set; }
                public string Longitude { get; set; }
                public string PersonsAtagString { get; set; }
                public string PersonName { get; set; }
            }

            //***************************************************************************************************************************************
            public Modules.NetworkMap.NetworkMap.GoogleMapLocation GetDefaultZoom()
            {
                Modules.NetworkMap.NetworkMap.GoogleMapLocation loc = null;
                Profiles.Profile.Utilities.DataIO data = new Profiles.Profile.Utilities.DataIO();


                loc = data.GetGoogleMapZoomLinks().Find(delegate(Modules.NetworkMap.NetworkMap.GoogleMapLocation item) { return item.DefaultLevel == "True"; });

                return loc;
            }


        }

        public class GoogleMapLocation
        {
            public string Address { get; set; }
            public string Latitude { get; set; }
            public string Longitude { get; set; }
            public string Label { get; set; }
            public string SortOrder { get; set; }
            public string DefaultLevel { get; set; }
            public string PersonsAtagString { get; set; }
            public string ZoomLevel { get; set; }
        }



    }
}