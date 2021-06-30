using System;
using System.Web;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using Profiles.Framework.Utilities;
using System.Text;
using System.Linq;
using Newtonsoft.Json;
using System.Diagnostics.Contracts;
using System.Collections.ObjectModel;
using System.Xml;
using static Profiles.Profile.Modules.NetworkMap.NetworkMap;

namespace Profiles.Lists.Utilities
{
    public static class DataIO
    {

        public class ProfilesList
        {
            public string SessionID { get; set; }
            public string OwnerNodeID { get; set; }
            public string ListName { get; set; }
            public string ListID { get; set; }
            public string Size { get; set; }
            public string CreateDate { get; set; }
            public List<ProfilesListItem> ListItems { get; set; }
            public List<GenericListItem> Institutions { get; set; }
            public List<GenericListItem> FacultyRanks { get; set; }
        }

        public class ProfilesListItem
        {
            public string PersonID { get; set; }
            public string DisplayName { get; set; }
            public string FirstName { get; set; }
            public string LastName { get; set; }
            public string InstitutionName { get; set; }
            public string FacultyRank { get; set; }
            public string DepartmentName { get; set; }
        }


        public class SummaryChart
        {

            public string cols { get; set; }
            public string rows { get; set; }
            public string colors { get; set; }
        }
        public class SummaryItem
        {
            public string Variable { get; set; }
            public string Value { get; set; }
            public int n { get; set; }
            public string color { get; set; }

        }

        public static List<SummaryItem> GetSummaryRaw(string listid, string type)
        {

            SummaryChart sc = new SummaryChart();

            List<SummaryItem> rawitems = new List<SummaryItem>();
            List<SummaryItem> rtnitems = new List<SummaryItem>();

            Framework.Utilities.DataIO dataio = new Framework.Utilities.DataIO();
            try
            {
                string connstr = dataio.GetConnectionString();
                SqlConnection dbconnection = new SqlConnection(connstr);

                dbconnection.Open();

                SqlCommand dbcommand = new SqlCommand();
                dbcommand.CommandType = CommandType.Text;
                dbcommand.CommandText = string.Format("exec [Profile.Data].[List.GetSummary]  @UserID = {0}", listid);
                dbcommand.CommandTimeout = dataio.GetCommandTimeout();

                dbcommand.Connection = dbconnection;
                using (SqlDataReader dbreader = dbcommand.ExecuteReader(CommandBehavior.CloseConnection))
                {
                    while (dbreader.Read())
                        rawitems.Add(new SummaryItem { Variable = dbreader["Variable"].ToString(), Value = dbreader["Value"].ToString().Replace("'", "\\'"), n = Convert.ToInt32(dbreader["n"]), color = "" });

                    if (!dbreader.IsClosed)
                        dbreader.Close();
                }


            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }

            rtnitems = rawitems.FindAll(o => o.Variable.ToLower() == type.ToLower()).ToList();



            return rtnitems;

        }

