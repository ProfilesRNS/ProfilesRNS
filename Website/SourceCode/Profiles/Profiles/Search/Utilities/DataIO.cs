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
using System.Linq;
using System.Web;

using System.Xml;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;

using Profiles.Framework.Utilities;
using System.Data.SqlTypes;

namespace Profiles.Search.Utilities
{
    public class DataIO : Framework.Utilities.DataIO
    {
        private SessionManagement sessionmanagement;

        public DataIO()
        {
            sessionmanagement = new SessionManagement();
        }


        public XmlDocument SearchRequest(string searchstring, string exactphrase, string classgroupuri, string classuri, string limit, string offset)
        {
            System.Text.StringBuilder search = new System.Text.StringBuilder();
            XmlDocument searchxml = new XmlDocument();

            if (searchstring == null)
                searchstring = string.Empty;


            if (classgroupuri == null)
                classgroupuri = string.Empty;

            if (classuri == null)
                classuri = string.Empty;

            if (limit == null)
                limit = string.Empty;

            if (offset == null)
                offset = string.Empty;

            search.Append("<SearchOptions>");
            search.Append("<MatchOptions>");

            if (searchstring != string.Empty && !(string.IsNullOrEmpty(exactphrase)))
            {

                search.Append("<SearchString ExactMatch=\"" + exactphrase.ToLower() + "\">");
                search.Append(this.EscapeXML(searchstring));
                search.Append("</SearchString>");
            }

            if (classgroupuri != string.Empty)
            {
                search.Append("<ClassGroupURI>");
                search.Append(classgroupuri);
                search.Append("</ClassGroupURI>");
            }
            if (classuri != string.Empty)
            {
                search.Append("<ClassURI>");
                search.Append(classuri);
                search.Append("</ClassURI>");
            }
            search.Append("</MatchOptions>");
            search.Append("<OutputOptions><Offset>");
            search.Append(offset.ToString());
            search.Append("</Offset><Limit>");
            search.Append(limit.ToString());
            search.Append("</Limit></OutputOptions>");
            search.Append("</SearchOptions>");

            searchxml.LoadXml(search.ToString());

            return searchxml;

        }

