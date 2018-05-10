using System;
using System.Collections.Generic;
using System.Web.UI;
using System.Xml;
using System.Web.UI.HtmlControls;


using Profiles.Framework.Utilities;

namespace Profiles.Profile.Modules.NetworkClusterGroup
{
    public partial class NetworkClusterGroup : BaseModule
    {
        public NetworkClusterGroup() { }

		public NetworkClusterGroup(XmlDocument data, List<ModuleParams> moduleparams, XmlNamespaceManager namespaces)
            : base(data, moduleparams, namespaces)
        {


        }
        protected void Page_PreRender(object sender, EventArgs e)
        {
            if (Request.QueryString["Subject"] != null)
                InitAssets();
        }
        protected void InitAssets()
        {
            System.Web.UI.HtmlControls.HtmlLink NetworkBrowsercss = new System.Web.UI.HtmlControls.HtmlLink();
            NetworkBrowsercss.Href = Root.Domain + "/Profile/CSS/NetworkBrowser.css";
            NetworkBrowsercss.Attributes["rel"] = "stylesheet";
            NetworkBrowsercss.Attributes["type"] = "text/css";
            NetworkBrowsercss.Attributes["media"] = "all";
            Page.Header.Controls.Add(NetworkBrowsercss);

            HtmlGenericControl jsscript0 = new HtmlGenericControl("script");
            jsscript0.Attributes.Add("type", "text/javascript");
            jsscript0.Attributes.Add("src", Root.Domain + "/Profile/Modules/NetworkRadial/JavaScript/watchdog.js");
            Page.Header.Controls.Add(jsscript0);

            HtmlGenericControl jsscript1 = new HtmlGenericControl("script");
            jsscript1.Attributes.Add("type", "text/javascript");
			jsscript1.Attributes.Add("src", Root.Domain + "/Profile/Modules/NetworkCluster/scriptaculous/lib/prototype.js");
            Page.Header.Controls.Add(jsscript1);

            HtmlGenericControl jsscript2 = new HtmlGenericControl("script");
            jsscript2.Attributes.Add("type", "text/javascript");
			jsscript2.Attributes.Add("src", Root.Domain + "/Profile/Modules/NetworkCluster/scriptaculous/src/scriptaculous.js");
            Page.Header.Controls.Add(jsscript2);

            HtmlGenericControl jsscript3 = new HtmlGenericControl("script");
            jsscript3.Attributes.Add("type", "text/javascript");
            jsscript3.Attributes.Add("src", Root.Domain + "/Profile/Modules/NetworkClusterGroup/JavaScript/networkBrowserClass.js");
            Page.Header.Controls.Add(jsscript3);

            HtmlGenericControl jsscript4 = new HtmlGenericControl("script");
            jsscript4.Attributes.Add("type", "text/javascript");
            jsscript4.Attributes.Add("src", Root.Domain + "/Profile/Modules/NetworkClusterGroup/JavaScript/networkClusterLayoutEngine.js");
            Page.Header.Controls.Add(jsscript4);

            HtmlGenericControl jsscript5 = new HtmlGenericControl("script");
            jsscript5.Attributes.Add("type", "text/javascript");
            jsscript5.Attributes.Add("src", "//cdnjs.cloudflare.com/ajax/libs/d3/3.4.13/d3.min.js");
            Page.Header.Controls.Add(jsscript5);


            HtmlGenericControl script = new HtmlGenericControl("script");
            script.Attributes.Add("type", "text/javascript");
            script.InnerHtml = "function loadClusterView() {" +
                " network_browser.Init('" + Root.Domain + "/profile/modules/NetworkClusterGroup/NetworkClusterGroupSvc.aspx?p='); " +
                " network_browser.loadNetwork('" + Request.QueryString["Subject"].ToString() + "'); " +
                "};";
            Page.Header.Controls.Add(script);


            Profiles.Profile.Utilities.DataIO data = new Profiles.Profile.Utilities.DataIO();
            RDFTriple request = new RDFTriple(Convert.ToInt64(Request.QueryString["subject"]));
            XmlDocument x = data.GetGroupNetworkForBrowserXML(request);
            System.Xml.Xsl.XsltArgumentList args = new System.Xml.Xsl.XsltArgumentList();
            args.AddParam("root", "", Root.Domain);
            DateTime d = DateTime.Now;
            System.Xml.Xsl.XslCompiledTransform xslt = new System.Xml.Xsl.XslCompiledTransform();
            litNetworkText.Text = Profiles.Framework.Utilities.XslHelper.TransformInMemory(Server.MapPath("~/profile/XSLT/NetworkTableGroup.xslt"), args, x.InnerXml);


        }
    }
}