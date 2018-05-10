using System;

namespace Profiles
{
    public partial class DirectService : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Server.Transfer("~/DIRECT/Modules/DirectSearch/DirectService.aspx?Request=" + Request.QueryString["Request"] + "&SearchPhrase=" + Request.QueryString["SearchPhrase"]);
            Response.End();


        }
    }
}
