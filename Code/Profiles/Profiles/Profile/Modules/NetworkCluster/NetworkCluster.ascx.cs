using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.Common;
using System.Globalization;
using System.Text;
using System.Xml;
using System.Web.UI.HtmlControls;


using Profiles.Framework.Utilities;
using Profiles.Profile.Utilities;

namespace Profiles.Profile.Modules.NetworkCluster
{
    public partial class NetworkCluster : BaseModule
    {
        public NetworkCluster() { }

		public NetworkCluster(XmlDocument data, List<ModuleParams> moduleparams, XmlNamespaceManager namespaces)
            : base(data, moduleparams, namespaces)
        {


        }
        protected void Page_PreRender(object sender, EventArgs e)
        {
            if (Request.QueryString["Subject"] != null)
                InitAssets();
                
            lblProfileName.Text = 
				this.BaseData.SelectSingleNode("//rdf:RDF/rdf:Description[@rdf:about= ../rdf:Description[1]/rdf:subject/@rdf:resource]/foaf:firstName", this.Namespaces).InnerText + " " +
				this.BaseData.SelectSingleNode("//rdf:RDF/rdf:Description[@rdf:about= /rdf:RDF[1]/rdf:Description[1]/rdf:subject/@rdf:resource]/foaf:lastName", this.Namespaces).InnerText;
        }
        protected void InitAssets()
        {
            System.Web.UI.HtmlControls.HtmlLink NetworkBrowsercss = new System.Web.UI.HtmlControls.HtmlLink();
            NetworkBrowsercss.Href = Root.Domain + "/Profile/CSS/NetworkBrowser.css";
            NetworkBrowsercss.Attributes["rel"] = "stylesheet";
            NetworkBrowsercss.Attributes["type"] = "text/css";
            NetworkBrowsercss.Attributes["media"] = "all";
            Page.Header.Controls.Add(NetworkBrowsercss);

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
            jsscript3.Attributes.Add("src", Root.Domain + "/Profile/Modules/NetworkCluster/javascript/networkBrowserClass.js");
            Page.Header.Controls.Add(jsscript3);

            divSwfScript.InnerHtml = "<script language=\"JavaScript\" type=\"text/javascript\"> " +
               "AC_FL_RunContent(" +
               "'codebase', '//download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=10,0,0,0'," +
               "'width', '600'," +
               "'height', '485'," +
			   "'src', '" + Root.Domain + "/profile/Modules/NetworkCluster/network_browser_force.swf'," +
			   "'movie', '" + Root.Domain + "/profile/Modules/NetworkCluster/network_browser_force'," +
               "'quality', 'high'," +
               "'pluginspage', '//www.adobe.com/go/getflashplayer'," +
               "'align', 'middle'," +
               "'play', 'true'," +
               "'loop', 'true'," +
               "'scale', 'showall'," +
               "'wmode', 'transparent'," +
               "'devicefont', 'false'," +
               "'id', 'network_browserFLASH'," +
               "'bgcolor', '#ffffff'," +
               "'name', 'network_browserFLASH'," +
               "'menu', 'true'," +
               "'allowFullScreen', 'false'," +
               "'allowScriptAccess', 'always'," +
               "'salign', ''" +
               "); //end AC code" +
           "</script>";

            HtmlGenericControl script = new HtmlGenericControl("script");
            script.Attributes.Add("type", "text/javascript");
            script.InnerHtml = "function loadClusterView() {" +
				" network_browser._cfg.profile_network_path = '/" + Request.QueryString["Predicate"].ToString() + "/cluster'; " +
                " network_browser.Init('" + Root.Domain + "/profile/modules/NetworkCluster/NetworkClusterSvc.aspx?p='); " +
                " network_browser.loadNetwork('" + Request.QueryString["Subject"].ToString() + "'); " +
                "};" +
                "//function GoPerson(x) {document.location='"+ Root.Domain +"/profiles/profile/person/'+x;}";
            Page.Header.Controls.Add(script);

        }

    }
}