        public static string GetSummary(string listid, string type)
        {

            SummaryChart sc = new SummaryChart();

            List<SummaryItem> rawitems = new List<SummaryItem>();
            List<SummaryItem> rtnitems = new List<SummaryItem>();

            Framework.Utilities.DataIO dataio = new Framework.Utilities.DataIO();
            try
            {
                string connstr = dataio.GetConnectionString();
                SqlConnection dbconnection = new SqlConnection(connstr);

                dbconnection.Open();

                SqlCommand dbcommand = new SqlCommand();
                dbcommand.CommandType = CommandType.Text;
                dbcommand.CommandText = string.Format("exec [Profile.Data].[List.GetSummary]  @UserID = {0}", listid);
                dbcommand.CommandTimeout = dataio.GetCommandTimeout();

                dbcommand.Connection = dbconnection;
                using (SqlDataReader dbreader = dbcommand.ExecuteReader(CommandBehavior.CloseConnection))
                {
                    while (dbreader.Read())
                        rawitems.Add(new SummaryItem { Variable = dbreader["Variable"].ToString(), Value = dbreader["Value"].ToString().Replace("'", "\\'"), n = Convert.ToInt32(dbreader["n"]), color = "" });

                    if (!dbreader.IsClosed)
                        dbreader.Close();
                }


            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }

            rtnitems = rawitems.FindAll(o => o.Variable.ToLower() == type.ToLower()).ToList();

            sc.cols = "{\"cols\": [{\"id\":\"\",\"label\": \"" + type + "\",\"pattern\":\"\",\"type\":\"string\"},{\"id\":\"\",\"label\":\"Count\",\"pattern\":\"\",\"type\":\"number\"}],";
            sc.rows = "\"rows\":[";
            foreach (SummaryItem si in rtnitems)
            {


                sc.rows += "{ \"c\":[{\"v\":\"" + si.Value + "\"},{\"v\":" + si.n.ToString() + "}]},";


            }
            sc.rows = sc.rows.Substring(0, sc.rows.Length - 1);
            sc.colors = "],\"colors\":\"[#4E79A7,#F28E2B,#E15759,#76B7B2,#59A14F,#EDC948,#B07AA1,#FF9DA7,#9C755F,#BAB0AC]\"}";

            return sc.cols + sc.rows + sc.colors;

        }


