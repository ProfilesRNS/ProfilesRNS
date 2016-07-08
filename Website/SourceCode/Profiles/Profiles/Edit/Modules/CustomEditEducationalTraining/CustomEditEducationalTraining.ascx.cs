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
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Data.Common;
using System.Globalization;
using System.Text;
using System.Xml;
using System.Xml.Xsl;

using Profiles.Framework.Utilities;
using Profiles.Profile.Utilities;
using Profiles.Edit.Utilities;


namespace Profiles.Edit.Modules.CustomEditEducationalTraining
{
    public partial class CustomEditEducationalTraining : BaseModule
    {

        Edit.Utilities.DataIO data;
        protected void Page_Load(object sender, EventArgs e)
        {
            this.FillEducationalTrainingGrid(false);
            
            if (!IsPostBack)
                Session["pnlInsertEducationalTraining.Visible"] = null;
        }

        public CustomEditEducationalTraining() : base() { }
        public CustomEditEducationalTraining(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
            : base(pagedata, moduleparams, pagenamespaces)
        {
            SessionManagement sm = new SessionManagement();
            this.XMLData = pagedata;

            data = new Edit.Utilities.DataIO();
            Profiles.Profile.Utilities.DataIO propdata = new Profiles.Profile.Utilities.DataIO();

            if (Request.QueryString["subject"] != null)
                this.SubjectID = Convert.ToInt64(Request.QueryString["subject"]);
            else if (base.GetRawQueryStringItem("subject") != null)
                this.SubjectID = Convert.ToInt64(base.GetRawQueryStringItem("subject"));
            else
                Response.Redirect("~/search");

            string predicateuri = Request.QueryString["predicateuri"].Replace("!", "#");
            this.PropertyListXML = propdata.GetPropertyList(this.BaseData, base.PresentationXML, predicateuri, false, true, false);

            this.PredicateID = data.GetStoreNode(predicateuri);

            base.GetNetworkProfile(this.SubjectID, this.PredicateID);

            litBackLink.Text = "<a href='" + Root.Domain + "/edit/" + this.SubjectID.ToString() + "'>Edit Menu</a> &gt; <b>" + PropertyListXML.SelectSingleNode("PropertyList/PropertyGroup/Property/@Label").Value + "</b>";


            securityOptions.Subject = this.SubjectID;
            securityOptions.PredicateURI = predicateuri;
            securityOptions.PrivacyCode = Convert.ToInt32(this.PropertyListXML.SelectSingleNode("PropertyList/PropertyGroup/Property/@ViewSecurityGroup").Value);
            securityOptions.SecurityGroups = new XmlDataDocument();
            securityOptions.SecurityGroups.LoadXml(base.PresentationXML.DocumentElement.LastChild.OuterXml);

            if (Request.QueryString["new"] != null && Session["new"] != null)
            {
                Session["pnlInsertEducationalTraining.Visible"] = null;
                Session["new"] = null;

                if (Session["newclose"] != null)
                {
                    Session["newclose"] = null;
                    btnInsertCancel_OnClick(this,new EventArgs());

                }
                else
                {
                    btnEditEducation_OnClick(this, new EventArgs());
                }

            }

            securityOptions.BubbleClick += SecurityDisplayed;

        }

        #region Education

        private void SecurityDisplayed(object sender, EventArgs e)
        {

            
            if (Session["pnlSecurityOptions.Visible"] == null)
            {
                pnlEditEducation.Visible = true;
                
            }
            else
            {
                pnlEditEducation.Visible = false;
                
            }
        }

        protected void btnEditEducation_OnClick(object sender, EventArgs e)
        {
            if (Session["pnlInsertEducationalTraining.Visible"] == null)
            {
                btnInsertCancel_OnClick(sender, e);
                pnlSecurityOptions.Visible = false;
                pnlInsertEducationalTraining.Visible = true;
                imbAddArror.ImageUrl = "~/Framework/Images/icon_squareDownArrow.gif";
                Session["pnlInsertEducationalTraining.Visible"] = true;
            }
            else
            {
                Session["pnlInsertEducationalTraining.Visible"] = null;
                pnlSecurityOptions.Visible = true;
                pnlInsertEducationalTraining.Visible = false;
                imbAddArror.ImageUrl = "~/Framework/Images/icon_squareArrow.gif";

            }
            upnlEditSection.Update();
        }

        protected void GridViewEducation_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            TextBox txtEducationalTrainingInst = null;
            TextBox txtEducationalTrainingLocation = null;
            TextBox txtEducationalTrainingDegree = null;
            TextBox txtYr2 = null;
            TextBox txtEducationalTrainingFieldOfStudy = null;
            ImageButton lnkEdit = null;
            ImageButton lnkDelete = null;
            HiddenField hdURI = null;

            EducationalTrainingState educationalTrainingState = null;

            try
            {
                e.Row.Cells[4].Attributes.Add("style", "border-left:0px;");
            }
            catch (Exception ex) { }

            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                txtEducationalTrainingInst = (TextBox)e.Row.Cells[3].FindControl("txtEducationalTrainingInst");
                txtEducationalTrainingLocation = (TextBox)e.Row.Cells[3].FindControl("txtEducationalTrainingLocation");
                txtEducationalTrainingDegree = (TextBox)e.Row.Cells[2].FindControl("txtEducationalTrainingDegree");
                txtYr2 = (TextBox)e.Row.Cells[1].FindControl("txtYr2");
                txtEducationalTrainingFieldOfStudy = (TextBox)e.Row.Cells[2].FindControl("txtEducationalTrainingFieldOfStudy");
                hdURI = (HiddenField)e.Row.Cells[3].FindControl("hdURI");

                lnkEdit = (ImageButton)e.Row.Cells[4].FindControl("lnkEdit");
                lnkDelete = (ImageButton)e.Row.Cells[4].FindControl("lnkDelete");

                educationalTrainingState = (EducationalTrainingState)e.Row.DataItem;
                hdURI.Value = educationalTrainingState.SubjectURI;

                if (educationalTrainingState.EditDelete == false)
                    lnkDelete.Visible = false;

                if (educationalTrainingState.EditExisting == false)
                    lnkEdit.Visible = false;

            }

