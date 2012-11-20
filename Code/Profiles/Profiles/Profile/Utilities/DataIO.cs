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

namespace Profiles.Profile.Utilities
{
    public class DataIO : Profiles.Framework.Utilities.DataIO
    {
        #region "Profile,Network,Connection and PresentationXML"
        public XmlDocument GetRDFData(RDFTriple request)
        {
            string xmlstr = string.Empty;
            XmlDocument xmlrtn = new XmlDocument();
            try
            {
                if (Framework.Utilities.Cache.Fetch(request.Key + "data") == null || request.Edit)
                {

                    if (request.Type != string.Empty)
                    {

                        Framework.Utilities.DebugLogging.Log("{CLOUD} DATA BASE start GetRDFData(RDFTriple request)", request);
                        string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;

                        SqlConnection dbconnection = new SqlConnection(connstr);
                        SqlCommand dbcommand = new SqlCommand();

                        dbconnection.Open();
                        dbcommand.CommandType = CommandType.StoredProcedure;

                        dbcommand.CommandTimeout = base.GetCommandTimeout();

                        dbcommand.CommandText = "[RDF.].[GetDataRDF]";
                        dbcommand.Parameters.Add(new SqlParameter("@subject", request.Subject));
                        dbcommand.Parameters.Add(new SqlParameter("@predicate", request.Predicate));
                        dbcommand.Parameters.Add(new SqlParameter("@object", request.Object));
                        dbcommand.Parameters.Add(new SqlParameter("@returnXMLasStr", true));
                        

                        if (request.Offset != null && request.Offset != string.Empty)
                            dbcommand.Parameters.Add(new SqlParameter("@offset", request.Offset));

                        if (request.Limit != null && request.Limit != string.Empty)
                            dbcommand.Parameters.Add(new SqlParameter("@limit", request.Limit));

                        dbcommand.Parameters.Add(new SqlParameter("@showDetails", request.ShowDetails));
                        dbcommand.Parameters.Add(new SqlParameter("@expand", request.Expand));

                        dbcommand.Parameters.Add(new SqlParameter("@SessionID", request.Session.SessionID));

                        if (request.ExpandRDFList != string.Empty)
                            dbcommand.Parameters.Add(new SqlParameter("@ExpandRDFListXML", request.ExpandRDFList));

                        dbcommand.Connection = dbconnection;
                        Framework.Utilities.DebugLogging.Log("{CLOUD} DATA BASE end GetRDFData(RDFTriple request)", request);

                        using (var dbreader = dbcommand.ExecuteReader(CommandBehavior.CloseConnection))
                        {
                            while (dbreader.Read())
                            {
                                xmlstr += dbreader[0].ToString();
                            }
                            dbreader.Close();

                            SqlConnection.ClearPool(dbconnection);
                        }

                        xmlrtn.LoadXml(xmlstr);

                        Framework.Utilities.Cache.Set(request.Key + "data", xmlrtn);
                        xmlstr = string.Empty;

                    }
                    else if (request.URI != string.Empty)
                    {
                        Framework.Utilities.DebugLogging.Log("{CLOUD} HTTP POST start GetRDFData(RDFTriple request) ", request);
                        HTTPIO httpio = new HTTPIO();
                        xmlrtn = httpio.QueryHTTPIO(request);
                        Framework.Utilities.DebugLogging.Log("{CLOUD} HTTP POST end GetRDFData(RDFTriple request)", request);
                        Framework.Utilities.Cache.Set(request.Key + "data", xmlrtn);
                    }
                }


                else
                {
                    Framework.Utilities.DebugLogging.Log("{CLOUD} CACHE start GetRDFData(RDFTriple request)", request);
                    xmlrtn = Framework.Utilities.Cache.Fetch(request.Key + "data");
                    Framework.Utilities.DebugLogging.Log("{CLOUD} CACHE end GetRDFData(RDFTriple request)", request);
                }
            }
            catch (Exception e)
            {
                Framework.Utilities.DebugLogging.Log(e.Message + e.StackTrace);
                throw new Exception(e.Message);
            }

            return xmlrtn;
        }

