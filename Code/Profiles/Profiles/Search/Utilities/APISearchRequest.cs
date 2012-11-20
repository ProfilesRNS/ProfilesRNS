/*  
 
    Copyright (c) 2008-2012 by the President and Fellows of Harvard College. All rights reserved.  
    Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
    and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
    National Center for Research Resources and Harvard University.


    Code licensed under a BSD License. 
    For details, see: LICENSE.txt 
  
*/
using System;
using System.Web;
using System.Xml;
using System.Xml.XPath;

using Profiles.Framework;

namespace Profiles.Search.Utilities
{
    public class APISearchRequest
    {
        XmlDocument _doc = new XmlDocument();

        #region "CONSTRUCTORS"
        public APISearchRequest()
        {
            _doc.Load(AppDomain.CurrentDomain.BaseDirectory.ToString() + "/Search/Utilities/GetPersonList.xml");

        }
        public APISearchRequest(string PersonID)
        {
            _doc.Load(AppDomain.CurrentDomain.BaseDirectory.ToString() + "/Search/Utilities/GetPersonListSingle.xml");

            this.LoadPersonId(PersonID);
        }

        public APISearchRequest(string PersonID, string Keyword)
        {
            _doc.Load(AppDomain.CurrentDomain.BaseDirectory.ToString() + "/Search/Utilities/GetConnectionPersonListSingle.xml");

            this.LoadPersonId(PersonID);
            this.LoadKeywordString("and", Keyword);

        }
        #endregion

        #region "EXECUTE QUERY"
        public XmlDocument ExecuteSingle()
        {
            DataIO search = new DataIO();
            XmlDocument returndata = null;
            string queryid = string.Empty;

            _doc.LoadXml(_doc.OuterXml.Replace("xmlns=\"\"", ""));

            returndata = search.BetaSearch(_doc);
            return returndata;

        }
        public void Execute()
        {
            DataIO search = new DataIO();
            XmlDocument returndata = null;
            string queryid = string.Empty;

            _doc.LoadXml(_doc.OuterXml.Replace("xmlns=\"\"", ""));

            returndata = search.BetaSearch(_doc);

            this.SetQueryID(returndata);

            CacheWrapper.CacheItem(this.QueryID + "request", _doc);
            CacheWrapper.CacheItem(this.QueryID + "results", returndata);

        }

        public XmlDocument Execute(string QueryID, string Keyword, string EntityID)
        {           
            DataIO search = new DataIO();
            try
            {                
                _doc = new XmlDocument();
                _doc.Load(AppDomain.CurrentDomain.BaseDirectory.ToString() + "/Search/Utilities/GetSearchConnection.xml");

                _doc.LoadXml(_doc.InnerXml.Replace("{{{@EntityID}}}", EntityID));
                _doc.LoadXml(_doc.InnerXml.Replace("{{{@QueryID}}}", QueryID));
                _doc.LoadXml(_doc.InnerXml.Replace("{{{@Keyword}}}", Keyword));                            

             
            }
            catch (Exception ex)
            {
                //For Debugging only put a break(F9) on the ex=ex while debugging,  if an error takes place at this level then the cache for the query header has
                // exprired so notify the user and have them start a new search session.
               Framework.Utilities.DebugLogging.Log(ex.Message + " ++ " + ex.StackTrace);                
            }
            return search.BetaSearch(_doc);               

        }

