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
                // send them to the new location wiht a 301, this is better for SEO than a standard Response.SendRedirect call
                Response.Status = "301 Moved Permanently";
                Response.AddHeader("Location", Root.Domain + "/" + UCSFIDSet.ByPersonId[Convert.ToInt64(Request.QueryString["person"])].PrettyURL);
                Response.End();
            }
        }
    }
}
