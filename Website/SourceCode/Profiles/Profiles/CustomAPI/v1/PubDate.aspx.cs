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
using Connects.Profiles.Service.ServiceContracts;
using Profiles.CustomAPI.Utilities;

public partial class PubDate : System.Web.UI.Page
{

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            string PMID = Request["PMID"];
            string MPID = Request["MPID"];
            string PubID = Request["PubID"];

            PublicationDate pd = GetPubDate(PMID, MPID, PubID);
            Response.Write(pd.pubDate + Environment.NewLine);
        }
        catch (Exception ex)
        {
            Response.Write("ERROR" + Environment.NewLine + ex.Message + Environment.NewLine);
        }
    }

    // UCSF
    public PublicationDate GetPubDate(string MPID, string PMID, string PubID)
    {
        DataIO data = new DataIO();
        String pd = "";
        if (PMID != null && PMID.Trim().Length > 0)
        {
            pd = data.ProcessDateSQL("select PubDate from [Profile.Data].[Publication.PubMed.General] where PMID = '" + PMID + "';");
        }
        else if (MPID != null && MPID.Trim().Length > 0)
        {
            pd = data.ProcessDateSQL("select publicationdt from [Profile.Data].[Publication.MyPub.General] where mpid = '" + MPID + "';");
        }
        else if (PubID != null && PubID.Trim().Length > 0)
        {
            pd = data.ProcessDateSQL("select isnull(m.publicationdt, p.PubDate) from [Profile.Data].[Publication.Person.Include] i left outer join [Profile.Data].[Publication.MyPub.General] m on i.mpid = m.mpid left outer join " +
                       "[Profile.Data].[Publication.PubMed.General] p on i.pmid = p.pmid where pubid = '" + PubID + "';");
        }
        return new PublicationDate { pubDate = pd };
    }

    public PublicationDate JSONPubDate(string MPID, string PMID, string PubID)
    {
        return GetPubDate(MPID, PMID, PubID);
    }


}
