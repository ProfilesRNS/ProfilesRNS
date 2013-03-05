using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;

using Profiles.Framework.Utilities;

namespace Profiles.Search.Modules.SearchEverything
{
    public partial class SearchEverything : BaseModule
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            
        }


        
        public SearchEverything() { }
        public SearchEverything(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
            : base(pagedata, moduleparams, pagenamespaces)
        {

            searchfor.Attributes.Add("onkeypress", "JavaScript:runScript(event);");


            if (Request.QueryString["action"] == "modify")
            {
                this.ModifySearch();
            }

        
        }
        private void ModifySearch()
        {

            Search.Utilities.DataIO data = new Profiles.Search.Utilities.DataIO();
            string searchrequest = string.Empty;            

            XmlDocument request = new XmlDocument();

            if (base.MasterPage.SearchRequest != null && Request.QueryString["searchrequest"]==null)
            {                
                searchrequest = base.MasterPage.SearchRequest;
            }
            else if (Request.QueryString["searchrequest"].IsNullOrEmpty() == false)
            {
                searchrequest = Request.QueryString["searchrequest"];
            }

            request.LoadXml(data.DecryptRequest(searchrequest));


            if (request.SelectSingleNode("SearchOptions/MatchOptions/SearchString") != null)
            {
                searchfor.Text = request.SelectSingleNode("SearchOptions/MatchOptions/SearchString").InnerText;
            }


            if (request.SelectSingleNode("SearchOptions/MatchOptions/SearchString/@ExactMatch") != null)
            {
                switch (request.SelectSingleNode("SearchOptions/MatchOptions/SearchString/@ExactMatch").Value.ToLower())
                {
                    case "true":
                        chkExactPhrase.Checked = true;
                        break;
                    case "false":
                        chkExactPhrase.Checked = false;
                        break;
                }
            }

        }
    }
}