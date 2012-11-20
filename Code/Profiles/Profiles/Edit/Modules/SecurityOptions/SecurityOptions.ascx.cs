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

namespace Profiles.Edit.Modules.SecurityOptions
{
    public partial class SecurityOptions : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                Session["pnlSecurityOptions.Visible"] = null;
            
            DrawProfilesModule();

        }

        private void DrawProfilesModule()
        {

        

            List<SecurityItem> si = new List<SecurityItem>();

            foreach (XmlNode securityitem in this.SecurityGroups.SelectNodes("SecurityGroupList/SecurityGroup"))
            {
                si.Add(new SecurityItem(securityitem.SelectSingleNode("@Label").Value,
                    securityitem.SelectSingleNode("@Description").Value,
                    Convert.ToInt32(securityitem.SelectSingleNode("@ID").Value)));
            }


            grdSecurityGroups.DataSource = si;
            grdSecurityGroups.DataBind();


        }
        protected void grdSecurityGroups_OnDataBound(object sender, GridViewRowEventArgs e)
        {


            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                SecurityItem si = (SecurityItem)e.Row.DataItem;
                RadioButton rb = (RadioButton)e.Row.FindControl("rdoSecurityOption");
                HiddenField hf = (HiddenField)e.Row.FindControl("hdnPrivacyCode");
                RadioButton rdoSecurityOption = (RadioButton)e.Row.FindControl("rdoSecurityOption");

                rdoSecurityOption.GroupName = "SecurityOption";

                hf.Value = si.PrivacyCode.ToString();

                if (si.PrivacyCode == this.PrivacyCode)
                {
                    rb.Checked = true;
                    lbSecurityOptions.Text = "Edit Visibility (" + si.Label + ")";
                }
                else
                {
                    rb.Checked = false;
                }
            }
        }
        protected void imbSecurityOptions_OnClick(object sender, EventArgs e)
        {
            if (Session["pnlSecurityOptions.Visible"] == null)
            {
                pnlSecurityOptions.Visible = true;
                imbSecurityOptions.ImageUrl = "~/Framework/Images/icon_squareDownArrow.gif";
                Session["pnlSecurityOptions.Visible"] = true;
            }
            else
            {
                pnlSecurityOptions.Visible = false;
                imbSecurityOptions.ImageUrl = "~/Framework/Images/icon_squareArrow.gif";
                Session["pnlSecurityOptions.Visible"] = null;
            }
        }
        protected void rdoSecurityOption_OnCheckedChanged(object sender, EventArgs e)
        {
            Session["pnlSecurityOptions.Visible"] = null;

            //Clear the existing selected row 
            foreach (GridViewRow oldrow in grdSecurityGroups.Rows)
            {
                ((RadioButton)oldrow.FindControl("rdoSecurityOption")).Checked = false;
            }

            //Set the new selected row
            RadioButton rb = (RadioButton)sender;
            GridViewRow row = (GridViewRow)rb.NamingContainer;
            ((RadioButton)row.FindControl("rdoSecurityOption")).Checked = true;
            lbSecurityOptions.Text = "Edit Visibility (" + row.Cells[1].Text + ")";
              
             UpdateSecuritySetting(((HiddenField)row.Cells[0].FindControl("hdnPrivacyCode")).Value);          

        }

        private void UpdateSecuritySetting(string securitygroup)
        {
            Edit.Utilities.DataIO data = new Profiles.Edit.Utilities.DataIO();
            
            data.UpdateSecuritySetting(this.Subject, data.GetStoreNode(this.PredicateURI), Convert.ToInt32(securitygroup));

        }

        public XmlDataDocument SecurityGroups { get; set; }

        public Int64 Subject { get; set; }
        public string PredicateURI { get; set; }
        public int PrivacyCode { get; set; }

        public class SecurityItem
        {
            public SecurityItem(string label, string description, int privacycode)
            {
                this.Label = label;
                this.Description = description;
                this.PrivacyCode = privacycode;
            }

            public string Label { get; set; }
            public string Description { get; set; }
            public int PrivacyCode { get; set; }
        }

    }
}