        public XmlDocument SearchRequest(string searchstring, string exactphrase, string fname, string lname,
            string institution, string institutionallexcept, string department, string departmentallexcept,
            string division, string divisionallexcept,
            string classuri, string limit, string offset,
            string sortby, string sortdirection,
            string otherfilters, string facrank, ref string searchrequest)
        {

            System.Text.StringBuilder search = new System.Text.StringBuilder();
            XmlDocument xmlrequest = new XmlDocument();
            XmlDocument searchxml = new XmlDocument();

            string isexclude = "0";

            if (searchrequest != string.Empty)
                xmlrequest.LoadXml(this.DecryptRequest(searchrequest));
            else
            {
                if (searchstring == null)
                    searchstring = string.Empty;
            }

            if (fname.IsNullOrEmpty())
            {
                if(xmlrequest.SelectSingleNode("SearchOptions/MatchOptions/SearchFiltersList/SearchFilter[@Property='http://xmlns.com/foaf/0.1/firstName']")!=null)
                fname = xmlrequest.SelectSingleNode("SearchOptions/MatchOptions/SearchFiltersList/SearchFilter[@Property='http://xmlns.com/foaf/0.1/firstName']").InnerText;
            }

            if (lname.IsNullOrEmpty())
            {
                if(xmlrequest.SelectSingleNode("SearchOptions/MatchOptions/SearchFiltersList/SearchFilter[@Property='http://xmlns.com/foaf/0.1/lastName']")!=null)
                lname = xmlrequest.SelectSingleNode("SearchOptions/MatchOptions/SearchFiltersList/SearchFilter[@Property='http://xmlns.com/foaf/0.1/lastName']").InnerText;
            }

            if (classuri == null)
                classuri = string.Empty;

            if (limit == null)
                limit = string.Empty;

            if (offset == null)
                offset = string.Empty;


            search.Append("<SearchOptions>");
            search.Append("<MatchOptions>");
            if (string.IsNullOrEmpty(exactphrase))
               exactphrase = string.Empty;

           // if (exactphrase.IsNullOrEmpty())
               // exactphrase = string.Empty;

            if (searchstring != string.Empty && exactphrase != string.Empty)
            {
                search.Append("<SearchString ExactMatch=\"" + exactphrase.ToLower() + "\">");

                search.Append(searchstring);
                search.Append("</SearchString>");
            }
            else if (xmlrequest.SelectSingleNode("//SearchString") != null)
            {
                search.Append(xmlrequest.SelectSingleNode("//SearchString").OuterXml);
            }

            search.Append("<SearchFiltersList>");


            if (searchrequest == string.Empty)
            {

                if (fname != string.Empty)
                {
                    search.Append(" <SearchFilter Property=\"http://xmlns.com/foaf/0.1/firstName\" MatchType=\"Left\">" + fname + "</SearchFilter>");
                }

                if (lname != string.Empty)
                {
                    search.Append("<SearchFilter Property=\"http://xmlns.com/foaf/0.1/lastName\" MatchType=\"Left\">" + lname + "</SearchFilter>");
                }


                if (institution != string.Empty)
                {
                    if (institutionallexcept == "on")
                        isexclude = "1";

                    search.Append("<SearchFilter IsExclude=\"" + isexclude + "\" Property=\"http://profiles.catalyst.harvard.edu/ontology/prns#personInPrimaryPosition\"  Property2=\"http://vivoweb.org/ontology/core#positionInOrganization\"  MatchType=\"Exact\">" + institution + "</SearchFilter>");
                    isexclude = "0";
                }

                if (department != string.Empty)
                {
                    if (departmentallexcept == "on")
                        isexclude = "1";

                    search.Append("<SearchFilter IsExclude=\"" + isexclude + "\"  Property=\"http://profiles.catalyst.harvard.edu/ontology/prns#personInPrimaryPosition\"  Property2=\"http://profiles.catalyst.harvard.edu/ontology/prns#positionInDepartment\"   MatchType=\"Exact\">" + department + "</SearchFilter>");
                    isexclude = "0";
                }

                if (division != string.Empty)
                {
                    if (divisionallexcept == "on")
                        isexclude = "1";

                    search.Append("<SearchFilter IsExclude=\"" + isexclude + "\"  Property=\"http://profiles.catalyst.harvard.edu/ontology/prns#personInPrimaryPosition\"  Property2=\"http://profiles.catalyst.harvard.edu/ontology/prns#positionInDivision\"   MatchType=\"Exact\">" + division + "</SearchFilter>");
                    isexclude = "0";
                }

            }
            else
            {
                foreach (XmlNode searchfilter in xmlrequest.SelectNodes("//SearchFiltersList/SearchFilter"))
                {
                    search.Append(searchfilter.OuterXml);
                }
            }

            List<GenericListItem> filters = new List<GenericListItem>();

            if (!otherfilters.IsNullOrEmpty())
            {
                filters = GetOtherOptions(otherfilters);
            }

            if (filters.Count > 0)
            {
                foreach (GenericListItem item in filters)
                {
                    search.Append("<SearchFilter Property=\"http://profiles.catalyst.harvard.edu/ontology/prns#hasPersonFilter\" MatchType=\"Exact\">" + item.Value + "</SearchFilter>");
                }
            }
            else if(searchrequest == string.Empty)
            {
                foreach (XmlNode node in xmlrequest.SelectNodes("//SearchFiltersList/SearchFilter[@Property='http://profiles.catalyst.harvard.edu/ontology/prns#hasPersonFilter']"))
                {
                    search.Append(node.OuterXml);
                }
            }
            if (facrank != null)
            {
                List<GenericListItem> facranks = GetFacultyRanks(facrank);

                if (facranks.Count == 1)
                {

                    foreach (GenericListItem item in facranks)
                    {
                        search.Append("<SearchFilter Property=\"http://profiles.catalyst.harvard.edu/ontology/prns#hasFacultyRank\" MatchType=\"Exact\">" + item.Value + "</SearchFilter>");
                    }
                }
                else if (facranks.Count > 1)
                {
                    search.Append("<SearchFilter Property=\"http://profiles.catalyst.harvard.edu/ontology/prns#hasFacultyRank\" MatchType=\"In\">");

                    foreach (GenericListItem item in facranks)
                    {
                        search.Append("<Item>" + item.Value + "</Item>");

                    }
                    search.Append("</SearchFilter>");

                }
            }
            else if (searchrequest == string.Empty)
            {
                foreach (XmlNode node in xmlrequest.SelectNodes("//SearchFiltersList/SearchFilter[@Property='http://profiles.catalyst.harvard.edu/ontology/prns#hasFacultyRank']"))
                {
                    search.Append(node.OuterXml);
                }
            }



            search.Append("</SearchFiltersList>");

            if (classuri != string.Empty)
            {
                search.Append("<ClassURI>");
                search.Append(classuri);
                search.Append("</ClassURI>");
            }
            else
            {
                if (xmlrequest.SelectSingleNode("//SearchOptions/MatchOptions/ClassURI") != null)
                {
                    search.Append("<ClassURI>");
                    search.Append(xmlrequest.SelectSingleNode("//SearchOptions/MatchOptions/ClassURI").InnerText);
                    search.Append("</ClassURI>");
                }
            }

            search.Append("</MatchOptions>");
            search.Append("<OutputOptions><Offset>");
            search.Append(offset.ToString());
            search.Append("</Offset><Limit>");
            search.Append(limit.ToString());
            search.Append("</Limit>");

            search.Append("<SortByList>");

            switch (sortby.ToLower())
            {
                case "name":
                    sortby = this.NameSort(sortdirection);
                    break;
                case "title":
                    sortby = this.TitleSort(sortdirection);
                    break;
                case "institution":
                    sortby = this.InstitutionSort(sortdirection);
                    break;
                case "department":
                    sortby = this.DepartmentSort(sortdirection);
                    break;
                case "division":
                    sortby = this.DivisionSort(sortdirection);
                    break;
                case "facrank":
                    sortby = this.FacultyRankSort(sortdirection);
                    break;
            }

            search.Append(sortby);

            search.Append("</SortByList>");

            search.Append("</OutputOptions>");
            search.Append("</SearchOptions>");

            searchrequest = this.EncryptRequest(search.ToString());
            searchxml.LoadXml(search.ToString());

            return searchxml;

        }
        public XmlDocument Search(XmlDocument searchoptions, bool lookup)
        {
            string xmlstr = string.Empty;
            XmlDocument xmlrtn = new XmlDocument();

            string cachekey = searchoptions.OuterXml + sessionmanagement.Session().SessionID;

            if (Framework.Utilities.Cache.Fetch(cachekey) == null)
            {
                try
                {
                    string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;

                    SqlConnection dbconnection = new SqlConnection(connstr);
                    SqlCommand dbcommand = new SqlCommand();

                    SqlDataReader dbreader;
                    dbconnection.Open();
                    dbcommand.CommandType = CommandType.StoredProcedure;

                    dbcommand.CommandText = "[Search.].[GetNodes]";
                    dbcommand.CommandTimeout = base.GetCommandTimeout();

                    dbcommand.Parameters.Add(new SqlParameter("@SearchOptions", searchoptions.OuterXml));

                    dbcommand.Parameters.Add(new SqlParameter("@SessionId", sessionmanagement.Session().SessionID));

                    if (lookup)
                        dbcommand.Parameters.Add(new SqlParameter("@Lookup", 1));

                    dbcommand.Connection = dbconnection;

                    string query = dbcommand.CommandText;

                    dbreader = dbcommand.ExecuteReader(CommandBehavior.CloseConnection);

                    while (dbreader.Read())
                    {
                        xmlstr += dbreader[0].ToString();
                    }

                    if (!dbreader.IsClosed)
                        dbreader.Close();

                    xmlrtn.LoadXml(xmlstr);

                    Framework.Utilities.DebugLogging.Log(xmlstr);
                    Framework.Utilities.Cache.Set(cachekey, xmlrtn);
                    xmlstr = string.Empty;
                }
                catch (Exception e)
                {
                    Framework.Utilities.DebugLogging.Log(e.Message + " " + e.StackTrace);
                    throw new Exception(e.Message);
                }
            }
            else
            {
                xmlrtn = Framework.Utilities.Cache.Fetch(cachekey);
            }

            return xmlrtn;

        }


