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
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.Net;
using System.Text;
using System.IO;
using System.Globalization;

using Profiles.Framework.Utilities;
using Profiles.Profile.Utilities;
using Profiles.Edit.Utilities;



namespace Profiles.Edit.Modules.CustomEditResearcherRole
{
    public partial class CustomEditResearcherRole : BaseModule
    {

        #region Local Variables
        public int _personId = 0;
        public Int64 _subject = 0;
        private int _subgrantcount = 0;
        private string _parentrow = string.Empty;
        public string _predicateuri = string.Empty;
        Profiles.Profile.Utilities.DataIO propdata;
        private bool _clickedall = false;


        public CustomEditResearcherRole() { }
        public CustomEditResearcherRole(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
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

        private void SecurityDisplayed(object sender, EventArgs e)
        {


            if (Session["pnlSecurityOptions.Visible"] == null)
            {

                phAddGrant.Visible = true;
                phAddCustom.Visible = true;
                phDeleteGrant.Visible = true;

            }
            else
            {
                phAddGrant.Visible = false;
                phAddCustom.Visible = false;
                phDeleteGrant.Visible = false;

            }
        }

        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack)
            {
                if (HttpContext.Current.Session["GRANTREQUEST"] != null && Session["ADD"].ToString() != "true")
                {
                    //Need to stop this double post, its happening in an envent then it happens here after that event fires and a repost occurs. 

                    grdGrantSearchResults.DataSource = LoadFunding(CallAPI());
                    grdGrantSearchResults.DataBind();                    
                }

                Session["ADD"] = "false";

            }
            else
            {
                Session["pnlAddGrant.Visible"] = null;
                Session["pnlAddCustomGrant.Visible"] = null;
                Session["pnlDeleteGrant.Visible"] = null;
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
            litBackLink.Text = "<a Title='Edit Menu' href='" + Root.Domain + "/edit/" + _subject + "'>Edit Menu</a>" + " &gt; <b>" + PropertyListXML.SelectSingleNode("PropertyList/PropertyGroup/Property/@Label").Value + "</b>";
            LoadProjectYears();
            FillResearchGrid(true);
            
        }


        #region Add Grant By Search
        protected void btnSubmit_OnClick(object sender, EventArgs e)
        {
          
            SearchRequest = new GrantRequest();

            SearchRequest.FirstName = txtFirstName.Text.Trim();
            SearchRequest.LastName = txtLastName.Text.Trim();

            if (txtProjectNumber.Text.Trim() != string.Empty)
                SearchRequest.Project_Num = txtProjectNumber.Text.Trim();

            //ddlProjectYear

            if (ddlProjectYear.SelectedValue != string.Empty)
            {
                SearchRequest.Project_Year = ddlProjectYear.SelectedValue;
            }

            SearchRequest.Org_Name = txtOrganization.Text.Trim();
            SearchRequest.Project_Title = txtTitle.Text.Trim();
            Session["GRANTREQUEST"] = SearchRequest.StringRequest;
            grdGrantSearchResults.DataSource = LoadFunding(CallAPI());
            grdGrantSearchResults.DataBind();

            btnImgAddGrant.ImageUrl = Root.Domain + "/Framework/images/icon_squareDownArrow.gif";
            phAddCustom.Visible = false;
            phDeleteGrant.Visible = false;
            pnlAddGrantResults.Visible = false;
            pnlAddCustomGrant.Visible = false;
            phSecuritySettings.Visible = false;
            Session["pnlAddGrant.Visible"] = true;

            pnlAddGrantResults.Visible = true;
            upnlEditSection.Update();
          

        }
        protected void LoadProjectYears()
        {
            ddlProjectYear.Items.Add(new ListItem("Any Year", "")); //Nothing Selected for value.
            ddlProjectYear.Items.Add(new ListItem(DateTime.Now.Year.ToString()));
            for (int i = 1; i < 50; i++)
            {
                ddlProjectYear.Items.Add(new ListItem(DateTime.Now.AddYears(-i).Year.ToString()));
            }
        }
        protected void btnAddNewGrant_OnClick(object sender, EventArgs e)
        {
            if (Session["pnlAddGrant.Visible"] == null)
            {
                btnImgAddGrant.ImageUrl = Root.Domain + "/Framework/images/icon_squareDownArrow.gif";
                phAddCustom.Visible = false;
                phDeleteGrant.Visible = false;
                pnlAddGrant.Visible = true;
                pnlAddGrantResults.Visible = false;
                pnlAddCustomGrant.Visible = false;
                phSecuritySettings.Visible = false;
                Session["pnlAddGrant.Visible"] = true;
            }
            else
            {
                btnGrantClose_OnClick(sender, e);
                Session["pnlAddGrant.Visible"] = null;
            }

            upnlEditSection.Update();
        }
        protected void btnClear_OnClick(object sender, EventArgs e)
        {
            ResetGrantSearch();
            btnImgAddGrant.ImageUrl = Root.Domain + "/Framework/images/icon_squareDownArrow.gif";
            phAddCustom.Visible = false;
            phDeleteGrant.Visible = false;
            pnlAddGrant.Visible = true;
            pnlAddGrantResults.Visible = false;
            pnlAddCustomGrant.Visible = false;
            phSecuritySettings.Visible = false;
            Session["pnlAddGrant.Visible"] = true;
            upnlEditSection.Update();
        }

