using System;
using System.Collections.Generic;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Xml;
using System.Web.UI.HtmlControls;

using Profiles.Framework.Utilities;


namespace Profiles.Profile.Modules.CustomViewAuthorInAuthorship
{
    public partial class CustomViewAuthorInAuthorship : BaseModule
    {
        protected string svcURL { get { return Root.Domain + "/profile/modules/CustomViewAuthorInAuthorship/BibliometricsSvc.aspx?p="; } }

        protected long nodeID { get { return base.RDFTriple.Subject; } }
        protected void Page_Load(object sender, EventArgs e)
        {
            DrawProfilesModule();
        }

        public CustomViewAuthorInAuthorship() : base() { }
        public CustomViewAuthorInAuthorship(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
            : base(pagedata, moduleparams, pagenamespaces)
        {
            base.RDFTriple = new RDFTriple(Convert.ToInt64(Request.QueryString["Subject"]));
        }
        private void DrawProfilesModule()
        {


            DateTime d = DateTime.Now;
            Profiles.Profile.Modules.CustomViewAuthorInAuthorship.DataIO data = new Profiles.Profile.Modules.CustomViewAuthorInAuthorship.DataIO();
            List<Publication> publication = new List<Publication>();

            Utilities.DataIO.ClassType type = Utilities.DataIO.ClassType.Unknown;
            Framework.Utilities.Namespace xmlnamespace = new Profiles.Framework.Utilities.Namespace();
            XmlNamespaceManager namespaces = xmlnamespace.LoadNamespaces(BaseData);
            if (BaseData.SelectSingleNode("rdf:RDF/rdf:Description[1]/rdf:type[@rdf:resource='http://xmlns.com/foaf/0.1/Person']", namespaces) != null)
                type = Utilities.DataIO.ClassType.Person;
            if (BaseData.SelectSingleNode("rdf:RDF/rdf:Description[1]/rdf:type[@rdf:resource='http://xmlns.com/foaf/0.1/Group']", namespaces) != null)
                type = Utilities.DataIO.ClassType.Group;

            using (SqlDataReader reader = data.GetPublications(base.RDFTriple, type))
            {
                while (reader.Read())
                {
                    publication.Add(new Publication(reader["bibo_pmid"].ToString(), reader["vivo_pmcid"].ToString(),
                        reader["prns_informationResourceReference"].ToString(), reader["vivo_webpage"].ToString(), Convert.ToInt32(reader["PMCCitations"]),
                        reader["Fields"].ToString(), Convert.ToInt32(reader["TranslationHumans"]), Convert.ToInt32(reader["TranslationAnimals"]),
                        Convert.ToInt32(reader["TranslationCells"]), Convert.ToInt32(reader["TranslationPublicHealth"]), Convert.ToInt32(reader["TranslationClinicalTrial"])));
                }

                rpPublication.DataSource = publication;
                rpPublication.DataBind();
            }

            // Get timeline bar chart
            string storedproc = "[Profile.Module].[NetworkAuthorshipTimeline.Person.GetData]";
            if (type == Utilities.DataIO.ClassType.Group) storedproc = "[Profile.Module].[NetworkAuthorshipTimeline.Group.GetData]";
            using (SqlDataReader reader = data.GetGoogleTimeline(base.RDFTriple, storedproc))
            {
                while (reader.Read())
                {
                    timelineBar.Src = reader["gc"].ToString();
                    timelineBar.Alt = reader["alt"].ToString();
                    litTimelineTable.Text = reader["asText"].ToString();
                }
                reader.Close();
            }

            if (timelineBar.Src == "")
            {
                timelineBar.Visible = false;
            }


            // Login link
            loginLiteral.Text = String.Format("<a href='{0}'>login</a>", Root.Domain + "/login/default.aspx?pin=send&method=login&edit=true");

            if (type == Utilities.DataIO.ClassType.Group) divPubHeaderText.Visible = false;

            Framework.Utilities.DebugLogging.Log("PUBLICATION MODULE end Milliseconds:" + (DateTime.Now - d).TotalSeconds);
        }

        protected void rpPublication_OnDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                Publication pub = (Publication)e.Item.DataItem;
                Label lblNum = (Label)e.Item.FindControl("lblNum");
                Label lblPublication = (Label)e.Item.FindControl("lblPublication");
                Label lblPublicationIDs = (Label)e.Item.FindControl("lblPublicationIDs");
                Literal litViewIn = (Literal)e.Item.FindControl("litViewIn");
                System.Web.UI.HtmlControls.HtmlGenericControl liPublication = ((System.Web.UI.HtmlControls.HtmlGenericControl)(e.Item.FindControl("liPublication")));

                string lblPubTxt = "";// = pub.prns_informaitonResourceReference;
                if (pub.bibo_pmid != string.Empty && pub.bibo_pmid != null)
                {


                    lblPubTxt = lblPubTxt + " PMID: <a href='//www.ncbi.nlm.nih.gov/pubmed/" + pub.bibo_pmid + "' target='_blank'>" + pub.bibo_pmid + "</a>";
                    liPublication.Attributes["data-pmid"] = pub.bibo_pmid;
                    liPublication.Attributes["data-citations"] = "" + pub.PMCCitations;
                    // liPublication.Attributes["data-Fields"] = pub.Fields;
                    liPublication.Attributes["data-TranslationHumans"] = "" + pub.TranslationHumans;
                    liPublication.Attributes["data-TranslationAnimals"] = "" + pub.TranslationAnimals;
                    liPublication.Attributes["data-TranslationCells"] = "" + pub.TranslationCells;
                    liPublication.Attributes["data-TranslationPublicHealth"] = "" + pub.TranslationPublicHealth;
                    liPublication.Attributes["data-TranslationClinicalTrial"] = "" + pub.TranslationClinicalTrial;
                    //litViewIn.Text = "View in: <a href='//www.ncbi.nlm.nih.gov/pubmed/" + pub.bibo_pmid + "' target='_blank'>PubMed</a>";
                    if (pub.vivo_pmcid != null)
                    {
                        if (pub.vivo_pmcid.Contains("PMC"))
                        {
                            string pmcid = pub.vivo_pmcid;
                            int len = pmcid.IndexOf(' ');
                            if (len != -1) pmcid = pmcid.Substring(0, len);
                            lblPubTxt = lblPubTxt + "; PMCID: <a href='//www.ncbi.nlm.nih.gov/pmc/articles/" + pmcid + "' target='_blank'>" + pmcid + "</a>";
                            //litViewIn.Text = litViewIn.Text + ", <a href='//www.ncbi.nlm.nih.gov/pmc/articles/" + pmcid + "' target='_blank'>PubMed Central</a>";
                        }
                        else if (pub.vivo_pmcid.Contains("NIHMS"))
                        {
                            lblPubTxt = lblPubTxt + "; NIHMSID: " + pub.vivo_pmcid;
                        }
                    }
                    lblPubTxt = lblPubTxt + ".";

                    //if (pub.PMCCitations <= 0) litViewIn.Text = "Citations: <span class=\"PMC-citations\"><span class=\"PMC-citation-count\">0</span></span>";
                    if (pub.PMCCitations <= 0) litViewIn.Text = "<span id='spnHideOnNoAltmetric" + pub.bibo_pmid + "'> Citations: <span class='altmetric-embed' data-link-target='_blank' data-badge-popover='bottom' data-badge-type='4' data-hide-no-mentions='true' data-pmid='" + pub.bibo_pmid + "'></span>&nbsp;&nbsp;&nbsp;</span>";
                    else litViewIn.Text = "Citations: <a href='https://www.ncbi.nlm.nih.gov/pmc/articles/pmid/" + pub.bibo_pmid + "/citedby/' target='_blank' class=\"PMC-citations\"><span class=\"PMC-citation-count\">" + pub.PMCCitations + "</span></a>" +
                       "<span id='spnHideOnNoAltmetric" + pub.bibo_pmid + "'>&nbsp;&nbsp;<span class='altmetric-embed' data-link-target='_blank' data-badge-popover='bottom' data-badge-type='4' data-hide-no-mentions='true' data-pmid='" + pub.bibo_pmid + "'></span></span>&nbsp;&nbsp;&nbsp;";
                    if (!pub.Fields.Equals(""))
                    {
                        litViewIn.Text = litViewIn.Text + "Fields:&nbsp;<div style='display:inline-flex'>";
                        string[] tmparray = pub.Fields.Split('|');
                        for (int i = 0; i < tmparray.Length; i++)
                        {
                            string field = tmparray[i].Split(',')[0];
                            string colour = tmparray[i].Split(',')[1];
                            string displayName = tmparray[i].Split(',')[2];
                            liPublication.Attributes["data-Field" + colour] = "1";
                            litViewIn.Text += "<a class='publication-filter' style='border:1px solid #" + colour + ";' data-color=\"#" + colour + "\" OnClick=\"toggleFilter('data-Field" + colour + "')\">" + field + "<span class='tooltiptext' style='background-color:#" + colour + ";'> " + displayName + "</span></a>";
                        }
                        litViewIn.Text = litViewIn.Text + "</div>&nbsp;&nbsp;&nbsp;";
                    }

                    if (pub.TranslationHumans + pub.TranslationAnimals + pub.TranslationCells + pub.TranslationPublicHealth + pub.TranslationClinicalTrial > 0)
                    {
                        litViewIn.Text = litViewIn.Text + "Translation:";
                        if (pub.TranslationHumans == 1) litViewIn.Text = litViewIn.Text + "<a class='publication-filter publication-humans' data-color='#3333CC' OnClick=\"toggleFilter('data-TranslationHumans')\">Humans</a>";
                        if (pub.TranslationAnimals == 1) litViewIn.Text = litViewIn.Text + "<a class='publication-filter publication-animals' data-color='#33AA33' OnClick=\"toggleFilter('data-TranslationAnimals')\">Animals</a>";
                        if (pub.TranslationCells == 1) litViewIn.Text = litViewIn.Text + "<a class='publication-filter publication-cells' data-color='#BB3333' OnClick=\"toggleFilter('data-TranslationCells')\">Cells</a>";
                        if (pub.TranslationPublicHealth == 1) litViewIn.Text = litViewIn.Text + "<a class='publication-filter publication-public-health' data-color='#609' OnClick=\"toggleFilter('data-TranslationPublicHealth')\">PH<span class='tooltiptext' style='background-color:#609;'>Public Health</span></a>";
                        if (pub.TranslationClinicalTrial == 1) litViewIn.Text = litViewIn.Text + "<a class='publication-filter publication-clinical-trial' data-color='#00C' OnClick=\"toggleFilter('data-TranslationClinicalTrial')\">CT<span class='tooltiptext' style='background-color:#00C;'>Clinical Trials</span></a>";
                    }

                }
                else
                {
                    e.Item.FindControl("divArticleMetrics").Visible = false;
                    
                    if (pub.vivo_webpage != string.Empty && pub.vivo_webpage != null)
                    {
                        lblPubTxt = "<a href='" + pub.vivo_webpage + "' target='_blank'>View Publication</a>.";
                    }

                }
                lblPublication.Text = pub.prns_informaitonResourceReference;
                lblPublicationIDs.Text = lblPubTxt;
            }
        }
        public class Publication
        {
            public Publication(string _bibo_pmid, string _vivo_pmcid, string prns_informationresourcereference, string _vivo_webpage, int PMCCitations,
                string Fields, int TranslationHumans, int TranslationAnimals, int TranslationCells, int TranslationPublicHealth, int TranslationClinicalTrial)
            {
                this.bibo_pmid = _bibo_pmid;
                this.vivo_pmcid = _vivo_pmcid;
                this.prns_informaitonResourceReference = prns_informationresourcereference;
                this.vivo_webpage = _vivo_webpage;
                this.PMCCitations = PMCCitations;
                this.Fields = Fields;
                this.TranslationHumans = TranslationHumans;
                this.TranslationAnimals = TranslationAnimals;
                this.TranslationCells = TranslationCells;
                this.TranslationPublicHealth = TranslationPublicHealth;
                this.TranslationClinicalTrial = TranslationClinicalTrial;
            }

            public string bibo_pmid { get; set; }
            public string vivo_pmcid { get; set; }
            public string prns_informaitonResourceReference { get; set; }
            public string vivo_webpage
            { get; set; }
            public int PMCCitations { get; set; }
            public string Fields { get; set; }
            public int TranslationHumans { get; set; }
            public int TranslationAnimals { get; set; }
            public int TranslationCells { get; set; }
            public int TranslationPublicHealth { get; set; }
            public int TranslationClinicalTrial { get; set; }
        }
    }
}