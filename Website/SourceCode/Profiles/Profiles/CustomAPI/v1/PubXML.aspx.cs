using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.Common;
using Connects.Profiles.Common;
using Connects.Profiles.Service.DataContracts;
using Connects.Profiles.Utility;

public partial class PubXML : System.Web.UI.Page
{

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {            
            string PMID = Request["PMID"];

            if (PMID != null && PMID.Length > 0)
            {
                Response.ContentType = "text/xml";
                Response.Write(new Profiles.CustomAPI.Utilities.DataIO().ProcessPMID(PMID));
            }
        }
        catch (Exception ex)
        {
            Response.Write("ERROR" + Environment.NewLine + ex.Message + Environment.NewLine);
        }
    }
}