        public XmlDocument WhySearch(XmlDocument searchoptions, string uri, Int64 nodeid)
        {
            string xmlstr = string.Empty;
            XmlDocument xmlrtn = new XmlDocument();


            string cachekey = searchoptions.OuterXml + sessionmanagement.Session().SessionID + nodeid.ToString();

            if (Framework.Utilities.Cache.Fetch(cachekey) == null)
            {
                try
                {
                    string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;

                    SqlConnection dbconnection = new SqlConnection(connstr);
                    SqlCommand dbcommand = new SqlCommand();

                    SqlDataReader dbreader;
                    dbconnection.Open();
                    dbcommand.CommandType = CommandType.StoredProcedure;

                    dbcommand.CommandText = "[Search.].[GetConnection]";
                    dbcommand.CommandTimeout = base.GetCommandTimeout();

                    dbcommand.Parameters.Add(new SqlParameter("@SearchOptions", searchoptions.OuterXml));
                    dbcommand.Parameters.Add(new SqlParameter("@NodeID", nodeid.ToString()));
                    dbcommand.Parameters.Add(new SqlParameter("@NodeURI", uri));
                    dbcommand.Parameters.Add(new SqlParameter("@sessionid", sessionmanagement.Session().SessionID));

                    dbcommand.Connection = dbconnection;

                    dbreader = dbcommand.ExecuteReader(CommandBehavior.CloseConnection);

                    while (dbreader.Read())
                    {
                        xmlstr += dbreader[0].ToString();
                    }

                    if (!dbreader.IsClosed)
                        dbreader.Close();


                    xmlrtn.LoadXml(xmlstr);

                    Framework.Utilities.DebugLogging.Log(xmlstr);
                    Framework.Utilities.Cache.Set(cachekey, xmlrtn);
                    xmlstr = string.Empty;

                }
                catch (Exception e)
                {
                    Framework.Utilities.DebugLogging.Log(e.Message + " " + e.StackTrace);
                    throw new Exception(e.Message);
                }
            }
            else
            {
                xmlrtn = Framework.Utilities.Cache.Fetch(cachekey);
            }

            return xmlrtn;

        }

