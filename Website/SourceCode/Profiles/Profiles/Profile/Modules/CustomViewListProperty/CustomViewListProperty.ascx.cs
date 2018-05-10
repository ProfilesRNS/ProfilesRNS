using System;
using System.Collections.Generic;
using System.Xml;

using Profiles.Framework.Utilities;

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