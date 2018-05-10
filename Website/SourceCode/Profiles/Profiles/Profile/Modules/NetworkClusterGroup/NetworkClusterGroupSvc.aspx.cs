using System;
using Profiles.Framework.Utilities;

namespace Profiles.Profile.Modules.NetworkClusterGroup
{
    public partial class NetworkClusterGroupSvc : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {            
            Profiles.Profile.Utilities.DataIO data = new Profiles.Profile.Utilities.DataIO();

            Profiles.Framework.Utilities.RDFTriple request = new RDFTriple(Convert.ToInt32(Request.QueryString["p"]));
            Response.ContentType = "application/json; charset=utf-8";
            Response.AppendHeader("Access-Control-Allow-Origin", "*");
            Response.Write(data.GetGroupNetworkForBrowser(request));   
        }
    }
}
