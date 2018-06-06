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
        }

        #region Education

        protected void GridViewEducation_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            TextBox txtEducationalTrainingInst = null;
            TextBox txtEducationalTrainingLocation = null;
            TextBox txtEducationalTrainingDegree = null;
            TextBox txtYr2 = null;
            TextBox txtEducationalTrainingFieldOfStudy = null;
            HiddenField hdURI = null;

            EducationalTrainingState educationalTrainingState = null;

            try
            {
                e.Row.Cells[4].Attributes.Add("style", "border-left:0px;");
            }
            catch (Exception) { }

            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                txtEducationalTrainingInst = (TextBox)e.Row.Cells[3].FindControl("txtEducationalTrainingInst");
                txtEducationalTrainingLocation = (TextBox)e.Row.Cells[3].FindControl("txtEducationalTrainingLocation");
                txtEducationalTrainingDegree = (TextBox)e.Row.Cells[2].FindControl("txtEducationalTrainingDegree");
                txtYr2 = (TextBox)e.Row.Cells[1].FindControl("txtYr2");
                txtEducationalTrainingFieldOfStudy = (TextBox)e.Row.Cells[2].FindControl("txtEducationalTrainingFieldOfStudy");
                hdURI = (HiddenField)e.Row.Cells[3].FindControl("hdURI");

                educationalTrainingState = (EducationalTrainingState)e.Row.DataItem;
                hdURI.Value = educationalTrainingState.SubjectURI;
            }
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
                    olddegreevalue, oldenddatevalue, oldfieldofstudyvalue, false, false));

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