            if (e.Row.RowType == DataControlRowType.DataRow && (e.Row.RowState & DataControlRowState.Edit) == DataControlRowState.Edit)
            {
                txtEducationalTrainingInst.Text = Server.HtmlDecode((string)txtEducationalTrainingInst.Text);
                txtEducationalTrainingLocation.Text = Server.HtmlDecode((string)txtEducationalTrainingLocation.Text);
                txtEducationalTrainingDegree.Text = Server.HtmlDecode((string)txtEducationalTrainingDegree.Text);
                txtYr2.Text = Server.HtmlDecode((string)txtYr2.Text);
                txtEducationalTrainingFieldOfStudy.Text = Server.HtmlDecode((string)txtEducationalTrainingFieldOfStudy.Text);

            }

        }

        protected void GridViewEducation_RowEditing(object sender, GridViewEditEventArgs e)
        {
            GridViewEducation.EditIndex = e.NewEditIndex;
            this.FillEducationalTrainingGrid(false);

            upnlEditSection.Update();
        }

        protected void GridViewEducation_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            TextBox txtEducationalTrainingInst = (TextBox)GridViewEducation.Rows[e.RowIndex].FindControl("txtEducationalTrainingInst");
            TextBox txtEducationalTrainingLocation = (TextBox)GridViewEducation.Rows[e.RowIndex].FindControl("txtEducationalTrainingLocation");
            TextBox txtEducationalTrainingDegree = (TextBox)GridViewEducation.Rows[e.RowIndex].FindControl("txtEducationalTrainingDegree");
            TextBox txtYr2 = (TextBox)GridViewEducation.Rows[e.RowIndex].FindControl("txtYr2");
            TextBox txtEducationalTrainingFieldOfStudy = (TextBox)GridViewEducation.Rows[e.RowIndex].FindControl("txtEducationalTrainingFieldOfStudy");

            HiddenField hdURI = (HiddenField)GridViewEducation.Rows[e.RowIndex].FindControl("hdURI");

