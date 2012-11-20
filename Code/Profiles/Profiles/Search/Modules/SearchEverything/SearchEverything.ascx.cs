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
    public partial class SearchEverything : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }


        
        public SearchEverything() { }
        public SearchEverything(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces) { }



    }
}