        protected void btnClose_OnClick(object sender, EventArgs e)
        {
            btnAddNewGrant_OnClick(sender, e);
        }
        private void ResetGrantSearch()
        {

            txtLastName.Text = "";
            txtFirstName.Text = "";
            txtOrganization.Text = "";
            txtProjectNumber.Text = "";
            txtTitle.Text = "";
            ddlProjectYear.Items[0].Selected = true;

            Session["pnlAddGrant.Visible"] = null;
            Session["pnlAddCustomGrant.Visible"] = null;
            Session["pnlDeleteGrant.Visible"] = null;
        }

        protected void btnGrantClose_OnClick(object sender, EventArgs e)
        {
            ResetGrantSearch();
            pnlAddGrant.Visible = false;
            phAddCustom.Visible = true;
            phDeleteGrant.Visible = true;
            phSecuritySettings.Visible = true;
            btnImgAddGrant.ImageUrl = Root.Domain + "/Framework/images/icon_squareArrow.gif";
            upnlEditSection.Update();
        }

        protected void btnGrantReset_OnClick(object sender, EventArgs e)
        {
            ResetGrantSearch();
            upnlEditSection.Update();
        }

        protected void grdGrantSearchResults_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType != DataControlRowType.DataRow) return;


            for (int i = 0; i < grdGrantSearchResults.Columns.Count; i++)
            {
                if (i == 0)
                    e.Row.Cells[i].Attributes.Add("style", "padding:5px 5px 5px 10px");
                else
                    e.Row.Cells[i].Attributes.Add("style", "padding:5px 5px 5px 0px");
            }


            if (_clickedall)
            {
                CheckBox chkGrant = (CheckBox)e.Row.FindControl("chkGrant");
                chkGrant.Checked = true;
            }

            FundingState grant = (FundingState)e.Row.DataItem as FundingState;
            List<FundingState> subgrants = new List<FundingState>();
            subgrants = grant.SubFundingState;

            GridView gvSubGrants = (GridView)e.Row.FindControl("grdSubGrantSearchResults");


