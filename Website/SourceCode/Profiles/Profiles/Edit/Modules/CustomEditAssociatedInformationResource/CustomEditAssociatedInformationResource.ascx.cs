/*  
 
    Copyright (c) 2008-2012 by the President and Fellows of Harvard College. All rights reserved.  
    Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
    and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
    National Center for Research Resources and Harvard University.


    Code licensed under a BSD License. 
    For details, see: LICENSE.txt 
  
*/
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
using Profiles.Edit.Utilities;


namespace Profiles.Edit.Modules.CustomEditAssociatedInformationResource
{
    public partial class CustomEditAssociatedInformationResource : BaseModule
    {

        #region Local Variables
        public int _personId = 0;
        public Int64 _subject = 0;
        private bool syncUserPubs = false;

        public string _predicateuri = string.Empty;
        Profiles.Profile.Utilities.DataIO propdata;
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

        public CustomEditAssociatedInformationResource() { }
        public CustomEditAssociatedInformationResource(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
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
            securityOptions.SecurityGroups = new XmlDataDocument();
            securityOptions.SecurityGroups.LoadXml(base.PresentationXML.DocumentElement.LastChild.OuterXml);

            securityOptions.BubbleClick += SecurityDisplayed;


        }

        protected void menuBtn_OnClick(object sender, EventArgs e)
        {
            string buttonID = ((Control)sender).ID;

            if (Session["pnl.Visible"] != null &&
                !(
                    buttonID.Equals("btnGroupMemberFiltersReset") ||
                    buttonID.Equals("btnGroupMemberFiltersApply")
                )
               )
            {
                reset();
                return;
            }


            if (buttonID.Equals("btnAddPub")) {
                pnlAddPubById.Visible = true;
                phAddPub.Visible = true;
                Session["pnl.Visible"] = true;
                btnImgAddPub.ImageUrl = Root.Domain + "/Framework/images/icon_squareDownArrow.gif";
            }
            else {
                pnlAddPubById.Visible = false;
                phAddPub.Visible = false;
            }


            if (buttonID.Equals("btnAddCustom")) {
                pnlAddCustomPubMed.Visible = true;
                phAddCustom.Visible = true;
                Session["pnl.Visible"] = true;
                btnImgAddCustom.ImageUrl = Root.Domain + "/Framework/images/icon_squareDownArrow.gif";
            }
            else {
                pnlAddCustomPubMed.Visible = false;
                phAddCustom.Visible = false;
            }


            if (buttonID.Equals("btnDeletePub")) {
                pnlDeletePubMed.Visible = true;
                phDeletePub.Visible = true;
                Session["pnl.Visible"] = true;
                btnImgDeletePub.ImageUrl = Root.Domain + "/Framework/images/icon_squareDownArrow.gif";
            }
            else {
                pnlDeletePubMed.Visible = false;
                phDeletePub.Visible = false;
            }


            if (buttonID.Equals("btnAddPubMed") || buttonID.Equals("btnPubMedById")) {
                phAddPubMed.Visible = true;
                phAddMemberPubs.Visible = false;
                pnlAddPubMed.Visible = true;
                pnlGroupMemberFilters.Visible = false;
                Session["pnl.Visible"] = true;
                btnImgAddPubMed.ImageUrl = Root.Domain + "/Framework/images/icon_squareDownArrow.gif";
            }
            else if (buttonID.Equals("btnAddMemberPub") || buttonID.Equals("btnGroupMemberFiltersReset") || buttonID.Equals("btnGroupMemberFiltersApply")) {
                if (buttonID.Equals("btnGroupMemberFiltersApply"))
                {
                    DateTime startDate;
                    DateTime.TryParse(txtGroupMemberFiltersStartDate.Text, out startDate);
                    if (startDate < new DateTime(1800, 1, 1)) startDate = new DateTime(1800, 1, 1);
                    DateTime endDate;
                    DateTime.TryParse(txtGroupMemberFiltersEndDate.Text, out endDate);
                    if (endDate.Equals(new DateTime(1, 1, 1))) endDate = new DateTime(2200, 1, 1);
                    else if (endDate < new DateTime(1800, 1, 1)) endDate = new DateTime(1800, 1, 1);

                    string selectedRows = Request.Form[this.hidList.UniqueID];
                    string personIDs = "";

                    if (!selectedRows.Equals(""))
                    {
                        string[] selectedRowStringArray = selectedRows.Split(',');

                        Utilities.DataIO data = new Profiles.Edit.Utilities.DataIO();
                        System.Data.SqlClient.SqlDataReader sqldr = data.GetGroupMembers(_subject);
                        personIDs = "<PersonIDs>";
                        int i = 0;
                        int j = 0;
                        int nextIndex = Convert.ToInt32(selectedRowStringArray[j]);
                        while (sqldr.Read())
                        {
                            if(i == nextIndex)
                            {
                                personIDs += "<PersonID>" + sqldr["PersonID"].ToString() + "</PersonID>";
                                j++;
                                if (j == selectedRowStringArray.Length - 1) break;
                                nextIndex = Convert.ToInt32(selectedRowStringArray[j]);
                            }
                            i++;
                        }

                        personIDs = personIDs + "</PersonIDs>";

                        //Always close your readers
                        if (!sqldr.IsClosed)
                            sqldr.Close();
                    }
                    showMemberPublications(startDate, endDate, personIDs);
                    ScriptManager.RegisterStartupScript(this.Page, Page.GetType(), "text", "getSelectedItem('', '', '', '')", true);
                }
                else
                {
                    txtGroupMemberFiltersStartDate.Text = "";
                    txtGroupMemberFiltersEndDate.Text = "";
                    showMemberPublications(new DateTime(1800, 01, 01), new DateTime(2500, 01, 01), "");
                    ScriptManager.RegisterStartupScript(this.Page, Page.GetType(), "text", "uncheckAllPeople()", true);
                }
                pnlAddPubMedResults.Visible = true;
                phAddPubMed.Visible = false;
                phAddMemberPubs.Visible = true;
                pnlGroupMemberFilters.Visible = true;
                Session["pnl.Visible"] = true;
                
                btnImgAddMemberPub.ImageUrl = Root.Domain + "/Framework/images/icon_squareDownArrow.gif";
            }
            else {
                pnlAddPubMedResults.Visible = false;
                phAddMemberPubs.Visible = false;
                phAddPubMed.Visible = false;
            }


            if (buttonID.Equals("btnSyncMemberPubs") && !syncUserPubs) {
                pnlSyncMemberPubs.Visible = true;
                phSyncMemberPubs.Visible = true;
                Session["pnl.Visible"] = true;
                btnImgSyncMemberPubs.ImageUrl = Root.Domain + "/Framework/images/icon_squareDownArrow.gif";
            }
            else if (buttonID.Equals("btnSyncMemberPubs") && syncUserPubs)
            {
                //pnlUnsyncMemberPubs.Visible = true;
                phSyncMemberPubs.Visible = true;
                Session["pnl.Visible"] = true;
                btnImgSyncMemberPubs.ImageUrl = Root.Domain + "/Framework/images/icon_squareDownArrow.gif";
            }
            else {
                pnlSyncMemberPubs.Visible = false;
                //pnlUnsyncMemberPubs.Visible = false;
                phSyncMemberPubs.Visible = false;
            }


            if (buttonID.Equals("securityOptions"))
            {
                phSecuritySettings.Visible = true;
            }
            else
            {
                phSecuritySettings.Visible = false;
            }

            upnlEditSection.Update();
        }

