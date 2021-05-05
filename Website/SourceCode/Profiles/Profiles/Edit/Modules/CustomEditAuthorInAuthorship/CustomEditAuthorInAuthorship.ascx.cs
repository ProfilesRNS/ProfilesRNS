
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.Net;
using System.Text;
using System.IO;

using Profiles.Framework.Utilities;




namespace Profiles.Edit.Modules.CustomEditAuthorInAuthorship
{
    public partial class CustomEditAuthorInAuthorship : BaseModule
    {

        #region Local Variables
        public int _personId = 0;
        public Int64 _subject = 0;

        public string _predicateuri = string.Empty;
        Profiles.Profile.Utilities.DataIO propdata;
        #endregion


        public CustomEditAuthorInAuthorship() { }
        public CustomEditAuthorInAuthorship(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
            : base(pagedata, moduleparams, pagenamespaces)
        {

            SessionManagement sm = new SessionManagement();
            Utilities.DataIO data = new Profiles.Edit.Utilities.DataIO();
            propdata = new Profiles.Profile.Utilities.DataIO();

            this._subject = Convert.ToInt64(Request.QueryString["subject"]);
            this._predicateuri = Request.QueryString["predicateuri"].Replace("!", "#");
            this._personId = data.GetPersonID(_subject);

            Session["NodeID"] = this._subject;
            Session["SessionID"] = sm.Session().SessionID;

            this.PropertyListXML = propdata.GetPropertyList(pagedata, base.PresentationXML, this._predicateuri, false, true, false);

            securityOptions.Subject = this._subject;
            securityOptions.PredicateURI = this._predicateuri;
            securityOptions.PrivacyCode = Convert.ToInt32(this.PropertyListXML.SelectSingleNode("PropertyList/PropertyGroup/Property/@ViewSecurityGroup").Value);
            securityOptions.SecurityGroups = new XmlDocument();
            securityOptions.SecurityGroups.LoadXml(base.PresentationXML.DocumentElement.LastChild.OuterXml);


            securityOptions.BubbleClick += SecurityDisplayed;


        }

        private void SecurityDisplayed(object sender, EventArgs e)
        {
            if (Session["pnlSecurityOptions.Visible"] == null)
            {
                phAddPubMed.Visible = true;
                phAddPub.Visible = true;
                phAddCustom.Visible = true;
                phDeletePub.Visible = true;
                phDisableDisambig.Visible = true;

            }
            else
            {
                phAddPubMed.Visible = false;
                phAddPub.Visible = false;
                phAddCustom.Visible = false;
                phDeletePub.Visible = false;
                phDisableDisambig.Visible = false;
            }

        }


        protected void Page_Load(object sender, EventArgs e)
        {

            if (IsPostBack)
            {
                if (PubMedResults.Tables.Count > 0)
                {
                    grdPubMedSearchResults.DataSource = PubMedResults;
                    grdPubMedSearchResults.DataBind();

                }
            }
            else
            {
                Session["phAddPub.Visible"] = null;
                Session["pnlAddPubMed.Visible"] = null;
                Session["pnlAddCustomPubMed.Visible"] = null;
                Session["pnlDeletePubMed.Visible"] = null;


            }

            if (_personId == 0)
            {
                if (Session["CurrentPersonEditing"] != null)
                    _personId = System.Convert.ToInt32(Session["CurrentPersonEditing"]);
            }
            else
                Session["CurrentPersonEditing"] = _personId;


            Profiles.Edit.Modules.CustomEditAuthorInAuthorship.DataIO data;
            data = new Profiles.Edit.Modules.CustomEditAuthorInAuthorship.DataIO();
            string predicateuri = Request.QueryString["predicateuri"].Replace("!", "#");
            this.PropertyListXML = propdata.GetPropertyList(this.BaseData, base.PresentationXML, predicateuri, false, true, false);
            litBackLink.Text = "<a href='" + Root.Domain + "/edit/default.aspx?subject=" + _subject + "'>Edit Menu</a>" + " &gt; <b>" + PropertyListXML.SelectSingleNode("PropertyList/PropertyGroup/Property/@Label").Value + "</b>";
            Boolean disambig = data.GetDisambiguationSettings(_personId);
            rblDisambiguationSettings.SelectedValue = disambig ? "enable" : "disable"; 
            lblDisambigStatus.Text = disambig ? "Automatically adding publications to my profile." : "Not automatically adding publications to my profile.";

        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            if (grdEditPublications.Rows.Count == 0)
            {
                btnDeleteGray.Visible = true;
                btnDeletePub.Visible = false;
                btnDeletePub.Enabled = false;
                btnImgDeletePub.Visible = false;
                btnImgDeletePub2.Visible = true;

                btnDeletePubMedOnly.Enabled = false;
                btnDeleteCustomOnly.Enabled = false;
                btnDeleteAll.Enabled = false;
                btnDeletePubMedClose.Enabled = false;
            }

        }
        #region Publications
        protected void PubsDataSource_Selecting(object sender, SqlDataSourceStatusEventArgs e)
        {


            if (e.AffectedRows == 0)
            {
                lblNoItems.Text = "<i>No publications have been added.</i>";
                lblNoItems.Visible = true;
                grdEditPublications.Visible = false;
            }
            else
            {
                lblNoItems.Visible = false;
                grdEditPublications.Visible = true;

            }

        }


        protected void grdEditPublications_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.Header)
            {
                e.Row.Cells[0].Text = PropertyListXML.SelectSingleNode("PropertyList/PropertyGroup/Property/@Label").Value;
                e.Row.Cells[0].Attributes.Add("style", "border-right:none;");
                e.Row.Cells[1].Attributes.Add("style", "width:70px;");
            }