        public XmlDocument GetPresentationData(RDFTriple request)
        {
            string xmlstr = string.Empty;
            XmlDocument xmlrtn = new XmlDocument();
            try
            {

                if (Framework.Utilities.Cache.Fetch(request.Key + "presentation") == null || request.Edit)
                {
                    string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;
                    SqlConnection dbconnection = new SqlConnection(connstr);
                    SqlCommand dbcommand = new SqlCommand("[rdf.].[GetPresentationXML]");

                    SqlDataReader dbreader;
                    dbconnection.Open();
                    dbcommand.CommandType = CommandType.StoredProcedure;
                    dbcommand.CommandTimeout = base.GetCommandTimeout();
                    dbcommand.Parameters.Add(new SqlParameter("@subject", request.Subject));
                    if (request.Predicate > 0)
                        dbcommand.Parameters.Add(new SqlParameter("@predicate", request.Predicate));

                    if (request.Object > 0)
                        dbcommand.Parameters.Add(new SqlParameter("@object", request.Object));

                    //ZAP, this will need to be worked out on how I tell if its open for edit.                    
                    dbcommand.Parameters.Add(new SqlParameter("@EditMode", request.Edit ? 1 : 0));

                    dbcommand.Parameters.Add(new SqlParameter("@sessionid", request.Session.SessionID));

                    dbcommand.Connection = dbconnection;

                    dbreader = dbcommand.ExecuteReader(CommandBehavior.CloseConnection);

                    while (dbreader.Read())
                        xmlstr += dbreader[0].ToString();






                    Framework.Utilities.DebugLogging.Log(xmlstr);

                    xmlrtn.LoadXml(xmlstr);

                    Framework.Utilities.Cache.Set(request.Key + "presentation", xmlrtn);
                    xmlstr = string.Empty;


                    if (!dbreader.IsClosed)
                        dbreader.Close();


                }
                else
                {
                    xmlrtn = Framework.Utilities.Cache.Fetch(request.Key + "presentation");
                }


            }
            catch (Exception ex) { }


            return xmlrtn;
        }

        #endregion

        #region "Profile Photo"

        public System.IO.Stream GetUserPhotoList(Int64 NodeID)
        {
            Object result = null;

            //if (Framework.Utilities.Cache.FetchBytes(NodeID.ToString() + "photo") == null)
            //{
            try
            {
                string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;

                SqlConnection dbconnection = new SqlConnection(connstr);
                dbconnection.Open();

                SqlCommand dbcommand = new SqlCommand("[Profile.Data].[Person.GetPhotos]");
                //SqlCommand dbcommand = new SqlCommand("Select Photo from [profile.data].[person.photo]");

                dbcommand.CommandType = CommandType.StoredProcedure;
                dbcommand.CommandTimeout = base.GetCommandTimeout();
                dbcommand.Parameters.Add(new SqlParameter("@NodeID", NodeID));

                dbcommand.Connection = dbconnection;

                result = dbcommand.ExecuteScalar();

                if (result == null)
                {
                    result = (byte[])System.Text.Encoding.ASCII.GetBytes("null");
                }


                //string connstr2 = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;

                //SqlConnection dbconnection1 = new SqlConnection(connstr2);
                //dbconnection1.Open();

                ////Save this chestnut for when we edit 
                //using (SqlCommand cmd = new SqlCommand("INSERT INTO [profile.data].[person.photo](personid,photo) VALUES (32213,@binaryValue)", dbconnection1))
                //{
                //    // Replace 8000, below, with the correct size of the field
                //    cmd.Parameters.Add("@binaryValue", SqlDbType.VarBinary).Value = result;
                //    cmd.ExecuteNonQuery();
                //}

                //dbconnection1.Close();
                dbconnection.Close();

                //   Framework.Utilities.Cache.Set(NodeID.ToString() + "photo", result);

            }
            catch (Exception e)
            {

                throw new Exception(e.Message);

            }



            return new System.IO.MemoryStream((byte[])result);
        }

        #endregion

        #region "CustomViewPersonSameDepartment"

