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
                // need to convert personid to nodeid!!!.  Doesn't really make sense to use an ORNG DataIO to do this, but since we don't have one in Framework that is what we do
                Int64 nodeId = new Profiles.ORNG.Utilities.DataIO().GetNodeId(Convert.ToInt32(Request.QueryString["person"].ToString()));
                // send them to the new location wiht a 301, this is better for SEO than a standard Response.SendRedirect call
                Response.Status = "301 Moved Permanently";
                Response.AddHeader("Location", Root.Domain + "/display/" + nodeId);
                Response.End();
            }
        }
    }
}