            if (e.Row.RowType == DataControlRowType.DataRow)
            {

                e.Row.Cells[0].Attributes.Add("style", "padding:2px;");
                e.Row.Cells[1].Attributes.Add("style", "padding:2px;width:70px;vertical-align:top;");


                btnImgDeletePub2.Visible = false;
                btnImgDeletePub.Visible = true;
                btnDeletePub.Enabled = true;
                ++this.Counter;

                ImageButton lnkDelete = (ImageButton)e.Row.FindControl("lnkDelete");
                lnkDelete.CommandArgument = grdEditPublications.DataKeys[e.Row.RowIndex].Value.ToString();

                Label lblCounter = (Label)e.Row.FindControl("lblCounter");
                lblCounter.Text = (this.Counter).ToString() + ".";

                if (!DataBinder.Eval(e.Row.DataItem, "mpid").Equals(System.DBNull.Value))
                {
                    string str = (string)DataBinder.Eval(e.Row.DataItem, "mpid");
                    string category = (string)DataBinder.Eval(e.Row.DataItem, "Category");

                    if (str.Length > 0 && !category.Equals("PubMedBookDocument"))
                    {
                        ImageButton lb = (ImageButton)e.Row.FindControl("lnkEdit");
                        lb.Visible = true;
                        lb.ImageUrl = Root.Domain + "/edit/images/icon_edit.gif";
                        lb.Enabled = true;
                    }

                }
            }
        }

        protected void grdEditPublications_SelectedIndexChanged(object sender, EventArgs e)
        {
            pnlAddPubById.Visible = false;
            pnlAddPubMed.Visible = false;
            pnlAddPubMedResults.Visible = false;
            pnlAddCustomPubMed.Visible = true;


            IDataReader reader = null;
            try
            {
                Utilities.DataIO data = new Profiles.Edit.Utilities.DataIO();

                HiddenField hdn = (HiddenField)grdEditPublications.Rows[grdEditPublications.SelectedIndex].FindControl("hdnMPID");

                reader = data.GetCustomPub(hdn.Value);

                if (reader.Read())
                {

                    drpPublicationType.SelectedValue = reader["hmspubcategory"].ToString();

                    txtPubMedAdditionalInfo.Text = reader["additionalinfo"].ToString();
                    txtPubMedAuthors.Text = reader["authors"].ToString();
                    if (reader["hmspubcategory"].ToString() == "Thesis")
                    { txtPubMedNewsCity.Text = reader["placeofpub"].ToString(); }
                    else
                    { txtPubMedPublisherCity.Text = reader["placeofpub"].ToString(); }
                    txtPubMedNewsColumn.Text = reader["newspapercol"].ToString();
                    txtPubMedConferenceDate.Text = reader["confdts"].ToString();
                    txtPubMedConferenceEdition.Text = reader["confeditors"].ToString();
                    txtPubMedConferenceName.Text = reader["confnm"].ToString();
                    txtPubMedPublisherContract.Text = reader["contractnum"].ToString();

                    if (reader["publicationdt"].ToString().Length > 0)
                    {
                        DateTime dt = (DateTime.Parse(reader["publicationdt"].ToString()));
                        txtPubMedPublicationDate.Text = dt.ToShortDateString();

                    }
                    txtPubMedEdition.Text = reader["edition"].ToString();
                    txtPubMedPublicationIssue.Text = reader["issuepub"].ToString();
                    txtPubMedConferenceLocation.Text = reader["confloc"].ToString();
                    txtPubMedPublisherName.Text = reader["publisher"].ToString();
                    txtPubMedOptionalWebsite.Text = reader["url"].ToString();
                    txtPubMedPublicationPages.Text = reader["paginationpub"].ToString();
                    txtPubMedPublisherReport.Text = reader["reptnumber"].ToString();
                    txtPubMedNewsSection.Text = reader["newspapersect"].ToString();
                    txtPubMedTitle.Text = reader["pubtitle"].ToString();
                    txtPubMedTitle2.Text = reader["articletitle"].ToString();
                    txtPubMedNewsUniversity.Text = reader["dissunivnm"].ToString();
                    txtPubMedPublicationVolume.Text = reader["volnum"].ToString();
                    txtPubMedAbstract.Text = reader["abstract"].ToString();

                    ShowCustomEdit(reader["hmspubcategory"].ToString());


                    upnlEditSection.Update();

                }
            }
            catch (Exception ex)
            {
                string err = ex.Message;
            }
            finally
            {
                if (reader != null)
                {
                    if (!reader.IsClosed)
                    { reader.Close(); }
                }
            }
        }
        protected void deleteOne_Onclick(object sender, EventArgs e)
        {
            ImageButton lb = (ImageButton)sender;

            string key = lb.CommandArgument;

            Utilities.DataIO data = new Profiles.Edit.Utilities.DataIO();

            data.DeleteOnePublication(this._personId, Convert.ToInt64(Session["NodeID"]), key, this.PropertyListXML);
            this.Counter = 0;
            grdEditPublications.DataBind();
            upnlEditSection.Update();

        }



        #endregion

        #region Add PubMed By ID

        protected void btnAddPub_OnClick(object sender, EventArgs e)
        {
            if (Session["phAddPub.Visible"] == null)
            {
                btnImgAddPub.ImageUrl = Root.Domain + "/Framework/images/icon_squareDownArrow.gif";

                phAddCustom.Visible = false;
                phAddPubMed.Visible = false;
                phDeletePub.Visible = false;
                phDisableDisambig.Visible = false;
                pnlAddPubById.Visible = true;
                pnlAddPubMed.Visible = false;
                phSecuritySettings.Visible = false;
                pnlAddPubMedResults.Visible = false;
                pnlAddCustomPubMed.Visible = false;
                Session["phAddPub.Visible"] = true;
            }
            else
            {
                Session["phAddPub.Visible"] = null;
                btnDonePub_OnClick(sender, e);

            }



            upnlEditSection.Update();



        }

