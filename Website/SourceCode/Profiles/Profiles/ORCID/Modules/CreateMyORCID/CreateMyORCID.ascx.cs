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
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.Web.UI.HtmlControls;
using System.Web.Script.Serialization;
using Profiles.Login.Utilities;
using Profiles.Framework.Utilities;
using Profiles.ORNG.Utilities;

using System.Data;
using System.Data.SqlClient;
using System.Data.Common;
using System.Globalization;
using System.Text;
using System.Xml.Xsl;

using Profiles.Profile.Utilities;


namespace Profiles.ORCID.Modules.CreateMyORCID
{
    public partial class CreateMyORCID : ORCIDBaseModule, IPostBackEventHandler
    {
        public CreateMyORCID() {
            base.RDFTriple = new RDFTriple(Convert.ToInt64(sm.Session().NodeID.ToString()));             
        }
        public void Initialize(XmlDocument basedata, XmlNamespaceManager namespaces, RDFTriple rdftriple)
        {
            BaseData = basedata;
            Namespaces = namespaces;
            RDFTriple = rdftriple;
            UploadInfoToORCID1.Initialize(basedata, namespaces, rdftriple);
        }
        public override Label Errors
        {
            get { return this.lblErrors; }
        }

        protected void Page_Load(object sender, System.EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    DrawProfilesModule();
                }
                else
                    loadSessionState();
            }
            catch (Exception ex)
            {
                LogException(ex);
            }
        }
        private void loadSessionState()
        {
            LoadAssets();
            UpdateAcknowledgeVisibility();
            this.txtEmailAddress.Text = Session["txtEmailAddress.Text"].ToString();
            this.txtFirstName.Text = Session["txtFirstName.Text"].ToString();
            this.txtLastName.Text = Session["txtLastName.Text"].ToString();
            this.hlORCIDAckAndConsent.Text = Session["hlORCIDAckAndConsent.Text"].ToString();
            this.hlORCIDAckAndConsent.NavigateUrl = Session["hlORCIDAckAndConsent.NavigateUrl"].ToString();
        }

        protected void DrawProfilesModule()
        {
            LoadAssets();
            Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID.Person orcidPerson = GetPersonWithDBData(Convert.ToInt32(Request.QueryString["subject"]));
            this.txtEmailAddress.Text = orcidPerson.EmailAddress;
            this.txtFirstName.Text = orcidPerson.FirstName;
            this.txtLastName.Text = orcidPerson.LastName;
            this.hlORCIDAckAndConsent.Text = Profiles.ORCID.Utilities.config.AcknowledgementInfoSiteText;
            this.hlORCIDAckAndConsent.NavigateUrl = ORCID_WordPress_Agreement;
            CheckForExistingORCID();
            UpdateAcknowledgeVisibility();
            UpdateUploadNowVisibility();
            this.lblOrgEmailRequired.Text = Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.ORCID.Person.EmailRequiredMessage;
            Session["txtEmailAddress.Text"] = this.txtEmailAddress.Text;
            Session["txtFirstName.Text"] = this.txtFirstName.Text;
            Session["txtLastName.Text"] = this.txtLastName.Text;
            Session["hlORCIDAckAndConsent.Text"] = this.hlORCIDAckAndConsent.Text;
            Session["hlORCIDAckAndConsent.NavigateUrl"] = this.hlORCIDAckAndConsent.NavigateUrl;
        }

        private void LoadAssets()
        {
            HtmlLink ORCIDcss = new HtmlLink();
            ORCIDcss.Href = Root.Domain + "/ORCID/CSS/ORCID.css";
            ORCIDcss.Attributes["rel"] = "stylesheet";
            ORCIDcss.Attributes["type"] = "text/css";
            ORCIDcss.Attributes["media"] = "all";
            Page.Header.Controls.Add(ORCIDcss);

            HtmlGenericControl ORCIDjs = new HtmlGenericControl("script");
            ORCIDjs.Attributes.Add("type", "text/javascript");
            ORCIDjs.Attributes.Add("src", Root.Domain + "/ORCID/JavaScript/orcid.js?v=1");
            Page.Header.Controls.Add(ORCIDjs);
        }

        protected void btnNewORCID_Click(object sender, EventArgs e)
        {
            try
            {
                long subjectID = Convert.ToInt32(Request.QueryString["subject"]);
                int profilePersonID = new Profiles.Edit.Utilities.DataIO().GetPersonID(subjectID);
                Utilities.ProfilesRNSDLL.BLL.ORCID.Person personBLL = new Utilities.ProfilesRNSDLL.BLL.ORCID.Person();
                Utilities.ProfilesRNSDLL.BO.ORCID.Person bo = personBLL.GetByPersonID(profilePersonID);
                if (chkUploadInfoNow.Checked)
                {
                    bo = UploadInfoToORCID1.GetPersonWithPageData(bo);
                }

                GetPageControlValues(bo);

                if (Profiles.ORCID.Utilities.config.RequireAcknowledgement)
                {
                    bo.AgreementAcknowledged = true;
                }
                if (new Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.ORCID.Person().CreateNewORCID(bo, LoggedInInternalUsername, Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID.REFPersonStatusType.REFPersonStatusTypes.User_Push_Failed))
                {
                    Edit.Utilities.DataIO data = new Edit.Utilities.DataIO();
                    data.AddLiteral(subjectID, data.GetStoreNode("http://vivoweb.org/ontology/core#orcidId"), data.GetStoreNode(bo.ORCID));

                    bool isProxy = Profiles.ORCID.Utilities.DataIO.getNodeIdFromInternalUserName(LoggedInInternalUsername) != subjectID;
                    Response.Redirect("~/ORCID/CreationConfirmation.aspx?UserORCID=" + bo.ORCID + "&Proxy="+isProxy, false);
                    return;
                }
                else
                {
                    this.lblErrorsCreate.Text = bo.Error + bo.AllErrors + "<br /><br />";
                    GetErrorsAndMessages(bo);
                }
            }
            catch (Exception ex)
            {
                lblErrorsCreate.Text = ex.Message;
                LogException(ex);
            }
        }
        protected void chkIAgree_CheckedChanged(object sender, EventArgs e)
        {
            this.btnNewORCID.Enabled = this.chkIAgree.Checked;
        }
        protected void chkUploadInfoNow_CheckedChanged(object sender, EventArgs e)
        {
            UpdateUploadNowVisibility();
        }

        private void GetErrorsAndMessages(Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID.Person bo)
        {
            AddError(bo.Error);
            this.lblFirstNameErrors.Text = bo.FirstNameErrors;
            this.lblLastNameErrors.Text = bo.LastNameErrors;
            this.lblPublishedNameErrors.Text = bo.PublishedNameErrors;
            this.lblEmailAddressErrors.Text = bo.EmailAddressErrors;
            this.lblAlternateEmailDecisionIDErrors.Text = bo.AlternateEmailDecisionIDErrors;
            this.UploadInfoToORCID1.ResearchExpertiseAndProfessionalInterestsErrors = bo.BiographyErrors;
        }
        private Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID.Person GetPageControlValues(Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID.Person bo)
        {
            bo.AlternateEmails = new List<Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID.PersonAlternateEmail>();

            //bo.InternalUsername = LoggedInInternalUsername;
            bo.PersonStatusTypeID = (int)Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID.REFPersonStatusType.REFPersonStatusTypes.ORCID_Created;

            if (!this.txtFirstName.Text.Equals(string.Empty))
            {
                bo.FirstName = this.txtFirstName.Text;
            }
            else
            {
                bo.FirstNameIsNull = true;
            }
            if (!this.txtLastName.Text.Equals(string.Empty))
            {
                bo.LastName = this.txtLastName.Text;
            }
            else
            {
                bo.LastNameIsNull = true;
            }
            if (!this.txtPublishedName.Text.Equals(string.Empty))
            {
                bo.PublishedName = this.txtPublishedName.Text;
            }
            foreach (string othername in this.txtOtherNames.Text.Split(Environment.NewLine.ToCharArray()))
            {
                if (!othername.Trim().Equals(string.Empty))
                {
                    Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID.PersonOthername otherNameBO = new Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID.PersonOthername();
                    otherNameBO.OtherName = othername.Trim();
                    bo.Othernames.Add(otherNameBO);
                }
            }
            if (!this.txtEmailAddress.Text.Equals(string.Empty))
            {
                bo.EmailAddress = this.txtEmailAddress.Text;
            }
            else
            {
                bo.EmailAddressIsNull = true;
            }
            if (!this.ddlEmailDecisionID.Text.Equals(string.Empty))
            {
                bo.EmailDecisionID = int.Parse(this.ddlEmailDecisionID.SelectedValue);
            }
            else
            {
                bo.EmailDecisionIDIsNull = true;
            }
            if (!this.ddlAlternateEmailDecisionID.Text.Equals(string.Empty))
            {
                bo.AlternateEmailDecisionID = int.Parse(this.ddlAlternateEmailDecisionID.SelectedValue);
            }
            else
            {
                bo.AlternateEmailDecisionIDIsNull = true;
            }
            foreach (string email in this.txtAlternateEmail.Text.Split(Environment.NewLine.ToCharArray()))
            {
                if (!email.Equals(string.Empty))
                {
                    Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID.PersonAlternateEmail emailBO = new Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID.PersonAlternateEmail();
                    emailBO.EmailAddress = email;
                    bo.AlternateEmails.Add(emailBO);
                }
            }
            return bo;
        }
        private void CheckForExistingORCID()
        {
            Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID.Person person = GetPerson();
            if (person.Exists && !person.ORCIDIsNull && !person.ORCID.Equals(string.Empty))
            {
                AddError("You already have an ORCID.  Please visit the <a href='" + Profiles.ORCID.Utilities.config.ORCID_URL + "'>ORCID website</a> to make any changes.");
                this.divEntryForm.Visible = false;
            }
        }
        private void SetPrivacy(DropDownList ddl, string privacyLevel)
        {
            ddl.ClearSelection();
            ListItem li = ddl.Items.FindByValue(privacyLevel);
            if (!(li == null))
            {
                li.Selected = true;
            }
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            if (Page.IsPostBack)
            { }
        }

        private void UpdateUploadNowVisibility()
        {
            this.UploadInfoToORCID1.Visible = chkUploadInfoNow.Checked;
        }
        private void UpdateAcknowledgeVisibility()
        {
            bool requireAcknowledgement = Profiles.ORCID.Utilities.config.RequireAcknowledgement;
            if (requireAcknowledgement)
            {
                this.pAcknowledge.Visible = true;
                this.btnNewORCID.Enabled = this.chkIAgree.Checked;
            }
            else
            {
                this.pAcknowledge.Visible = false;
                this.btnNewORCID.Enabled = true;
            }
        }
        private Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID.Person GetPersonWithDBData()
        {
            int profilePersonID = new Profiles.Edit.Utilities.DataIO().GetPersonID(base.RDFTriple.Subject);
            return new Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.ORCID.Person().GetPersonWithDBData(profilePersonID, sm.Session().SessionID);
        }


        private Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID.Person GetPersonWithDBData(int subject)
        {
            int profilePersonID = new Profiles.Edit.Utilities.DataIO().GetPersonID(subject);
            return new Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.ORCID.Person().GetPersonWithDBData(profilePersonID, sm.Session().SessionID);
        }

        public void RaisePostBackEvent(string eventArgument)
        {
            throw new NotImplementedException();
        }
    }
}