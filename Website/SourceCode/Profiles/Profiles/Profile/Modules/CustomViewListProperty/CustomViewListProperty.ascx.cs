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
using Profiles.Profile.Utilities;

namespace Profiles.Profile.Modules.CustomViewListProperty
{
    public partial class CustomViewListProperty : BaseModule
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            DrawProfilesModule();
        }

        public CustomViewListProperty() : base() { }
        public CustomViewListProperty(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
            : base(pagedata, moduleparams, pagenamespaces)
        {
            base.RDFTriple = new RDFTriple(Convert.ToInt64(Request.QueryString["Subject"]));

        }

        private void DrawProfilesModule()
        {
            string nodes = base.GetModuleParamString("nodes");

            string items = "";
            foreach (XmlNode item in this.BaseData.SelectNodes(nodes, base.Namespaces))
            {
                items += item.InnerText + ", ";
            }
            litListItems.Text = items.Length > 2 ? items.Substring(0, items.Length - 2) : "";
        }
    }
}