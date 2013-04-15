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
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.Xml.Xsl;
using System.Web.UI.HtmlControls;
using System.Configuration;

using Profiles.Framework.Utilities;
using Profiles.Search.Utilities;

namespace Profiles.Search.Modules.SearchResults
{
    public partial class SearchResults : BaseModule
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            DrawProfilesModule();
        }
        public SearchResults() { }
        public SearchResults(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
            : base(pagedata, moduleparams, pagenamespaces)
        {
            Utilities.DataIO data = new Profiles.Search.Utilities.DataIO();

           
            this.SearchData = pagedata;
        }

        public XmlDocument SearchData { get; set; }


        private void DrawProfilesModule()
        {

            XsltArgumentList args = new XsltArgumentList();
            long offset = 0;
            long perpage = 0;
            long totalcount = 0;
            long totalpageremainder = 0;
            long totalpages = 0;
            long startrecord = 0;
            long page = 0;
            string searchfor = "";
            string classgroupuri = "";
            string classuri = "";

            string fname = "";
            string lname = "";
            string institution = "";
            string department = "";
            string division = "";
            string sort = "";
            string sortdirection = "";
            string searchrequest = "";
            XmlDocument xmlsearchrequest;
            xmlsearchrequest = new XmlDocument();
            
            Int16 showcolumns = 0;

            string otherfilters = "";
            string institutionallexcept = string.Empty;
            string departmentallexcept = string.Empty;
            string divisionallexcept = string.Empty;
            string exactphrase = string.Empty;


            string searchtype = "";

            Search.Utilities.DataIO data = new Profiles.Search.Utilities.DataIO();

            if (String.IsNullOrEmpty(Request.QueryString["searchrequest"])==false)
            {
                searchrequest = data.DecryptRequest(Request.QueryString["searchrequest"]);
                xmlsearchrequest.LoadXml(searchrequest);
            }
            else if (string.IsNullOrEmpty(base.MasterPage.SearchRequest) == false)
            {
                searchrequest = data.DecryptRequest(base.MasterPage.SearchRequest);
                xmlsearchrequest.LoadXml(searchrequest);
            }
            

            if (String.IsNullOrEmpty(Request.QueryString["searchtype"])==false)
            {
                searchtype = Request.QueryString["searchtype"];
            }
            else if (String.IsNullOrEmpty(Request.Form["searchtype"])==false)
            {
                searchtype = Request.Form["searchtype"];
            }


            if (String.IsNullOrEmpty(Request.QueryString["searchfor"])==false)
            {
                searchfor = Request.QueryString["searchfor"];
            }
            else if(String.IsNullOrEmpty(Request.Form["txtSearchFor"])==false)
            {
                searchfor = Request.Form["txtSearchFor"];
            }
            else if (xmlsearchrequest.ChildNodes.Count > 0)
            {
				try
				{				
					searchfor = xmlsearchrequest.SelectSingleNode("SearchOptions/MatchOptions/SearchString").InnerText;
				}
				catch(Exception)
				{
					// Do nothing, leave searchfor = null
				}
            }



            if (searchfor == null)
                searchfor = string.Empty;

            if (String.IsNullOrEmpty(Request.QueryString["lname"])==false)
                lname = Request.QueryString["lname"];
            else
                lname = Request.Form["txtLname"];

            if (lname == null)
                lname = string.Empty;

            if (String.IsNullOrEmpty(Request.QueryString["fname"])==false)
                fname = Request.QueryString["fname"];
            else
                fname = Request.Form["txtFname"];

            if (fname == null)
                fname = string.Empty;

            if (String.IsNullOrEmpty(Request.QueryString["institution"])==false)
                institution = Request.QueryString["institution"];

            if (String.IsNullOrEmpty(Request.QueryString["department"])==false)
                department = Request.QueryString["department"];

            if (String.IsNullOrEmpty(Request.QueryString["division"]) == false)
                division = Request.QueryString["division"];
            
            if (String.IsNullOrEmpty(Request.QueryString["perpage"])==false)
            {
				perpage = Convert.ToInt64(Request.QueryString["perpage"]);
				if (!(perpage>0))
					perpage = 15;

				//if (String.IsNullOrEmpty(Request.QueryString["perpage"])==false)
				//    perpage = Convert.ToInt64(Request.QueryString["perpage"]);
				//else
				//    perpage = 15;
            }
            else
            {
                perpage = 15; //default
            }

            if (String.IsNullOrEmpty(Request.QueryString["offset"])==false)
            {
				offset = Convert.ToInt64(Request.QueryString["offset"]);
				//if (Request.QueryString["offset"] != string.Empty)
				//    offset = Convert.ToInt64(Request.QueryString["offset"]);
				//else
				//    offset = 0;
            }
            else
            {
                offset = 0;
            }

            if (String.IsNullOrEmpty(Request.QueryString["page"])==false)
            {
				page = Convert.ToInt64(Request.QueryString["page"]);
				if (!(page > 0))
					page = 1;
				//if (Request.QueryString["page"] != string.Empty)
				//    page = Convert.ToInt64(Request.QueryString["page"]);
				//else
				//    page = 1;
            }
            else
            {
                page = 1;
            }


            if (String.IsNullOrEmpty(Request.QueryString["classgroupuri"])==false)
                classgroupuri = HttpUtility.UrlDecode(Request.QueryString["classgroupuri"]);
            else
                classgroupuri = HttpUtility.UrlDecode(Request.Form["classgroupuri"]);

            if (classgroupuri != null)
            {
                if (classgroupuri.Contains("!"))
                    classgroupuri = classgroupuri.Replace('!', '#');
            }
            else
            {
                classgroupuri = string.Empty;
            }

            if (String.IsNullOrEmpty(Request.QueryString["classuri"])==false)
                classuri = HttpUtility.UrlDecode(Request.QueryString["classuri"]);
            else
                classuri = HttpUtility.UrlDecode(Request.Form["classuri"]);

            if (classuri != null)
            {
                if (classuri.Contains("!"))
                    classuri = classuri.Replace('!', '#');
            }
            else
            {
                classuri = string.Empty;
            }


            if (String.IsNullOrEmpty(Request.QueryString["sortby"])==false)
                sort = Request.QueryString["sortby"];

            if (String.IsNullOrEmpty(Request.QueryString["sortdirection"])==false)
                sortdirection = Request.QueryString["sortdirection"];


            if (String.IsNullOrEmpty(Request.QueryString["showcolumns"])==false)
            {
                showcolumns = Convert.ToInt16(Request.QueryString["showcolumns"]);
            }
            else
            {
                showcolumns = 1;
            }


            if (String.IsNullOrEmpty(Request.QueryString["otherfilters"])==false)
            {
                otherfilters = Request.QueryString["otherfilters"];

            }






            if (String.IsNullOrEmpty(Request.QueryString["institutionallexcept"])==false)
            {
                institutionallexcept = Request.QueryString["institutionallexcept"];

            }


            if (String.IsNullOrEmpty(Request.QueryString["departmentallexcept"])==false)
            {
                departmentallexcept = Request.QueryString["departmentallexcept"];

            }

            if (String.IsNullOrEmpty(Request.QueryString["divisionallexcept"]) == false)
            {
                divisionallexcept = Request.QueryString["divisionallexcept"];

            }

            if (String.IsNullOrEmpty(Request.QueryString["exactphrase"])==false)
            {
                exactphrase = Request.QueryString["exactphrase"];

            }


            try
            {

                totalcount = data.GetTotalSearchConnections(this.SearchData, base.Namespaces);
                
                if (page < 0)
                {
                    page = 1;
                }

         
                totalpages = Math.DivRem(totalcount, Convert.ToInt64(perpage), out totalpageremainder);

                if (totalpageremainder > 0) { totalpages = totalpages + 1; }

                if (page > totalpages)
                    page = totalpages;

                startrecord = ((Convert.ToInt32(page) * Convert.ToInt32(perpage)) + 1) - Convert.ToInt32(perpage);

                if (startrecord < 0)
                    startrecord = 1;

                if(searchrequest.Trim() != string.Empty)
                searchrequest = data.EncryptRequest(searchrequest);

                List<GenericListItem> g = new List<GenericListItem>();
                g = data.GetListOfFilters();

                if (otherfilters.IsNullOrEmpty() && base.BaseData.SelectSingleNode("rdf:RDF/rdf:Description/vivo:overview/SearchOptions/MatchOptions/SearchFiltersList/SearchFilter[@Property='http://profiles.catalyst.harvard.edu/ontology/prns#hasPersonFilter']", base.Namespaces) !=null)
                {
                    string s = string.Empty;

                    foreach (XmlNode x in base.BaseData.SelectSingleNode("rdf:RDF/rdf:Description/vivo:overview/SearchOptions/MatchOptions/SearchFiltersList/SearchFilter[@Property='http://profiles.catalyst.harvard.edu/ontology/prns#hasPersonFilter']", base.Namespaces))
                    {
                        s = data.GetConvertedURIListItem(g, x.InnerText);
                        otherfilters += "," + s;
                    }
                }

                switch (searchtype.ToLower())
                {
                    case "everything":                       
                            xmlsearchrequest = data.SearchRequest(searchfor,exactphrase, classgroupuri, classuri, perpage.ToString(), (startrecord - 1).ToString());
                        break;

                    default:                       
                            xmlsearchrequest = data.SearchRequest(searchfor, exactphrase, fname, lname, institution, institutionallexcept, department, departmentallexcept, division, divisionallexcept,  "http://xmlns.com/foaf/0.1/Person", perpage.ToString(), (startrecord - 1).ToString(), sort, sortdirection, otherfilters, "",ref searchrequest);                    
                        break;
                }

                this.SearchData = data.Search(xmlsearchrequest,false);
                this.SearchRequest = data.EncryptRequest(xmlsearchrequest.OuterXml);
                base.MasterPage.SearchRequest = this.SearchRequest;
                base.MasterPage.RDFData = this.SearchData;
                base.MasterPage.RDFNamespaces = this.Namespaces;

            }
            catch (Exception ex)
            {
                ex = ex;
                //for now just flip it back to the defaults. This is if someone keys some funky divide by zero stuff in the URL
                // to try and break the system.
                startrecord = 1;
                perpage = 15;
            }

            args.AddParam("root", "", Root.Domain);
            args.AddParam("perpage", "", perpage);
            args.AddParam("offset", "", offset);
            args.AddParam("totalpages", "", totalpages);
            args.AddParam("page", "", page);
            args.AddParam("searchfor", "", searchfor);
            args.AddParam("classGrpURIpassedin", "", classgroupuri);
            args.AddParam("classURIpassedin", "", classuri);
            args.AddParam("searchrequest", "", this.SearchRequest);

            switch (searchtype.ToLower())
            {
                case "everything":
                    litEverythingResults.Text = XslHelper.TransformInMemory(Server.MapPath("~/Search/Modules/SearchResults/EverythingResults.xslt"), args, this.SearchData.OuterXml);
                    break;
                case "people":

                    args.AddParam("showcolumns", "", showcolumns.ToString());

                    if ((showcolumns & 1) == 1)
                    {
                        args.AddParam("institution", "", "true");
                    }
                    else
                    {
                        args.AddParam("institution", "", "false");
                    }

                    if ((showcolumns & 2) == 2)
                    {
                        args.AddParam("department", "", "true");
                    }
                    else
                    {
                        args.AddParam("department", "", "false");
                    }

                  

                    if ((showcolumns & 8) == 8)
                    {
                        args.AddParam("facrank", "", "true");
                    }
                    else
                    {
                        args.AddParam("facrank", "", "false");
                    }



                    //Profiles.Search.Utilities.DataIO dropdowns = new Profiles.Search.Utilities.DataIO();
                    if (Convert.ToBoolean(ConfigurationSettings.AppSettings["ShowInstitutions"]) == true)
                    {

                        args.AddParam("ShowInstitutions", "", "true");
                    }
                    else
                    {
                        args.AddParam("ShowInstitutions", "", "false");
                    }


                    if (Convert.ToBoolean(ConfigurationSettings.AppSettings["ShowDepartments"]) == true)
                    {
                        args.AddParam("ShowDepartments", "", "true");
                    }
                    else
                    {
                        args.AddParam("ShowDepartments", "", "false");
                    }
                 
                    //Faculty Rank always shows
                    args.AddParam("ShowFacRank", "", "true");

                    args.AddParam("currentsort", "", sort);
                    args.AddParam("currentsortdirection", "", sortdirection);

                    if (base.BaseData.SelectNodes("rdf:RDF/rdf:Description/vivo:overview/SearchDetails/SearchPhraseList", base.Namespaces).Count > 0)
                        args.AddParam("why", "", true);
                    else
                        args.AddParam("why", "", false);

                    litEverythingResults.Text = HttpUtility.HtmlDecode( XslHelper.TransformInMemory(Server.MapPath("~/Search/Modules/SearchResults/PeopleResults.xslt"), args, this.SearchData.OuterXml));
                    break;
            }
        }


        private string SearchRequest { get; set; }


    }
}