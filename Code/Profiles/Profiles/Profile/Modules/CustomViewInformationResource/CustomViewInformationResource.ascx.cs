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

namespace Profiles.Profile.Modules.CustomViewInformationResource
{
    public partial class CustomViewInformationResource : BaseModule
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            DrawProfilesModule();
        }
        public CustomViewInformationResource() : base() { }
        public CustomViewInformationResource(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
            : base(pagedata, moduleparams, pagenamespaces)
        {
            base.RDFTriple = new RDFTriple(Convert.ToInt64(Request.QueryString["Subject"]));

        }
        private void DrawProfilesModule()
        {

            XsltArgumentList args = new XsltArgumentList();
            args.AddParam("root", "", Root.Domain);


            litPublication.Text = XslHelper.TransformInMemory(Server.MapPath("~/Profile/Modules/CustomViewInformationResource/CustomViewInformationResource.xslt"), args, base.BaseData.OuterXml);


        }
    }
}