        public XmlDocument GetSameDepartment(RDFTriple request)
        {
            string xmlstr = string.Empty;
            XmlDocument xmlrtn = new XmlDocument();

            string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;
            SqlConnection dbconnection = new SqlConnection(connstr);
            SqlCommand dbcommand = new SqlCommand("[Profile.Module].[CustomViewPersonSameDepartment.GetList]");

            SqlDataReader dbreader;
            dbconnection.Open();
            dbcommand.CommandType = CommandType.StoredProcedure;
            dbcommand.CommandTimeout = base.GetCommandTimeout();
            dbcommand.Parameters.Add(new SqlParameter("@nodeid", request.Subject));
            dbcommand.Parameters.Add(new SqlParameter("@sessionid", request.Session.SessionID));

            dbcommand.Connection = dbconnection;

            dbreader = dbcommand.ExecuteReader(CommandBehavior.CloseConnection);

            while (dbreader.Read())
                xmlstr += dbreader[0].ToString();

            xmlrtn.LoadXml(xmlstr);

            if (!dbreader.IsClosed)
                dbreader.Close();

            return xmlrtn;
        }

        #endregion



        #region

        public string GetConnectionPubs(string connectiontype, Int64 node1, Int64 node2, string concept)
        {

            System.Text.StringBuilder html = new System.Text.StringBuilder();

            if (Framework.Utilities.Cache.Fetch(connectiontype + node1.ToString() + node2.ToString() + concept) == null)
            {
                try
                {
                    string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;
                    SqlConnection dbconnection = new SqlConnection(connstr);

                    System.Text.StringBuilder sql = new System.Text.StringBuilder();

                    sql.AppendLine("Declare @Person1 Bigint");

                    if (node2 > 0)
                        sql.AppendLine("Declare @Person2 Bigint");

                    sql.AppendLine("select @person1 = i.internalid from  [RDF.Stage].internalnodemap i with(nolock) where i.nodeid = " + node1.ToString());

                    if (node2 > 0)
                        sql.AppendLine("select @person2 = i.internalid from  [RDF.Stage].internalnodemap i with(nolock) where i.nodeid = " + node2.ToString());


                    switch (connectiontype.ToLower())
                    {

                        case "coauth":
                            sql.AppendLine("exec [Profile.Data].[Publication.GetPersonSharedPublicationsKeyword] @userid = @Person1 ,@userid2 = @person2 ,  @keyword = NULL , @exactkeyword = 0");
                            break;

                        case "concept":
                            sql.AppendLine("exec [Profile.Data].[Publication.GetPersonSharedPublicationsKeyword]@userid = @Person1 ,@userid2=NULL , @keyword = '" + concept + "' , @exactkeyword = 0");
                            break;
                    }





                    SqlCommand dbcommand = new SqlCommand(sql.ToString());
                    SqlDataReader dbreader;

                    dbconnection.Open();
                    dbcommand.Connection = dbconnection;

                    dbreader = dbcommand.ExecuteReader(CommandBehavior.CloseConnection);





                    html.AppendLine("<div class=\"sectionHeader\">Publications</div>");
                    html.AppendLine("<ul style=\"list-style-type:decimal\">");


                    html.AppendLine("<div id=\"publicationListAll\" class=\"publications\">");





                    while (dbreader.Read())
                    {



                        html.AppendLine(" <li>");
                        html.AppendLine(" <div>");
                        html.AppendLine(dbreader["PublicationReference"].ToString());
                        html.AppendLine("</div>");

                        if (dbreader["pmid"] != System.DBNull.Value)
                        {
                            html.AppendLine("<div class=\"viewIn\">");
                            html.AppendLine("<span class=\"viewInLabel\">View in: </span>");

                            html.AppendLine("<a href=\"" + dbreader["URL"].ToString() + "\" target=\"_blank\">");
                            html.AppendLine(dbreader["Name"].ToString());
                            html.AppendLine("</a>");
                        }
                        html.AppendLine("</div>");

                        html.AppendLine("</li>");




                    }
                    html.AppendLine("</div>");
                    html.AppendLine("</ul>");


                    Framework.Utilities.Cache.Set(connectiontype + node1.ToString() + node2.ToString() + concept, html.ToString());



                    if (!dbreader.IsClosed)
                        dbreader.Close();

                }
                catch (Exception e)
                {

                    throw new Exception(e.Message);

                }
            }
            else
            {
                html.Append(Framework.Utilities.Cache.Fetch(connectiontype + node1.ToString() + node2.ToString() + concept));
            }


            return html.ToString();

        }