        protected void btnDonePub_OnClick(object sender, EventArgs e)
        {
            phAddCustom.Visible = true;
            phAddPubMed.Visible = true;
            phDeletePub.Visible = true;
            phDisableDisambig.Visible = true;
            phSecuritySettings.Visible = true;
            txtPubId.Text = "";
            pnlAddPubById.Visible = false;
            btnImgAddPub.ImageUrl = Root.Domain + "/Framework/images/icon_squareArrow.gif";
            Session["phAddPub.Visible"] = null;

            upnlEditSection.Update();
        }

        protected void btnSavePub_OnClick(object sender, EventArgs e)
        {


            string inputString = txtPubId.Text.Trim();

            inputString = inputString.Replace(";", ",");
            inputString = inputString.Replace("\r\n", ",");
            inputString = inputString.Replace("\n", ",");
            inputString = inputString.Replace(" ", "");

            string[] PubIds = inputString.Split(',');
            string value = "";
            string seperator = "";
            foreach (string s in PubIds)
            {
                if (s.Length > 0)
                {
                    value = value + seperator + s;
                    seperator = ",";
                }
            }

            value = value.Trim();
            if (value.Length > 0)
            {
                string pubIdType = drpPubIdType.SelectedValue;
                try
                {
                    switch (pubIdType.ToLower())
                    {
                        case "pmid":

                            InsertPubMedIds(value);
                            break;
                    }

                    phAddCustom.Visible = true;
                    phAddPubMed.Visible = true;
                    phDeletePub.Visible = true;
                    phDisableDisambig.Visible = true;
                    phSecuritySettings.Visible = true;
                    txtPubId.Text = "";
                    pnlAddPubById.Visible = false;
                    grdEditPublications.DataBind();
                    btnImgAddPub.ImageUrl = Root.Domain + "/Framework/images/icon_squareArrow.gif";

                }
                catch (Exception ex)
                {
                    string err = ex.Message;
                }
            }
            upnlEditSection.Update();
        }

        //Inserts comma seperated string of PubMed Ids into the db
        private void InsertPubMedIds(string value)
        {

            string uri = "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?retmax=1000&db=pubmed&retmode=xml&id=" + value;

            System.Xml.XmlDocument myXml = new System.Xml.XmlDocument();
            myXml.LoadXml(this.HttpPost(uri, "Catalyst", "text/plain"));
            XmlNodeList nodes = myXml.SelectNodes("PubmedArticleSet/PubmedArticle");

            DataIO data = new DataIO();

            foreach (XmlNode node in nodes)
            {
                string pmid = node.SelectSingleNode("MedlineCitation/PMID").InnerText;
                if (!data.CheckPublicationExists(pmid))
                    // Insert or update the publication
                    data.AddPublication(pmid, node.OuterXml);

                // Assign the user to the publication
                data.AddPublication(_personId, _subject, Convert.ToInt32(pmid), this.PropertyListXML);
            }

            XmlNodeList bookDocNodes = myXml.SelectNodes("PubmedArticleSet/PubmedBookArticle");
            foreach (XmlNode node in bookDocNodes)
            {
                string pmid = node.SelectSingleNode("BookDocument/PMID").InnerText;
                if (!data.CheckPublicationExists(pmid))
                    // Insert or update the publication
                    data.AddPublication(pmid, node.OuterXml);
                data.AddPubmedBookArticle(_personId, _subject, Convert.ToInt32(pmid), this.PropertyListXML);
            }


            data.UpdateEntityOnePerson(_personId);
            this.KillCache();
            this.Counter = 0;
            Session["phAddPub.Visible"] = null;
            Session["pnlAddPubMed.Visible"] = null;
            Session["pnlAddCustomPubMed.Visible"] = null;
            Session["pnlDeletePubMed.Visible"] = null;
            upnlEditSection.Update();

        }
        private void KillCache()
        {
            Framework.Utilities.Cache.AlterDependency(this._subject.ToString());
        }

        #endregion

        #region Add PubMed By Search

        protected void btnAddPubMed_OnClick(object sender, EventArgs e)
        {

            if (Session["pnlAddPubMed.Visible"] == null)
            {
                btnImgAddPubMed.ImageUrl = Root.Domain + "/Framework/images/icon_squareDownArrow.gif";
                phAddCustom.Visible = false;
                phAddPub.Visible = false;
                phDeletePub.Visible = false;
                phDisableDisambig.Visible = false;
                pnlAddPubMed.Visible = true;
                pnlAddPubById.Visible = false;
                pnlAddPubMedResults.Visible = false;
                pnlAddCustomPubMed.Visible = false;
                phSecuritySettings.Visible = false;
                Session["pnlAddPubMed.Visible"] = true;
            }
            else
            {
                btnPubMedClose_OnClick(sender, e);
                Session["pnlAddPubMed.Visible"] = null;

            }

            upnlEditSection.Update();
        }

        private void ResetPubMedSearch()
        {
            txtSearchAffiliation.Text = "";
            txtSearchAuthor.Text = "";
            txtSearchKeyword.Text = "";
            txtPubMedQuery.Text = "";
            rdoPubMedQuery.Checked = false;
            rdoPubMedKeyword.Checked = true;
            grdPubMedSearchResults.DataBind();
            lblPubMedResultsHeader.Text = "";
            pnlAddPubMedResults.Visible = false;
            Session["phAddPub.Visible"] = null;
            Session["pnlAddPubMed.Visible"] = null;
            Session["pnlAddCustomPubMed.Visible"] = null;
            Session["pnlDeletePubMed.Visible"] = null;


        }

