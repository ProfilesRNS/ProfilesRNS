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
using System.Xml;
using Profiles.Framework.Utilities;
using System.Data.SqlClient;

namespace Profiles.Edit.Modules.CustomEditGroupSettings
{
    public partial class CustomEditGroupSettings : BaseModule
    {
        Edit.Utilities.DataIO data;
        Profiles.Profile.Utilities.DataIO propdata;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session["pnlInsertProperty.Visible"] = null;
            }

        }

        public CustomEditGroupSettings() { }
        public CustomEditGroupSettings(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
            : base(pagedata, moduleparams, pagenamespaces)
        {
            SessionManagement sm = new SessionManagement();
            data = new Profiles.Edit.Utilities.DataIO();
            propdata = new Profiles.Profile.Utilities.DataIO();
            string predicateuri = Request.QueryString["predicateuri"].Replace("!", "#");

            if (Request.QueryString["subject"] != null)
                this.SubjectID = Convert.ToInt64(Request.QueryString["subject"]);
            else if (base.GetRawQueryStringItem("subject") != null)
                this.SubjectID = Convert.ToInt64(base.GetRawQueryStringItem("subject"));
            else
                Response.Redirect("~/search");

            litBackLink.Text = "<a href='" + Root.Domain + "/edit/default.aspx?subject=" + this.SubjectID + "'>Edit Menu</a> &gt; <b>Group Settings</b>";

            
            imbAddArror.Visible = true;

            SqlDataReader reader = data.GetGroup(SubjectID);
            reader.Read();
            securityOptions.PrivacyCode = Convert.ToInt32(reader["ViewSecurityGroup"].ToString());
            reader.Close();

            
            securityOptions.Subject = this.SubjectID;
            securityOptions.PredicateURI = predicateuri;
            
            securityOptions.SecurityGroups = new XmlDocument();
            securityOptions.SecurityGroups.LoadXml(base.PresentationXML.DocumentElement.LastChild.OuterXml);

            securityOptions.BubbleClick += SecurityDisplayed;
        }

        #region Property

        private void SecurityDisplayed(object sender, EventArgs e)
        {


            if (Session["pnlSecurityOptions.Visible"] == null)
            {
                phEditProperty.Visible = true;

            }
            else
            {
                phEditProperty.Visible = false;                
            }
        }

        protected void btnUpdateDateCancel_OnClick(object sender, EventArgs e)
        {
            if (Session["pnlInsertProperty.Visible"] != null)
            {
                phSecurityOptions.Visible = true;
                phEditProperty.Visible = true;
                //phDelAll.Visible = true;
                //btnInsertCancel_OnClick(sender, e);
                imbAddArror.ImageUrl = "~/Framework/Images/icon_squareArrow.gif";
                Session["pnlInsertProperty.Visible"] = null;
            }
            else
            {
                phSecurityOptions.Visible = false;
                phEditProperty.Visible = true;
                //phDelAll.Visible = false;
                pnlInsertProperty.Visible = true;
                imbAddArror.ImageUrl = "~/Framework/Images/icon_squareDownArrow.gif";
                Session["pnlInsertProperty.Visible"] = true;

                SqlDataReader reader = data.GetGroup(SubjectID);
                reader.Read();
                string ed = reader["EndDate"].ToString();
                ed = ed.Substring(0, ed.IndexOf(' '));
                txtEndDate.Text = ed;
                reader.Close();
            }
            upnlEditSection.Update();
        }

        protected void btnUpdateDateSave_OnClick(object sender, EventArgs e)
        {
            if (Session["pnlInsertProperty.Visible"] != null)
            {
                if (txtEndDate.Text.Trim().Length > 0)
                {
                    data.UpdateGroupEndDate(this.SubjectID, txtEndDate.Text.Trim());
                }
                btnUpdateDateCancel_OnClick(sender, e);
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