        public string EscapeXML(string value)
        {
            return value.Replace("&", "&amp;").Replace("<", "&lt;").Replace(">", "&gt;").Replace("\"", "&quot;").Replace("'", "&apos;");
        }


        public Int64 GetTotalSearchConnections(XmlDocument searchdata, XmlNamespaceManager namespaces)
        {
            Int64 totalcount = 0;

            foreach (XmlNode x in searchdata.SelectNodes("//prns:matchesClassGroup/prns:numberOfConnections", namespaces))
            {
                totalcount = totalcount + Convert.ToInt64(x.InnerText);
            }

            return totalcount;

        }


        public string EncryptRequest(string request)
        {
            byte[] keyArray;
            byte[] toEncryptArray = UTF8Encoding.UTF8.GetBytes(request);


            string Key = "ryojvlzmdalyglrj";

            keyArray = UTF8Encoding.UTF8.GetBytes(Key);

            TripleDESCryptoServiceProvider tDes = new TripleDESCryptoServiceProvider();

            tDes.Key = keyArray;
            tDes.Mode = CipherMode.ECB;
            tDes.Padding = PaddingMode.PKCS7;
            ICryptoTransform cTransform = tDes.CreateEncryptor();
            byte[] resultArray = cTransform.TransformFinalBlock(toEncryptArray, 0, toEncryptArray.Length);
            tDes.Clear();
            return Convert.ToBase64String(resultArray, 0, resultArray.Length);


        }

