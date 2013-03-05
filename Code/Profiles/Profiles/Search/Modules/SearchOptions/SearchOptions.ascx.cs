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


using Profiles.Framework.Utilities;
using Profiles.Search.Utilities;

namespace Profiles.Search.Modules.SearchOptions
{
    public partial class SearchOptions : BaseModule
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            BuildLinks();
        }

        public SearchOptions() { }
        public SearchOptions(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
            : base(pagedata, moduleparams, pagenamespaces)
        {
            this.SearchData = pagedata;
        }
        private void BuildLinks()
        {
            string tab = string.Empty;
            string searchfor = string.Empty;
            string searchrequest = string.Empty;

            tab = Request.QueryString["tab"];

            if (Request.QueryString["searchtype"] == "everything")
            {
                tab = "all";
            }

            litModifySearch.Text = "<a href=\"javascript:modify('" + Root.Domain + "','" + tab + "','" + base.MasterPage.SearchRequest + "');\">" + "Modify Search" + "</a>";

            if (Request.QueryString["searchfor"].IsNullOrEmpty())
                searchfor = Request.Form["txtSearchFor"];
            else
                searchfor = Request.QueryString["searchfor"];

            if (searchfor.IsNullOrEmpty())
            {
                Utilities.DataIO data = new Profiles.Search.Utilities.DataIO();

                XmlDocument xmlsearchrequest = new XmlDocument();
                searchrequest = data.DecryptRequest(base.MasterPage.SearchRequest);
                xmlsearchrequest.LoadXml(searchrequest);

                if (xmlsearchrequest.SelectSingleNode("SearchOptions/MatchOptions/SearchString") != null)
                    searchfor = xmlsearchrequest.SelectSingleNode("SearchOptions/MatchOptions/SearchString").InnerText;
            }

            litSearchOtherInstitutions.Text = "<a href='" + Root.Domain + "/direct/default.aspx?keyword=" + searchfor + "&searchrequest=" + base.MasterPage.SearchRequest + "&searchtype=" + Request.QueryString["searchtype"] + "'>" + "Search Other Institutions" + "</a>";
        }

        private XmlDocument SearchData { get; set; }

    }
}