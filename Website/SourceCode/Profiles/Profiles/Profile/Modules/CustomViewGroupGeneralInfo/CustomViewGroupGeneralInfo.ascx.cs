using System;
using System.Collections.Generic;
using System.Xml;

using Profiles.Framework.Utilities;

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
                imgPhoto.ImageUrl = imageurl + "&cachekey=" + Guid.NewGuid().ToString() + "&width=500";
                imgPhoto.Attributes.Add("style", "margin-top:25px");
            }
            else
            {
                imgPhoto.Visible = false;
            }
        }

    }
}