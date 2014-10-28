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

namespace Profiles.Profile.Modules.CustomViewPersonGeneralInfo
{
    public partial class CustomViewPersonGeneralInfo : BaseModule
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            DrawProfilesModule();
        }

        public CustomViewPersonGeneralInfo() : base() { }
        public CustomViewPersonGeneralInfo(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
            : base(pagedata, moduleparams, pagenamespaces)
        {
            base.RDFTriple = new RDFTriple(Convert.ToInt64(Request.QueryString["Subject"]));

        }
        private void DrawProfilesModule()
        {

            XsltArgumentList args = new XsltArgumentList();
            XslCompiledTransform xslt = new XslCompiledTransform();
            SessionManagement sm = new SessionManagement();

            Utilities.DataIO data = new Profiles.Profile.Utilities.DataIO();
            string email = string.Empty;
            //string imageemailurl = string.Empty;
            string emailPlainText = string.Empty;
            if (this.BaseData.SelectSingleNode("rdf:RDF[1]/rdf:Description[1]/prns:emailEncrypted", this.Namespaces) != null &&
                this.BaseData.SelectSingleNode("rdf:RDF[1]/rdf:Description[1]/vivo:email", this.Namespaces) == null)
            {
                email = this.BaseData.SelectSingleNode("rdf:RDF[1]/rdf:Description[1]/prns:emailEncrypted", this.Namespaces).InnerText;
                //imageemailurl = string.Format(Root.Domain + "/profile/modules/CustomViewPersonGeneralInfo/" + "EmailHandler.ashx?msg={0}", HttpUtility.UrlEncode(email));
                emailPlainText = getEmailPlainText(email);
            }
            
            args.AddParam("root", "", Root.Domain);
            if (email != string.Empty)
            {
                //args.AddParam("email", "", imageemailurl);
                args.AddParam("email", "", emailPlainText);
            }
            args.AddParam("imgguid", "", Guid.NewGuid().ToString());

            litPersonalInfo.Text = XslHelper.TransformInMemory(Server.MapPath("~/Profile/Modules/CustomViewPersonGeneralInfo/CustomViewPersonGeneralInfo.xslt"), args, base.BaseData.OuterXml);

            if (base.BaseData.SelectSingleNode("rdf:RDF/rdf:Description[1]/prns:mainImage/@rdf:resource", base.Namespaces) != null)
            {
                string imageurl = base.BaseData.SelectSingleNode("//rdf:RDF/rdf:Description[1]/prns:mainImage/@rdf:resource", base.Namespaces).Value;
                imgPhoto.ImageUrl = imageurl + "&cachekey=" + Guid.NewGuid().ToString();
            }
            else
            {
                imgPhoto.Visible = false;
            }

            // OpenSocial.  Allows gadget developers to show test gadgets if you have them installed
            string uri = this.BaseData.SelectSingleNode("rdf:RDF/rdf:Description/@rdf:about", base.Namespaces).Value;
            OpenSocialManager om = OpenSocialManager.GetOpenSocialManager(uri, Page);
            if (om.IsVisible()) 
            {
                litGadget.Visible = true;
                string sandboxDivs = "";
                foreach (PreparedGadget gadget in om.GetSandboxGadgets())
                {
                    sandboxDivs += "<div id='" + gadget.GetChromeId() + "' class='gadgets-gadget-parent'></div>";
                }
                litGadget.Text = sandboxDivs;
                om.LoadAssets();
                // Add this just in case it is needed.
                new ORNGProfileRPCService(Page, this.BaseData.SelectSingleNode("rdf:RDF/rdf:Description/foaf:firstName", base.Namespaces).InnerText, uri);
            }
        }

        // UCSF
        private string getEmailPlainText(String emailEncrypted)
        {
            Utilities.DataIO data = new Profiles.Profile.Utilities.DataIO();
            SqlDataReader reader;

            SqlCommand cmd = new SqlCommand("SELECT [Utility.Application].[fnDecryptBase64RC4] ( '" + emailEncrypted + "',   (Select [value] from [Framework.].parameter with(nolock) where ParameterID = 'RC4EncryptionKey'))");
            reader = data.GetSQLDataReader(cmd);
            reader.Read();

            string emailPlain = reader[0].ToString();
            reader.Close();
            return emailPlain;
        }

    }

    public class ORNGProfileRPCService : PeopleListRPCService
    {
        string name;
        List<string> people = new List<string>();

        public ORNGProfileRPCService(Page page, string name, string uri)
            : base(null, page, false)
        {
            this.name = name;
            this.people.Add(uri);
        }

        public override string getPeopleListMetadata()
        {
            return name;
        }

        public override List<string> getPeople()
        {
            return people;
        }
    }

}