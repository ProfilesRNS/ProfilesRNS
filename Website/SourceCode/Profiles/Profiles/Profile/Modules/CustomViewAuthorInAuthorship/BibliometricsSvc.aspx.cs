using System;
using Profiles.Framework.Utilities;

namespace Profiles.Profile.Modules.CustomViewAuthorInAuthorship
{
    public partial class BibliometricsSvc : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Profiles.Profile.Modules.CustomViewAuthorInAuthorship.DataIO data = new Profiles.Profile.Modules.CustomViewAuthorInAuthorship.DataIO();

            Profiles.Framework.Utilities.RDFTriple request = new RDFTriple(Convert.ToInt32(Request.QueryString["p"]));
            Response.ContentType = "application/json; charset=utf-8";
            Response.AppendHeader("Access-Control-Allow-Origin", "*");
            Response.Write(data.GetJournalHeadingsForProfile(request));              
        }
    }
}
