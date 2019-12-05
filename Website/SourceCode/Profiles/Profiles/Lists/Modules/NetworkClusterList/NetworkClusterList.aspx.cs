using System;
using System.Web.UI.HtmlControls;

using Profiles.Framework.Utilities;

namespace Profiles.Lists.Modules.NetworkClusterList
{
    public partial class NetworkClusterList : System.Web.UI.Page
    {
       
        protected void Page_PreRender(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(Request.QueryString["listid"]))
                InitAssets(Request.QueryString["listid"].ToString());
        }
        protected void InitAssets(string listid)
        {
            System.Web.UI.HtmlControls.HtmlLink NetworkBrowsercss = new System.Web.UI.HtmlControls.HtmlLink();
            NetworkBrowsercss.Href = Root.Domain + "/profile/CSS/NetworkBrowser.css";
            NetworkBrowsercss.Attributes["rel"] = "stylesheet";
            NetworkBrowsercss.Attributes["type"] = "text/css";
            NetworkBrowsercss.Attributes["media"] = "all";            
            Head1.Controls.Add(NetworkBrowsercss);

            HtmlGenericControl jsscript0 = new HtmlGenericControl("script");
            jsscript0.Attributes.Add("type", "text/javascript");
            jsscript0.Attributes.Add("src", Root.Domain + "/profile/Modules/NetworkCluster/JavaScript/watchdog.js");
            Head1.Controls.Add(jsscript0);

            HtmlGenericControl jsscript1 = new HtmlGenericControl("script");
            jsscript1.Attributes.Add("type", "text/javascript");
			jsscript1.Attributes.Add("src", Root.Domain + "/profile/Modules/NetworkCluster/scriptaculous/lib/prototype.js");
            Head1.Controls.Add(jsscript1);

            HtmlGenericControl jsscript2 = new HtmlGenericControl("script");
            jsscript2.Attributes.Add("type", "text/javascript");
			jsscript2.Attributes.Add("src", Root.Domain + "/profile/Modules/NetworkCluster/scriptaculous/src/scriptaculous.js");
            Head1.Controls.Add(jsscript2);

            HtmlGenericControl jsscript3 = new HtmlGenericControl("script");
            jsscript3.Attributes.Add("type", "text/javascript");
            jsscript3.Attributes.Add("src", Root.Domain + "/lists/Modules/NetworkClusterList/JavaScript/networkBrowserClass.js");
            Head1.Controls.Add(jsscript3);

            HtmlGenericControl jsscript4 = new HtmlGenericControl("script");
            jsscript4.Attributes.Add("type", "text/javascript");
            jsscript4.Attributes.Add("src", Root.Domain + "/lists/Modules/NetworkClusterList/JavaScript/networkClusterLayoutEngine.js");
            Head1.Controls.Add(jsscript4);

            HtmlGenericControl jsscript5 = new HtmlGenericControl("script");
            jsscript5.Attributes.Add("type", "text/javascript");
            jsscript5.Attributes.Add("src", "//cdnjs.cloudflare.com/ajax/libs/d3/3.4.13/d3.min.js");
            Head1.Controls.Add(jsscript5);
            
            HtmlGenericControl script = new HtmlGenericControl("script");
            script.Attributes.Add("type", "text/javascript");
            script.InnerHtml = "function loadClusterView() {" +
                " network_browser.Init('" + Root.Domain + "/lists/modules/NetworkClusterList/NetworkClusterListSvc.aspx?p='); " +
                " network_browser.loadNetwork('" + listid + "'); " +
                 "};";
            Head1.Controls.Add(script);
            
        }
    }
}