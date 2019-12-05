using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using Profiles.Framework.Utilities;

namespace Profiles.Lists.Modules.Lists
{
    public partial class SearchResultsList : BaseModule
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            DrawProfilesModule();
        }
        public SearchResultsList() { }
        public SearchResultsList(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
        {

        }

        private void DrawProfilesModule()
        {
                  
              
            hlCreateList.NavigateUrl = String.Format("{0}/lists/default.aspx?type=search", Root.Domain);



        }



    }
}