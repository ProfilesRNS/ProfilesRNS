using System;
using Profiles.Framework.Utilities;
using System.Xml;
using System.Collections.Generic;
using System.Web.UI.HtmlControls;

namespace Profiles.Profile.Modules.CustomViewSocialMediaPlugins
{
    public partial class FeaturedVideos : BaseSocialMediaModule
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            

        }
        public FeaturedVideos() : base() {}
        public FeaturedVideos(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
            : base(pagedata, moduleparams, pagenamespaces)
        {   


            LoadAssets();
        }


        private void LoadAssets()
        {

            HtmlGenericControl jsscript1 = new HtmlGenericControl("script");
            jsscript1.Attributes.Add("type", "text/javascript");
            jsscript1.Attributes.Add("src", Root.Domain + "/Profile/Modules/CustomViewSocialMediaPlugins/YouTubeJquery.js");
            Page.Header.Controls.Add(jsscript1);
            this.PlugInName = "FeaturedVideos";
            litjs.Text = base.SocialMediaInit(this.PlugInName);

            HtmlLink Displaycss = new HtmlLink();
            Displaycss.Href = Root.Domain + "/Profile/Modules/CustomViewSocialMediaPlugins/style.css";
            Displaycss.Attributes["rel"] = "stylesheet";
            Displaycss.Attributes["type"] = "text/css";
            Displaycss.Attributes["media"] = "all";
            Page.Header.Controls.Add(Displaycss);




        }

    }
}