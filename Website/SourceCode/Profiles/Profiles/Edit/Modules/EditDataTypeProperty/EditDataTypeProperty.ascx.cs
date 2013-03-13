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
using System.Collections;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.Xml.Xsl;
using Profiles.Framework.Utilities;
using Profiles.Profile.Utilities;
using System.Globalization;
using Profiles.Edit.Utilities;

namespace Profiles.Edit.Modules.EditDataTypeProperty
{
    public partial class EditDataTypeProperty : BaseModule
    {
        Edit.Utilities.DataIO data;
        Profiles.Profile.Utilities.DataIO propdata;

        protected void Page_Load(object sender, EventArgs e)
        {
            this.FillPropertyGrid(false);
            if (!IsPostBack)
            {
                Session["pnlInsertProperty.Visible"] = null;
            }

        }

        public EditDataTypeProperty() { }
        public EditDataTypeProperty(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
            : base(pagedata, moduleparams, pagenamespaces)
        {

            SessionManagement sm = new SessionManagement();
            propdata = new Profiles.Profile.Utilities.DataIO();
            data = new Profiles.Edit.Utilities.DataIO();
            string predicateuri = Request.QueryString["predicateuri"].Replace("!", "#");
            this.PropertyListXML = propdata.GetPropertyList(this.BaseData, base.PresentationXML, predicateuri, false, true, false);
            PropertyLabel = this.PropertyListXML.SelectSingleNode("PropertyList/PropertyGroup/Property/@Label").Value;

            if (Request.QueryString["subject"] != null)
                this.SubjectID = Convert.ToInt64(Request.QueryString["subject"]);
            else if (base.GetRawQueryStringItem("subject") != null)
                this.SubjectID = Convert.ToInt64(base.GetRawQueryStringItem("subject"));
            else
                Response.Redirect("~/search");

            litBackLink.Text = "<a href='" + Root.Domain + "/edit/" + this.SubjectID + "'>Edit Menu</a> &gt; <b>" + PropertyListXML.SelectSingleNode("PropertyList/PropertyGroup/Property/@Label").Value + "</b>";

            btnEditProperty.Text = "Add " + PropertyLabel;

            this.PropertyListXML = propdata.GetPropertyList(this.BaseData, base.PresentationXML, predicateuri, false, true, false);
            this.MaxCardinality = this.PropertyListXML.SelectSingleNode("PropertyList/PropertyGroup/Property/@MaxCardinality").Value;
            this.MinCardinality = this.PropertyListXML.SelectSingleNode("PropertyList/PropertyGroup/Property/@MinCardinality").Value;

            securityOptions.Subject = this.SubjectID;
            securityOptions.PredicateURI = predicateuri;
            securityOptions.PrivacyCode = Convert.ToInt32(this.PropertyListXML.SelectSingleNode("PropertyList/PropertyGroup/Property/@ViewSecurityGroup").Value);
            securityOptions.SecurityGroups = new XmlDataDocument();
            securityOptions.SecurityGroups.LoadXml(base.PresentationXML.DocumentElement.LastChild.OuterXml);


        }

        #region Property

        protected void btnEditProperty_OnClick(object sender, EventArgs e)
        {



            if (Session["pnlInsertProperty.Visible"] != null)
            {

                btnInsertCancel_OnClick(sender, e);
                imbAddArror.ImageUrl = "~/Framework/Images/icon_squareArrow.gif";
                Session["pnlInsertProperty.Visible"] = null;
            }
            else
            {
                pnlInsertProperty.Visible = true;
                imbAddArror.ImageUrl = "~/Framework/Images/icon_squareDownArrow.gif";
                Session["pnlInsertProperty.Visible"] = true;

            }
            upnlEditSection.Update();
        }

        protected void GridViewProperty_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            TextBox txtLabel = null;

            ImageButton lnkEdit = null;
            ImageButton lnkDelete = null;
            
            //  System.Web.UI.WebControls.Panel pnlMovePanel = null;
            LiteralState ls = (LiteralState)e.Row.DataItem;
            ImageButton ibUp = (ImageButton)e.Row.FindControl("ibUp");
            ImageButton ibDown = (ImageButton)e.Row.FindControl("ibDown");
            Label lblLabel = (Label)e.Row.FindControl("lblLabel");
            

            LiteralState literalstate = null;
            if (e.Row.RowType == DataControlRowType.Header)
            {
                e.Row.Cells[0].Text = PropertyLabel;
            }

            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                lnkEdit = (ImageButton)e.Row.Cells[1].FindControl("lnkEdit");
                lnkDelete = (ImageButton)e.Row.Cells[1].FindControl("lnkDelete");
                // pnlMovePanel = (System.Web.UI.WebControls.Panel)e.Row.Cells[2].FindControl("pnlMovePanel");


                literalstate = (LiteralState)e.Row.DataItem;

                if (literalstate.EditDelete == false)
                    lnkDelete.Visible = false;
                if (literalstate.EditExisting == false)
                {
                    lnkEdit.Visible = false;
                    //     pnlMovePanel.Visible = false;
                }
                else
                {
                    if (ibUp != null)
                        ibUp.CommandArgument = ls.Subject.ToString();
                }

                if (lnkDelete != null)
                    lnkDelete.OnClientClick = "Javascript:return confirm('Are you sure you want to delete this " + PropertyLabel + "?');";

                if(lblLabel!=null)
                lblLabel.Text = literalstate.Literal.Replace("\n", "<br/>");
                

            }