        #endregion

        public SqlDataReader GetPublications(RDFTriple request)
        {

            SessionManagement sm = new SessionManagement();

            string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;
            SqlConnection dbconnection = new SqlConnection(connstr);
            SqlCommand dbcommand = new SqlCommand("[Profile.Module].[CustomViewAuthorInAuthorship.GetList]");

            SqlDataReader dbreader;
            dbconnection.Open();
            dbcommand.CommandType = CommandType.StoredProcedure;
            dbcommand.CommandTimeout = base.GetCommandTimeout();
            dbcommand.Parameters.Add(new SqlParameter("@nodeid", request.Subject));
            dbcommand.Parameters.Add(new SqlParameter("@sessionid", sm.Session().SessionID));

            dbcommand.Connection = dbconnection;

            dbreader = dbcommand.ExecuteReader(CommandBehavior.CloseConnection);

            return dbreader;
        }

        public SqlDataReader GetProfileConnection(RDFTriple request, string storedproc)
        {
            SessionManagement sm = new SessionManagement();
            string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;
            var db = new SqlConnection(connstr);

            db.Open();

            SqlCommand dbcommand = new SqlCommand(storedproc, db);
            dbcommand.CommandType = CommandType.StoredProcedure;
            dbcommand.CommandTimeout = base.GetCommandTimeout();
            // Add parameters
            dbcommand.Parameters.Add(new SqlParameter("@subject", request.Subject));
            dbcommand.Parameters.Add(new SqlParameter("@object", request.Object));
            // Return reader
            return dbcommand.ExecuteReader(CommandBehavior.CloseConnection);
        }

        public DataView GetNetworkTimeline(RDFTriple request, string storedproc)
        {
            SessionManagement sm = new SessionManagement();
            string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;
            SqlDataAdapter dataAdapter = null;
            DataSet dataSet = null;
            DataView dataView = null;

            var db = new SqlConnection(connstr);
            dataAdapter = new SqlDataAdapter(storedproc + " " + request.Subject, db);
            dataSet = new DataSet();
            dataAdapter.Fill(dataSet);
            dataView = new DataView(dataSet.Tables[0]);

            db.Close();

            return dataView;

        }

        public SqlDataReader GetGoogleTimeline(RDFTriple request, string storedproc)
        {
            SessionManagement sm = new SessionManagement();
            string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;
            var db = new SqlConnection(connstr);

            db.Open();

            SqlCommand dbcommand = new SqlCommand(storedproc, db);
            dbcommand.CommandType = CommandType.StoredProcedure;
            dbcommand.CommandTimeout = base.GetCommandTimeout();
            // Add parameters
            dbcommand.Parameters.Add(new SqlParameter("@NodeId", request.Subject));
            // Return reader
            return dbcommand.ExecuteReader(CommandBehavior.CloseConnection);
        }

        public SqlDataReader GetPublicationSupportHtml(RDFTriple request, bool editMode)
        {
            SessionManagement sm = new SessionManagement();
            string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;
            var db = new SqlConnection(connstr);

            db.Open();

            SqlCommand dbcommand = new SqlCommand("[Profile.Module].[Support.GetHTML]", db);
            dbcommand.CommandType = CommandType.StoredProcedure;
            dbcommand.CommandTimeout = base.GetCommandTimeout();
            // Add parameters
            dbcommand.Parameters.Add(new SqlParameter("@NodeId", request.Subject));
            dbcommand.Parameters.Add(new SqlParameter("@EditMode", (editMode) ? 1 : 0));
            // Return reader
            return dbcommand.ExecuteReader(CommandBehavior.CloseConnection);
        }

