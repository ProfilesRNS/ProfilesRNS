using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;

using Profiles.Framework.Utilities;

namespace Profiles.ProfileDetailsError.Modules.ProfileDetailsError
{
    public partial class ProfileDetailsError : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {


        }

        public ProfileDetailsError() { }
        public ProfileDetailsError(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
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


        }
    }
}