            if (e.Row.RowType == DataControlRowType.DataRow && (e.Row.RowState & DataControlRowState.Edit) == DataControlRowState.Edit)
            {
                txtLabel = (TextBox)e.Row.Cells[0].FindControl("txtLabel");
                txtLabel.Text = literalstate.Literal.Trim();
            }
        }

        protected void GridViewProperty_RowEditing(object sender, GridViewEditEventArgs e)
        {
            GridViewProperty.EditIndex = e.NewEditIndex;
            this.FillPropertyGrid(false);
            upnlEditSection.Update();
        }

        protected void GridViewProperty_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {

            HiddenField hdLabel = (HiddenField)GridViewProperty.Rows[e.RowIndex].FindControl("hdLabel");
            TextBox txtLabel = (TextBox)GridViewProperty.Rows[e.RowIndex].FindControl("txtLabel");

            data.UpdateLiteral(this.SubjectID, this.PredicateID, data.GetStoreNode(hdLabel.Value), data.GetStoreNode(txtLabel.Text.Trim()));
            GridViewProperty.EditIndex = -1;
            this.FillPropertyGrid(true);
            upnlEditSection.Update();
        }

        protected void GridViewProperty_RowUpdated(object sender, GridViewUpdatedEventArgs e)
        {
            this.FillPropertyGrid(false);
            upnlEditSection.Update();
        }

        protected void GridViewProperty_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            GridViewProperty.EditIndex = -1;

