using System;
using Profiles.Framework.Utilities;
using System.Xml;
using System.Collections.Generic;

namespace Profiles.Profile.Modules.CustomViewSocialMediaPlugins
{
    public partial class Twitter : BaseSocialMediaModule
    {        
        protected void Page_Load(object sender, EventArgs e)
        {            
           
        }
        
        public Twitter() : base() { }
        public Twitter(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
            : base(pagedata, moduleparams, pagenamespaces)
        {
            base.PlugInName = "Twitter";
            litjs.Text = base.SocialMediaInit(base.PlugInName);
        }    

    }
}