            if (subgrants != null)
            {
                _subgrantcount = subgrants.Count;
                //todo:fix this hard coded color code issue. its in two places. 
                //If you change the color codes here, they will need to be changed in the grid view control as well. I was going to refac this soon.
                if (e.Row.RowState == DataControlRowState.Alternate)
                    _parentrow = "background-color:#FFFFFF;";
                else
                    _parentrow = "background-color:#dde4ee;";

                gvSubGrants.DataSource = subgrants;
                gvSubGrants.DataBind();
            }

        }

        protected void grdSubGrantSearchResults_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (!(e.Row.RowType == DataControlRowType.DataRow) && !(e.Row.RowType == DataControlRowType.Footer)) return;

            bool _rowzero = false;
            bool _lastrow = false;
            bool _firstcell = false;
            bool _footer = false;
            string _backgroundcolor = string.Empty;
            string _borderstyle = string.Empty;

            if (e.Row.RowIndex == _subgrantcount - 1)
            {
                _lastrow = true;
            }

            if (e.Row.RowIndex != 0)
            {
                e.Row.Cells[0].Text = "";
            }
            else if (e.Row.RowIndex == 0)
            {
                _rowzero = true;
                Image img = (Image)e.Row.FindControl("imgArrow");
                img.ImageUrl = Root.Domain + "/Edit/images/img_arrow.png";
            }

            for (int i = 0; i < grdGrantSearchResults.Columns.Count; i++)
            {
                if (e.Row.RowType == DataControlRowType.Footer)
                {
                    _footer = true;
                    _backgroundcolor = _parentrow;
                }

                if (e.Row.RowState == DataControlRowState.Alternate && !_footer)
                    _backgroundcolor = "background-color:#E6D9C8;";
                else if (e.Row.RowState == DataControlRowState.Normal && !_footer)
                    _backgroundcolor = "background-color:#F4EBE0;";

                if (i == 0)
                {
                    _firstcell = true;
                    _borderstyle = string.Empty;
                    _backgroundcolor = _parentrow;
                }

                if (i == 6 && !_footer) //6 is the last cell in the UI grid of sub grant search results
                    _borderstyle += "border-right:1px solid #AAA9A9;";

                if (i == 1 && !_footer)
                    _borderstyle += "border-left:1px solid #AAA9A9;";

                if (!(i == 0) && !_footer)
                {
                    //1 is the first cell in the UI grid of sub grant search results
                    if (_lastrow)
                        _borderstyle += "border-bottom: 1px solid #AAA9A9;";

                    if (_rowzero)
                        _borderstyle += "border-top: 1px solid #AAA9A9;";
                }

                if (_footer)
                    e.Row.Cells[i].Attributes.Add("style", string.Format("{0}", _backgroundcolor));
                else
                    e.Row.Cells[i].Attributes.Add("style", string.Format("{0}{1}padding-top:5px;padding-right:5px;padding-bottom:5px;", _backgroundcolor, _borderstyle));

                _borderstyle = string.Empty;
                //todo:null this stuff out, there is more
                _backgroundcolor = string.Empty;
                _firstcell = false;
            }

        }

        private bool RoleTest(string PI)
        {

            bool pi = false;

            if (PI.ToLower().Contains(base.BaseData.SelectSingleNode("rdf:RDF/rdf:Description/foaf:lastName", base.Namespaces).InnerText.ToLower()))
                pi = true;


            return pi;

        }


        /// <summary>
        /// If the user clicks the overall project, 
        /// then FundingID = core_project_num and FundingID2 = core_project_num.
        /// If the user selects a subproject, 
        /// then FundingID = full_project_num and FundingID2 = core_project_num.
        /// </summary>        
        protected void btnGrantAddSelected_OnClick(object sender, EventArgs e)
        {
            string value = "";
            string seperator = "";
            Edit.Utilities.DataIO data = new Edit.Utilities.DataIO();
            List<FundingState> funding = LoadFunding(CallAPI());


            foreach (GridViewRow row in grdGrantSearchResults.Rows)
            {

                CheckBox cb = (CheckBox)row.FindControl("chkGrant");
                FundingState result = funding.Find(x => x.FundingID == (string)grdGrantSearchResults.DataKeys[row.RowIndex]["FundingID"]);

                if (cb.Checked)
                {
                    if (RoleTest(result.PrincipalInvestigatorName))
                        result.RoleLabel = "Principal Investigator";
                    else
                        result.RoleLabel = "Co-Investigator";

                    result.FundingRoleID = Guid.NewGuid();

                    data.AddUpdateFunding(new FundingState
                    {
                        FundingRoleID = result.FundingRoleID,
                        PersonID = this._personId,
                        FullFundingID = result.CoreProjectNum,
                        CoreProjectNum = result.CoreProjectNum,
                        RoleLabel = result.RoleLabel,
                        RoleDescription = result.RoleDescription,
                        GrantAwardedBy = result.GrantAwardedBy,
                        StartDate = result.StartDate,
                        EndDate = result.EndDate,
                        PrincipalInvestigatorName = result.PrincipalInvestigatorName,
                        Abstract = result.Abstract,
                        AgreementLabel = result.AgreementLabel,
                        Source = "NIH"
                    });
                }


                GridView subgrants = (GridView)row.FindControl("grdSubGrantSearchResults");

                foreach (GridViewRow subrow in subgrants.Rows)
                {
                    CheckBox subcb = (CheckBox)subrow.FindControl("chkSubGrant");
                    FundingState subresult = result.SubFundingState.Find(x => x.FullFundingID == (string)subgrants.DataKeys[subrow.RowIndex]["FullFundingID"]);
                    if (subcb.Checked)
                    {
                        if (RoleTest(subresult.PrincipalInvestigatorName))
                            subresult.RoleLabel = "Principal Investigator";
                        else
                            subresult.RoleLabel = "Co-Investigator";

                        subresult.FundingRoleID = Guid.NewGuid();
                        data.AddUpdateFunding(new FundingState
                        {
                            FundingRoleID = subresult.FundingRoleID,
                            PersonID = this._personId,
                            FullFundingID = subresult.FullFundingID,
                            CoreProjectNum = subresult.CoreProjectNum,
                            RoleLabel = subresult.RoleLabel,
                            RoleDescription = subresult.RoleDescription,
                            GrantAwardedBy = subresult.GrantAwardedBy,
                            StartDate = subresult.StartDate,
                            EndDate = subresult.EndDate,
                            PrincipalInvestigatorName = subresult.PrincipalInvestigatorName,
                            Abstract = subresult.Abstract,
                            AgreementLabel = subresult.AgreementLabel,
                            Source = "NIH"
                        });
                    }
                }

            }



            //after the batch is completed, call this method once,  same as publications.  All you need is the person ID.
            data.FundingUpdateOnePerson(new FundingState { PersonID = this._personId });

            //Clear form and grid after insert
            ResetGrantSearch();
            pnlAddGrantResults.Visible = false;
            pnlAddGrant.Visible = false;
            phAddCustom.Visible = true;
            phDeleteGrant.Visible = true;
            phSecuritySettings.Visible = true;
            btnImgAddGrant.ImageUrl = Root.Domain + "/Framework/images/icon_squareArrow.gif";
            FillResearchGrid(true);
            upnlEditSection.Update();
            Session["ADD"] = "true";
        }

        private string CallAPI()
        {
            if (SearchRequest == null)
                SearchRequest = new GrantRequest();


            //TODO: need to refactor all the posts in Profiles to a central static method. 
            string stringrequest = (string)HttpContext.Current.Session["GRANTREQUEST"];
            if (stringrequest != null)
            {
                SearchRequest.StringRequest = stringrequest;

                string result = (string)Framework.Utilities.Cache.FetchObject(SearchRequest.StringRequest);
              
                if (result == null)
                {
                    try
                    {
                        System.Net.HttpWebRequest request = null;
                        request = (System.Net.HttpWebRequest)System.Net.WebRequest.Create(System.Configuration.ConfigurationManager.AppSettings["GrantEndPoint"]);
                        request.Method = "POST";
                        request.ContentType = "text/xml";
                        request.ContentLength = SearchRequest.StringRequest.Length;

                        using (Stream writeStream = request.GetRequestStream())
                        {
                            UTF8Encoding encoding = new UTF8Encoding();
                            byte[] bytes = encoding.GetBytes(SearchRequest.StringRequest);
                            writeStream.Write(bytes, 0, bytes.Length);
                        }

                        using (System.Net.HttpWebResponse response = (System.Net.HttpWebResponse)request.GetResponse())
                        {
                            using (Stream responseStream = response.GetResponseStream())
                            {
                                using (StreamReader readStream = new StreamReader(responseStream, Encoding.UTF8))
                                {
                                    result = readStream.ReadToEnd();
                                }
                            }
                        }

                        result = result.ToLower() == "error" ? "" : result;

                        Framework.Utilities.Cache.SetWithTimeout(SearchRequest.StringRequest, result,54000 );

                        return result;

                    }
                    catch (Exception ex)
                    {
                        return result;
                    }
                }
                else
                {
                    return (string)result;
                }
            }
            else
                return "";

        }

        #endregion

        #region Add Grant Custom

        protected void btnAddCustom_OnClick(object sender, EventArgs e)
        {
            if (Session["pnlAddCustomGrant.Visible"] == null)
            {
                btnImgAddCustom.ImageUrl = Root.Domain + "/Framework/images/icon_squareDownArrow.gif";
                phAddGrant.Visible = false;
                phDeleteGrant.Visible = false;
                pnlAddCustomGrant.Visible = true;
                phSecuritySettings.Visible = false;
                Session["pnlAddCustomGrant.Visible"] = true;
            }
            else
            {

                phAddGrant.Visible = true;
                phDeleteGrant.Visible = true;
                pnlAddCustomGrant.Visible = false;
                phSecuritySettings.Visible = true;
                Session["pnlAddCustomGrant.Visible"] = null;
            }

            upnlEditSection.Update();
        }



        #endregion

        #region GrantPageStuff

        protected void btnUncheckAll_OnClick(object sender, EventArgs e)
        {
            this._clickedall = false;
        }
        protected void btnCheckAll_OnClick(object sender, EventArgs e)
        {
            this._clickedall = true;

            pnlAddGrantResults.Visible = true;

            grdGrantSearchResults.DataSource = LoadFunding(CallAPI());
            grdGrantSearchResults.DataBind();
            pnlAddGrantResults.Visible = true;
            upnlEditSection.Update();

        }
        protected void GridViewResearcherRole_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            ImageButton lnkEdit = null;
            ImageButton lnkDelete = null;

            FundingState fundingstate = null;
            string pi = string.Empty;
            string date = string.Empty;


            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                fundingstate = (FundingState)e.Row.DataItem;

                Literal lblFundingItem = (Literal)e.Row.FindControl("lblFundingItem");

                FundingState fs = (FundingState)e.Row.DataItem;

                lblFundingItem.Text = "<table width='650px' border='0'><tr><td width='450px'>";

                if (fs.PrincipalInvestigatorName != string.Empty)
                    pi = "(" + fs.PrincipalInvestigatorName.Trim() + ")";


                if (fs.FundingID != string.Empty)
                    lblFundingItem.Text += fs.FullFundingID + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + pi;
                else
                    lblFundingItem.Text += pi;


                if (fs.StartDate != "?")
                    date = fs.StartDate;

                if (fs.EndDate != "?")
                {
                    if (date != string.Empty)
                        date += "&nbsp;-&nbsp;" + fs.EndDate;
                    else
                        date = fs.EndDate;
                }
                else if(fs.StartDate =="?" && fs.EndDate =="?")
                    date = string.Empty;


                lblFundingItem.Text += "</td><td valign='right' width='200px'>" + date + "</td></tr>";
                lblFundingItem.Text += "<tr><td colspan='2'>" + fs.GrantAwardedBy + "</td></tr>";
                lblFundingItem.Text += "<tr><td colspan='2'>" + fs.AgreementLabel + "</td></tr>";
                lblFundingItem.Text += "<tr><td colspan='2'>" + fs.RoleDescription + "</td></tr>";
                if (fs.RoleLabel != string.Empty)
                    lblFundingItem.Text += "<tr><td colspan='2'>Role: " + fs.RoleLabel + "</td><tr>";
                lblFundingItem.Text += "</table>";

                lnkEdit = (ImageButton)e.Row.FindControl("lnkEdit");
                lnkEdit.CommandArgument = fundingstate.FundingRoleID.ToString();
                lnkDelete = (ImageButton)e.Row.FindControl("lnkDelete");
                lnkDelete.CommandArgument = fundingstate.FundingRoleID.ToString();
            }
        }

        protected void grdEditGrants_RowDataBound(object sender, GridViewRowEventArgs e)
        {

            if (e.Row.RowType == DataControlRowType.DataRow)
            {

                Label lblFundingItem = (Label)e.Row.FindControl("lblFundingItem");

                FundingState fs = (FundingState)e.Row.DataItem;


                lblFundingItem.Text = "<div><span style='float:left'>" + fs.FullFundingID + "</span>&nbsp;(" + fs.PrincipalInvestigatorName + ")<span style='float:right'>" + fs.StartDate + " - " + fs.EndDate + "</span></div>";
                if (fs.GrantAwardedBy != string.Empty)
                    lblFundingItem.Text += "<div style='float:right'>" + fs.GrantAwardedBy + "</div>";
                if (fs.AgreementLabel != string.Empty)
                    lblFundingItem.Text += "<div style='fload:right'>" + fs.AgreementLabel + "</div>";
                if (fs.RoleDescription != string.Empty)
                    lblFundingItem.Text += "<div style='float:right'>" + fs.RoleDescription + "</div>";
                if (fs.RoleLabel != string.Empty)
                    lblFundingItem.Text += "<div style='float:right'>" + fs.RoleLabel + "</div>";


            }
        }


        protected void btnInsertCancel_OnClick(object sender, EventArgs e)
        {
            Session["pnlAddCustomGrant.Visible"] = null;
            pnlAddCustomGrant.Visible = false;
            upnlEditSection.Update();
        }
        private void ClearFields()
        {

            txtStartYear.Text = "";
            txtEndYear.Text = "";
            txtRole.Text = "";
            txtRoleDescription.Text = "";
            txtSponsorAwardID.Text = "";
            txtGrantAwardedBy.Text = "";
            txtPIName.Text = "";
            txtAbstract.Text = "";
            txtProjectTitle.Text = "";
        }


        private void AddFunding()
        {
            string startyear = txtStartYear.Text.Trim();
            string endyear = txtEndYear.Text.Trim();
            string role = txtRole.Text.Trim();

            string roledesc = txtRoleDescription.Text.Trim();
            string sponsorid = txtSponsorAwardID.Text.Trim();
            string grantawardedby = txtGrantAwardedBy.Text.Trim();
            string piname = txtPIName.Text.Trim();
            string projecttitle = txtProjectTitle.Text.Trim();
            string _abstract = txtAbstract.Text.Trim();
            string source = "";
            Guid FundingRoleID;

            Edit.Utilities.DataIO data = new Utilities.DataIO();

            if (HttpContext.Current.Session["FundingRoleID"] != null) //Edit existing
                FundingRoleID = new Guid((string)HttpContext.Current.Session["FundingRoleID"]);
            else
            {
                FundingRoleID = Guid.NewGuid(); //Then its an add.
                source = "Custom";
            }

            //Need to test if edit or insert.  This form/button is used for both.            
            data.AddUpdateFunding(new FundingState
            {
                FundingRoleID = FundingRoleID,
                PersonID = this._personId,
                FundingID = sponsorid,
                FullFundingID = sponsorid,
                RoleLabel = role,
                RoleDescription = roledesc,
                GrantAwardedBy = grantawardedby,
                StartDate = startyear,
                EndDate = endyear,
                PrincipalInvestigatorName = piname,
                Abstract = _abstract,
                AgreementLabel = projecttitle,
                Source = source //"NIH"
            });

            //after the batch is completed, call this method once,  same as publications.  All you need is the person ID.
            data.FundingUpdateOnePerson(new FundingState { PersonID = this._personId });


            HttpContext.Current.Session["FundingRoleID"] = null;

            ClearFields();

        }
        protected void btnInsert_OnClick(object sender, EventArgs e)
        {
            AddFunding();
            Session["pnlAddCustomGrant.Visible"] = null;
            btnAddCustom_OnClick(sender, e);
            this.FillResearchGrid(true);
            upnlEditSection.Update();
        }

        protected void btnInsertClose_OnClick(object sender, EventArgs e)
        {

            AddFunding();
            Session["pnlAddCustomGrant.Visible"] = null;
            this.FillResearchGrid(true);
            btnInsertCancel_OnClick(sender, e);
            upnlEditSection.Update();

        }

        protected void FillResearchGrid(bool refresh)
        {
            //todo:i need to refactor the regions.  
            Edit.Utilities.DataIO data = new Utilities.DataIO();

            List<FundingState> fundingstate = new List<FundingState>();

            bool editexisting = false;
            bool editaddnew = false;
            bool editdelete = false;

            if (this.PropertyListXML.SelectSingleNode("PropertyList/PropertyGroup/Property/@EditExisting").Value.ToLower() == "true" ||
             this.PropertyListXML.SelectSingleNode("PropertyList/PropertyGroup/Property/@CustomEdit").Value.ToLower() == "true")
                editexisting = true;

            if (this.PropertyListXML.SelectSingleNode("PropertyList/PropertyGroup/Property/@EditAddNew").Value.ToLower() == "true" ||
                this.PropertyListXML.SelectSingleNode("PropertyList/PropertyGroup/Property/@CustomEdit").Value.ToLower() == "true")
                editaddnew = true;

            if (this.PropertyListXML.SelectSingleNode("PropertyList/PropertyGroup/Property/@EditDelete").Value.ToLower() == "true" ||
                this.PropertyListXML.SelectSingleNode("PropertyList/PropertyGroup/Property/@CustomEdit").Value.ToLower() == "true")
                editdelete = true;


            this.SubjectID = Convert.ToInt64(base.GetRawQueryStringItem("subject"));
            ClearFields();

            List<FundingState> fs = data.GetFunding(_personId);
            if (fs.Count > 0)
            {
                GridViewResearcherRole.DataSource = fs;
                GridViewResearcherRole.DataBind();
                GridViewResearcherRole.Visible = true;
                lblNoResearcherRole.Visible = false;
            }
            else
            {
                lblNoResearcherRole.Visible = true;
                GridViewResearcherRole.Visible = false;
            }

            upnlEditSection.Update();
        }


        protected void editOne_Onclick(object sender, EventArgs e)
        {
            ImageButton lb = (ImageButton)sender;

            string key = lb.CommandArgument;
            Session["FundingRoleID"] = null;
            //string key = grdEditPublications.DataKeys[0].Value.ToString();
            Utilities.DataIO data = new Profiles.Edit.Utilities.DataIO();
            FundingState fs = data.GetFundingItem(new Guid(key));

            //btnAddCustom_OnClick(sender, e);                        
            pnlAddCustomGrant.Visible = true;
            btnInsertResearcherRole.Visible = false;
            lblInsertResearcherRolePipe.Visible = false;

            Session["pnlAddCustomGrant.Visible"] = true;

            ClearFields();

            txtAbstract.Text = fs.Abstract;
            txtGrantAwardedBy.Text = fs.GrantAwardedBy;
            txtPIName.Text = fs.PrincipalInvestigatorName;
            txtRole.Text = fs.RoleLabel;
            txtProjectTitle.Text = fs.AgreementLabel;
            txtRoleDescription.Text = fs.RoleDescription;
            txtSponsorAwardID.Text = fs.FullFundingID;  //TODO: not sure on the mapping of this one.
            txtStartYear.Text = fs.StartDate == "?" ? "" : fs.StartDate;
            txtEndYear.Text = fs.EndDate == "?" ? "" : fs.EndDate;

            if (fs.Source == "NIH")
            {
                SetForNIH(ref txtAbstract);
                SetForNIH(ref txtEndYear);
                SetForNIH(ref txtGrantAwardedBy);
                SetForNIH(ref txtPIName);
                SetForNIH(ref txtProjectTitle);
                SetForNIH(ref txtSponsorAwardID);
                SetForNIH(ref txtStartYear);
            }


            Session["FundingRoleID"] = fs.FundingRoleID.ToString();

        }

        private void SetForNIH(ref TextBox textbox)
        {
            textbox.ReadOnly = true;
            //textbox.Style.Add("border-Style", "none");
            textbox.Style.Add("background-Color", "#D1D0CE");

            textbox.Style["font-corlor"] = "black";
            dateValidator1.Enabled = false;
            dateValidator2.Enabled = false;
            btnCalendar2.Visible = false;
            btnCalendar3.Visible = false;

        }
        protected void deleteOne_Onclick(object sender, EventArgs e)
        {
            ImageButton lb = (ImageButton)sender;

            string key = lb.CommandArgument;

            //string key = grdEditPublications.DataKeys[0].Value.ToString();
            Utilities.DataIO data = new Profiles.Edit.Utilities.DataIO();

            data.DeleteFunding(new Guid(key), data.GetPersonID(this.SubjectID));
            //after the batch is completed, call this method once,  same as publications.  All you need is the person ID.
            data.FundingUpdateOnePerson(new FundingState { PersonID = this._personId });

            
            FillResearchGrid(false);
            upnlEditSection.Update();

        }
        #endregion

        #region DeleteGrant

        protected void btnDeleteGrant_OnClick(object sender, EventArgs e)
        {
            if (Session["pnlDeleteGrant.Visible"] == null)
            {
                btnImgDeleteGrant.ImageUrl = Root.Domain + "/Framework/images/icon_squareDownArrow.gif";
                phAddCustom.Visible = false;
                phAddGrant.Visible = false;
                pnlDeleteGrant.Visible = true;
                pnlAddGrant.Visible = false;
                pnlAddGrantResults.Visible = false;
                pnlAddCustomGrant.Visible = false;
                phSecuritySettings.Visible = false;
                Session["pnlDeleteGrant.Visible"] = true;
            }
            else
            {
                Session["pnlDeleteGrant.Visible"] = null;
                btnDeleteGrantClose_OnClick(sender, e);

            }
            upnlEditSection.Update();
        }


        protected void btnDeleteAll_OnClick(object sender, EventArgs e)
        {
            Utilities.DataIO data = new Profiles.Edit.Utilities.DataIO();

            FillResearchGrid(true);
            foreach (GridViewRow row in GridViewResearcherRole.Rows)
            {
                data.DeleteFunding((Guid)GridViewResearcherRole.DataKeys[row.RowIndex]["FundingRoleID"], _personId);
            }


            //after the batch is completed, call this method once,  same as publications.  All you need is the person ID.
            data.FundingUpdateOnePerson(new FundingState { PersonID = this._personId });
            
            phAddGrant.Visible = true;
            phAddCustom.Visible = true;
            phSecuritySettings.Visible = true;
            pnlDeleteGrant.Visible = false;
            btnImgDeleteGrant.ImageUrl = Root.Domain + "/Framework/images/icon_squareArrow.gif";
            FillResearchGrid(true);
            upnlEditSection.Update();
        }
        protected void btnDeleteGrantClose_OnClick(object sender, EventArgs e)
        {
            phAddGrant.Visible = true;
            phAddCustom.Visible = true;
            phDeleteGrant.Visible = true;
            phSecuritySettings.Visible = true;
            pnlDeleteGrant.Visible = false;
            btnImgDeleteGrant.ImageUrl = Root.Domain + "/Framework/images/icon_squareArrow.gif";
            upnlEditSection.Update();
        }


        protected void btnDeleteNIHOnly_OnClick(object sender, EventArgs e)
        {
            Utilities.DataIO data = new Profiles.Edit.Utilities.DataIO();

            List<FundingState> fs = (List<FundingState>)GridViewResearcherRole.DataSource;
            foreach (FundingState row in fs)
            {

                if (row.Source == "NIH")
                    data.DeleteFunding(row.FundingRoleID, _personId);
            }

            //after the batch is completed, call this method once,  same as publications.  All you need is the person ID.
            data.FundingUpdateOnePerson(new FundingState { PersonID = this._personId });

            FillResearchGrid(true);
            upnlEditSection.Update();

        }

        protected void btnDeleteCustomOnly_OnClick(object sender, EventArgs e)
        {
            Utilities.DataIO data = new Profiles.Edit.Utilities.DataIO();
            List<FundingState> fs = (List<FundingState>)GridViewResearcherRole.DataSource;
            foreach (FundingState row in fs)
            {

                if (row.Source != "NIH")
                    data.DeleteFunding(row.FundingRoleID, _personId);
            }

            //after the batch is completed, call this method once,  same as publications.  All you need is the person ID.
            data.FundingUpdateOnePerson(new FundingState { PersonID = this._personId });
            FillResearchGrid(true);
            upnlEditSection.Update();

        }


        #endregion

        #region State


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
        
        private List<FundingState> LoadFunding(string rawxml)
        {

            XmlDocument xml = new XmlDocument();
            List<FundingState> funding = new List<FundingState>();

            FundingState item;
            if (rawxml != string.Empty)
            {
                xml.LoadXml(rawxml);

                //- <CORE_PROJECT>
                //        <CORE_PROJECT_NUM>A11NU000238</CORE_PROJECT_NUM> 
                //        <TITLE>PROFESSIONAL NURSE TRAINEESHIP</TITLE> 
                //        <PI_NAME>GRIFFITH, HURDIS M</PI_NAME> 
                //        <ORG_NAME>RUTGERS THE STATE UNIV OF NJ NEWARK</ORG_NAME> 
                //        <PROJECT_START>1976-08-01</PROJECT_START> 
                //        <PROJECT_END>1999-06-30</PROJECT_END> 
                //      - <FULL_PROJECT>
                //            <FULL_PROJECT_NUM>2A11NU000238-21</FULL_PROJECT_NUM> 
                //            <CORE_PROJECT_NUM>A11NU000238</CORE_PROJECT_NUM> 
                //            <TITLE>PROFESSIONAL NURSE TRAINEESHIP</TITLE> 
                //            <PI_NAME>NORMAN, ELIZABETH MARY</PI_NAME> 
                //            <ORG_NAME>RUTGERS THE STATE UNIV OF NJ NEWARK</ORG_NAME> 
                //            <PROJECT_START>1976-08-01</PROJECT_START> 
                //            <PROJECT_END>1999-06-30</PROJECT_END> 
                //        </FULL_PROJECT>
                //   </CORE_PROJECT>

                foreach (XmlNode x in xml.SelectNodes("PROJECTS/CORE_PROJECT"))
                {
                    try
                    {
                        funding.Add(new FundingState
                        {
                            FundingID = x.SelectSingleNode("CORE_PROJECT_NUM").InnerText,
                            CoreProjectNum = x.SelectSingleNode("CORE_PROJECT_NUM").InnerText,
                            FullFundingID = x.SelectSingleNode("FULL_PROJECT/FULL_PROJECT_NUM").InnerText,
                            GrantAwardedBy = x.SelectSingleNode("IC_NAME") != null ? x.SelectSingleNode("IC_NAME").InnerText : "",
                            AgreementLabel = x.SelectSingleNode("TITLE").InnerText,
                            PrincipalInvestigatorName = x.SelectSingleNode("PI_NAME") != null ? x.SelectSingleNode("PI_NAME").InnerText : "",
                            StartDate = String.Format("{0:M/d/yyyy}", DateTime.Parse(x.SelectSingleNode("PROJECT_START") != null ? x.SelectSingleNode("PROJECT_START").InnerText : "1/1/1900")),
                            EndDate = String.Format("{0:M/d/yyyy}", DateTime.Parse(x.SelectSingleNode("PROJECT_END") != null ? x.SelectSingleNode("PROJECT_END").InnerText : "1/1/1900")),
                            Abstract = x.SelectSingleNode("ABSTRACT_TEXT") != null ? x.SelectSingleNode("ABSTRACT_TEXT").InnerText : ""

                        });
                    }
                    catch (Exception ex)
                    {
                        Framework.Utilities.DebugLogging.Log(ex.Message);
                    }

                    try
                    {
                        foreach (XmlNode sub in x.SelectNodes("FULL_PROJECT"))
                        {
                            if (funding[funding.Count - 1].SubFundingState == null)
                                funding[funding.Count - 1].SubFundingState = new List<FundingState>();

                            funding[funding.Count - 1].SubFundingState.Add(new FundingState
                            {
                                FundingID = sub.SelectSingleNode("FULL_PROJECT_NUM").InnerText,
                                CoreProjectNum = sub.SelectSingleNode("CORE_PROJECT_NUM").InnerText,
                                FullFundingID = sub.SelectSingleNode("FULL_PROJECT_NUM").InnerText,
                                GrantAwardedBy = sub.SelectSingleNode("IC_NAME") != null ? sub.SelectSingleNode("IC_NAME").InnerText : "",
                                AgreementLabel = sub.SelectSingleNode("TITLE").InnerText,
                                PrincipalInvestigatorName = sub.SelectSingleNode("PI_NAME").InnerText,
                                StartDate = String.Format("{0:M/d/yyyy}", DateTime.Parse(sub.SelectSingleNode("PROJECT_START") != null ? sub.SelectSingleNode("PROJECT_START").InnerText : "1/1/1900")),
                                EndDate = String.Format("{0:M/d/yyyy}", DateTime.Parse(sub.SelectSingleNode("PROJECT_END") != null ? sub.SelectSingleNode("PROJECT_END").InnerText : "1/1/1900")),
                                Abstract = sub.SelectSingleNode("ABSTRACT_TEXT") != null ? sub.SelectSingleNode("ABSTRACT_TEXT").InnerText : ""

                            });
                        }
                    }
                    catch (Exception ex)
                    {

                        Framework.Utilities.DebugLogging.Log(ex.Message);

                    }

                }
            }
            return funding;
        }

        public GrantRequest SearchRequest { get; set; }

        public class GrantRequest
        {


            public GrantRequest()
            {
            }

            private string _firstname;
            private string _lastname;
            private string _project_year;
            private string _project_title;
            private string _project_num;
            private string _org_name;


            public bool Loaded { get; set; }

            public string FirstName
            {
                get { return "<First>" + _firstname + "</First>"; }
                set
                {
                    _firstname = value;
                    this.Loaded = true;
                }
            }

            public string LastName
            {
                get { return "<Last>" + _lastname + "</Last>"; }
                set { _lastname = value; this.Loaded = true; }
            }

            public string Project_Title
            {
                get { return "<Project_Title>" + _project_title + "</Project_Title>"; }
                set { _project_title = value; this.Loaded = true; }
            }

            public string Project_Num
            {
                get { return "<Project_Num>" + _project_num + "</Project_Num>"; }
                set { _project_num = value; this.Loaded = true; }
            }

            public string Project_Year
            {
                get { return "<Project_Year>" + _project_year + "</Project_Year>"; }
                set { _project_year = value; this.Loaded = true; }
            }

            public string Org_Name
            {
                get { return "<Org_Name>" + _org_name + "</Org_Name>"; }
                set { _org_name = value; this.Loaded = true; }
            }

            public string StringRequest
            {

                //<SearchGrants>
                //    <Project_Num>%U01%</Project_Num>
                //    <Org_Name>Harvard Medical School</Org_Name>
                //    <Name>
                //        <Last>Weber</Last>
                //        <First>Griffin</First>
                //    </Name>
                //    <Project_Year>2016</Project_Year>
                // </SearchGrants>

                get
                {
                    System.Text.StringBuilder sb = new System.Text.StringBuilder();

                    sb.Append("<SearchGrants>");
                    sb.Append("<Name>");
                    sb.Append(this.FirstName);
                    sb.Append(this.LastName);
                    sb.Append("</Name>");
                    sb.Append(this.Project_Num);
                    sb.Append(this.Project_Year);
                    sb.Append(this.Project_Title);
                    sb.Append(this.Org_Name);
                    sb.Append("</SearchGrants>");
                    if (this.Loaded)
                        return sb.ToString();
                    else
                        return string.Empty;
                }
                set
                {
                    string s = value;

                    try
                    {
                        XmlDocument x = new XmlDocument();
                        x.LoadXml(s);
                        this.FirstName = x.SelectSingleNode("SearchGrants/Name/First").InnerText;
                        this.LastName = x.SelectSingleNode("SearchGrants/Name/Last").InnerText;
                        this.Project_Num = x.SelectSingleNode("SearchGrants/Project_Num").InnerText;
                        this.Project_Year = x.SelectSingleNode("SearchGrants/Project_Year").InnerText;
                        this.Project_Title = x.SelectSingleNode("SearchGrants/Project_Title").InnerText;
                        this.Org_Name = x.SelectSingleNode("SearchGrants/Org_Name").InnerText;

                    }
                    catch (Exception ex) { string err = ex.Message; }

                }
            }



        }
        public string GetURLDomain()
        {
            return Root.Domain;
        }

        private Int64 SubjectID { get; set; }
        private Int64 PredicateID { get; set; }
        private XmlDocument XMLData { get; set; }
        #endregion

    }


}