        public string DecryptRequest(string request)
        {

            request = request.Replace(" ", "+");

            byte[] keyArray;
            byte[] toDecryptArray = Convert.FromBase64String(request);

            string Key = "ryojvlzmdalyglrj";


            keyArray = UTF8Encoding.UTF8.GetBytes(Key);

            TripleDESCryptoServiceProvider tDes = new TripleDESCryptoServiceProvider();
            tDes.Key = keyArray;
            tDes.Mode = CipherMode.ECB;
            tDes.Padding = PaddingMode.PKCS7;
            ICryptoTransform cTransform = tDes.CreateDecryptor();
            try
            {
                byte[] resultArray = cTransform.TransformFinalBlock(toDecryptArray, 0, toDecryptArray.Length);

                tDes.Clear();
                return UTF8Encoding.UTF8.GetString(resultArray, 0, resultArray.Length);
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        private string NameSort(string direction)
        {
            string sort = "<SortBy IsDesc=\"" + (direction == "desc" ? "0" : "1") + "\" Property=\"http://xmlns.com/foaf/0.1/lastName\" />";
            sort += "<SortBy IsDesc=\"0\" Property=\"http://xmlns.com/foaf/0.1/firstName\" />";

            return sort;
        }

        private string TitleSort(string direction)
        {
            string sort = "<SortBy IsDesc=\"" + (direction == "desc" ? "0" : "1") + "\" Property=\"http://profiles.catalyst.harvard.edu/ontology/prns#personInPrimaryPosition\" Property2=\"http://www.w3.org/2000/01/rdf-schema#label\"/>";
            sort += "<SortBy IsDesc=\"0\" Property=\"http://xmlns.com/foaf/0.1/lastName\" />";

            return sort;
        }
        private string InstitutionSort(string direction)
        {
            string sort = "<SortBy IsDesc=\"" + (direction == "desc" ? "0" : "1") + "\" Property=\"http://profiles.catalyst.harvard.edu/ontology/prns#personInPrimaryPosition\" Property2=\"http://vivoweb.org/ontology/core#positionInOrganization\"  Property3=\"http://www.w3.org/2000/01/rdf-schema#label\"/>";
            sort += "<SortBy IsDesc=\"0\" Property=\"http://xmlns.com/foaf/0.1/lastName\" />";

            return sort;
        }
        private string DepartmentSort(string direction)
        {
            string sort = "<SortBy IsDesc=\"" + (direction == "desc" ? "0" : "1") + "\" Property=\"http://profiles.catalyst.harvard.edu/ontology/prns#personInPrimaryPosition\" Property2=\"http://profiles.catalyst.harvard.edu/ontology/prns#positionInDepartment\"  Property3=\"http://www.w3.org/2000/01/rdf-schema#label\"/>";
            sort += "<SortBy IsDesc=\"0\" Property=\"http://xmlns.com/foaf/0.1/lastName\" />";

            return sort;
        }
        private string DivisionSort(string direction)
        {
            string sort = "<SortBy IsDesc=\"" + (direction == "desc" ? "0" : "1") + "\" Property=\"http://profiles.catalyst.harvard.edu/ontology/prns#personInPrimaryPosition\" Property2=\"http://profiles.catalyst.harvard.edu/ontology/prns#positionInDivision\"  Property3=\"http://www.w3.org/2000/01/rdf-schema#label\"/>";
            sort += "<SortBy IsDesc=\"0\" Property=\"http://xmlns.com/foaf/0.1/lastName\" />";

            return sort;
        }

        private string FacultyRankSort(string direction)
        {
            string sort = "<SortBy IsDesc=\"" + (direction == "desc" ? "0" : "1") + "\" Property=\"http://profiles.catalyst.harvard.edu/ontology/prns#hasFacultyRank\"  Property2=\"http://profiles.catalyst.harvard.edu/ontology/prns#sortOrder\"/>";
            sort += "<SortBy IsDesc=\"0\" Property=\"http://xmlns.com/foaf/0.1/lastName\" />";

            return sort;
        }


        public SqlDataReader TopSearchPhrase(string timeperiod)
        {
            SqlDataReader dbreader;
            try
            {
                string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;

                SqlConnection dbconnection = new SqlConnection(connstr);
                SqlCommand dbcommand = new SqlCommand();

                dbconnection.Open();
                dbcommand.CommandType = CommandType.StoredProcedure;

                dbcommand.CommandText = "[Search.].[GetTopSearchPhrase]";
                dbcommand.CommandTimeout = base.GetCommandTimeout();

                dbcommand.Parameters.Add(new SqlParameter("@TimePeriod", timeperiod));

                dbcommand.Connection = dbconnection;

                dbreader = dbcommand.ExecuteReader(CommandBehavior.CloseConnection);

            }
            catch (Exception e)
            {
                Framework.Utilities.DebugLogging.Log(e.Message + " " + e.StackTrace);
                throw new Exception(e.Message);
            }

            return dbreader;
        }


        public string GetConvertedListItem(List<GenericListItem> listitems, string itemtoconvert)
        {
            GenericListItem rtnlistitem = null;
            rtnlistitem = listitems.Find(delegate(GenericListItem module) { return module.Text == itemtoconvert; });

            return rtnlistitem.Value;
        }

        public string GetConvertedURIListItem(List<GenericListItem> listitems, string itemtoconvert)
        {
            GenericListItem rtnlistitem = null;
            rtnlistitem = listitems.Find(delegate(GenericListItem module) { return module.Value == itemtoconvert; });

            return rtnlistitem.Text;
        }

        public string GetTextFromListItem(List<GenericListItem> listitems, string itemtoconvert)
        {
            GenericListItem rtnlistitem = null;
            rtnlistitem = listitems.Find(delegate(GenericListItem module) { return module.Text == itemtoconvert; });

            return rtnlistitem.Text;
        }



        /// <summary>
        /// To return the list of all the Divisions
        /// </summary>
        /// <returns></returns>
        public List<GenericListItem> GetDivisions()
        {

            List<GenericListItem> divisions = new List<GenericListItem>();


            if (Framework.Utilities.Cache.FetchObject("GetDivisions") == null)
            {
                try
                {

                    string sql = "EXEC [Profile.Data].[Organization.GetDivisions]";

                    SqlDataReader sqldr = this.GetSQLDataReader("", sql, CommandType.Text, CommandBehavior.CloseConnection, null);

                    while (sqldr.Read())
                        divisions.Add(new GenericListItem(sqldr["DivisionName"].ToString(), sqldr["URI"].ToString()));
                    //Always close your readers
                    if (!sqldr.IsClosed)
                        sqldr.Close();


                    //Defaulted this to be one hour
                    Framework.Utilities.Cache.SetWithTimeout("GetDivisions", divisions, 3600);


                }
                catch (Exception e)
                {
                    Framework.Utilities.DebugLogging.Log(e.Message + " " + e.StackTrace);
                    throw new Exception(e.Message);
                }
            }
            else
            {
                divisions = (List<GenericListItem>)Framework.Utilities.Cache.FetchObject("GetDivisions");

            }

            return divisions;
        }

        /// <summary>
        /// To return the list of all the Institutions
        /// </summary>
        /// <returns></returns>
        public List<GenericListItem> GetInstitutions()
        {
            List<GenericListItem> institutions = new List<GenericListItem>();

            if (Framework.Utilities.Cache.FetchObject("GetInstitutions") == null)
            {
                try
                {

                    string sql = "EXEC [Profile.Data].[Organization.GetInstitutions]";

                    SqlDataReader sqldr = this.GetSQLDataReader("", sql, CommandType.Text, CommandBehavior.CloseConnection, null);

                    while (sqldr.Read())
                        institutions.Add(new GenericListItem(sqldr["InstitutionName"].ToString(), sqldr["URI"].ToString()));

                    //Always close your readers
                    if (!sqldr.IsClosed)
                        sqldr.Close();

                    //Defaulted this to be one hour
                    Framework.Utilities.Cache.SetWithTimeout("GetInstitutions", institutions, 3600);


                }
                catch (Exception e)
                {
                    Framework.Utilities.DebugLogging.Log(e.Message + " " + e.StackTrace);
                    throw new Exception(e.Message);
                }
            }
            else
            {
                institutions = (List<GenericListItem>)Framework.Utilities.Cache.FetchObject("GetInstitutions");

            }

            return institutions;
        }
        public DataSet GetFilters()
        {
            DataSet ds = new DataSet();
            SqlDataAdapter da;


            if (Framework.Utilities.Cache.FetchObject("GetFilters") == null)
            {
                try
                {

                    string sql = "EXEC [Profile.Data].[Person.GetFilters]";
                    SqlConnection conn = this.GetDBConnection("");
                    da = new SqlDataAdapter(sql, conn);

                    da.Fill(ds, "Table");
                    //Defaulted this to be one hour
                    Framework.Utilities.Cache.SetWithTimeout("GetFilters", ds, 3600);

                    conn.Close();

                }
                catch (Exception e)
                {
                    Framework.Utilities.DebugLogging.Log(e.Message + " " + e.StackTrace);
                    throw new Exception(e.Message);
                }
            }
            else
            {
                ds = (DataSet)Framework.Utilities.Cache.FetchObject("GetFilters");

            }
            return ds;

        }

        /// <summary>
        /// To return the list of all the Departments
        /// </summary>
        /// <returns></returns>
        public List<GenericListItem> GetDepartments()
        {
            List<GenericListItem> departments = new List<GenericListItem>();

            if (Framework.Utilities.Cache.FetchObject("GetDepartments") == null)
            {
                try
                {
                    string sql = "EXEC [Profile.Data].[Organization.GetDepartments]";


                    SqlDataReader sqldr = this.GetSQLDataReader("", sql, CommandType.Text, CommandBehavior.CloseConnection, null);

                    while (sqldr.Read())
                        departments.Add(new GenericListItem(sqldr["Department"].ToString(), sqldr["URI"].ToString()));

                    //Always close your readers
                    if (!sqldr.IsClosed)
                        sqldr.Close();

                    //Defaulted this to be one hour
                    Framework.Utilities.Cache.SetWithTimeout("GetDepartments", departments, 3600);

                }
                catch (Exception e)
                {
                    Framework.Utilities.DebugLogging.Log(e.Message + " " + e.StackTrace);
                    throw new Exception(e.Message);
                }
            }
            else
            {
                departments = (List<GenericListItem>)Framework.Utilities.Cache.FetchObject("GetDepartments");

            }
            return departments;
        }

        /// To return the list of all the Departments
        /// </summary>
        /// <returns></returns>
        public List<GenericListItem> GetFacultyRanks()
        {
            List<GenericListItem> ranks = new List<GenericListItem>();

            if (Framework.Utilities.Cache.FetchObject("GetFacultyRanks") == null)
            {
                try
                {
                    string sql = "EXEC [Profile.Data].[Person.GetFacultyRanks]";

                    SqlDataReader sqldr = this.GetSQLDataReader("", sql, CommandType.Text, CommandBehavior.CloseConnection, null);

                    while (sqldr.Read())
                        ranks.Add(new GenericListItem(sqldr["FacultyRank"].ToString(), sqldr["URI"].ToString()));

                    //Always close your readers
                    if (!sqldr.IsClosed)
                        sqldr.Close();

                    //Defaulted this to be one hour
                    Framework.Utilities.Cache.SetWithTimeout("GetFacultyRanks", ranks, 3600);

                }
                catch (Exception e)
                {
                    Framework.Utilities.DebugLogging.Log(e.Message + " " + e.StackTrace);
                    throw new Exception(e.Message);
                }

            }
            else
            {
                ranks = (List<GenericListItem>)Framework.Utilities.Cache.FetchObject("GetFacultyRanks");
            }
            return ranks;
        }

        public List<GenericListItem> GetFacultyRanks(string rankstrings)
        {
            List<GenericListItem> ranks = new List<GenericListItem>();

            
            rankstrings = rankstrings.Replace(" ,", ",").Replace(", ", ",");
            string[] items = rankstrings.Split(',');


            foreach (GenericListItem gli in this.GetFacultyRanks())
            {
                if (items.Contains(gli.Text))
                {
                    ranks.Add(new GenericListItem(gli.Text, gli.Value));

                }

            }

            return ranks;

        }


        /// <summary>
        /// Get a list of person types from the database.
        /// Logically reorganized to be in the correct format for the ComboTreeCheck control
        /// </summary>
        /// <returns>DataSet</returns>
        public DataSet GetPersonTypes()
        {
            DataSet personTypesReturn;

            DataSet personTypes = this.GetFilters();
            personTypesReturn = new DataSet();

            // New table for the master records
            personTypesReturn.Tables.Add("DataMasterName");
            personTypesReturn.Tables[0].Columns.Add("personTypeGroupId", Type.GetType("System.Int32"));
            personTypesReturn.Tables[0].Columns.Add("personTypeGroup", Type.GetType("System.String"));
            personTypesReturn.Tables[0].Columns.Add("Expanded", Type.GetType("System.Boolean"));

            // New table for the detail records
            personTypesReturn.Tables.Add("DataDetailName");
            personTypesReturn.Tables[1].Columns.Add("personTypeGroupId", Type.GetType("System.Int32"));
            personTypesReturn.Tables[1].Columns.Add("personTypeFlagId", Type.GetType("System.Int32"));
            personTypesReturn.Tables[1].Columns.Add("personTypeFlag", Type.GetType("System.String"));
            personTypesReturn.Tables[1].Columns.Add("Checked", Type.GetType("System.Boolean"));

            string lastParentTag = "";
            string currentParentTag = "";
            string currentChildTag = "";
            int parentRowId = 0;
            int childRowId = 1;
            bool getChild = false;

            foreach (DataRow pRow in personTypes.Tables[0].Rows)
            {
                currentParentTag = Convert.ToString(pRow["PersonFilterCategory"]);
                currentChildTag = Convert.ToString(pRow["personfilter"]);
                getChild = false;

                if (currentParentTag != lastParentTag)
                {
                    // We have a new parent
                    parentRowId++;
                    personTypesReturn.Tables[0].Rows.Add(parentRowId, currentParentTag);
                    lastParentTag = currentParentTag;

                    // Also get child
                    getChild = true;
                }
                else
                {
                    // We only have child
                    getChild = true;
                }

                if (getChild)
                {
                    personTypesReturn.Tables[1].Rows.Add(parentRowId, childRowId, currentChildTag);
                    childRowId++;
                }
            }


            return personTypesReturn;
        }



        public List<GenericListItem> GetListOfFilters()
        {
            List<GenericListItem> gli = new List<GenericListItem>();

            XmlDocument xml = new XmlDocument();
            xml.LoadXml(this.GetFilters().GetXml());


            foreach (XmlNode x in xml.SelectNodes("NewDataSet/Table"))
            {
                gli.Add(new GenericListItem(x.SelectSingleNode("PersonFilter").InnerText, x.SelectSingleNode("URI").InnerText));
            }

            return gli;

        }



        public List<GenericListItem> GetOtherOptions(string otheroptions)
        {

            List<GenericListItem> filters = new List<GenericListItem>();
            DataSet ds = this.GetFilters();
            otheroptions = otheroptions.Replace(" ,", ",").Replace(", ", ",");
            string[] items = otheroptions.Split(',');





            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                if (items.Contains(dr[2].ToString()))
                    filters.Add(new GenericListItem(dr[2].ToString(), dr[5].ToString()));

            }

            return filters;


        }


    }

}