        protected void btnPubMedClose_OnClick(object sender, EventArgs e)
        {
            ResetPubMedSearch();
            pnlAddPubMed.Visible = false;
            phAddCustom.Visible = true;
            phAddPub.Visible = true;
            phDeletePub.Visible = true;
            phDisableDisambig.Visible = true;
            phSecuritySettings.Visible = true;
            btnImgAddPubMed.ImageUrl = Root.Domain + "/Framework/images/icon_squareArrow.gif";

            upnlEditSection.Update();
        }


        protected void btnPubMedSearch_OnClick(object sender, EventArgs e)
        {
            string value = "";

            if (rdoPubMedKeyword.Checked)
            {
                string andString = "";
                value = "(";

                if (txtSearchAuthor.Text.Length > 0)
                {
                    string inputString = txtSearchAuthor.Text.Trim();
                    inputString = inputString.Replace("\r\n", "|");
                    inputString = inputString.Replace("\n", "|");

                    string[] split = inputString.Split('|');

                    for (int i = 0; i < split.Length; i++)
                    {
                        value = value + andString + "(" + split[i] + "[Author])";
                        andString = " AND ";
                    }
                }
                if (txtSearchAffiliation.Text.Length > 0)
                {
                    value = value + andString + "(" + txtSearchAffiliation.Text + "[Affiliation])";
                    andString = " AND ";
                }
                if (txtSearchKeyword.Text.Length > 0)
                {
                    value = value + andString + "((" + txtSearchKeyword.Text + "[Title/Abstract]) OR (" + txtSearchKeyword.Text + "[MeSH Terms]))";
                }

                value = value + ")";
            }
            else if (rdoPubMedQuery.Checked)
            {
                value = txtPubMedQuery.Text.Trim();
            }

            string orString = "";
            string idValues = "";

            if (chkPubMedExclude.Checked)
            {
                foreach (GridViewRow gvr in grdEditPublications.Rows)
                {
                    HiddenField hdn = (HiddenField)gvr.FindControl("hdnPMID");
                    idValues = idValues + orString + hdn.Value;
                    orString = ",";
                }
            }

            Hashtable MyParameters = new Hashtable();

            string uri = "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pubmed&usehistory=y&retmax=1&retmode=xml&term=" + value;
            System.Xml.XmlDocument myXml = new System.Xml.XmlDocument();
            myXml.LoadXml(this.HttpPost(uri, "Catalyst", "text/plain"));

            XmlNodeList xnList;
            string queryKey = "";
            string webEnv = "";

            xnList = myXml.SelectNodes("/eSearchResult");

            try
            {
                foreach (XmlNode xn in xnList)
                {
                    queryKey = xn["QueryKey"].InnerText;
                    webEnv = xn["WebEnv"].InnerText;
                }
            }
            catch (Exception ex)
            {

                //do nothing. its a blank search
            }

			System.Threading.Thread.Sleep(1000);
            int pubscount = 100;
            if (chkPubMedExclude.Checked) pubscount += Convert.ToInt32(this.PropertyListXML.SelectSingleNode("PropertyList/PropertyGroup/Property/@NumberOfConnections").Value) + 100;
            uri = "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi?retmin=0&retmax="+ pubscount + "&retmode=xml&db=Pubmed&query_key=" + queryKey + "&webenv=" + webEnv;
            myXml.LoadXml(this.HttpPost(uri, "Catalyst", "text/plain"));

            string pubMedAuthors = "";
            string pubMedTitle = "";
            string pubMedSO = "";
            string pubMedID = "";
            string seperator = "";

            PubMedResults.Tables.Clear();
            PubMedResults.Tables.Add("Results");
            PubMedResults.Tables["Results"].Columns.Add(new System.Data.DataColumn("pmid"));
            PubMedResults.Tables["Results"].Columns.Add(new System.Data.DataColumn("citation"));
            PubMedResults.Tables["Results"].Columns.Add(new System.Data.DataColumn("checked"));

            int MaxPubs = 100;
            XmlNodeList docSums = myXml.SelectNodes("eSummaryResult/DocSum");
            foreach (XmlNode docSum in docSums)
            {
                pubMedAuthors = "";
                pubMedTitle = "";
                pubMedSO = "";
                pubMedID = "";
                seperator = "";
                XmlNodeList authors = docSum.SelectNodes("Item[@Name='AuthorList']/Item[@Name='Author']");
                foreach (XmlNode author in authors)
                {
                    pubMedAuthors = pubMedAuthors + seperator + author.InnerText;
                    seperator = ", ";
                }
                pubMedTitle = docSum.SelectSingleNode("Item[@Name='Title']").InnerText;
                pubMedSO = docSum.SelectSingleNode("Item[@Name='SO']").InnerText;
                pubMedID = docSum.SelectSingleNode("Id").InnerText;

                if (!idValues.Contains(pubMedID))
                {
                    DataRow myDataRow = PubMedResults.Tables["Results"].NewRow();
                    myDataRow["pmid"] = pubMedID;
                    myDataRow["checked"] = "0";
                    myDataRow["citation"] = pubMedAuthors + "; " + pubMedTitle + "; " + pubMedSO;
                    PubMedResults.Tables["Results"].Rows.Add(myDataRow);
                    PubMedResults.AcceptChanges();
                    MaxPubs--;
                }
                if (MaxPubs <= 0) break;
            }

            grdPubMedSearchResults.DataSource = PubMedResults;
            grdPubMedSearchResults.DataBind();

            lblPubMedResultsHeader.Text = "PubMed Results (" + PubMedResults.Tables["Results"].Rows.Count.ToString() + ")";

            if (PubMedResults.Tables[0].Rows.Count == 0)
            {
                lnkUpdatePubMed.Visible = false;
            }


            pnlAddPubMedResults.Visible = true;

            btnImgAddPubMed.ImageUrl = Root.Domain + "/Framework/images/icon_squareDownArrow.gif";
            phAddCustom.Visible = false;
            phAddPub.Visible = false;
            phDeletePub.Visible = false;
            pnlAddPubMed.Visible = false;
            pnlAddPubById.Visible = false;
            pnlAddCustomPubMed.Visible = false;
            phSecuritySettings.Visible = false;
            Session["pnlAddPubMed.Visible"] = null;


            upnlEditSection.Update();
        }