        private void reset()
        {
            phSecuritySettings.Visible = true;
            phSyncMemberPubs.Visible = true;
            phAddMemberPubs.Visible = true;
            phAddPubMed.Visible = true;
            phAddPub.Visible = true;
            phAddCustom.Visible = true;
            phDeletePub.Visible = true;

            //Hide all panels
            pnlSyncMemberPubs.Visible = false;
            //pnlUnsyncMemberPubs.Visible = false;
            pnlAddPubById.Visible = false;
            pnlAddPubMed.Visible = false;
            pnlAddPubMedResults.Visible = false;
            pnlAddCustomPubMed.Visible = false;
            pnlDeletePubMed.Visible = false;
            pnlGroupMemberFilters.Visible = false;

            Session["pnl.Visible"] = null;

            btnImgAddPub.ImageUrl = Root.Domain + "/Framework/images/icon_squareArrow.gif";
            btnImgSyncMemberPubs.ImageUrl = Root.Domain + "/Framework/images/icon_squareArrow.gif";
            btnImgAddMemberPub.ImageUrl = Root.Domain + "/Framework/images/icon_squareArrow.gif";
            btnImgAddPubMed.ImageUrl = Root.Domain + "/Framework/images/icon_squareArrow.gif";
            btnImgAddPub.ImageUrl = Root.Domain + "/Framework/images/icon_squareArrow.gif";
            btnImgAddCustom.ImageUrl = Root.Domain + "/Framework/images/icon_squareArrow.gif";
            btnImgDeletePub.ImageUrl = Root.Domain + "/Framework/images/icon_squareArrow.gif";

            Edit.Utilities.DataIO data = new Edit.Utilities.DataIO();
            if (data.GetGroupPublicationOption(_personId)) litSyncMemberPubs.Text = "(<b>On</b> / Off)";
            else litSyncMemberPubs.Text = "(On / <b>Off</b>)";

            txtPubId.Text = "";
            txtSearchAffiliation.Text = "";
            txtSearchAuthor.Text = "";
            txtSearchKeyword.Text = "";
            txtPubMedQuery.Text = "";
            rdoPubMedQuery.Checked = false;
            rdoPubMedKeyword.Checked = true;
            lblPubMedResultsHeader.Text = "";
            ClearPubMedCustom();

            upnlEditSection.Update();
        }