        public XmlDocument Execute(string QueryID, string SortBy, string StartRecord, string MaxRecords)
        {
            XmlDocument rtn = new XmlDocument();
            try
            {
                DataIO search = new DataIO();
                XmlDocument returndata = new XmlDocument();
                _doc.LoadXml(search.GetQueryXML(QueryID));

                if (_doc == null)
                {
                    _doc = new XmlDocument();
                    _doc.Load(AppDomain.CurrentDomain.BaseDirectory.ToString() + "/Search/Utilities/GetPersonListWithQueryID.xml");
                    this.LoadQueryID(QueryID);
                    this.LoadOutputOptions(SortBy, StartRecord, MaxRecords);
                }
                else
                {
                              
                    this.SetPages(StartRecord, MaxRecords);
                    this.SetSort(SortBy);
                }

                //TODO: ZAP: Sometimes the personid gets cached if its a connection search of a keyword.
                if (_doc.SelectSingleNode("Profiles/QueryDefinition/PersonID") != null)
                {
                    _doc.SelectSingleNode("Profiles/QueryDefinition/PersonID").InnerText = "";
                }

                returndata = search.BetaSearch(_doc);
                
                this.QueryID = QueryID;

                CacheWrapper.CacheItem(QueryID + "request", _doc);
                CacheWrapper.CacheItem(QueryID + "results", returndata);
                rtn = returndata;
            }
            catch (Exception ex)
            {
                //For Debugging only put a break(F9) on the ex=ex while debugging,  if an error takes place at this level then the cache for the query header has
                // exprired so notify the user and have them start a new search session.
               Framework.Utilities.DebugLogging.Log(ex.Message + " ++ " + ex.StackTrace);
              
            }

            return rtn;

        }

        #endregion

        #region "PAGGING AND SORT"
        public void SetSort(string SortBy)
        {
            try
            {
                if (SortBy.Contains("_DESC"))
                {
                    SortBy = SortBy.Replace("_DESC", "");
                    XmlAttribute sort = _doc.CreateAttribute("SortAsc");                    
                    sort.Value = "False";
                    _doc.SelectSingleNode(".").FirstChild.LastChild.Attributes.Append(sort);                    
                }
                _doc.SelectSingleNode(".").FirstChild.LastChild.Attributes["SortType"].Value = SortBy;
            }
            catch (Exception ex) { }
        }

        public void SetPages(string StartRecord, string MaxRecords)
        {
            try
            {
                _doc.SelectSingleNode(".").FirstChild.LastChild.Attributes["MaxRecords"].Value = MaxRecords;
                _doc.SelectSingleNode(".").FirstChild.LastChild.Attributes["StartRecord"].Value = StartRecord;
            }
            catch (Exception ex) { }

        }

        #endregion

        #region "BUILD REQUEST METHODS"

        public void LoadQueryID(string QueryID)
        {

            XmlElement querydefinition = _doc.CreateElement("QueryDefinition");
            XmlAttribute queryid = _doc.CreateAttribute("QueryID");

            queryid.Value = QueryID;


            if (_doc.SelectSingleNode("Profiles/QueryDefinition") == null)
            {
                queryid.Value = QueryID;

                querydefinition.SetAttributeNode(queryid);

                _doc.DocumentElement.AppendChild(querydefinition);
            }
            else
            {
                if (_doc.SelectSingleNode("Profiles/QueryDefinition/@QueryID") != null)
                {
                    _doc.SelectSingleNode("Profiles/QueryDefinition/@QueryID").Value = QueryID;
                }
                else
                {
                    _doc.SelectSingleNode("Profiles/QueryDefinition").Attributes.Append(queryid);
                }
            }

        }

        public void LoadPersonName(string FirstName, string LastName)
        {
            FirstName = FirstName.Trim();
            LastName = LastName.Trim();
            XmlElement name = _doc.CreateElement("Name");

            XmlElement lname = _doc.CreateElement("LastName");

            XmlAttribute matchtype = _doc.CreateAttribute("MatchType");
            matchtype.Value = "left";

            lname.SetAttributeNode(matchtype);

            XmlElement fname = _doc.CreateElement("FirstName");

            lname.InnerText = LastName;
            fname.InnerText = FirstName;

            name.AppendChild(fname);
            name.AppendChild(lname);

            _doc.DocumentElement.FirstChild.InsertBefore(name, _doc.DocumentElement.FirstChild.FirstChild);
        }


