/*  
 
    Copyright (c) 2008-2012 by the President and Fellows of Harvard College. All rights reserved.  
    Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
    and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
    National Center for Research Resources and Harvard University.


    Code licensed under a BSD License. 
    For details, see: LICENSE.txt 
  
*/
using System;
using System.Collections.Generic;
using System.Web.UI.WebControls;
using System.Xml;

using Profiles.Framework.Utilities;
using Profiles.Edit.Utilities;


namespace Profiles.Edit.Modules.CustomEditWebsite
{
    public partial class CustomEditWebsite : BaseModule
    {

        Profiles.Edit.Modules.CustomEditWebsite.DataIO data;
        protected void Page_Load(object sender, EventArgs e)
        {
            this.FillAwardGrid(false);
            
            if (!IsPostBack)
                Session["pnlInsertAward.Visible"] = null;
        }

        public CustomEditWebsite() : base() { }
        public CustomEditWebsite(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
            : base(pagedata, moduleparams, pagenamespaces)
        {
            SessionManagement sm = new SessionManagement();
            this.XMLData = pagedata;

            data = new Profiles.Edit.Modules.CustomEditWebsite.DataIO();
            Profiles.Profile.Utilities.DataIO propdata = new Profiles.Profile.Utilities.DataIO();

            if (Request.QueryString["subject"] != null)
                this.SubjectID = Convert.ToInt64(Request.QueryString["subject"]);
            else if (base.GetRawQueryStringItem("subject") != null)
                this.SubjectID = Convert.ToInt64(base.GetRawQueryStringItem("subject"));
            else
                Response.Redirect("~/search");

            Predicate = Request.QueryString["predicateuri"].Replace("!", "#");
            this.PropertyListXML = propdata.GetPropertyList(this.BaseData, base.PresentationXML, Predicate, false, true, false);

            this.PredicateID = data.GetStoreNode(Predicate);

            base.GetNetworkProfile(this.SubjectID, this.PredicateID);

            litBackLink.Text = "<a href='" + Root.Domain + "/edit/" + this.SubjectID.ToString() + "'>Edit Menu</a> &gt; <b>" + PropertyListXML.SelectSingleNode("PropertyList/PropertyGroup/Property/@Label").Value + "</b>";

            litAddAwardsText.Text = "Add " + PropertyListXML.SelectSingleNode("PropertyList/PropertyGroup/Property/@Label").Value + "(s)";
            lblNoAwards.Text = "No " + PropertyListXML.SelectSingleNode("PropertyList/PropertyGroup/Property/@Label").Value + "s have been added.";

            securityOptions.Subject = this.SubjectID;
            securityOptions.PredicateURI = Predicate;
            securityOptions.PrivacyCode = Convert.ToInt32(this.PropertyListXML.SelectSingleNode("PropertyList/PropertyGroup/Property/@ViewSecurityGroup").Value);
            securityOptions.SecurityGroups = new XmlDataDocument();
            securityOptions.SecurityGroups.LoadXml(base.PresentationXML.DocumentElement.LastChild.OuterXml);

            if (Request.QueryString["new"] != null && Session["new"] != null)
            {
                Session["pnlInsertAward.Visible"] = null;
                Session["new"] = null;

                if (Session["newclose"] != null)
                {
                    Session["newclose"] = null;
                    btnInsertCancel_OnClick(this,new EventArgs());

                }
                else
                {
                    btnEditAwards_OnClick(this, new EventArgs());
                }

            }

            securityOptions.BubbleClick += SecurityDisplayed;

        }

        #region Awards

        private void SecurityDisplayed(object sender, EventArgs e)
        {

            
            if (Session["pnlSecurityOptions.Visible"] == null)
            {
                pnlEditAwards.Visible = true;
                
            }
            else
            {
                pnlEditAwards.Visible = false;
                
            }
        }

        protected void btnEditAwards_OnClick(object sender, EventArgs e)
        {
            if (Session["pnlInsertAward.Visible"] == null)
            {
                btnInsertCancel_OnClick(sender, e);
                pnlSecurityOptions.Visible = false;
                pnlInsertAward.Visible = true;
                imbAddArror.ImageUrl = "~/Framework/Images/icon_squareDownArrow.gif";
                Session["pnlInsertAward.Visible"] = true;
            }
            else
            {
                Session["pnlInsertAward.Visible"] = null;
                pnlSecurityOptions.Visible = true;
                pnlInsertAward.Visible = false;
                imbAddArror.ImageUrl = "~/Framework/Images/icon_squareArrow.gif";

            }
            upnlEditSection.Update();
        }

        protected void GridViewAwards_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            TextBox txtTitle = null;
            TextBox txtURL = null;
            TextBox txtDate = null;
            ImageButton lnkEdit = null;
            ImageButton lnkDelete = null;

            WebsiteState websitestate = null;

            try
            {
                e.Row.Cells[4].Attributes.Add("style", "border-left:0px;");
            }
            catch (Exception ex) { }

            if (e.Row.RowType == DataControlRowType.DataRow)
            {

                txtTitle = (TextBox)e.Row.Cells[0].FindControl("txtTitle");
                txtURL = (TextBox)e.Row.Cells[1].FindControl("txtURL");
                txtDate = (TextBox)e.Row.Cells[2].FindControl("txtDate");

                lnkEdit = (ImageButton)e.Row.Cells[3].FindControl("lnkEdit");
                lnkDelete = (ImageButton)e.Row.Cells[3].FindControl("lnkDelete");

                websitestate = (WebsiteState)e.Row.DataItem;
/*
                if (websitestate.EditDelete == false)
                    lnkDelete.Visible = false;

                if (websitestate.EditExisting == false)
                    lnkEdit.Visible = false;
*/
            }

            if (e.Row.RowType == DataControlRowType.DataRow && (e.Row.RowState & DataControlRowState.Edit) == DataControlRowState.Edit)
            {
                txtTitle.Text = Server.HtmlDecode((string)txtTitle.Text);
                txtURL.Text = Server.HtmlDecode((string)txtURL.Text);
                txtDate.Text = Server.HtmlDecode((string)txtDate.Text);
            }

        }

