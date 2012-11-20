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
using System.Xml;
using System.Web.UI.WebControls;
using System.IO;
using System.Web.UI.HtmlControls;

using Profiles.Framework.Utilities;
using Profiles.Search.Utilities;

namespace Profiles.Search
{
    public partial class Default : System.Web.UI.Page
    {
        Profiles.Framework.Template masterpage;

        //public void Page_Load(object sender, EventArgs e)
        override protected void OnInit(EventArgs e)
        {
            masterpage = (Framework.Template)base.Master;

            if (Request.QueryString["searchtype"] == null && Request.Form["searchtype"] == null)
            {
                this.LoadPresentationXML("searchform");
                if (Request.QueryString["tab"] != null)
                    masterpage.Tab = Request.QueryString["tab"];
                else
                    masterpage.Tab = "";
                masterpage.RDFData = null;
                masterpage.RDFNamespaces = null;
            }
            else
            {
                if (Request.QueryString["tab"] != null)
                    masterpage.Tab = Request.QueryString["tab"];
                else
                    masterpage.Tab = "";

                if (Request.QueryString["searchtype"] != null)
                    this.LoadPresentationXML(Request.QueryString["searchtype"]);
                else
                    this.LoadPresentationXML(Request.Form["searchtype"]);

                this.LoadRDFSearchResults();
            }

            this.LoadAssets();
            masterpage.PresentationXML = this.PresentationXML;

        }

        public void LoadPresentationXML(string type)
        {
            string presentationxml = string.Empty;
            switch (type.ToLower())
            {
                case "searchform":
                    presentationxml = System.IO.File.ReadAllText(AppDomain.CurrentDomain.BaseDirectory + "/Search/PresentationXML/SearchFormPresentation.xml");
                    break;
                case "everything":
                    presentationxml = System.IO.File.ReadAllText(AppDomain.CurrentDomain.BaseDirectory + "/Search/PresentationXML/SearchResultsEverythingPresentation.xml");
                    break;
                case "people":
                    presentationxml = System.IO.File.ReadAllText(AppDomain.CurrentDomain.BaseDirectory + "/Search/PresentationXML/SearchResultsPersonPresentation.xml");
                    break;
                case "whyeverything":
                case "whypeople":
                    presentationxml = System.IO.File.ReadAllText(AppDomain.CurrentDomain.BaseDirectory + "/Search/PresentationXML/SearchResultsConnectionPresentation.xml");
                    break;

            }


            this.PresentationXML = new XmlDocument();
            this.PresentationXML.LoadXml(presentationxml);
            Framework.Utilities.DebugLogging.Log(presentationxml);

        }

        private void LoadAssets()
        {
            HtmlLink Searchcss = new HtmlLink();
            Searchcss.Href = Root.Domain + "/Search/CSS/search.css";
            Searchcss.Attributes["rel"] = "stylesheet";
            Searchcss.Attributes["type"] = "text/css";
            Searchcss.Attributes["media"] = "all";
            Page.Header.Controls.Add(Searchcss);


            HtmlLink Checkboxcss = new HtmlLink();
            Checkboxcss.Href = Root.Domain + "/Search/CSS/comboTreeCheck.css";
            Checkboxcss.Attributes["rel"] = "stylesheet";
            Checkboxcss.Attributes["type"] = "text/css";
            Checkboxcss.Attributes["media"] = "all";
            Page.Header.Controls.Add(Searchcss);

            HtmlGenericControl jsscript = new HtmlGenericControl("script");
            jsscript.Attributes.Add("type", "text/javascript");
            jsscript.Attributes.Add("src", Root.Domain + "/Search/JavaScript/comboTreeCheck.js");
            Page.Header.Controls.Add(jsscript);

			// Inject script into HEADER
			Literal script = new Literal();
			script.Text = "<script>var _path = \"" + Root.Domain + "\";</script>";
			Page.Header.Controls.Add(script);

            //Response.Write("<script>var _path = \"" + Root.Domain + "\";</script>");


        }
        //Need to process this at the page level for the framework data
        //to process the presentation XML
        public void LoadRDFSearchResults()
        {

            XmlDocument xml = new XmlDocument();
            Namespace rdfnamespaces = new Namespace();
            Utilities.DataIO data = new Utilities.DataIO();

            string searchtype = string.Empty;
            string lname = string.Empty;
            string fname = string.Empty;
            string institution = string.Empty;
            string department = string.Empty;

            string searchfor = string.Empty;
            string classgroupuri = string.Empty;
            string classuri = string.Empty;
            string perpage = string.Empty;
            string offset = string.Empty;
            string sortby = string.Empty;
            string sortdirection = string.Empty;
            string searchrequest = string.Empty;
            string otherfilters = string.Empty;
            string institutionallexcept = string.Empty;
            string departmentallexcept = string.Empty;
            string exactphrase = string.Empty;
            string nodeuri = string.Empty;
            string nodeid = string.Empty;

            string division = string.Empty;
            string divisionallexcept = string.Empty;
						
            if (Request.QueryString["searchtype"].IsNullOrEmpty()==false)
				searchtype = Request.QueryString["searchtype"];
            
			//else if (Request.Form["searchtype"] != null)
			//{
			//    searchtype = Request.Form["searchtype"];
			//}

            if (Request.QueryString["searchfor"].IsNullOrEmpty()==false)
                searchfor = Request.QueryString["searchfor"];

            if (Request.Form["txtSearchFor"].IsNullOrEmpty()==false)
				searchfor = Request.Form["txtSearchFor"];
            
            if (Request.QueryString["lname"].IsNullOrEmpty()==false)
                lname = Request.QueryString["lname"];

            if (Request.QueryString["institution"].IsNullOrEmpty()==false)
                institution = Request.QueryString["institution"];

            if (Request.QueryString["department"].IsNullOrEmpty()==false)
                department = Request.QueryString["department"];

            if (Request.QueryString["fname"].IsNullOrEmpty()==false)
                fname = Request.QueryString["fname"];

            if (Request.QueryString["classgroupuri"].IsNullOrEmpty()==false)
                classgroupuri = HttpUtility.UrlDecode(Request.QueryString["classgroupuri"]);
            else
                classgroupuri = HttpUtility.UrlDecode(Request.Form["classgroupuri"]);

            if (classgroupuri != null)
            {
                if (classgroupuri.Contains("!"))
                    classgroupuri = classgroupuri.Replace('!', '#');
            }

            if (Request.QueryString["classuri"].IsNullOrEmpty()==false)
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
                classuri = "";
            }