        public void LoadPersonFilter(string Visiting, string NotVisiting, string Emeritus, string NotEmeritus, string FullTime, string NotFullTime)
        {
            Visiting = Visiting.Trim();
            NotVisiting = NotVisiting.Trim();
            Emeritus = Emeritus.Trim();
            NotEmeritus = NotEmeritus.Trim();
            FullTime = FullTime.Trim();
            NotFullTime = NotFullTime.Trim();


            XmlElement personfilterlist = _doc.CreateElement("PersonFilterList");


            if (Visiting.Trim() != "")
            {
                XmlElement personfilter = _doc.CreateElement("PersonFilter");
                personfilterlist.AppendChild(personfilter);
                personfilter.InnerText = Visiting;

            }
            if (NotVisiting.Trim() != "")
            {
                XmlElement personfilter = _doc.CreateElement("PersonFilter");
                personfilterlist.AppendChild(personfilter);
                personfilter.InnerText = NotVisiting;
            }
            if (Emeritus.Trim() != "")
            {
                XmlElement personfilter = _doc.CreateElement("PersonFilter");
                personfilterlist.AppendChild(personfilter);
                personfilter.InnerText = Emeritus;
            }
            if (NotEmeritus.Trim() != "")
            {
                XmlElement personfilter = _doc.CreateElement("PersonFilter");
                personfilterlist.AppendChild(personfilter);
                personfilter.InnerText = NotEmeritus;

            }
            if (FullTime.Trim() != "")
            {
                XmlElement personfilter = _doc.CreateElement("PersonFilter");
                personfilterlist.AppendChild(personfilter);
                personfilter.InnerText = FullTime;

            }
            if (NotFullTime.Trim() != "")
            {
                XmlElement personfilter = _doc.CreateElement("PersonFilter");
                personfilterlist.AppendChild(personfilter);
                personfilter.InnerText = NotFullTime;

            }

            _doc.DocumentElement.FirstChild.AppendChild(personfilterlist);




        }

        public void LoadFacultyRank(string FacultyRank, string ExcludeVisiting, string ExcludeFullTime, string ExcludeEmeritus)
        {

            FacultyRank = FacultyRank.Trim();

            if (FacultyRank != string.Empty)
            {

                ExcludeVisiting = ExcludeVisiting.Trim();
                ExcludeFullTime = ExcludeFullTime.Trim();
                ExcludeEmeritus = ExcludeEmeritus.Trim();


                XmlElement facultyranklist = _doc.CreateElement("FacultyRankList");

                if (ExcludeVisiting != string.Empty)
                {
                    XmlAttribute visiting = _doc.CreateAttribute("ExcludeVisiting");
                    facultyranklist.SetAttributeNode(visiting);
                    visiting.Value = ExcludeVisiting;
                }

                if (ExcludeFullTime != string.Empty)
                {
                    XmlAttribute fulltime = _doc.CreateAttribute("ExcludeFullTime");
                    facultyranklist.SetAttributeNode(fulltime);
                    fulltime.Value = ExcludeFullTime;
                }

                if (FacultyRank != string.Empty)
                {
                    XmlAttribute emeritus = _doc.CreateAttribute("ExcludeEmeritus");
                    facultyranklist.SetAttributeNode(emeritus);
                    emeritus.Value = ExcludeEmeritus;
                }

                XmlElement facultyrank = _doc.CreateElement("FacultyRank");
                facultyrank.InnerText = FacultyRank;
                facultyranklist.AppendChild(facultyrank);

                _doc.FirstChild.FirstChild.AppendChild(facultyranklist);

            }

        }

