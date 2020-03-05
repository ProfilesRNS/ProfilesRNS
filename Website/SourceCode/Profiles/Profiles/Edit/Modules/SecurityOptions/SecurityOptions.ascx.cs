
using Profiles.Framework.Utilities;
using System;
using System.Collections.Generic;
using System.Web.UI.WebControls;
using System.Xml;

namespace Profiles.Edit.Modules.SecurityOptions
{
    public partial class SecurityOptions : BaseModule
    {
        public event EventHandler BubbleClick;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                Session["pnlSecurityOptions.Visible"] = null;

            DrawProfilesModule();
        }
        override protected void OnInit(EventArgs e)
        {
            this.Load += Page_Load;

            base.OnInit(e);
        }

        private void DrawProfilesModule()
        {
            List<SecurityItem> si = new List<SecurityItem>();

            if (this.PropertyListXML != null)
            {
                if ("0".Equals(this.PropertyListXML.SelectSingleNode("PropertyList/PropertyGroup/Property[@URI='" + this.PredicateURI + "']/@NumberOfConnections").Value))
                    divHidden.Visible = true;
                else
                    divHidden.Visible = false;
            }
            else
            {
                divHidden.Visible = false;
            }

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
                    if (this.PrivacyCode == 0)
                        si.Label = "<b>" + si.Label + "</b>";

                    rb.Checked = true;
                    imbSecurityOptions.Text = "Edit Visibility (" + si.Label + ")";
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
                imbAddArrow.ImageUrl = "~/Framework/Images/icon_squareDownArrow.gif";
                Session["pnlSecurityOptions.Visible"] = true;
            }
            else
            {
                pnlSecurityOptions.Visible = false;
                imbAddArrow.ImageUrl = "~/Framework/Images/icon_squareArrow.gif";
                Session["pnlSecurityOptions.Visible"] = null;
            }


            if (BubbleClick != null)
                BubbleClick(this, e);
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
            imbSecurityOptions.Text = "Edit Visibility (" + row.Cells[1].Text + ")";
            UpdateSecuritySetting(((HiddenField)row.Cells[0].FindControl("hdnPrivacyCode")).Value);
        }

        private void UpdateSecuritySetting(string securitygroup)
        {
            // maybe be able to make this more general purpose
            Edit.Utilities.DataIO secdata = new Profiles.Edit.Utilities.DataIO();

            if (!"0".Equals(securitygroup))
            {
                Edit.Utilities.DataIO data = new Profiles.Edit.Utilities.DataIO();
                if (this.PredicateURI.Equals("http://profiles.catalyst.harvard.edu/ontology/prns#hasGroupSettings"))
                {
                    data.UpdateGroupSecurity(this.Subject, Convert.ToInt32(securitygroup));
                }
                else if (this.PredicateURI.Equals("http://profiles.catalyst.harvard.edu/ontology/prns#emailEncrypted"))
                {
                    if (Convert.ToInt32(securitygroup) >= -10 && Convert.ToInt32(securitygroup) < 0)
                        data.UpdateSecuritySetting(this.Subject, data.GetStoreNode("http://vivoweb.org/ontology/core#email"), -20);
                    else
                        data.UpdateSecuritySetting(this.Subject, data.GetStoreNode("http://vivoweb.org/ontology/core#email"), Convert.ToInt32(securitygroup));
                }

                data.UpdateSecuritySetting(this.Subject, data.GetStoreNode(this.PredicateURI), Convert.ToInt32(securitygroup));

                divHidden.Visible = false;
            }
            Framework.Utilities.Cache.AlterDependency(this.Subject.ToString());
        }


        public XmlDocument SecurityGroups { get; set; }

        public Int64 Subject { get; set; }
        public string PredicateURI { get; set; }
        public int PrivacyCode { get; set; }
        public XmlDocument PropertyListXML { get; set; }
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