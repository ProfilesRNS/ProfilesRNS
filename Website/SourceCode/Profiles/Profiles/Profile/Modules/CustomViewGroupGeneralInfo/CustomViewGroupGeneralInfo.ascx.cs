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
using Profiles.ORNG.Utilities;

namespace Profiles.Profile.Modules.CustomViewGroupGeneralInfo
{
    public partial class CustomViewGroupGeneralInfo : BaseModule
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            DrawProfilesModule();
        }

        public CustomViewGroupGeneralInfo() : base() { }
        public CustomViewGroupGeneralInfo(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
            : base(pagedata, moduleparams, pagenamespaces)
        {
            base.RDFTriple = new RDFTriple(Convert.ToInt64(Request.QueryString["Subject"]));

        }
        private void DrawProfilesModule()
        {
            //litPersonalInfo.Text = "";

            if (base.BaseData.SelectSingleNode("rdf:RDF/rdf:Description[1]/prns:mainImage/@rdf:resource", base.Namespaces) != null)
            {
                string imageurl = base.BaseData.SelectSingleNode("//rdf:RDF/rdf:Description[1]/prns:mainImage/@rdf:resource", base.Namespaces).Value;
                imgPhoto.ImageUrl = imageurl + "&cachekey=" + Guid.NewGuid().ToString();
            }
            else
            {
                imgPhoto.Visible = false;
            }
        }

    }
}