        protected  void reset(object sender, EventArgs e)
        {
            reset();
        }


        private void SecurityDisplayed(object sender, EventArgs e)
        {


            if (Session["pnlSecurityOptions.Visible"] == null)
            {
                reset();
            }
            else
            {
                menuBtn_OnClick(sender, e);
            }
        }

        #endregion

        protected void grdSyncMemberPubs_OnDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                GroupPublicationOptionItem gpi = (GroupPublicationOptionItem)e.Row.DataItem;
                RadioButton rb = (RadioButton)e.Row.FindControl("rdoGroupPublicationOption");
                HiddenField hf = (HiddenField)e.Row.FindControl("hdnGroupPublicationOption");
                Literal l = (Literal)e.Row.FindControl("litGroupPublicationOption");
                rb.GroupName = "SecurityOption";

                hf.Value = gpi.Code.ToString();
                l.Text = gpi.Label;

                Edit.Utilities.DataIO data = new Edit.Utilities.DataIO();
                int groupPublicationOption = 0;
                if (data.GetGroupPublicationOption(_personId)) groupPublicationOption = 1;
                if (groupPublicationOption == gpi.Code) rb.Checked = true;
                else rb.Checked = false;
            }
        }

        protected void rdoGroupPublicationOption_OnCheckedChanged(object sender, EventArgs e)
        {
            //Clear the existing selected row 
            foreach (GridViewRow oldrow in grdSyncMemberPubs.Rows)
            {
                ((RadioButton)oldrow.FindControl("rdoGroupPublicationOption")).Checked = false;
            }

            //Set the new selected row
            RadioButton rb = (RadioButton)sender;
            GridViewRow row = (GridViewRow)rb.NamingContainer;
            ((RadioButton)row.FindControl("rdoGroupPublicationOption")).Checked = true;

            int o = Convert.ToInt32(((HiddenField)row.Cells[0].FindControl("hdnGroupPublicationOption")).Value);
            Utilities.DataIO data = new Profiles.Edit.Utilities.DataIO();
            data.SetGroupPublicationOption(_personId, o);
            reset();
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
                Session["pnl.Visible"] = null;
            }



            // a flag to inform the ucProfileBaseInfo that it is edit page
            Session["ProfileEdit"] = "true";

            Session["ProfileUsername"] = _personId;

            if (_personId == 0)
            {
                if (Session["CurrentPersonEditing"] != null)
                    _personId = System.Convert.ToInt32(Session["CurrentPersonEditing"]);
            }
            else
                Session["CurrentPersonEditing"] = _personId;

            Edit.Utilities.DataIO data;
            data = new Edit.Utilities.DataIO();

            string predicateuri = Request.QueryString["predicateuri"].Replace("!", "#");
            this.PropertyListXML = propdata.GetPropertyList(this.BaseData, base.PresentationXML, predicateuri, false, true, false);
            litBackLink.Text = "<a href='" + Root.Domain + "/edit/" + _subject + "'>Edit Menu</a>" + " &gt; <b>" + PropertyListXML.SelectSingleNode("PropertyList/PropertyGroup/Property/@Label").Value + "</b>";
            if (data.GetGroupPublicationOption(_personId)) litSyncMemberPubs.Text = "(<b>On</b> / Off)";
            else litSyncMemberPubs.Text = "(On / <b>Off</b>)";

            List<GroupPublicationOptionItem> gpi = new List<GroupPublicationOptionItem>();

            gpi.Add(new GroupPublicationOptionItem("On", "All member publications added to this group and updated automatically.", 1));
            gpi.Add(new GroupPublicationOptionItem("Off", "Only publications manually added to this group will be listed.", 0));

            grdSyncMemberPubs.DataSource = gpi;
            grdSyncMemberPubs.DataBind();

            BuildPersonFilterList();
        }

        private void BuildPersonFilterList()
        {
            Utilities.DataIO data = new Profiles.Edit.Utilities.DataIO();

            DropDownList ddl = new DropDownList();
            ddl.ID = "ddlChkList";
            ListItem lstItem = new ListItem();
            ddl.Items.Insert(0, lstItem);
            ddl.Attributes.Add("title", "Display Name");
            ddl.Width = new Unit(248);
            ddl.Height = new Unit(20);
            ddl.Attributes.Add("onclick", "showdivonClick()");
            ddl.Attributes.Add("onkeypress", "showdivonClick()");
            CheckBoxList chkBxLst = new CheckBoxList();
            chkBxLst.ID = "chkLstItem";
            chkBxLst.Attributes.Add("onmouseover", "showdiv()");
            chkBxLst.Attributes.Add("onfocus", "if ( event.keyCode == 13) showdiv()");
            System.Data.SqlClient.SqlDataReader sqldr = data.GetGroupMembers(_subject);
            List<GenericListItem> dtListItem = new List<GenericListItem>();
            while (sqldr.Read())
                dtListItem.Add(new GenericListItem(sqldr["DisplayName"].ToString(), sqldr["UserID"].ToString()));

            //Always close your readers
            if (!sqldr.IsClosed)
                sqldr.Close();



            int rowNo = dtListItem.Count;
            string lstValue = string.Empty;
            string lstID = string.Empty;
            string javascript = string.Empty;


            litGroupMemberScript.Text = "<script>";
            for (int i = 0; i < rowNo; i++)
            {
                lstValue = dtListItem[i].Text;
                lstID = dtListItem[i].Value;
                lstItem = new ListItem("<a href=\"javascript:void(0)\" id=\"alst\" style=\"text-decoration:none;color:Black; \" onclick=\"getSelectedItem(' " + lstValue + "','" + i + "','" + lstID + "','anchor');\">" + lstValue + "</a>", lstID);
                lstItem.Attributes.Add("onclick", "getSelectedItem('" + lstValue + "','" + i + "','" + lstID + "','listItem');");

                //if (SearchRequest != null && !lstID.IsNullOrEmpty())
                //{
                //    if (SearchRequest.OuterXml.Contains(lstID))
                //    {
                        javascript += " javascript:getSelectedItem('" + lstValue + "','" + i + "','" + lstID + "','anchor');";
                //    }
                //}

                chkBxLst.Items.Add(lstItem);
            }


            litGroupMemberScript.Text += javascript + "</script>";



            System.Web.UI.HtmlControls.HtmlGenericControl div = new System.Web.UI.HtmlControls.HtmlGenericControl("div");
            div.ID = "divChkList";
            div.Controls.Add(chkBxLst);
            div.Style.Add("background-color", "#ffffff");
            div.Style.Add("position", "absolute");
            div.Style.Add("fload", "left");
            div.Style.Add("border", "black 1px solid");
            div.Style.Add("width", "248px");
            div.Style.Add("height", "180px");
            div.Style.Add("overflow", "AUTO");
            div.Style.Add("display", "none");
            div.Style.Add("padding-top", "25px");
            phDDLCHK.Controls.Add(ddl);
            phDDLList.Controls.Add(div);

        }

        #region Publications
        protected void PubsDataSource_Selecting(object sender, SqlDataSourceStatusEventArgs e)
        {


            if (e.AffectedRows == 0)
            {
                lblNoItems.Text = "<i>No publications have been manually added.</i>";
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
                e.Row.Cells[0].ColumnSpan = 3;
                e.Row.Cells[1].Visible = false;
                e.Row.Cells[2].Visible = false;
            }

            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                ++this.Counter;


                ImageButton lnkDelete = (ImageButton)e.Row.FindControl("lnkDelete");


                lnkDelete.CommandArgument = grdEditPublications.DataKeys[e.Row.RowIndex].Value.ToString();

                Label lblCounter = (Label)e.Row.FindControl("lblCounter");
                lblCounter.Text = (this.Counter).ToString() + ".";

                if (!DataBinder.Eval(e.Row.DataItem, "mpid").Equals(System.DBNull.Value))
                {
                    string str = (string)DataBinder.Eval(e.Row.DataItem, "mpid");

                    if (str.Length > 0)
                    {
                        ImageButton lb = (ImageButton)e.Row.FindControl("lnkEdit");
                        lb.Visible = true;
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
            phAddMemberPubs.Visible = false;

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

            //string key = grdEditPublications.DataKeys[0].Value.ToString();
            Utilities.DataIO data = new Profiles.Edit.Utilities.DataIO();


            data.DeleteOneGroupPublication(Convert.ToInt32(Session["ProfileUsername"]), Convert.ToInt64(Session["NodeID"]), key, this.PropertyListXML);
            this.Counter = 0;
            grdEditPublications.DataBind();
            upnlEditSection.Update();

        }



        #endregion

        #region Add PubMed By ID



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
                    phAddMemberPubs.Visible = true;
                    phDeletePub.Visible = true;
                    phSecuritySettings.Visible = true;
                    txtPubId.Text = "";
                    pnlAddPubById.Visible = false;
                    grdEditPublications.DataBind();
                    btnImgAddPub.ImageUrl = Root.Domain + "/Framework/images/icon_squareArrow.gif";
                    upnlEditSection.Update();
                }
                catch (Exception ex)
                {
                    string err = ex.Message;
                }
            }
        }


        //Inserts comma seperated string of PubMed Ids into the db
        private void InsertPubMedIds(string value)
        {

            string uri = "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?retmax=1000&db=pubmed&retmode=xml&id=" + value;

            System.Xml.XmlDocument myXml = new System.Xml.XmlDocument();
            myXml.LoadXml(this.HttpPost(uri, "Catalyst", "text/plain"));
            XmlNodeList nodes = myXml.SelectNodes("PubmedArticleSet/PubmedArticle");

            Utilities.DataIO data = new Profiles.Edit.Utilities.DataIO();

            foreach (XmlNode node in nodes)
            {
                string pmid = node.SelectSingleNode("MedlineCitation/PMID").InnerText;

                if (!data.CheckPublicationExists(pmid))
                    // Insert or update the publication
                    data.AddPublication(pmid, node.OuterXml);

                // Assign the user to the publication
                data.AddGroupPublication(_subject, Convert.ToInt32(pmid), this.PropertyListXML);

            }
            data.UpdateEntityOneGroup(_personId);

            this.Counter = 0;
            Session["pnl.Visible"] = null;
        }

        #endregion

        #region Add PubMed By Search


 
        private void ResetPubMedSearch()
        {
            txtSearchAffiliation.Text = "";
            txtSearchAuthor.Text = "";
            //txtSearchTitle.Text = "";
            txtSearchKeyword.Text = "";
            txtPubMedQuery.Text = "";
            rdoPubMedQuery.Checked = false;
            rdoPubMedKeyword.Checked = true;
            grdPubMedSearchResults.DataBind();
            lblPubMedResultsHeader.Text = "";
            pnlAddPubMedResults.Visible = false;
            Session["pnl.Visible"] = null;
        }


        protected void btnPubMedReset_OnClick(object sender, EventArgs e)
        {
            ResetPubMedSearch();
            upnlEditSection.Update();
        }


        protected void showMemberPublications(DateTime startDate, DateTime endDate, string personIDs)
        {
            Edit.Utilities.DataIO data;
            data = new Edit.Utilities.DataIO();
            List<PublicationState> memberPubs = data.GetGroupMemberPubs(_personId, startDate, endDate, personIDs);

            PubMedResults.Tables.Clear();
            PubMedResults.Tables.Add("Results");
            PubMedResults.Tables["Results"].Columns.Add(new System.Data.DataColumn("pmid"));
            PubMedResults.Tables["Results"].Columns.Add(new System.Data.DataColumn("mpid"));
            PubMedResults.Tables["Results"].Columns.Add(new System.Data.DataColumn("citation"));
            PubMedResults.Tables["Results"].Columns.Add(new System.Data.DataColumn("checked"));

            foreach (PublicationState pub in memberPubs)
            {
               

                DataRow myDataRow = PubMedResults.Tables["Results"].NewRow();
                myDataRow["pmid"] = pub.PMID.ToString();
                myDataRow["mpid"] = pub.MPID != null ? pub.MPID.ToString() : "0";
                myDataRow["checked"] = "0";
                myDataRow["citation"] = pub.Reference;
                PubMedResults.Tables["Results"].Rows.Add(myDataRow);
                PubMedResults.AcceptChanges();
            }

            grdPubMedSearchResults.DataSource = PubMedResults;
            grdPubMedSearchResults.DataBind();

            lblPubMedResultsHeader.Text = "Group Member Publications (" + PubMedResults.Tables["Results"].Rows.Count.ToString() + ")";

            if (PubMedResults.Tables[0].Rows.Count == 0)
            {
                lnkUpdatePubMed.Visible = false;
                pnlAddAll.Visible = false;
            }

            pnlAddPubMedResults.Visible = true;
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
                    // Added line to handle multiple authors for Firefox
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
                value = txtPubMedQuery.Text;
            }

            string orString = "";
            string idValues = "";
            //if (chkPubMedExclude.Checked)
            //{
            //    if (grdEditPublications.Rows.Count > 0)
            //    {
            //        value = value + " not (";
            //        foreach (GridViewRow gvr in grdEditPublications.Rows)
            //        {
            //            value = value + orString + (string)grdEditPublications.DataKeys[gvr.RowIndex]["PubID"]) + "[uid]";
            //            orString = " OR ";
            //        }
            //        value = value + ")";
            //    }
            //}

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

            string uri = "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pubmed&usehistory=y&retmax=100&retmode=xml&term=" + value;
            System.Xml.XmlDocument myXml = new System.Xml.XmlDocument();
            myXml.LoadXml(this.HttpPost(uri, "Catalyst", "text/plain"));

            XmlNodeList xnList;
            string queryKey = "";
            string webEnv = "";

            xnList = myXml.SelectNodes("/eSearchResult");

            foreach (XmlNode xn in xnList)
            {
                // if (xn["QueryKey"] != null)                
                queryKey = xn["QueryKey"].InnerText;
                //if(xn["WebEnv"] !=null)
                webEnv = xn["WebEnv"].InnerText;

            }

            //string queryKey = MyGetXmlNodeValue(myXml, "QueryKey", "");
            //string webEnv = MyGetXmlNodeValue(myXml, "WebEnv", "");

            uri = "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi?retmin=0&retmax=100&retmode=xml&db=Pubmed&query_key=" + queryKey + "&webenv=" + webEnv;
            myXml.LoadXml(this.HttpPost(uri, "Catalyst", "text/plain"));

            string pubMedAuthors = "";
            string pubMedTitle = "";
            string pubMedSO = "";
            string pubMedID = "";
            string seperator = "";

            PubMedResults.Tables.Clear();
            PubMedResults.Tables.Add("Results");
            PubMedResults.Tables["Results"].Columns.Add(new System.Data.DataColumn("pmid"));
            PubMedResults.Tables["Results"].Columns.Add(new System.Data.DataColumn("mpid"));
            PubMedResults.Tables["Results"].Columns.Add(new System.Data.DataColumn("citation"));
            PubMedResults.Tables["Results"].Columns.Add(new System.Data.DataColumn("checked"));

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
                    myDataRow["mpid"] = "";
                    myDataRow["checked"] = "0";
                    myDataRow["citation"] = pubMedAuthors + "; " + pubMedTitle + "; " + pubMedSO;
                    PubMedResults.Tables["Results"].Rows.Add(myDataRow);
                    PubMedResults.AcceptChanges();
                }
            }

            grdPubMedSearchResults.DataSource = PubMedResults;
            grdPubMedSearchResults.DataBind();

            lblPubMedResultsHeader.Text = "PubMed Results (" + PubMedResults.Tables["Results"].Rows.Count.ToString() + ")";

            if (PubMedResults.Tables[0].Rows.Count == 0)
            {
                lnkUpdatePubMed.Visible = false;
                pnlAddAll.Visible = false;
            }

            pnlAddPubMedResults.Visible = true;
            upnlEditSection.Update();
        }

        protected void grdPubMedSearchResults_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType != DataControlRowType.DataRow) return;

            DataRowView drv = e.Row.DataItem as DataRowView;

            CheckBox cb = (CheckBox)e.Row.FindControl("chkPubMed");



            if (drv["checked"].ToString() == "0")
                cb.Checked = false;
            else
                cb.Checked = true;

        }

        protected void btnPubMedAddSelected_OnClick(object sender, EventArgs e)
        {
            string value = "";
            string seperator = "";
            Edit.Utilities.DataIO data = new Edit.Utilities.DataIO();

            foreach (GridViewRow row in grdPubMedSearchResults.Rows)
            {
                CheckBox cb = (CheckBox)row.FindControl("chkPubMed");
                if (cb.Checked)
                {
                    string pmid = (string)grdPubMedSearchResults.DataKeys[row.RowIndex]["pmid"];
                    if (!pmid.Equals("0")) value = value + seperator + pmid;
                    else data.copyCustomPubForGroup(_personId, _subject, (string)grdPubMedSearchResults.DataKeys[row.RowIndex]["mpid"], this.PropertyListXML);
                    seperator = ",";
                }
            }

            if (!value.Equals("")) InsertPubMedIds(value);
            this.Counter = 0;
            //Clear form and grid after insert
            ResetPubMedSearch();
            grdPubMedSearchResults.DataBind();
            grdEditPublications.DataBind();
            pnlAddPubMedResults.Visible = false;
            pnlAddPubMed.Visible = false;
            phAddCustom.Visible = true;
            phAddPub.Visible = true;
            phDeletePub.Visible = true;
            phAddMemberPubs.Visible = true;
            phSecuritySettings.Visible = true;
            btnImgAddMemberPub.ImageUrl = Root.Domain + "/Framework/images/icon_squareArrow.gif";
            btnImgAddPubMed.ImageUrl = Root.Domain + "/Framework/images/icon_squareArrow.gif";
            Session["pnl.Visible"] = null;
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


        private void ClearPubMedCustom()
        {
            phAdditionalInfo.Visible = false;
            phAdditionalInfo2.Visible = false;
            phConferenceInfo.Visible = false;
            phEdition.Visible = false;
            phNewsUniversity.Visible = false;
            phPubIssue.Visible = false;
            phPublisherInfo.Visible = false;
            phPublisherName.Visible = false;
            phPublisherNumbers.Visible = false;
            phPubPageNumbers.Visible = false;
            phPubVolume.Visible = false;
            phTitle2.Visible = false;

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
                    phPubIssue.Visible = true;
                    phPubVolume.Visible = true;
                    phPubPageNumbers.Visible = true;

                    lblTitle.Text = "Title of Abstract";
                    lblTitle2.Text = "Title of Publication";
                    break;
                case "Books/Monographs/Textbooks":
                    phTitle2.Visible = true;
                    phEdition.Visible = true;
                    phPubPageNumbers.Visible = true;
                    phPublisherInfo.Visible = true;
                    phPublisherName.Visible = true;
                    phPublisherNumbers.Visible = true;
                    phAdditionalInfo.Visible = true;
                    phAdditionalInfo2.Visible = true;
                    lblAdditionalInfo.Text = "For technical reports, sponsor info: Sponsered by the Agency for Health Care Policy and Research<br />For monograph in series, series editor info: Stoner GD, editor. Methods and perspectives in cell biology; vol 1.";

                    lblPubMedPublisherReport.Text = "Report Number";
                    lblPubMedPublisherContract.Text = "Contract Number";

                    lblTitle.Text = "Title of Book/Monograph";
                    lblTitle2.Text = "Title of Book/Monograph Series with Editor Report";
                    break;
                case "Clinical Communications":
                    phTitle2.Visible = true;
                    phEdition.Visible = true;
                    phPubIssue.Visible = true;
                    phPubVolume.Visible = true;
                    phPubPageNumbers.Visible = true;
                    phPublisherInfo.Visible = true;
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
                    phPublisherInfo.Visible = true;
                    phPublisherName.Visible = true;
                    phAdditionalInfo.Visible = true;
                    phAdditionalInfo2.Visible = true;

                    lblTitle.Text = "Title of Non-Print Materials";
                    break;
                case "Original Articles":
                    phTitle2.Visible = true;
                    phPubIssue.Visible = true;
                    phPubVolume.Visible = true;
                    phPubPageNumbers.Visible = true;
                    phNewsSection.Visible = true;

                    lblTitle.Text = "Title of Publication";
                    lblTitle2.Text = "Title of Article";
                    break;
                case "Patents":
                    phPublisherNumbers.Visible = true;
                    lblPubMedPublisherReport.Text = "Sponsor/Assignee";
                    lblPubMedPublisherContract.Text = "Patent Number";
                    lblTitle.Text = "Title of Patent";
                    break;
                case "Proceedings of Meetings":
                    phTitle2.Visible = true;
                    phPubIssue.Visible = true;
                    phPubVolume.Visible = true;
                    phPubPageNumbers.Visible = true;
                    phPublisherInfo.Visible = true;
                    phPublisherName.Visible = true;
                    phConferenceInfo.Visible = true;

                    lblTitle.Text = "Title of Paper";
                    lblTitle2.Text = "Title of Publication";
                    break;
                case "Reviews/Chapters/Editorials":
                    phTitle2.Visible = true;
                    phEdition.Visible = true;
                    phPubIssue.Visible = true;
                    phPubVolume.Visible = true;
                    phPubPageNumbers.Visible = true;
                    phPublisherInfo.Visible = true;
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
            phAddMemberPubs.Visible = false;
            phDeletePub.Visible = false;
            phSecuritySettings.Visible = false;
            pnlAddCustomPubMed.Visible = true;
            drpPublicationType.Enabled = true;
            phMain.Visible = false;

            Session["pnl.Visible"] = true;

            if (drpPublicationType.SelectedIndex < 1)
            {
                phMain.Visible = false;
                ClearPubMedCustom();
            }
            else
            {
                ShowCustomEdit(drpPublicationType.SelectedValue);

                //if (grdEditPublications.SelectedIndex > 1)
                //  grdEditPublications_SelectedIndexChanged(sender, e);

            }
            upnlEditSection.Update();
        }

        protected void btnPubMedSaveCustom_OnClick(object sender, EventArgs e)
        {
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
                myParameters.Add("@GroupID", _personId);
                myParameters.Add("@created_by", _personId);
                data.AddCustomGroupPublication(myParameters, _personId, _subject, this.PropertyListXML);
            }
            this.Counter = 0;
            grdEditPublications.DataBind();
            ClearPubMedCustom();

            LinkButton lb = (LinkButton)sender;
            if (lb.ID == "btnPubMedSaveCustom")
            {
                phAddPub.Visible = true;
                phAddPubMed.Visible = true;
                phDeletePub.Visible = true;
                phAddMemberPubs.Visible = true;
                phSecuritySettings.Visible = true;
                phMain.Visible = false;
                pnlAddCustomPubMed.Visible = false;
                btnImgAddCustom.ImageUrl = Root.Domain + "/Framework/images/icon_squareArrow.gif";
            }
            Session["pnl.Visible"] = null;
            upnlEditSection.Update();
        }

        protected void btnPubMedById_Click(object sender, EventArgs e)
        {
            reset();
            menuBtn_OnClick(sender, e);
        }

        #endregion

        #region DeletePubMed

        protected void btnDeletePubMedOnly_OnClick(object sender, EventArgs e)
        {
            // PRG: Double-check we're using the correct username variable here
            //myParameters.Add("@username", (string)Session["ProfileUsername"]));
            Utilities.DataIO data = new Profiles.Edit.Utilities.DataIO();
            data.DeleteGroupPublications(_personId, _subject, true, false);
            this.Counter = 0;
            phAddPub.Visible = true;
            phAddPubMed.Visible = true;
            phAddMemberPubs.Visible = true;
            phAddCustom.Visible = true;
            pnlDeletePubMed.Visible = false;
            phSecuritySettings.Visible = true;
            btnImgDeletePub.ImageUrl = Root.Domain + "/Framework/images/icon_squareArrow.gif";

            grdEditPublications.DataBind();
            upnlEditSection.Update();
        }

        protected void btnDeleteCustomOnly_OnClick(object sender, EventArgs e)
        {
            // PRG: Double-check we're using the correct username variable here
            //myParameters.Add("@username", (string)Session["ProfileUsername"]));
            Utilities.DataIO data = new Profiles.Edit.Utilities.DataIO();
            data.DeleteGroupPublications(_personId, _subject, false, true);
            this.Counter = 0;
            phAddPub.Visible = true;
            phAddMemberPubs.Visible = true;
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
            // PRG: Double-check we're using the correct username variable here
            //myParameters.Add("@username", (string)Session["ProfileUsername"]));
            Utilities.DataIO data = new Profiles.Edit.Utilities.DataIO();
            data.DeleteGroupPublications(_personId, _subject, true, true);
            this.Counter = 0;
            phAddPub.Visible = true;
            phAddMemberPubs.Visible = true;
            phAddPubMed.Visible = true;
            phAddCustom.Visible = true;
            phSecuritySettings.Visible = true;
            pnlDeletePubMed.Visible = false;
            btnImgDeletePub.ImageUrl = Root.Domain + "/Framework/images/icon_squareArrow.gif";

            grdEditPublications.DataBind();
            upnlEditSection.Update();
        }

        #endregion

        private XmlDocument PropertyListXML { get; set; }

        public string HttpPost(string myUri, string myXml, string contentType)
        {
            Uri uri = new Uri(myUri);
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

        private Int16 Counter { get; set; }


        public class GroupPublicationOptionItem
        {
            public GroupPublicationOptionItem(string label, string description, int code)
            {
                this.Label = label;
                this.Description = description;
                this.Code = code;
            }

            public string Label { get; set; }
            public string Description { get; set; }
            public int Code { get; set; }
        }
    }
}