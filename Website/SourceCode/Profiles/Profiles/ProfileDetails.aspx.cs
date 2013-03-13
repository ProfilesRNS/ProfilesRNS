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
            if(Request.QueryString["person"]!= null)
            Response.Redirect(Root.Domain + "/display/person/" + Request.QueryString["person"].ToString());


            Response.End();

        }
    }
}