        public void LoadAffiliation(bool AffiliationPrimary, string Institution, bool ExcludeIntitution, string Department, bool ExcludeDepartment)
        {


            XmlElement affiliationlist = _doc.CreateElement("AffiliationList");
            XmlElement affiliation = _doc.CreateElement("Affiliation");
            XmlAttribute primary = _doc.CreateAttribute("Primary");

            /*
              bool ExcludeIntitution = true;
                bool ExcludeDepartment = true;

            if (Institution.Trim() == string.Empty)
                ExcludeIntitution = false;

            if (Department.Trim() == string.Empty)
                ExcludeDepartment = false;

            */

            if (AffiliationPrimary)
            {
                primary.Value = "true";
            }
            else
            {
                primary.Value = "false";
            }
            affiliation.SetAttributeNode(primary);


            XmlElement institution = null;
            XmlElement department = null;

            if (Institution != string.Empty)
            {
                institution = _doc.CreateElement("InstitutionName");
                XmlAttribute ex = _doc.CreateAttribute("Exclude");
                if (ExcludeIntitution)
                {
                    ex.Value = "true";
                }
                else
                {
                    ex.Value = "false";
                }

                institution.SetAttributeNode(ex);
                institution.InnerText = Institution;


            }

            if (Department != string.Empty)
            {
                department = _doc.CreateElement("DepartmentName");

                XmlAttribute ex = _doc.CreateAttribute("Exclude");
                if (ExcludeDepartment)
                {
                    ex.Value = "true";
                }
                else
                {
                    ex.Value = "false";
                }

                department.SetAttributeNode(ex);
                department.InnerText = Department;

            }

            if (institution != null)
            {
                affiliation.AppendChild(institution);
            }
            if (department != null)
            {
                affiliation.AppendChild(department);
            }

            affiliationlist.AppendChild(affiliation);


            _doc.DocumentElement.FirstChild.AppendChild(affiliationlist);



        }

        public void LoadKeywordString(string MatchType, string KeywordString)
        {
            KeywordString = KeywordString.Trim();

            XmlElement keyword = _doc.CreateElement("Keywords");

            XmlElement kewordstring = _doc.CreateElement("KeywordString");

            if (KeywordString == string.Empty)
            {
                MatchType = "and";
            }

            if (KeywordString != string.Empty)
            {
                XmlAttribute matchtype = _doc.CreateAttribute("MatchType");
                matchtype.Value = MatchType;
                kewordstring.SetAttributeNode(matchtype);
                kewordstring.InnerText = KeywordString;
            }

            if (MatchType.ToLower() == "exact")
            {
                kewordstring.InnerText = KeywordString.Replace("\"", "");
                kewordstring.InnerText = KeywordString;
            }


            keyword.AppendChild(kewordstring);

            _doc.DocumentElement.FirstChild.InsertAfter(keyword, _doc.DocumentElement.FirstChild.FirstChild);


        }

        public void LoadOutputOptions(string SortType, string StartRecord, string MaxRecords)
        {
            SortType = SortType.Trim();
            StartRecord = StartRecord.Trim();
            MaxRecords = MaxRecords.Trim();

            XmlElement outputoptions = _doc.CreateElement("OutputOptions");
            XmlAttribute sorttype = _doc.CreateAttribute("SortType");
            XmlAttribute startrecord = _doc.CreateAttribute("StartRecord");
            XmlAttribute maxrecords = _doc.CreateAttribute("MaxRecords");

            XmlElement outputfilterlist;
            XmlElement outputfilter;
            XmlAttribute summary;

            sorttype.Value = SortType;
            startrecord.Value = StartRecord;
            maxrecords.Value = MaxRecords;

            outputoptions.SetAttributeNode(sorttype);
            outputoptions.SetAttributeNode(startrecord);

            if (MaxRecords != "")
            {
                outputoptions.SetAttributeNode(maxrecords);
            }

            outputfilterlist = _doc.CreateElement("OutputFilterList");
            outputfilter = _doc.CreateElement("OutputFilter");
            summary = _doc.CreateAttribute("Summary");
            summary.Value = "True";

            outputfilter.InnerText = "KeywordList";
            outputfilter.SetAttributeNode(summary);
            outputfilterlist.AppendChild(outputfilter);
            outputoptions.AppendChild(outputfilterlist);



            _doc.DocumentElement.AppendChild(outputoptions);
        }


        public void LoadPersonId(string PersonId)
        {
            PersonId = PersonId.Trim();
            XmlElement personid = _doc.CreateElement("PersonID");
            personid.InnerText = PersonId;
            _doc.DocumentElement.FirstChild.AppendChild(personid);

        }

        #endregion

        private void SetQueryID(XmlDocument data)
        {
            //this.QueryId = data.SelectSingleNode("PersonList").Attributes["QueryID"].Value;
            this.QueryID = data.SelectSingleNode(".").LastChild.Attributes["QueryID"].Value;
        }

        public string QueryID
        {
            get;
            set;
        }
    }
}
