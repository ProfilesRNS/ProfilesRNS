using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DevelopmentBase.Helpers
{
    public abstract class PageMonitorBase : System.Web.UI.Page
    {
        protected abstract bool CheckIsUp();
        protected abstract string FailureMessage { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (CheckIsUp())
            {
                System.Web.HttpContext.Current.Response.Write("POLLINGSUCCESS");
            }
            else
            {
                System.Web.HttpContext.Current.Response.Write("POLLINGFAILURE" + " : " + FailureMessage);
            }
        }
    }
}