        protected void GridViewAwards_RowEditing(object sender, GridViewEditEventArgs e)
        {
            GridViewWebsites.EditIndex = e.NewEditIndex;
            this.FillAwardGrid(false);

            upnlEditSection.Update();
        }

        protected void GridViewAwards_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            TextBox txtTitle = (TextBox)GridViewWebsites.Rows[e.RowIndex].FindControl("txtTitle");
            TextBox txtURL = (TextBox)GridViewWebsites.Rows[e.RowIndex].FindControl("txtURL");
            TextBox txtDate = (TextBox)GridViewWebsites.Rows[e.RowIndex].FindControl("txtDate");

            string URLID = GridViewWebsites.DataKeys[e.RowIndex].Values[0].ToString();

            string url = txtURL.Text;
            if (!(url.StartsWith("http://") || url.StartsWith("https://"))) url = "http://" + url;

            data.EditWebsiteData(URLID, url, txtTitle.Text, txtDate.Text, -1);
            GridViewWebsites.EditIndex = -1;
            Session["pnlInsertAward.Visible"] = null;
            this.FillAwardGrid(true);
            upnlEditSection.Update();
        }

        protected void GridViewAwards_RowUpdated(object sender, GridViewUpdatedEventArgs e)
        {
            this.FillAwardGrid(false);
            upnlEditSection.Update();
        }

