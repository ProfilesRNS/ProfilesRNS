using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using Profiles.Framework.Utilities;

namespace Profiles
{
    public partial class BetaRedirect : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["person"] != null)
            {
                // need to convert personid to nodeid
                // send them to the pretty URL
                Response.Status = "301 Moved Permanently";
                Response.AddHeader("Location", Root.Domain + "/" + new Profiles.Framework.Utilities.DataIO().GetPrettyURL(Convert.ToInt64(Request.QueryString["person"])));
            }

            Response.End();
        }
    }
}