            if (Request.QueryString["perpage"].IsNullOrEmpty()==false)
                perpage = Request.QueryString["perpage"];
            else
                perpage = Request.Form["perpage"];

			//if (perpage == string.Empty || perpage == null)
			//{
			//    perpage = Request.QueryString["perpage"];
			//}

            if (perpage.IsNullOrEmpty())
                perpage = "15";

            if (Request.QueryString["offset"].IsNullOrEmpty()==false)
                offset = Request.QueryString["offset"];
            else
                offset = Request.Form["offset"];

            if (offset.IsNullOrEmpty())
                offset = "0";

			//if (offset == null)
			//    offset = "0";

			if (Request.QueryString["sortby"].IsNullOrEmpty() == false)
                sortby = Request.QueryString["sortby"];

			if (Request.QueryString["sortdirection"].IsNullOrEmpty() == false)
                sortdirection = Request.QueryString["sortdirection"];

			if (Request.QueryString["searchrequest"].IsNullOrEmpty() == false)
                searchrequest = Request.QueryString["searchrequest"];

			if (Request.QueryString["otherfilters"].IsNullOrEmpty() == false)
				otherfilters = Request.QueryString["otherfilters"];

			if (Request.QueryString["institutionallexcept"].IsNullOrEmpty() == false)            
                institutionallexcept = Request.QueryString["institutionallexcept"];

			if (Request.QueryString["departmentallexcept"].IsNullOrEmpty() == false)            
                departmentallexcept = Request.QueryString["departmentallexcept"];

			if (Request.QueryString["division"].IsNullOrEmpty() == false)            
                division = Request.QueryString["division"];

			if (Request.QueryString["divisionallexcept"].IsNullOrEmpty() == false)
				divisionallexcept = Request.QueryString["divisionallexcept"];

			if (Request.QueryString["exactphrase"].IsNullOrEmpty() == false)
                exactphrase = Request.QueryString["exactphrase"];

			if (Request.QueryString["nodeuri"].IsNullOrEmpty() == false)
            {
                nodeuri = Request.QueryString["nodeuri"];
                nodeid = nodeuri.Substring(nodeuri.LastIndexOf("/") + 1);
            }
	
            switch (searchtype.ToLower())
            {
                case "everything":

                    if (searchrequest != string.Empty)
                        xml.LoadXml(data.DecryptRequest(searchrequest));
                    else
                        xml = data.SearchRequest(searchfor, classgroupuri, classuri, perpage, offset);

                    break;
                default:                //Person is the default
                    if (searchrequest != string.Empty)
                        xml.LoadXml(data.DecryptRequest(searchrequest));
                    else
                        xml = data.SearchRequest(searchfor, exactphrase, fname, lname, institution, institutionallexcept, department, departmentallexcept, division, divisionallexcept, classuri, perpage, offset, sortby, sortdirection, otherfilters, ref searchrequest);
                    break;
            }


            if (nodeuri != string.Empty && nodeid != string.Empty)
                masterpage.RDFData = data.WhySearch(xml, nodeuri, Convert.ToInt64(nodeid));
            else
                masterpage.RDFData = data.Search(xml,false);

            Framework.Utilities.DebugLogging.Log(masterpage.RDFData.OuterXml);
            masterpage.RDFNamespaces = rdfnamespaces.LoadNamespaces(masterpage.RDFData);

        }

        public XmlDocument PresentationXML { get; set; }
    }
}