        //replace this method so the 
        public static string GetListCount()
        {
            SessionManagement sm = new SessionManagement();
            if (sm.Session().ListID == null || sm.Session().ListSize == null)
            {
                Profiles.Lists.Utilities.DataIO.GetList();
            }
            return sm.Session().ListSize.ToString();


        }
        public static string CreateList(string listownerid, string ListName)
        {

            string data = string.Empty;
            Framework.Utilities.DataIO dataio = new Framework.Utilities.DataIO();
            try
            {
                string connstr = dataio.GetConnectionString();
                SqlConnection dbconnection = new SqlConnection(connstr);

                dbconnection.Open();


                SqlCommand dbcommand = new SqlCommand();
                dbcommand.CommandType = CommandType.Text;
                dbcommand.CommandText = string.Format("exec [Profile.Data].[List.CreateList]  @OwnerNodeID = {0}, @ListName = '{1}'", listownerid, ListName);
                dbcommand.CommandTimeout = dataio.GetCommandTimeout();

                dbcommand.Connection = dbconnection;
                using (SqlDataReader dbreader = dbcommand.ExecuteReader(CommandBehavior.CloseConnection))
                {
                    while (dbreader.Read())
                        data = dbreader[0].ToString();

                    if (!dbreader.IsClosed)
                        dbreader.Close();
                }

            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
            return data.Trim();

        }
        public static string AddRemovePerson(string listid, string personid, bool remove = false)
        {
            SessionManagement sm = new SessionManagement();

            Profiles.Framework.Utilities.DataIO dataio = new Framework.Utilities.DataIO();
            using (SqlConnection sqlconnection = new SqlConnection(dataio.GetConnectionString()))
            {
                SqlCommand cmd = new SqlCommand("[Profile.Data].[List.AddRemove.Person]", sqlconnection);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlParameter parm = new SqlParameter("@UserID", SqlDbType.Int);
                parm.Direction = ParameterDirection.Input;
                parm.Value = listid;
                cmd.Parameters.Add(parm);
                parm = new SqlParameter("@PersonID", SqlDbType.Int);
                parm.Direction = ParameterDirection.Input;
                parm.Value = Convert.ToInt32(personid);
                cmd.Parameters.Add(parm);
                parm = new SqlParameter("@Remove", SqlDbType.Bit);
                parm.Direction = ParameterDirection.Input;
                parm.Value = remove;
                cmd.Parameters.Add(parm);
                parm = new SqlParameter("@Size", SqlDbType.Int);
                parm.Direction = ParameterDirection.Output;
                cmd.Parameters.Add(parm);

                sqlconnection.Open();
                cmd.ExecuteNonQuery();
                sqlconnection.Close();

                sm.Session().ListSize = cmd.Parameters["@Size"].Value.ToString();
            }

            return sm.Session().ListSize;

        }
        public static string PersonExists(string listid, string personid)
        {
            string data = string.Empty;
            Framework.Utilities.DataIO dataio = new Framework.Utilities.DataIO();
            try
            {
                string connstr = dataio.GetConnectionString();
                SqlConnection dbconnection = new SqlConnection(connstr);

                dbconnection.Open();
                SqlCommand dbcommand = new SqlCommand();
                dbcommand.CommandType = CommandType.Text;
                dbcommand.CommandText = string.Format("select count(*) as count from [Profile.Data].[List.Member]  where UserID = {0} and personid = {1}", listid, personid);
                dbcommand.CommandTimeout = dataio.GetCommandTimeout();

                dbcommand.Connection = dbconnection;
                using (SqlDataReader dbreader = dbcommand.ExecuteReader(CommandBehavior.CloseConnection))
                {
                    while (dbreader.Read())
                        data = dbreader[0].ToString();

                    if (!dbreader.IsClosed)
                        dbreader.Close();
                }


                if (dbcommand.Connection.State != ConnectionState.Closed) dbcommand.Connection.Close();

            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
            return data;
        }



        public static void DeleteFildered(string listid, string institution, string facultyrank)
        {

            Profiles.Framework.Utilities.DataIO dataio = new Framework.Utilities.DataIO();
            SessionManagement sm = new SessionManagement();
            using (SqlConnection sqlconnection = new SqlConnection(dataio.GetConnectionString()))
            {

                SqlCommand cmd = new SqlCommand("[Profile.Data].[List.AddRemove.Filter]", sqlconnection);
                cmd.CommandTimeout = dataio.GetCommandTimeout();
                cmd.CommandType = CommandType.StoredProcedure;
                SqlParameter parm = new SqlParameter("@UserID", SqlDbType.Int);
                parm.Direction = ParameterDirection.Input;
                parm.Value = listid;
                cmd.Parameters.Add(parm);
                parm = new SqlParameter("@Institution", SqlDbType.NVarChar);
                parm.Direction = ParameterDirection.Input;
                parm.Value = institution;
                cmd.Parameters.Add(parm);
                parm = new SqlParameter("@FacultyRank", SqlDbType.NVarChar);
                parm.Direction = ParameterDirection.Input;

                parm.Value = facultyrank;
                cmd.Parameters.Add(parm);
                parm = new SqlParameter("@Remove", SqlDbType.Bit);
                parm.Direction = ParameterDirection.Input;
                parm.Value = true;
                cmd.Parameters.Add(parm);
                parm = new SqlParameter("@Size", SqlDbType.Int);
                parm.Direction = ParameterDirection.Output;
                cmd.Parameters.Add(parm);

                sqlconnection.Open();
                cmd.ExecuteNonQuery();
                sqlconnection.Close();

                sm.Session().ListSize = cmd.Parameters["@Size"].Value.ToString();

            }
        }
        public static void DeleteSelected(string ListID, string personids, bool remove = true)
        {

            if (personids.Trim() != "")
            {
                Profiles.Framework.Utilities.DataIO dataio = new Framework.Utilities.DataIO();
                SessionManagement sm = new SessionManagement();
                using (SqlConnection sqlconnection = new SqlConnection(dataio.GetConnectionString()))
                {

                    SqlCommand cmd = new SqlCommand("[Profile.Data].[List.AddRemove.SelectedPeople]", sqlconnection);
                    cmd.CommandTimeout = dataio.GetCommandTimeout();
                    cmd.CommandType = CommandType.StoredProcedure;
                    SqlParameter parm = new SqlParameter("@UserID", SqlDbType.Int);
                    parm.Direction = ParameterDirection.Input;
                    parm.Value = ListID;
                    cmd.Parameters.Add(parm);
                    parm = new SqlParameter("@SelectedPeople", SqlDbType.NVarChar);
                    parm.Direction = ParameterDirection.Input;
                    parm.Value = personids;
                    cmd.Parameters.Add(parm);
                    parm = new SqlParameter("@Remove", SqlDbType.Bit);
                    parm.Direction = ParameterDirection.Input;
                    parm.Value = remove;
                    cmd.Parameters.Add(parm);
                    parm = new SqlParameter("@Size", SqlDbType.Int);
                    parm.Direction = ParameterDirection.Output;
                    cmd.Parameters.Add(parm);

                    sqlconnection.Open();
                    cmd.ExecuteNonQuery();
                    sqlconnection.Close();

                    sm.Session().ListSize = cmd.Parameters["@Size"].Value.ToString();



                }
            }
        }

        public static string GetList()
        {

            SessionManagement sm = new SessionManagement();
            Framework.Utilities.DataIO dataio = new Framework.Utilities.DataIO();
            try
            {

                using (SqlConnection sqlconnection = new SqlConnection(dataio.GetConnectionString()))
                {

                    SqlCommand cmd = new SqlCommand("[Profile.Data].[List.GetList]", sqlconnection);
                    cmd.CommandType = CommandType.StoredProcedure;
                    SqlParameter parm = new SqlParameter("@SessionID", SqlDbType.UniqueIdentifier);
                    parm.Value = Guid.Parse(sm.Session().SessionID);
                    parm.Direction = ParameterDirection.Input;
                    cmd.Parameters.Add(parm);
                    parm = new SqlParameter("@ListID", SqlDbType.Int);
                    parm.Direction = ParameterDirection.Output;
                    cmd.Parameters.Add(parm);
                    parm = new SqlParameter("@Size", SqlDbType.Int);
                    parm.Direction = ParameterDirection.Output;
                    cmd.Parameters.Add(parm);
                    sqlconnection.Open();
                    cmd.ExecuteNonQuery();
                    sqlconnection.Close();


                    sm.Session().ListID = cmd.Parameters["@ListID"].Value.ToString();
                    sm.Session().ListSize = cmd.Parameters["@Size"].Value.ToString();
                }


            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }


            return sm.Session().ListID;
        }
        public static ProfilesList GetPeople(string institution = "", string facultyrank = "")
        {
            ProfilesList pl = new ProfilesList();
          
            SessionManagement sm = new SessionManagement();
            string listid = sm.Session().ListID;


            Framework.Utilities.DataIO dataio = new Framework.Utilities.DataIO();
            using (SqlConnection sqlconnection = new SqlConnection(dataio.GetConnectionString()))
            {

                SqlCommand cmd = new SqlCommand("[Profile.Data].[List.GetPeople]", sqlconnection);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlParameter parm = new SqlParameter("@UserID", SqlDbType.Int);
                parm.Direction = ParameterDirection.Input;
                parm.Value = listid;
                cmd.Parameters.Add(parm);
                parm = new SqlParameter("@ReturnInstitutions", SqlDbType.Bit);
                parm.Direction = ParameterDirection.Input;
                parm.Value = true;
                cmd.Parameters.Add(parm);
                parm = new SqlParameter("@ReturnFacultyRanks", SqlDbType.Bit);
                parm.Direction = ParameterDirection.Input;
                parm.Value = true;
                cmd.Parameters.Add(parm);

                if (!string.IsNullOrEmpty(institution))
                {
                    parm = new SqlParameter("@Institution", SqlDbType.VarChar);
                    parm.Direction = ParameterDirection.Input;
                    parm.Value = institution;
                    cmd.Parameters.Add(parm);
                }
                if (!string.IsNullOrEmpty(facultyrank))
                {
                    parm = new SqlParameter("@FacultyRank", SqlDbType.VarChar);
                    parm.Direction = ParameterDirection.Input;
                    parm.Value = facultyrank;
                    cmd.Parameters.Add(parm);
                }

                parm = new SqlParameter("@NumPeople", SqlDbType.Int);
                parm.Direction = ParameterDirection.Output;
                cmd.Parameters.Add(parm);

                sqlconnection.Open();
                using (SqlDataReader dbreader = cmd.ExecuteReader())
                {
                    pl.Institutions = new List<GenericListItem>();
                    while (dbreader.Read())
                    {

                        pl.Institutions.Add(new GenericListItem(dbreader["InstitutionName"].ToString(), dbreader["n"].ToString()));

                    }
                    dbreader.NextResult();
                    pl.FacultyRanks = new List<GenericListItem>();
                    while (dbreader.Read())
                    {

                        pl.FacultyRanks.Add(new GenericListItem(dbreader["FacultyRank"].ToString(), dbreader["n"].ToString()));

                    }

                    dbreader.NextResult();
                    pl.ListItems = new List<ProfilesListItem>();
                    while (dbreader.Read())
                        pl.ListItems.Add(new ProfilesListItem
                        {
                            PersonID = dbreader[0].ToString(),
                            DisplayName = dbreader[1].ToString(),
                            FirstName = dbreader[2].ToString(),
                            LastName = dbreader[3].ToString(),
                            InstitutionName = dbreader[4].ToString(),
                            FacultyRank = dbreader[5].ToString(),
                            DepartmentName = dbreader[6].ToString()
                        });
                }
                sqlconnection.Close();


            }





            return pl;

        }
        public static void AddRemoveSearchResults(bool remove = false)
        {
            SessionManagement sm = new SessionManagement();
            string listid = sm.Session().ListID;


            Framework.Utilities.DataIO dataio = new Framework.Utilities.DataIO();
            using (SqlConnection sqlconnection = new SqlConnection(dataio.GetConnectionString()))
            {

                SqlCommand cmd = new SqlCommand("[Profile.Data].[List.AddRemove.Search]", sqlconnection);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlParameter parm = new SqlParameter("@SessionID", SqlDbType.UniqueIdentifier);
                parm.Value = Guid.Parse(sm.Session().SessionID);
                parm.Direction = ParameterDirection.Input;
                cmd.Parameters.Add(parm);
                parm = new SqlParameter("@UserID", SqlDbType.Int);
                parm.Direction = ParameterDirection.Input;
                parm.Value = listid;
                cmd.Parameters.Add(parm);
                parm = new SqlParameter("@SearchXML", SqlDbType.Xml);
                parm.Direction = ParameterDirection.Input;
                parm.Value = HttpContext.Current.Session["SEARCHREQUEST"].ToString();
                cmd.Parameters.Add(parm);
                parm = new SqlParameter("@Remove", SqlDbType.Bit);
                parm.Direction = ParameterDirection.Input;
                parm.Value = remove;
                cmd.Parameters.Add(parm);
                parm = new SqlParameter("@Size", SqlDbType.Int);
                parm.Direction = ParameterDirection.Output;
                cmd.Parameters.Add(parm);

                sqlconnection.Open();
                cmd.ExecuteNonQuery();
                sqlconnection.Close();

                sm.Session().ListSize = cmd.Parameters["@Size"].Value.ToString();
            }

        }
        private static void GetCSV(string data, string filename)
        {
            try
            {
                if (!string.IsNullOrEmpty(data))
                {

                    HttpContext.Current.Response.Clear();
                    HttpContext.Current.Response.Buffer = true;
                    HttpContext.Current.Response.ContentType = "text/csv";
                    HttpContext.Current.Response.AddHeader("Content-disposition", string.Format("attachment; filename={0}.csv", filename));
                    HttpContext.Current.Response.Output.Write(data);
                    HttpContext.Current.Response.Flush();
                    HttpContext.Current.Response.End();
                }
            }
            catch (Exception ex)
            {
                //donothingbecause of the end();;;; calllllllll


            }
        }
        public static void GetPersons(string listid)
        {
            StringBuilder data = new StringBuilder();
            Framework.Utilities.DataIO dataio = new Framework.Utilities.DataIO();
            try
            {
                string connstr = dataio.GetConnectionString();
                SqlConnection dbconnection = new SqlConnection(connstr);

                dbconnection.Open();


                SqlCommand dbcommand = new SqlCommand();
                dbcommand.CommandType = CommandType.Text;
                dbcommand.CommandText = string.Format("exec [Profile.Data].[List.ExportPersonList] @UserID={0}", listid);
                dbcommand.CommandTimeout = dataio.GetCommandTimeout();

                dbcommand.Connection = dbconnection;
                using (SqlDataReader dbreader = dbcommand.ExecuteReader(CommandBehavior.CloseConnection))
                {
                    while (dbreader.Read())
                        data.AppendLine(dbreader[0].ToString());

                    if (!dbreader.IsClosed)
                        dbreader.Close();


                    GetCSV(data.ToString(), "People");
                }

            }
            catch (Exception e)
            {
                //donothingbecause of the end();;;; calllllllll

            }

        }
        public static void GetPublications(string listid)
        {
            StringBuilder data = new StringBuilder();
            Framework.Utilities.DataIO dataio = new Framework.Utilities.DataIO();
            try
            {
                string connstr = dataio.GetConnectionString();
                SqlConnection dbconnection = new SqlConnection(connstr);

                dbconnection.Open();


                SqlCommand dbcommand = new SqlCommand();
                dbcommand.CommandType = CommandType.Text;
                dbcommand.CommandText = string.Format("exec [Profile.Data].[List.ExportPersonPublicationsList] @UserID={0}", listid);
                dbcommand.CommandTimeout = 5000;

                dbcommand.Connection = dbconnection;
                using (SqlDataReader dbreader = dbcommand.ExecuteReader(CommandBehavior.CloseConnection))
                {
                    while (dbreader.Read())
                        data.AppendLine(dbreader[0].ToString());

                    if (!dbreader.IsClosed)
                        dbreader.Close();


                    GetCSV(data.ToString(), "Publications");
                }

            }
            catch (Exception e)
            {
                //donothingbecause of the end();;;; calllllllll

            }

        }
        public static void GetCoauthorConnections(string listid)
        {
            StringBuilder data = new StringBuilder();
            Framework.Utilities.DataIO dataio = new Framework.Utilities.DataIO();
            try
            {
                string connstr = dataio.GetConnectionString();
                SqlConnection dbconnection = new SqlConnection(connstr);

                dbconnection.Open();


                SqlCommand dbcommand = new SqlCommand();
                dbcommand.CommandType = CommandType.Text;
                dbcommand.CommandText = string.Format("exec [Profile.Data].[List.ExportCoAuthorConnections] @UserID={0}", listid);
                dbcommand.CommandTimeout = dataio.GetCommandTimeout();

                dbcommand.Connection = dbconnection;
                using (SqlDataReader dbreader = dbcommand.ExecuteReader(CommandBehavior.CloseConnection))
                {
                    while (dbreader.Read())
                        data.AppendLine(dbreader[0].ToString());

                    if (!dbreader.IsClosed)
                        dbreader.Close();


                    GetCSV(data.ToString(), "Connections");
                }

            }
            catch (Exception e)
            {
                //donothingbecause of the end();;;; calllllllll

            }

        }
        public static string GetNetworkRadialCoAuthors(string listid)
        {
            string str = string.Empty;


            if (Framework.Utilities.Cache.FetchObject(listid + "LISTGetNetworkRadialCoAuthors") == null)
            {
                Framework.Utilities.DataIO dataio = new Framework.Utilities.DataIO();
                try
                {
                    string connstr = dataio.GetConnectionString();
                    SqlConnection dbconnection = new SqlConnection(connstr);
                    SqlCommand dbcommand = new SqlCommand("[Profile.Module].[NetworkRadial.List.GetCoAuthors]");

                    SqlDataReader dbreader;
                    dbconnection.Open();
                    dbcommand.CommandType = CommandType.StoredProcedure;
                    dbcommand.CommandTimeout = dataio.GetCommandTimeout();
                    dbcommand.Parameters.Add(new SqlParameter("@OutputFormat", "JSON"));
                    dbcommand.Parameters.Add(new SqlParameter("@UserID", listid));

                    dbcommand.Connection = dbconnection;
                    dbreader = dbcommand.ExecuteReader(CommandBehavior.CloseConnection);

                    while (dbreader.Read())
                        str += dbreader[0].ToString();

                    Framework.Utilities.DebugLogging.Log(str);

                    if (!dbreader.IsClosed)
                        dbreader.Close();

                    Framework.Utilities.Cache.Set(listid + "LISTGetNetworkRadialCoAuthors", str);
                }
                catch (Exception ex)
                {
                    Framework.Utilities.DebugLogging.Log(ex.Message + " ++ " + ex.StackTrace);
                }
            }
            else
            {
                str = (string)Framework.Utilities.Cache.FetchObject(listid + "LISTGetNetworkRadialCoAuthors");
            }

            return str;
        }


        #region "GoogleMaps"

        public static String GetGoogleKey()
        {
            XmlDocument val = new XmlDocument();
            val.Load(Root.Domain + "/Lists/Modules/NetworkMapList/config.xml");
            string result = val.SelectSingleNode("//mapconfig/Key").InnerText;

            return result;
        }
        public static List<GoogleMapLocation> GetGoogleMapZoomLinks()
        {
            XmlDocument vals = new XmlDocument();
            List<GoogleMapLocation> linklist = new List<GoogleMapLocation>();
            GoogleMapLocation link = new GoogleMapLocation();
            try
            {
                vals.Load(Root.Domain + "/Lists/Modules/NetworkMapList/config.xml");
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
                link = new GoogleMapLocation();
            }
            linklist.Sort(delegate (GoogleMapLocation p1, GoogleMapLocation p2)
            {
                return p1.SortOrder.CompareTo(p2.SortOrder);
            });
            return linklist;
        }

        public static SqlDataReader GetGMapList(string listid, string which, string sessionid)
        {
            SqlDataReader dbreader = null;

            try
            {
                Framework.Utilities.DataIO dataio = new Framework.Utilities.DataIO();
                string connstr = dataio.GetConnectionString();
                SqlConnection dbconnection = new SqlConnection(connstr);

                dbconnection.Open();

                SqlCommand dbcommand = new SqlCommand();
                dbcommand.CommandType = CommandType.Text;
                dbcommand.CommandText = string.Format("exec [Profile.Module].[NetworkMap.GetList] @UserID = {0}, @which ={1},@sessionid = '{2}'", listid, which, sessionid);
                dbcommand.CommandTimeout = dataio.GetCommandTimeout();
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

        public static IEnumerable<IEnumerable<T>> Page<T>(this IEnumerable<T> source, int pageSize)
        {
            Contract.Requires(source != null);
            Contract.Requires(pageSize > 0);
            Contract.Ensures(Contract.Result<IEnumerable<IEnumerable<T>>>() != null);

            using (var enumerator = source.GetEnumerator())
            {
                while (enumerator.MoveNext())
                {
                    var currentPage = new List<T>(pageSize)
            {
                enumerator.Current
            };

                    while (currentPage.Count < pageSize && enumerator.MoveNext())
                    {
                        currentPage.Add(enumerator.Current);
                    }
                    yield return new ReadOnlyCollection<T>(currentPage);
                }
            }
        }
    }
}
