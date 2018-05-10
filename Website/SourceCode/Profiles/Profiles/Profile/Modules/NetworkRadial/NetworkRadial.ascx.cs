using System;
using System.Collections.Generic;
using System.Web.UI;
using System.Xml;
using System.Web.UI.HtmlControls;


using Profiles.Framework.Utilities;

namespace Profiles.Profile.Modules.NetworkRadial
{
    public partial class NetworkRadial : BaseModule
    {
        public NetworkRadial() { }

        public NetworkRadial(XmlDocument data, List<ModuleParams> moduleparams, XmlNamespaceManager namespaces)
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

            System.Web.UI.HtmlControls.HtmlLink vizcss = new System.Web.UI.HtmlControls.HtmlLink();
            vizcss.Href = Root.Domain + "/Profile/CSS/viz.css";
            vizcss.Attributes["rel"] = "stylesheet";
            vizcss.Attributes["type"] = "text/css";
            vizcss.Attributes["media"] = "all";
            Page.Header.Controls.Add(vizcss);

            HtmlGenericControl jsscript0 = new HtmlGenericControl("script");
            jsscript0.Attributes.Add("type", "text/javascript");
            jsscript0.Attributes.Add("src", Root.Domain + "/Profile/Modules/NetworkRadial/JavaScript/watchdog.js");
            Page.Header.Controls.Add(jsscript0);

            HtmlGenericControl jsscript1 = new HtmlGenericControl("script");
            jsscript1.Attributes.Add("type", "text/javascript");
            jsscript1.Attributes.Add("src", Root.Domain + "/Profile/Modules/NetworkRadial/scriptaculous/lib/prototype.js");
            Page.Header.Controls.Add(jsscript1);

            HtmlGenericControl jsscript2 = new HtmlGenericControl("script");
            jsscript2.Attributes.Add("type", "text/javascript");
            jsscript2.Attributes.Add("src", Root.Domain + "/Profile/Modules/NetworkRadial/scriptaculous/src/scriptaculous.js");
            Page.Header.Controls.Add(jsscript2);

            HtmlGenericControl jsscript3 = new HtmlGenericControl("script");
            jsscript3.Attributes.Add("type", "text/javascript");
            jsscript3.Attributes.Add("src", Root.Domain + "/Profile/Modules/NetworkRadial/JavaScript/layout_balanced.js");
            Page.Header.Controls.Add(jsscript3);

            HtmlGenericControl jsscript4 = new HtmlGenericControl("script");
            jsscript4.Attributes.Add("type", "text/javascript");
            jsscript4.Attributes.Add("src", Root.Domain + "/Profile/Modules/NetworkRadial/JavaScript/sliders.js");
            Page.Header.Controls.Add(jsscript4);

            HtmlGenericControl jsscript5 = new HtmlGenericControl("script");
            jsscript5.Attributes.Add("type", "text/javascript");
            jsscript5.Attributes.Add("src", Root.Domain + "/Profile/Modules/NetworkRadial/JavaScript/viz.js");
            Page.Header.Controls.Add(jsscript5);

            HtmlGenericControl jsscript6 = new HtmlGenericControl("script");
            jsscript6.Attributes.Add("type", "text/javascript");
            jsscript6.Attributes.Add("src", "//cdnjs.cloudflare.com/ajax/libs/d3/3.4.13/d3.min.js");
            Page.Header.Controls.Add(jsscript6);

            Profiles.Profile.Utilities.DataIO data = new Profiles.Profile.Utilities.DataIO();
            int personID = data.GetPersonId(Int64.Parse(Request.QueryString["Subject"].ToString()));
            HtmlGenericControl script = new HtmlGenericControl("script");
            script.Attributes.Add("type", "text/javascript");
            script.InnerHtml = "jQuery(document).ready(function() {try{" +
                " radial_viz = new RadialGraph_Visualization(jQuery('#radial_view')[0], {radius: 100});" +
                //" radial_viz.loadNetwork('" + Root.Domain + "/profile/modules/NetworkRadial/NetworkRadialSvc.aspx?p=" + Request.QueryString["Subject"].ToString() + "', '" + Request.QueryString["Subject"].ToString() + "'); " +
                " radial_viz.loadNetwork('" + Root.Domain + "/profile/modules/NetworkRadial/NetworkRadialSvc.aspx?p=" + Request.QueryString["Subject"].ToString() + "', '" + personID + "'); " +
                "} catch(e){}});";
            Page.Header.Controls.Add(script);

            //Profiles.Profile.Utilities.DataIO data = new Profiles.Profile.Utilities.DataIO();

            RDFTriple request = new RDFTriple(Convert.ToInt64(Request.QueryString["subject"]));
            XmlDocument x = data.GetProfileNetworkForBrowserXML(request);
            System.Xml.Xsl.XsltArgumentList args = new System.Xml.Xsl.XsltArgumentList();
            args.AddParam("root", "", Root.Domain);

            System.Xml.Xsl.XslCompiledTransform xslt = new System.Xml.Xsl.XslCompiledTransform();

            lblProfileName.Text = x.SelectSingleNode("LocalNetwork/NetworkPeople/NetworkPerson[@d='0']").Attributes["fn"].Value + " " +
                x.SelectSingleNode("LocalNetwork/NetworkPeople/NetworkPerson[@d='0']").Attributes["ln"].Value;

            litNetworkText.Text = Profiles.Framework.Utilities.XslHelper.TransformInMemory(Server.MapPath("~/profile/XSLT/NetworkTable.xslt"), args, x.InnerXml);

            iFrameFlashGraph.Attributes.Add("data-src", Root.Domain + "/profile/Modules/NetworkRadialFlash/Default.aspx?Subject=" + Request.QueryString["subject"] + "&Predicate=" + Request.QueryString["Predicate"]);

        }
    }
}