            this.FillPropertyGrid(false);
            upnlEditSection.Update();
        }

        protected void GridViewProperty_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            Int64 subject = Convert.ToInt64(GridViewProperty.DataKeys[e.RowIndex].Values[0].ToString());
            Int64 predicate = Convert.ToInt64(GridViewProperty.DataKeys[e.RowIndex].Values[1].ToString());
            Int64 _object = Convert.ToInt64(GridViewProperty.DataKeys[e.RowIndex].Values[2].ToString());

            data.DeleteTriple(subject, predicate, _object);

            this.FillPropertyGrid(true);
            upnlEditSection.Update();
        }

        protected void btnInsertCancel_OnClick(object sender, EventArgs e)
        {
            txtLabel.Text = "";
            pnlInsertProperty.Visible = false;
            upnlEditSection.Update();
        }

        protected void btnInsert_OnClick(object sender, EventArgs e)
        {
            if (Session["pnlInsertProperty.Visible"] != null)
            {
                data.AddLiteral(this.SubjectID, this.PredicateID, data.GetStoreNode(txtLabel.Text.Trim()));

                this.FillPropertyGrid(true);
                txtLabel.Text = "";
                Session["pnlInsertProperty.Visible"] = null;
                btnEditProperty_OnClick(sender, e);
                upnlEditSection.Update();
            }
        }

        protected void btnInsertClose_OnClick(object sender, EventArgs e)
        {
            if (Session["pnlInsertProperty.Visible"] != null)
            {
                data.AddLiteral(this.SubjectID, this.PredicateID, data.GetStoreNode(txtLabel.Text.Trim()));
                this.FillPropertyGrid(true);
                Session["pnlInsertProperty.Visible"] = null;
                btnInsertCancel_OnClick(sender, e);
            }
        }
        protected void ibUp_Click(object sender, EventArgs e)
        {

            GridViewRow row = ((ImageButton)sender).Parent.Parent as GridViewRow;
            GridViewProperty.EditIndex = -1;

            if (GridViewProperty.Rows.Count > 1)
            {
                Int64 subject = Convert.ToInt64(GridViewProperty.DataKeys[row.RowIndex].Values[0].ToString());
                Int64 predicate = Convert.ToInt64(GridViewProperty.DataKeys[row.RowIndex].Values[1].ToString());
                Int64 _object = Convert.ToInt64(GridViewProperty.DataKeys[row.RowIndex].Values[2].ToString());


                data.MoveTripleDown(subject, predicate, _object);

                this.FillPropertyGrid(true);
            }
            upnlEditSection.Update();


        }

        protected void ibDown_Click(object sender, EventArgs e)
        {
            GridViewRow row = ((ImageButton)sender).Parent.Parent as GridViewRow;
            GridViewProperty.EditIndex = -1;
            if (GridViewProperty.Rows.Count > 1)
            {
                Int64 subject = Convert.ToInt64(GridViewProperty.DataKeys[row.RowIndex].Values[0].ToString());
                Int64 predicate = Convert.ToInt64(GridViewProperty.DataKeys[row.RowIndex].Values[1].ToString());
                Int64 _object = Convert.ToInt64(GridViewProperty.DataKeys[row.RowIndex].Values[2].ToString());

                data.MoveTripleUp(subject, predicate, _object);
            }
            this.FillPropertyGrid(true);
            upnlEditSection.Update();

        }
        protected void FillPropertyGrid(bool refresh)
        {
            if (refresh)
            {
                base.GetSubjectProfile();
                this.PropertyListXML = propdata.GetPropertyList(this.BaseData, base.PresentationXML, this.PredicateURI, false, true, false);
            }

            List<LiteralState> literalstate = new List<LiteralState>();

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

            if (!editaddnew)
            {
                btnEditProperty.Visible = false;
                imbAddArror.Visible = false;
            }

            this.SubjectID = Convert.ToInt64(base.GetRawQueryStringItem("subject"));


            this.PredicateURI = Server.UrlDecode(base.GetRawQueryStringItem("predicateuri").Replace("!", "#"));
            this.PredicateID = data.GetStoreNode(this.PredicateURI);

            foreach (XmlNode property in this.PropertyListXML.SelectNodes("PropertyList/PropertyGroup/Property/Network/Connection"))
            {
                literalstate.Add(new LiteralState(this.SubjectID, this.PredicateID, data.GetStoreNode(property.InnerText.Trim()), property.InnerText.Trim(), editexisting, editdelete));
            }

            if (literalstate.Count > 0)
            {

                GridViewProperty.DataSource = literalstate;
                GridViewProperty.DataBind();
                lblNoItems.Visible = false;
                GridViewProperty.Visible = true;


                if (MaxCardinality == literalstate.Count.ToString())
                {
                    imbAddArror.Visible = false;
                    btnEditProperty.Visible = false;
                    btnInsertProperty.Visible = false;                    
                }



            }
            else
            {
                lblNoItems.Visible = true;
                GridViewProperty.Visible = false;
                imbAddArror.Visible = true;
                btnEditProperty.Visible = true;
                if (MaxCardinality == "1")
                { 
                    
                    
                    
                    btnInsertProperty.Visible = false;
                }
                upnlEditSection.Update();
            }


        }
        #endregion

        private Int64 SubjectID { get; set; }
        private Int64 PredicateID { get; set; }
        private string PredicateURI { get; set; }

        private XmlDocument XMLData { get; set; }

        private XmlDocument PropertyListXML { get; set; }
        private string PropertyLabel { get; set; }
        private string MaxCardinality { get; set; }
        private string MinCardinality { get; set; }


    }
}