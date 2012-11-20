using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using Profiles.Profile.Utilities;
using Profiles.Framework.Utilities;

namespace Profiles.Profile.Modules.NetworkRadial
{
    public partial class NetworkRadialSvc : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {            
            Profiles.Profile.Utilities.DataIO data = new Profiles.Profile.Utilities.DataIO();

            Profiles.Framework.Utilities.RDFTriple request = new RDFTriple(Convert.ToInt32(Request.QueryString["p"]));            

            Response.Write(data.GetProfileNetworkForBrowser(request).InnerXml);            
        }
    }
}
