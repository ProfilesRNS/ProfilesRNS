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
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Data.Common;
using System.Globalization;
using System.Text;
using System.Xml;
using System.Xml.Xsl;

using Profiles.Framework.Utilities;
using Profiles.Search.Utilities;


namespace Profiles.Search.Modules.SearchEverythingFacets
{
    public partial class SearchEverythingFacets : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {


            DrawProfilesModule();
        }

        public SearchEverythingFacets() : base() { }
        public SearchEverythingFacets(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
        {
            this.SearchResults = pagedata;
            this.Namespaces = pagenamespaces;
        }
        private void DrawProfilesModule()
        {
            XsltArgumentList args = new XsltArgumentList();

            string searchfor = string.Empty;
            string classgroupuri = string.Empty;
            string classuri = string.Empty;
            string searchrequest = string.Empty;

            XmlDocument xmlsearchrequest;

            if (Request.QueryString["searchfor"] != null)
                searchfor = Request.QueryString["searchfor"];
            else
                searchfor = Request.Form["txtSearchFor"];

                     



            if (Request.QueryString["classgroupuri"] != null)
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

            if (Request.QueryString["classuri"] != null)
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


            Search.Utilities.DataIO data = new Profiles.Search.Utilities.DataIO();


            if (Request.QueryString["searchrequest"] != null)
            {
                searchrequest = Request.QueryString["searchrequest"];

                if (searchfor == null)
                {
                    xmlsearchrequest = new XmlDocument();

                    xmlsearchrequest.LoadXml(data.DecryptRequest(searchrequest));

                    searchfor = xmlsearchrequest.SelectSingleNode("SearchOptions/MatchOptions/SearchString").InnerText;


                }
            }

            //Grab the full results so I can get the counts, this comes from the cache cloud.
            this.SearchResults = data.Search(data.SearchRequest(searchfor, "", "", "0", "100"),false);



            Int64 total = 0;

            foreach (XmlNode x in this.SearchResults.SelectNodes("rdf:RDF/rdf:Description/vivo:overview/prns:matchesClassGroupsList/prns:matchesClassGroup", this.Namespaces))
            {

                total += Convert.ToInt64(x.SelectSingleNode("prns:numberOfConnections", this.Namespaces).InnerText);
            }

            args.AddParam("total", "", total);
            args.AddParam("searchfor", "", searchfor);
            args.AddParam("root", "", Root.Domain);
            args.AddParam("classGrpURIpassedin", "", classgroupuri);
            args.AddParam("classURIpassedin", "", classuri);



            XslCompiledTransform xslt = new XslCompiledTransform();
            litEverythingPassiveResults.Text = XslHelper.TransformInMemory(Server.MapPath("~/Search/Modules/SearchEverythingFacets/SearchEverythingFacets.xslt"), args, this.SearchResults.OuterXml);









        }
        private XmlNamespaceManager Namespaces { get; set; }
        private XmlDocument SearchResults { get; set; }



    }
}