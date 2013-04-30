using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Routing;
using System.Web.Compilation;
using System.Web.UI;
using System.Web.UI.WebControls;

using Profiles.Framework.Utilities;

namespace Profiles
{
    public partial class RobotsTxt : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Response.Write("Sitemap: " + Root.Domain + "/sitemap.xml" + Environment.NewLine);
            Response.End();
        }
    }

    public class RobotsTxtHandler : IRouteHandler
    {
        public IHttpHandler GetHttpHandler(RequestContext requestContext)
        {
            return BuildManager.CreateInstanceFromVirtualPath("~/RobotsTxt.aspx", typeof(Page)) as IHttpHandler;
        }
    }
}
