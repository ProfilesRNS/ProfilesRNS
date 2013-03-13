using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;

using Profiles.Framework.Utilities;

namespace Profiles.About.Modules.About
{
    public partial class About : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {


        }

        public About() { }
        public About(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
        {
            DrawProfilesModule();
        }

        public void DrawProfilesModule()
        {

            string tabs = string.Empty;
            string tab = string.Empty;

            if (Request.QueryString["tab"] != null)
            {
                tab = Request.QueryString["tab"].ToString().ToLower();
            }
            else
            {
                tab = "overview";
            }

            tabs = Tabs.DrawTabsStart();


            switch (tab)
            {
                case "overview":
                    
                    tabs += Tabs.DrawActiveTab("Overview");
                    tabs += Tabs.DrawDisabledTab("Frequently Asked Questions", Root.Domain + "/about/default.aspx?tab=faq");
                    tabs += Tabs.DrawDisabledTab("Sharing Data", Root.Domain + "/about/default.aspx?tab=data");
                    

                    pnlOverview.Visible = true;

                    break;

                case "faq":
                    tabs += Tabs.DrawDisabledTab("Overview", Root.Domain + "/about/default.aspx?tab=overview");
                    tabs += Tabs.DrawActiveTab("Frequently Asked Questions");
                    tabs += Tabs.DrawDisabledTab("Sharing Data", Root.Domain + "/about/default.aspx?tab=data");
                    
                    pnlFAQ.Visible = true;
                    break;


                case "data":
                    tabs += Tabs.DrawDisabledTab("Overview", Root.Domain + "/about/default.aspx?tab=overview");
                    tabs += Tabs.DrawDisabledTab("Frequently Asked Questions", Root.Domain + "/about/default.aspx?tab=faq");
                    tabs += Tabs.DrawActiveTab("Sharing Data");

                    pnlData.Visible = true;
                    break;



            }

            tabs += Tabs.DrawTabsEnd();
            litTabs.Text = tabs;


            imgProfilesIcon.ImageUrl = Root.Domain + "/framework/images/icon_profile.gif";
            imgNetworkIcon.ImageUrl = Root.Domain + "/framework/images/icon_network.gif";
            imgConnectionIcon.ImageUrl = Root.Domain + "/framework/images/icon_connection.gif";
            imgVis.ImageUrl = Root.Domain + "/framework/images/about_visualizations.jpg";

        }
    }
}