        public SqlDataReader GetConceptSimilarMesh(RDFTriple request)
        {
            SessionManagement sm = new SessionManagement();
            string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;
            var db = new SqlConnection(connstr);

            db.Open();

            SqlCommand dbcommand = new SqlCommand("[Profile.Data].[Concept.Mesh.GetSimilarMesh]", db);
            dbcommand.CommandType = CommandType.StoredProcedure;
            dbcommand.CommandTimeout = base.GetCommandTimeout();
            // Add parameters
            dbcommand.Parameters.Add(new SqlParameter("@NodeId", request.Subject));
            // Return reader
            return dbcommand.ExecuteReader(CommandBehavior.CloseConnection);
        }

        public SqlDataReader GetConceptTopJournal(RDFTriple request)
        {
            SessionManagement sm = new SessionManagement();
            string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;
            var db = new SqlConnection(connstr);

            db.Open();

            SqlCommand dbcommand = new SqlCommand("[Profile.Data].[Concept.Mesh.GetJournals]", db);
            dbcommand.CommandType = CommandType.StoredProcedure;
            dbcommand.CommandTimeout = base.GetCommandTimeout();
            // Add parameters
            dbcommand.Parameters.Add(new SqlParameter("@NodeId", request.Subject));
            // Return reader
            return dbcommand.ExecuteReader(CommandBehavior.CloseConnection);
        }

        public SqlDataReader GetConceptPublications(RDFTriple request)
        {
            SessionManagement sm = new SessionManagement();
            string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;

            var db = new SqlConnection(connstr);
            db.Open();

            SqlCommand dbcommand = new SqlCommand("[Profile.Data].[Concept.Mesh.GetPublications]", db);
            dbcommand.CommandType = CommandType.StoredProcedure;
            dbcommand.CommandTimeout = base.GetCommandTimeout();
            // Add parameters
            dbcommand.Parameters.Add(new SqlParameter("@NodeId", request.Subject));
			dbcommand.Parameters.Add(new SqlParameter("@ListType", "newest"));
            // Return reader
            return dbcommand.ExecuteReader(CommandBehavior.CloseConnection);
        }


        #region "Network Browser"

        public XmlDocument GetProfileNetworkForBrowser(RDFTriple request)
        {
            string xmlstr = string.Empty;
            XmlDocument xmlrtn = new XmlDocument();

            if (Framework.Utilities.Cache.Fetch(request.Key + "GetProfileNetworkForBrowser") == null)
            {
                try
                {
                    string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;
                    SqlConnection dbconnection = new SqlConnection(connstr);
                    SqlCommand dbcommand = new SqlCommand("[Profile.Module].[NetworkRadial.GetCoauthors]");

                    SqlDataReader dbreader;
                    dbconnection.Open();
                    dbcommand.CommandType = CommandType.StoredProcedure;
                    dbcommand.CommandTimeout = base.GetCommandTimeout();
                    dbcommand.Parameters.Add(new SqlParameter("@nodeid", request.Subject));
                    dbcommand.Parameters.Add(new SqlParameter("@sessionid", request.Session.SessionID));
                    dbcommand.Connection = dbconnection;
                    dbreader = dbcommand.ExecuteReader(CommandBehavior.CloseConnection);

                    while (dbreader.Read())
                        xmlstr += dbreader[0].ToString();

                    Framework.Utilities.DebugLogging.Log(xmlstr);

                    if (!dbreader.IsClosed)
                        dbreader.Close();

                    xmlstr = xmlstr.Replace(" id=", " lid=");
                    xmlstr = xmlstr.Replace(" nodeid=", " id=");

                    xmlstr = xmlstr.Replace(" id1=", " lid1=");
                    xmlstr = xmlstr.Replace(" id2=", " lid2=");
                    xmlstr = xmlstr.Replace(" nodeid1=", " id1=");
                    xmlstr = xmlstr.Replace(" nodeid2=", " id2=");


                    xmlrtn.LoadXml(xmlstr);

                }
                catch (Exception ex)
                {

                    Framework.Utilities.DebugLogging.Log(ex.Message + " ++ " + ex.StackTrace);
                }
            }
            else
            {
                xmlrtn = Framework.Utilities.Cache.Fetch(request.Key + "GetProfileNetworkForBrowser");
            }

            return xmlrtn;
        }


        #endregion

