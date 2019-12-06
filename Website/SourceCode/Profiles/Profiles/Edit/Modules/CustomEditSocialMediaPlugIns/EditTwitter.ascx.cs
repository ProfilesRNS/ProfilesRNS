using Profiles.Framework.Utilities;
using System;
using System.Collections.Generic;
using System.Xml;
using Profiles.Profile.Modules;

namespace Profiles.Edit.Modules.CustomEditSocialMediaPlugIns
{
    public partial class Twitter : BaseSocialMediaModule
    {
        Boolean dataexists = false;

        public Twitter() : base() { }
        public Twitter(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
            : base(pagedata, moduleparams, pagenamespaces)
        {
            SessionManagement sm = new SessionManagement();
            securityOptions.Subject = base.SubjectID;
            securityOptions.PredicateURI = base.PredicateURI.Replace("!", "#");
            securityOptions.PrivacyCode = Convert.ToInt32(base.PropertyListXML.SelectSingleNode("PropertyList/PropertyGroup/Property/@ViewSecurityGroup").Value);
            securityOptions.SecurityGroups = new XmlDocument();
            securityOptions.SecurityGroups.LoadXml(base.PresentationXML.DocumentElement.LastChild.OuterXml);
            securityOptions.BubbleClick += SecurityDisplayed;
            this.PlugInName = "Twitter";
            string data = Profiles.Framework.Utilities.GenericRDFDataIO.GetSocialMediaPlugInData(this.SubjectID, this.PlugInName);

            litBackLink.Text = "<a href='" + Root.Domain + "/edit/default.aspx?subject=" + this.SubjectID + "'>Edit Menu</a> &gt; <b>" + PropertyListXML.SelectSingleNode("PropertyList/PropertyGroup/Property/@Label").Value + "</b>";
            if (data.Length > 0)
                dataexists = true;

            txtUsername.Text = data;
            lblUsername.Text = data;

        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) { litjs.Text = base.SocialMediaInit(this.PlugInName); }
            SetDeleteButtons();
            upnlEditSection.Update();
        }

        private void SetDeleteButtons()
        {
            if (dataexists)
            {
                btnDeleteGray.Visible = false;
                imbDeleteArrow.Visible = true;
                btnDelete.Visible = true;
                btnImgDeleteGray.Visible = false;
                divShowTwitter.Visible = true;
                divNoTwitter.Visible = false;
            }
            else
            {
                btnDeleteGray.Visible = true;
                btnDelete.Visible = false;
                imbDeleteArrow.Visible = false;
                btnImgDeleteGray.Visible = true;
                divShowTwitter.Visible = false;
                divNoTwitter.Visible = true;
            }

        }
        private void SecurityDisplayed(object sender, EventArgs e)
        {

            if (Session["pnlSecurityOptions.Visible"] == null)
            {
                pnlDelete.Visible = true;
                pnlAddEdit.Visible = true;

            }
            else
            {
                pnlDelete.Visible = false;
                pnlAddEdit.Visible = false;

            }

            upnlEditSection.Update();
        }
        protected void btnAddEdit_OnClick(object sender, EventArgs e)
        {
            if (Session["pnlImportTwitter.Visible"] == null)
            {
                pnlImportTwitter.Visible = true;
                imbAddArrow.ImageUrl = "~/Framework/Images/icon_squareDownArrow.gif";
                pnlDeleteTwitter.Visible = false;
                pnlDelete.Visible = false;
                phSecuritySettings.Visible = false;
                Session["pnlImportTwitter.Visible"] = true;
            }
            else
            {
                pnlImportTwitter.Visible = false;
                imbAddArrow.ImageUrl = "~/Framework/Images/icon_squareArrow.gif";
                pnlDeleteTwitter.Visible = false;
                phSecuritySettings.Visible = true;
                pnlDelete.Visible = true;
            }

        }
        protected void btnDelete_OnClick(object sender, EventArgs e)
        {

            if (Session["pnlDeleteTwitter.Visible"] == null)
            {
                pnlImportTwitter.Visible = false;
                imbDeleteArrow.ImageUrl = "~/Framework/Images/icon_squareDownArrow.gif";
                pnlDeleteTwitter.Visible = true;
                pnlAddEdit.Visible = false;
                phSecuritySettings.Visible = false;
                Session["pnlDeleteTwitter.Visible"] = true;
            }
            else
            {
                Session["pnlDeleteTwitter.Visible"] = null;
                pnlImportTwitter.Visible = false;
                imbDeleteArrow.ImageUrl = "~/Framework/Images/icon_squareArrow.gif";
                pnlDeleteTwitter.Visible = false;
                phSecuritySettings.Visible = true;
                pnlAddEdit.Visible = true;
            }

        }

        protected void btnSaveAndClose_OnClick(object sender, EventArgs e)
        {
            Profiles.Framework.Utilities.GenericRDFDataIO.AddEditPluginData(this.PlugInName, this.SubjectID, txtUsername.Text.Trim(), "Twitter Tweets Harvard Tweets");
            Response.Redirect(Request.Url.AbsoluteUri);
            Response.End();
        }
        protected void btnDeleteClose_OnClick(object sender, EventArgs e)
        {
            Profiles.Framework.Utilities.GenericRDFDataIO.AddEditPluginData(this.PlugInName, this.SubjectID, "", "");
            Profiles.Framework.Utilities.GenericRDFDataIO.RemovePluginData(this.PlugInName, this.SubjectID);

            dataexists = false;
            txtUidToDelete.Text = "";
            txtUsername.Text = "";
            ResetDisplay();

        }
        protected void btnDeleteCancel_OnClick(object sender, EventArgs e)
        {
            ResetDisplay();
        }
        protected void btnCancel_OnClick(object sender, EventArgs e)
        {
            ResetDisplay();
        }

        private void ResetDisplay()
        {

            phSecuritySettings.Visible = true;
            pnlAddEdit.Visible = true;
            pnlDelete.Visible = true;
            pnlDeleteTwitter.Visible = false;
            pnlImportTwitter.Visible = false;
            Session["pnlImportTwitter.Visible"] = null;
            //
            dataexists = false;
            string data = Profiles.Framework.Utilities.GenericRDFDataIO.GetSocialMediaPlugInData(this.SubjectID, this.PlugInName);
            if (data.Length > 0)
            {
                dataexists = true;
                lblUsername.Text = data;
            }
            //
            //make sure dataexists is set to false then reset if data exists,  this should be its own function in the base class
            SetDeleteButtons();
            upnlEditSection.Update();
        }
    }
}