            //data.AddEducationalTraining(this.SubjectID, txtInstitution.Text, txtLocation.Text, txtEducationalTrainingDegree.Text, txtEndYear.Text, txtFieldOfStudy.Text, this.PropertyListXML);
            data.UpdateEducationalTraining(hdURI.Value, this.SubjectID, txtEducationalTrainingInst.Text, txtEducationalTrainingLocation.Text, txtEducationalTrainingDegree.Text, txtYr2.Text, txtEducationalTrainingFieldOfStudy.Text);
            GridViewEducation.EditIndex = -1;
            Session["pnlInsertEducationalTraining.Visible"] = null;
            this.FillEducationalTrainingGrid(true);
            upnlEditSection.Update();
        }

        protected void GridViewEducation_RowUpdated(object sender, GridViewUpdatedEventArgs e)
        {
            this.FillEducationalTrainingGrid(false);
            upnlEditSection.Update();
        }

        protected void GridViewEducation_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            GridViewEducation.EditIndex = -1;

            this.FillEducationalTrainingGrid(false);
            upnlEditSection.Update();
        }

        protected void GridViewEducation_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {

            Int64 predicate = Convert.ToInt64(GridViewEducation.DataKeys[e.RowIndex].Values[1].ToString());
            Int64 _object = Convert.ToInt64(GridViewEducation.DataKeys[e.RowIndex].Values[2].ToString());

            data.DeleteTriple(this.SubjectID, predicate, _object);
            this.FillEducationalTrainingGrid(true);

            upnlEditSection.Update();
        }

        protected void btnInsertCancel_OnClick(object sender, EventArgs e)
        {
            Session["pnlInsertEducationalTraining.Visible"] = null;
            txtEndYear.Text = "";
            txtInstitution.Text = "";
            txtEducationalTrainingDegree.Text = "";
            txtEducationalTrainingSchool.Text = "";
            txtLocation.Text = "";
            txtFieldOfStudy.Text = "";
            pnlInsertEducationalTraining.Visible = false;
            upnlEditSection.Update();
        }

        protected void btnInsert_OnClick(object sender, EventArgs e)
        {
            if (txtEducationalTrainingDegree.Text != "" || txtInstitution.Text != "" || txtLocation.Text != "" || txtFieldOfStudy.Text != "")
            {
                data.AddEducationalTraining(this.SubjectID, txtInstitution.Text, txtLocation.Text, txtEducationalTrainingDegree.Text, txtEndYear.Text, txtFieldOfStudy.Text, this.PropertyListXML);


                txtEndYear.Text = "";
                txtInstitution.Text = "";
                txtEducationalTrainingDegree.Text = "";
                txtEducationalTrainingSchool.Text = "";
                txtLocation.Text = "";
                txtFieldOfStudy.Text = "";
                Session["pnlInsertEducationalTraining.Visible"] = null;
                btnEditEducation_OnClick(sender, e);
                this.FillEducationalTrainingGrid(true);
                if (GridViewEducation.Rows.Count == 1)
                {
                    Session["new"] = true;
                    //stupid update panel bug we cant figure out.
                    Response.Redirect(Request.Url.ToString() + "&new=true");
                }
                else
                {
                    this.FillEducationalTrainingGrid(true);
                    upnlEditSection.Update();
                }

            }

        }

        protected void btnInsertClose_OnClick(object sender, EventArgs e)
        {
            if (txtEducationalTrainingDegree.Text != "" || txtInstitution.Text != "" || txtLocation.Text != "" || txtFieldOfStudy.Text != "")
            {
                Session["pnlInsertEducationalTraining.Visible"] = null;
                data.AddEducationalTraining(this.SubjectID, txtInstitution.Text, txtLocation.Text, txtEducationalTrainingDegree.Text, txtEndYear.Text, txtFieldOfStudy.Text, this.PropertyListXML);

                this.FillEducationalTrainingGrid(true);


                if (GridViewEducation.Rows.Count == 1)
                {
                    Session["new"] = true;
                    Session["newclose"] = true;
                    //stupid update panel bug we cant figure out.
                    Response.Redirect(Request.Url.ToString() + "&new=true");
                }
                else
                {
                    btnInsertCancel_OnClick(sender, e);
                    upnlEditSection.Update();
                }


              
            }

        }
        protected void ibUp_Click(object sender, EventArgs e)
        {

            GridViewRow row = ((ImageButton)sender).Parent.Parent as GridViewRow;

            GridViewEducation.EditIndex = -1;
            Int64 predicate = Convert.ToInt64(GridViewEducation.DataKeys[row.RowIndex].Values[1].ToString());
            Int64 _object = Convert.ToInt64(GridViewEducation.DataKeys[row.RowIndex].Values[2].ToString());

            data.MoveTripleDown(this.SubjectID, predicate, _object);

            this.FillEducationalTrainingGrid(true);

            upnlEditSection.Update();

        }

        protected void ibDown_Click(object sender, EventArgs e)
        {
            GridViewRow row = ((ImageButton)sender).Parent.Parent as GridViewRow;
            GridViewEducation.EditIndex = -1;

            Int64 predicate = Convert.ToInt64(GridViewEducation.DataKeys[row.RowIndex].Values[1].ToString());
            Int64 _object = Convert.ToInt64(GridViewEducation.DataKeys[row.RowIndex].Values[2].ToString());

            data.MoveTripleUp(this.SubjectID, predicate, _object);

            this.FillEducationalTrainingGrid(true);

            upnlEditSection.Update();

        }
        protected void FillEducationalTrainingGrid(bool refresh)
        {
            if (refresh)
                base.GetNetworkProfile(this.SubjectID, this.PredicateID);

            List<EducationalTrainingState> educationalTrainingState = new List<EducationalTrainingState>();

            Int64 predicate = 0;

            string awarduri = string.Empty;

            Int64 oldobjectid = 0;

            string oldinstitutionvalue = string.Empty;
            string oldlocationvalue = string.Empty;
            string olddegreevalue = string.Empty;
            string oldenddatevalue = string.Empty;
            string oldfieldofstudyvalue = string.Empty;

            string predicateuri = string.Empty;
            string method = string.Empty;

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
                btnEditEducation.Visible = false;

            this.SubjectID = Convert.ToInt64(base.GetRawQueryStringItem("subject"));
            predicate = Convert.ToInt64(data.GetStoreNode(Server.UrlDecode(base.GetRawQueryStringItem("predicateuri")).Replace("!", "#")));
            predicateuri = base.GetRawQueryStringItem("predicateuri").Replace("!", "#");

            foreach (XmlNode property in (base.BaseData).SelectNodes("rdf:RDF/rdf:Description/prns:hasConnection/@rdf:resource", base.Namespaces))
            {

                awarduri = base.BaseData.SelectSingleNode("rdf:RDF/rdf:Description[@rdf:about='" + property.InnerText + "']/rdf:object/@rdf:resource", base.Namespaces).Value;
                oldobjectid = data.GetStoreNode(awarduri);

                if (base.BaseData.SelectSingleNode("rdf:RDF/rdf:Description[@rdf:about='" + awarduri + "']/prns:trainingAtOrganization", base.Namespaces) != null)
                    oldinstitutionvalue = base.BaseData.SelectSingleNode("rdf:RDF/rdf:Description[@rdf:about='" + awarduri + "']/prns:trainingAtOrganization", base.Namespaces).InnerText;
                else
                    oldinstitutionvalue = string.Empty;

                if (base.BaseData.SelectSingleNode("rdf:RDF/rdf:Description[@rdf:about='" + awarduri + "']/prns:trainingLocation", base.Namespaces) != null)
                    oldlocationvalue = base.BaseData.SelectSingleNode("rdf:RDF/rdf:Description[@rdf:about='" + awarduri + "']/prns:trainingLocation", base.Namespaces).InnerText;
                else
                    oldlocationvalue = string.Empty;

                if (base.BaseData.SelectSingleNode("rdf:RDF/rdf:Description[@rdf:about='" + awarduri + "']/vivo:degreeEarned", base.Namespaces) != null)
                    olddegreevalue = base.BaseData.SelectSingleNode("rdf:RDF/rdf:Description[@rdf:about='" + awarduri + "']/vivo:degreeEarned", base.Namespaces).InnerText;
                else
                    olddegreevalue = string.Empty;

                if (base.BaseData.SelectSingleNode("rdf:RDF/rdf:Description[@rdf:about='" + awarduri + "']/prns:endDate", base.Namespaces) != null)
                    oldenddatevalue = base.BaseData.SelectSingleNode("rdf:RDF/rdf:Description[@rdf:about='" + awarduri + "']/prns:endDate", base.Namespaces).InnerText;
                else
                    oldenddatevalue = string.Empty;

                if (base.BaseData.SelectSingleNode("rdf:RDF/rdf:Description[@rdf:about='" + awarduri + "']/vivo:majorField", base.Namespaces) != null)
                    oldfieldofstudyvalue = base.BaseData.SelectSingleNode("rdf:RDF/rdf:Description[@rdf:about='" + awarduri + "']/vivo:majorField", base.Namespaces).InnerText;
                else
                    oldfieldofstudyvalue = string.Empty;

                educationalTrainingState.Add(new EducationalTrainingState(awarduri, predicate, oldobjectid, oldinstitutionvalue, oldlocationvalue,
                    olddegreevalue, oldenddatevalue, oldfieldofstudyvalue, editexisting, editdelete));

            }


            if (educationalTrainingState.Count > 0)
            {


                GridViewEducation.DataSource = educationalTrainingState;
                GridViewEducation.DataBind();
            }
            else
            {

                lblNoEducation.Visible = true;
                GridViewEducation.Visible = false;

            }

        }
        #endregion

        private Int64 SubjectID { get; set; }
        private Int64 PredicateID { get; set; }
        private XmlDocument XMLData { get; set; }
        private XmlDocument PropertyListXML { get; set; }




    }
}