        #region "GoogleMaps"

        public String GetGoogleKey()
        {
            XmlDocument val = new XmlDocument();
            val.Load(Root.Domain + "/Profile/Modules/NetworkMap/config.xml");
            string result = val.SelectSingleNode("//mapconfig/Key").InnerText;

            return result;
        }
        public List<Profiles.Profile.Modules.NetworkMap.NetworkMap.GoogleMapLocation> GetGoogleMapZoomLinks()
        {
            XmlDocument vals = new XmlDocument();
            List<Profiles.Profile.Modules.NetworkMap.NetworkMap.GoogleMapLocation> linklist = new List<Profiles.Profile.Modules.NetworkMap.NetworkMap.GoogleMapLocation>();
            Profiles.Profile.Modules.NetworkMap.NetworkMap.GoogleMapLocation link = new Profiles.Profile.Modules.NetworkMap.NetworkMap.GoogleMapLocation();
            try
            {
                vals.Load(Root.Domain + "/Profile/Modules/NetworkMap/config.xml");
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }

            foreach (XmlElement x in vals.SelectNodes("mapconfig/Zoom"))
            {

                link.Latitude = x.SelectSingleNode("CenterLat").InnerText;
                link.Longitude = x.SelectSingleNode("CenterLong").InnerText;
                link.ZoomLevel = x.SelectSingleNode("ZoomLevel").InnerText;
                link.Label = x.SelectSingleNode("Label").InnerText;
                link.SortOrder = x.SelectSingleNode("SortOrder").InnerText;
                link.DefaultLevel = x.SelectSingleNode("DefaultLevel").InnerText;

                linklist.Add(link);
                link = new Profiles.Profile.Modules.NetworkMap.NetworkMap.GoogleMapLocation();
            }
            linklist.Sort(delegate(Profiles.Profile.Modules.NetworkMap.NetworkMap.GoogleMapLocation p1, Profiles.Profile.Modules.NetworkMap.NetworkMap.GoogleMapLocation p2)
            {
                return p1.SortOrder.CompareTo(p2.SortOrder);
            });
            return linklist;
        }

        public SqlDataReader GetGMapUserCoAuthors(Int64 nodeid, int which, string sessionid)
        {
            SqlDataReader dbreader = null;

            try
            {

                string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;
                SqlConnection dbconnection = new SqlConnection(connstr);

                dbconnection.Open();

                SqlCommand dbcommand = new SqlCommand();
                dbcommand.CommandType = CommandType.StoredProcedure;
                dbcommand.CommandText = "[Profile.Module].[NetworkMap.GetCoauthors]";
                dbcommand.CommandTimeout = base.GetCommandTimeout();

                dbcommand.Parameters.Add(new SqlParameter("@NodeID", nodeid));
                dbcommand.Parameters.Add(new SqlParameter("@which", which));
                dbcommand.Parameters.Add(new SqlParameter("@SessionID", sessionid));
                dbcommand.Connection = dbconnection;
                dbreader = dbcommand.ExecuteReader(CommandBehavior.CloseConnection);

            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }

            return dbreader;
        }

        public SqlDataReader GetGMapUserSimilarPeople(Int64 nodeid, bool showConnections, string sessionid)
        {
            SqlDataReader dbreader = null;
            try
            {


                string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;
                SqlConnection dbconnection = new SqlConnection(connstr);

                dbconnection.Open();

                SqlCommand dbcommand = new SqlCommand();
                dbcommand.CommandType = CommandType.StoredProcedure;
                dbcommand.CommandText = "[Profile.Module].[NetworkMap.GetSimilarPeople]";
                dbcommand.CommandTimeout = base.GetCommandTimeout();

                dbcommand.Parameters.Add(new SqlParameter("@NodeID", nodeid));
                dbcommand.Parameters.Add(new SqlParameter("@show_connections", showConnections));
                dbcommand.Parameters.Add(new SqlParameter("@SessionID", sessionid));
                dbcommand.Connection = dbconnection;
                dbreader = dbcommand.ExecuteReader(CommandBehavior.CloseConnection);


            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }

            return dbreader;
        }


        #endregion

    }





}