        protected void grdPubMedSearchResults_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType != DataControlRowType.DataRow) return;

            DataRowView drv = e.Row.DataItem as DataRowView;

            CheckBox cb = (CheckBox)e.Row.FindControl("chkPubMed");

            cb.Attributes.Add("checked", "");

            if (drv["checked"].ToString() == "0")
                cb.Checked = false;
            else
                cb.Checked = true;

        }

        protected void btnPubMedAddSelected_OnClick(object sender, EventArgs e)
        {


            string value = "";
            string seperator = "";

            foreach (GridViewRow row in grdPubMedSearchResults.Rows)
            {
                CheckBox cb = (CheckBox)row.FindControl("chkPubMed");
                if (cb.Checked)
                {
                    value = value + seperator + (string)grdPubMedSearchResults.DataKeys[row.RowIndex]["pmid"];
                    seperator = ",";
                }
            }

            InsertPubMedIds(value);


            this.KillCache();
            this.Counter = 0;

            grdPubMedSearchResults.DataBind();
            grdEditPublications.DataBind();
            pnlAddPubMedResults.Visible = false;
            pnlAddPubMed.Visible = false;
            phAddCustom.Visible = true;
            phAddPub.Visible = true;
            phDeletePub.Visible = true;
            phSecuritySettings.Visible = true;
            btnImgAddPubMed.ImageUrl = Root.Domain + "/Framework/images/icon_squareArrow.gif";
            PubMedResults = null;

            upnlEditSection.Update();
        }

        protected void grdPubMedSearchResults_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            //add checks to ds
            foreach (GridViewRow row in grdPubMedSearchResults.Rows)
            {
                CheckBox cb = (CheckBox)row.FindControl("chkPubMed");
                if (cb.Checked)
                {
                    PubMedResults.Tables["Results"].Rows[row.RowIndex]["checked"] = "1";
                }
                else
                {
                    PubMedResults.Tables["Results"].Rows[row.RowIndex]["checked"] = "0";
                }
            }
            PubMedResults.AcceptChanges();

            grdPubMedSearchResults.PageIndex = e.NewPageIndex;
            grdPubMedSearchResults.DataSource = PubMedResults;
            grdPubMedSearchResults.DataBind();
            upnlEditSection.Update();
        }

        #endregion

        #region Add PubMed Custom

        protected void btnAddCustom_OnClick(object sender, EventArgs e)
        {

            if (Session["pnlAddCustomPubMed.Visible"] == null)
            {
                btnImgAddCustom.ImageUrl = Root.Domain + "/Framework/images/icon_squareDownArrow.gif";
                grdEditPublications.SelectedIndex = -1;
                phAddPub.Visible = false;
                phAddPubMed.Visible = false;
                phDeletePub.Visible = false;
                phDisableDisambig.Visible = false;
                pnlAddCustomPubMed.Visible = true;
                drpPublicationType.Enabled = true;
                phMain.Visible = false;
                phSecuritySettings.Visible = false;
                ClearPubMedCustom();
                Session["pnlAddCustomPubMed.Visible"] = true;
            }
            else
            {
                btnPubMedFinished_OnClick(sender, e);
            }

            upnlEditSection.Update();
        }

        private void ClearPubMedCustom()
        {
            phAdditionalInfo.Visible = false;
            phAdditionalInfo2.Visible = false;
            phConferenceInfo.Visible = false;
            phEdition.Visible = false;
            phNewsUniversity.Visible = false;
            phPubIssue.Visible = false;

            phPublisherName.Visible = false;
            phPublisherNumbers.Visible = false;
            phPubPageNumbers.Visible = false;

            phTitle2.Visible = false;

            CalendarExtender1.SelectedDate = DateTime.Today;
            txtPubMedAdditionalInfo.Text = "";
            txtPubMedAuthors.Text = "";
            txtPubMedNewsCity.Text = "";
            txtPubMedPublisherCity.Text = "";
            txtPubMedNewsColumn.Text = "";
            txtPubMedConferenceDate.Text = "";
            txtPubMedConferenceEdition.Text = "";
            txtPubMedConferenceName.Text = "";
            txtPubMedPublisherContract.Text = "";
            txtPubMedPublicationDate.Text = "";
            txtPubMedEdition.Text = "";
            txtPubMedPublicationIssue.Text = "";
            txtPubMedConferenceLocation.Text = "";
            txtPubMedPublisherName.Text = "";
            txtPubMedOptionalWebsite.Text = "";
            txtPubMedPublicationPages.Text = "";
            txtPubMedPublisherReport.Text = "";
            txtPubMedNewsSection.Text = "";
            txtPubMedTitle.Text = "";
            txtPubMedTitle2.Text = "";

            txtPubMedNewsUniversity.Text = "";
            txtPubMedPublicationVolume.Text = "";
            txtPubMedAbstract.Text = "";
        }

        private void ShowCustomEdit(string publicationType)
        {
            phMain.Visible = true;


            switch (publicationType)
            {
                case "Abstracts":
                    phTitle2.Visible = true;
                    phPubPageNumbers.Visible = true;

                    phPubIssue.Visible = true;



                    lblTitle.Text = "Title of Abstract";
                    lblTitle2.Text = "Title of Publication";
                    break;
                case "Books/Monographs/Textbooks":
                    phTitle2.Visible = true;
                    phPubPageNumbers.Visible = true;

                    phEdition.Visible = true;

                    phPublisherName.Visible = true;



                    phPublisherNumbers.Visible = true;
                    phAdditionalInfo.Visible = true;
                    phAdditionalInfo2.Visible = true;
                    lblAdditionalInfo.Text = "For technical reports, sponsor info: Sponsered by the Agency for Health Care Policy and Research<br />For monograph in series, series editor info: Stoner GD, editor. Methods and perspectives in cell biology; vol 1.";


                    lblTitle.Text = "Title of Book/Monograph";
                    lblTitle2.Text = "Title of Book/Monograph Series with Editor Report";
                    break;
                case "Clinical Communications":
                    phTitle2.Visible = true;
                    phPubPageNumbers.Visible = true;

                    phEdition.Visible = true;

                    phPubIssue.Visible = true;

                    phPublisherName.Visible = true;



                    phAdditionalInfo.Visible = true;
                    phAdditionalInfo2.Visible = true;
                    lblAdditionalInfo.Text = "Include description of who commissioned, purpose, users, penetration in summaryField.";

                    lblTitle.Text = "Title of Communication";
                    lblTitle2.Text = "Title of Journal/Book";
                    break;
                case "Educational Materials":
                    phAdditionalInfo.Visible = true;
                    phAdditionalInfo2.Visible = true;
                    lblAdditionalInfo.Text = "Brief description of educational context: e.g., presented at the Annual meeting of the Association of Academic Physiatrists, Las Vegas Indicate course and institution, if applicable";

                    lblTitle.Text = "Title of Educational Materials";
                    break;
                case "Non-Print Materials":
                    phPublisherName.Visible = true;
                    phAdditionalInfo.Visible = true;
                    phAdditionalInfo2.Visible = true;

                    lblTitle.Text = "Title of Non-Print Materials";
                    break;
                case "Original Articles":
                    phTitle2.Visible = true;
                    phPubPageNumbers.Visible = true;

                    phPubIssue.Visible = true;


                    phNewsSection.Visible = true;

                    lblTitle.Text = "Title of Publication";
                    lblTitle2.Text = "Title of Article";
                    break;
                case "Patents":
                    phPublisherNumbers.Visible = true;
                    lblTitle.Text = "Title of Patent";
                    break;
                case "Proceedings of Meetings":
                    phTitle2.Visible = true;
                    phPubPageNumbers.Visible = true;

                    phPubIssue.Visible = true;

                    phPublisherName.Visible = true;



                    phConferenceInfo.Visible = true;
                    lblTitle.Text = "Title of Paper";
                    lblTitle2.Text = "Title of Publication";
                    break;
                case "Reviews/Chapters/Editorials":
                    phTitle2.Visible = true;
                    phPubPageNumbers.Visible = true;

                    phEdition.Visible = true;

                    phPubIssue.Visible = true;

                    phPublisherName.Visible = true;



                    lblTitle.Text = "Title of Reviews/Chapters/Editorials";
                    lblTitle2.Text = "Title of Publication (include editor if applicable)";
                    break;
                case "Thesis":
                    phNewsUniversity.Visible = true;

                    lblTitle.Text = "Title of Thesis";
                    break;
            }
        }

        protected void drpPublicationType_SelectedIndexChanged(object sender, EventArgs e)
        {

            phAddPub.Visible = false;
            phAddPubMed.Visible = false;
            phDeletePub.Visible = false;
            phSecuritySettings.Visible = false;
            pnlAddCustomPubMed.Visible = true;
            drpPublicationType.Enabled = true;
            phMain.Visible = false;
            CalendarExtender1.SelectedDate = DateTime.Today;
            Session["pnlAddCustomPubMed.Visible"] = true;

            if (drpPublicationType.SelectedIndex < 1)
            {
                phMain.Visible = false;
                ClearPubMedCustom();
            }
            else
            {
                ShowCustomEdit(drpPublicationType.SelectedValue);
            }
            upnlEditSection.Update();
        }

        protected void btnPubMedSaveCustom_OnClick(object sender, EventArgs e)
        {
            string click = "btnPubMedSaveCustom_OnClick";


            Hashtable myParameters = new Hashtable();
            Utilities.DataIO data = new Profiles.Edit.Utilities.DataIO();

            myParameters.Add("@HMS_PUB_CATEGORY", drpPublicationType.SelectedValue);
            myParameters.Add("@ADDITIONAL_INFO", txtPubMedAdditionalInfo.Text);
            myParameters.Add("@ABSTRACT", txtPubMedAbstract.Text);
            myParameters.Add("@AUTHORS", txtPubMedAuthors.Text);
            if (drpPublicationType.SelectedValue == "Thesis")
            { myParameters.Add("@PLACE_OF_PUB", txtPubMedNewsCity.Text); }
            else
            { myParameters.Add("@PLACE_OF_PUB", txtPubMedPublisherCity.Text); }
            myParameters.Add("@NEWSPAPER_COL", txtPubMedNewsColumn.Text);
            myParameters.Add("@CONF_DTS", txtPubMedConferenceDate.Text);
            myParameters.Add("@CONF_EDITORS", txtPubMedConferenceEdition.Text);
            myParameters.Add("@CONF_NM", txtPubMedConferenceName.Text);
            myParameters.Add("@CONTRACT_NUM", txtPubMedPublisherContract.Text);

            DateTime temp;
            bool yessubmit = false;
            if (DateTime.TryParse(txtPubMedPublicationDate.Text, out temp))
            {
                yessubmit = true;
            }

            myParameters.Add("@PUBLICATION_DT", txtPubMedPublicationDate.Text);

            myParameters.Add("@EDITION", txtPubMedEdition.Text);
            myParameters.Add("@ISSUE_PUB", txtPubMedPublicationIssue.Text);
            myParameters.Add("@CONF_LOC", txtPubMedConferenceLocation.Text);
            myParameters.Add("@PUBLISHER", txtPubMedPublisherName.Text);
            myParameters.Add("@URL", txtPubMedOptionalWebsite.Text);
            myParameters.Add("@PAGINATION_PUB", txtPubMedPublicationPages.Text);
            myParameters.Add("@REPT_NUMBER", txtPubMedPublisherReport.Text);
            myParameters.Add("@NEWSPAPER_SECT", txtPubMedNewsSection.Text);
            myParameters.Add("@PUB_TITLE", txtPubMedTitle.Text);
            myParameters.Add("@ARTICLE_TITLE", txtPubMedTitle2.Text);
            myParameters.Add("@DISS_UNIV_NM", txtPubMedNewsUniversity.Text);
            myParameters.Add("@VOL_NUM", txtPubMedPublicationVolume.Text);



            if (grdEditPublications.SelectedIndex > -1)
            {
                //myParameters.Add("@username", Profile.UserId);
                myParameters.Add("@updated_by", _personId);
                HiddenField hdn = (HiddenField)grdEditPublications.Rows[grdEditPublications.SelectedIndex].FindControl("hdnMPID");
                myParameters.Add("@mpid", hdn.Value);

                data.EditCustomPublication(myParameters, _subject, this.PropertyListXML);
                grdEditPublications.SelectedIndex = -1;
            }
            else
            {
                myParameters.Add("@PersonID", _personId);
                myParameters.Add("@created_by", _personId);
                data.AddCustomPublication(myParameters, _personId, _subject, this.PropertyListXML);
            }





            this.Counter = 0;
            grdEditPublications.DataBind();
            ClearPubMedCustom();
            ShowCustomEdit(drpPublicationType.SelectedValue);

            this.KillCache();
            LinkButton lb = (LinkButton)sender;

            if (lb.ID == "btnPubMedSaveCustom")
            {
                phAddPub.Visible = true;
                phAddPubMed.Visible = true;
                phDeletePub.Visible = true;
                phSecuritySettings.Visible = true;
                phMain.Visible = false;
                pnlAddCustomPubMed.Visible = false;
                btnImgAddCustom.ImageUrl = Root.Domain + "/Framework/images/icon_squareArrow.gif";
            }
            Session["pnlAddCustomPubMed.Visible"] = null;

            upnlEditSection.Update();

        }

        protected void btnPubMedFinished_OnClick(object sender, EventArgs e)
        {
            phAddPub.Visible = true;
            phAddPubMed.Visible = true;
            phDeletePub.Visible = true;
            phSecuritySettings.Visible = true;
            ClearPubMedCustom();
            drpPublicationType.SelectedIndex = -1;
            grdEditPublications.SelectedIndex = -1;
            phMain.Visible = false;
            pnlAddCustomPubMed.Visible = false;
            btnImgAddCustom.ImageUrl = Root.Domain + "/Framework/images/icon_squareArrow.gif";
            Session["pnlAddCustomPubMed.Visible"] = null;

            upnlEditSection.Update();
        }

        protected void btnPubMedById_Click(object sender, EventArgs e)
        {
            btnPubMedFinished_OnClick(sender, e);
            btnAddPubMed_OnClick(sender, e);

            upnlEditSection.Update();
        }

        #endregion

        #region DeletePubMed


        protected void btnDeletePub_OnClick(object sender, EventArgs e)
        {
            if (Session["pnlDeletePubMed.Visible"] == null)
            {
                btnImgDeletePub.ImageUrl = Root.Domain + "/Framework/images/icon_squareDownArrow.gif";
                phAddCustom.Visible = false;
                phAddPubMed.Visible = false;
                phAddPub.Visible = false;
                pnlDeletePubMed.Visible = true;
                phDisableDisambig.Visible = false;
                pnlAddPubById.Visible = false;
                pnlAddPubMed.Visible = false;
                pnlAddPubMedResults.Visible = false;
                pnlAddCustomPubMed.Visible = false;
                phSecuritySettings.Visible = false;
                Session["pnlDeletePubMed.Visible"] = true;
            }
            else
            {
                Session["pnlDeletePubMed.Visible"] = null;
                btnDeletePubMedClose_OnClick(sender, e);
            }

            upnlEditSection.Update();

        }





        protected void btnDeletePubMedOnly_OnClick(object sender, EventArgs e)
        {

            Utilities.DataIO data = new Profiles.Edit.Utilities.DataIO();
            data.DeletePublications(_personId, _subject, true, false);

            this.KillCache();
            this.Counter = 0;
            phAddPub.Visible = true;
            phAddPubMed.Visible = true;
            phAddCustom.Visible = true;
            pnlDeletePubMed.Visible = false;
            phSecuritySettings.Visible = true;
            btnImgDeletePub.ImageUrl = Root.Domain + "/Framework/images/icon_squareArrow.gif";

            grdEditPublications.DataBind();



            upnlEditSection.Update();
        }

        protected void btnDeleteCustomOnly_OnClick(object sender, EventArgs e)
        {


            Utilities.DataIO data = new Profiles.Edit.Utilities.DataIO();
            data.DeletePublications(_personId, _subject, false, true);
            this.KillCache();
            this.Counter = 0;
            phAddPub.Visible = true;
            phAddPubMed.Visible = true;
            phAddCustom.Visible = true;
            pnlDeletePubMed.Visible = false;
            phSecuritySettings.Visible = true;
            btnImgDeletePub.ImageUrl = Root.Domain + "/Framework/images/icon_squareArrow.gif";

            grdEditPublications.DataBind();


            upnlEditSection.Update();

        }

        protected void btnDeleteAll_OnClick(object sender, EventArgs e)
        {

            Utilities.DataIO data = new Profiles.Edit.Utilities.DataIO();
            data.DeletePublications(_personId, _subject, true, true);



            this.KillCache();
            this.Counter = 0;
            phAddPub.Visible = true;
            phAddPubMed.Visible = true;
            phAddCustom.Visible = true;
            phSecuritySettings.Visible = true;
            pnlDeletePubMed.Visible = false;
            btnImgDeletePub.ImageUrl = Root.Domain + "/Framework/images/icon_squareArrow.gif";

            grdEditPublications.DataBind();


            upnlEditSection.Update();
        }
        protected void btnDeletePubMedClose_OnClick(object sender, EventArgs e)
        {
            phAddPubMed.Visible = true;
            phAddCustom.Visible = true;
            phAddPub.Visible = true;
            phDeletePub.Visible = true;
            phSecuritySettings.Visible = true;
            pnlDeletePubMed.Visible = false;
            phDisableDisambig.Visible = true;
            btnImgDeletePub.ImageUrl = Root.Domain + "/Framework/images/icon_squareArrow.gif";

            upnlEditSection.Update();
        }

        #endregion

        #region Disable Disambiguation
        protected void btnDisableDisambig_OnClick(object sender, EventArgs e)
        {
            if (Session["pnlDisableDisambig.Visible"] == null)
            {
                btnImgDisableDisambig.ImageUrl = Root.Domain + "/Framework/images/icon_squareDownArrow.gif";
                phAddCustom.Visible = false;
                phAddPubMed.Visible = false;
                phAddPub.Visible = false;
                pnlDeletePubMed.Visible = false;
                phDeletePub.Visible = false;
                pnlAddPubById.Visible = false;
                pnlAddPubMed.Visible = false;
                pnlDisableDisambig.Visible = true;
                pnlAddPubMedResults.Visible = false;
                pnlAddCustomPubMed.Visible = false;
                phSecuritySettings.Visible = false;
                Session["pnlDisableDisambig.Visible"] = true;
            }
            else
            {
                Session["pnlDisableDisambig.Visible"] = null;
                pnlDisableDisambig.Visible = false;
            }

            upnlEditSection.Update();


        }


        protected void btnSaveDisambig_OnClick(object sender, EventArgs e)
        {
            Profiles.Edit.Modules.CustomEditAuthorInAuthorship.DataIO data = new Profiles.Edit.Modules.CustomEditAuthorInAuthorship.DataIO();
            if (rblDisambiguationSettings.SelectedValue == "disable")
            {
                Session["disambig"] = "false";
                data.UpdateDisambiguationSettings(_personId, false);
            }
            else
            {
                Session["disambig"] = null;
                data.UpdateDisambiguationSettings(_personId, true);
            }
            Boolean disambig = data.GetDisambiguationSettings(_personId);
            rblDisambiguationSettings.SelectedValue = disambig ? "enable" : "disable";
            lblDisambigStatus.Text = disambig ? "Automatically adding publications to my profile." : "Not automatically adding publications to my profile.";

            upnlEditSection.Update();
            Session["pnlDisableDisambig.Visible"] = null;
            pnlDisableDisambig.Visible = false;

        }
        protected void btnCancel_OnClick(object sender, EventArgs e)
        {
            Session["pnlDisableDisambig.Visible"] = null;
            pnlDisableDisambig.Visible = false;
        }

        #endregion





        public DataSet PubMedResults
        {
            get
            {
                if (Session["PubMedResults"] == null)
                { Session["PubMedResults"] = new DataSet(); }
                return (DataSet)Session["PubMedResults"];
            }
            set
            {
                Session["PubMedResults"] = value;
            }
        }


        private XmlDocument PropertyListXML { get; set; }

        public string HttpPost(string myUri, string myXml, string contentType)
        {
            Uri uri = new Uri(myUri);
            ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;
            WebRequest myRequest = WebRequest.Create(uri);
            myRequest.ContentType = contentType;
            //myRequest.ContentType = "application/x-www-form-urlencoded";
            myRequest.Method = "POST";

            byte[] bytes = Encoding.ASCII.GetBytes(myXml);
            Stream os = null;

            string err = null;
            try
            { // send the Post
                myRequest.ContentLength = bytes.Length;   //Count bytes to send
                os = myRequest.GetRequestStream();
                os.Write(bytes, 0, bytes.Length);         //Send it
            }
            catch (WebException ex)
            {
                err = "Input=" + ex.Message;
            }
            finally
            {
                if (os != null)
                { os.Close(); }
            }

            try
            { // get the response
                WebResponse myResponse = myRequest.GetResponse();
                if (myResponse == null)
                { return null; }
                StreamReader sr = new StreamReader(myResponse.GetResponseStream());
                return sr.ReadToEnd().Trim();
            }
            catch (WebException ex)
            {
                err = "Output=" + ex.Message;
            }
            return err;
        } // end HttpPost 

        public string HttpGet(string myUri)
        {
            Uri uri = new Uri(myUri);
            ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;
            WebRequest myRequest = WebRequest.Create(uri);
            //myRequest.ContentType = contentType;
            //myRequest.ContentType = "application/x-www-form-urlencoded";
            myRequest.Method = "GET";

            //byte[] bytes = Encoding.ASCII.GetBytes(myXml);
            //Stream os = null;

            string err = null;
/*            try
            { // send the Post
                myRequest.ContentLength = bytes.Length;   //Count bytes to send
                os = myRequest.GetRequestStream();
                os.Write(bytes, 0, bytes.Length);         //Send it
            }
            catch (WebException ex)
            {
                err = "Input=" + ex.Message;
            }
            finally
            {
                if (os != null)
                { os.Close(); }
            }
*/
            try
            { // get the response
                WebResponse myResponse = myRequest.GetResponse();
                if (myResponse == null)
                { return null; }
                StreamReader sr = new StreamReader(myResponse.GetResponseStream());
                return sr.ReadToEnd().Trim();
            }
            catch (WebException ex)
            {
                err = "Output=" + ex.Message;
            }
            return err;
        } // end HttpPost 

        private Int16 Counter { get; set; }

    }
}