        protected void GridViewAwards_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            GridViewWebsites.EditIndex = -1;
            this.FillAwardGrid(false);
            upnlEditSection.Update();
             
        }

        protected void GridViewAwards_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            string URLID = GridViewWebsites.DataKeys[e.RowIndex].Values[0].ToString();
            data.DeleteWebsite(URLID);
            GridViewWebsites.EditIndex = -1;
            this.FillAwardGrid(true);
        }

        protected void btnInsertCancel_OnClick(object sender, EventArgs e)
        {
            Session["pnlInsertAward.Visible"] = null;
            txtTitle.Text = "";
            txtURL.Text = "";
            txtPubDate.Text = "";
            if ("http://vivoweb.org/ontology/core#webpage".Equals(Predicate))
            {
                txtPubDate.Visible = false;
                litMediaText.Visible = false;
                litPubDateLabel.Visible = false;
            }
            else
            {
                litWebsiteText.Visible = false;
            }
            pnlInsertAward.Visible = false;
            upnlEditSection.Update();
        }

        protected void btnInsert_OnClick(object sender, EventArgs e)
        {
           if (txtURL.Text != "" && txtTitle.Text != "")
            {
                string url = txtURL.Text;
                if (!(url.StartsWith("http://") || url.StartsWith("https://"))) url = "http://" + url;
                data.AddWebsite(this.SubjectID, Predicate, url, txtTitle.Text, txtPubDate.Text);
            }

            txtTitle.Text = "";
            txtURL.Text = "";
            txtPubDate.Text = "";
            Session["pnlInsertAward.Visible"] = null;
            btnEditAwards_OnClick(sender, e);
            this.FillAwardGrid(true);
            if (GridViewWebsites.Rows.Count == 1)
            {
                Session["new"] = true;
                //stupid update panel bug we cant figure out.
                Response.Redirect(Request.Url.ToString() + "&new=true");
            }
            else
            {
                this.FillAwardGrid(true);
                upnlEditSection.Update();
            }
        }

        protected void btnInsertClose_OnClick(object sender, EventArgs e)
        {
            Session["pnlInsertAward.Visible"] = null;
            if (txtURL.Text != "" && txtTitle.Text != "")
            {
                string url = txtURL.Text;
                if (!(url.StartsWith("http://") || url.StartsWith("https://"))) url = "http://" + url;
                data.AddWebsite(this.SubjectID, Predicate, url, txtTitle.Text, txtPubDate.Text);


                txtTitle.Text = "";
                txtURL.Text = "";
                txtPubDate.Text = "";
                Session["pnlInsertAward.Visible"] = null;
                btnEditAwards_OnClick(sender, e);
                this.FillAwardGrid(true);
                if (GridViewWebsites.Rows.Count == 1)
                {
                    Session["new"] = true;
                    //stupid update panel bug we cant figure out.
                    Response.Redirect(Request.Url.ToString() + "&new=true");
                }
                else
                {
                    btnEditAwards_OnClick(sender, e);
                    this.FillAwardGrid(true);
                    upnlEditSection.Update();
                }

            }
        }
        protected void ibUp_Click(object sender, EventArgs e)
        {
            GridViewRow row = ((ImageButton)sender).Parent.Parent as GridViewRow;
            string URLID = GridViewWebsites.DataKeys[row.RowIndex].Values[0].ToString();
            data.EditWebsiteData(URLID, null, null, null, row.RowIndex);
            GridViewWebsites.EditIndex = -1;
            this.FillAwardGrid(true);
            upnlEditSection.Update();
        }

        protected void ibDown_Click(object sender, EventArgs e)
        {
            GridViewRow row = ((ImageButton)sender).Parent.Parent as GridViewRow;
            string URLID = GridViewWebsites.DataKeys[row.RowIndex].Values[0].ToString();
            data.EditWebsiteData(URLID, null, null, null, row.RowIndex + 2);
            GridViewWebsites.EditIndex = -1;
            this.FillAwardGrid(true);
            upnlEditSection.Update();
        }
        protected void FillAwardGrid(bool refresh)
        {

            List<WebsiteState> websiteState = new List<WebsiteState>();

            websiteState = data.GetWebsiteData(SubjectID, Predicate);

            if (websiteState.Count > 0)
            {
                GridViewWebsites.DataSource = websiteState;
                GridViewWebsites.DataBind();
                if ("http://vivoweb.org/ontology/core#webpage".Equals(Predicate)) GridViewWebsites.Columns[2].Visible = false;
            }
            else
            {
                lblNoAwards.Visible = true;
                GridViewWebsites.Visible = false;

            }

        }
        #endregion

        private Int64 SubjectID { get; set; }
        private Int64 PredicateID { get; set; }
        private string Predicate { get; set; }
        private XmlDocument XMLData { get; set; }
        private XmlDocument PropertyListXML { get; set; }




    }
}