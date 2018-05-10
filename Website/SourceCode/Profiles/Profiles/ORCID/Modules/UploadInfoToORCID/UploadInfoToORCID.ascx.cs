using System;
using System.Collections.Generic;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using Profiles.Framework.Utilities;

namespace Profiles.ORCID.Modules.UploadInfoToORCID
{
    public partial class UploadInfoToORCID : ORCIDBaseModule
    {
        Utilities.DataIO data;


        protected void Page_PreRender(object sender, EventArgs e)
        {
            Boolean b = divPublications.Visible;
        }

        protected void Page_Load(object sender, System.EventArgs e)
        {
            try
            {
                //                if (!IsPostBack)
                //                {
                DrawProfilesModule();
                //                }
            }
            catch (Exception ex)
            {
                LogException(ex);
            }
        }
        protected void DrawProfilesModule()
        {
            Utilities.ProfilesRNSDLL.BO.ORCID.Person orcidPerson = GetPersonWithDBData(Convert.ToInt32(Request.QueryString["subject"]));
            LoadURLs(orcidPerson);
            LoadBIO(orcidPerson);
            LoadAffiliations(orcidPerson);
            LoadPublications(orcidPerson);


        }
        
        
        public override Label Errors
        {
            get
            {
                return ((ORCIDBaseModule)this.Parent.Parent).Errors;
            }
        }
        public UploadInfoToORCID()
        {
            data = new Profiles.ORCID.Utilities.DataIO();
            base.RDFTriple = new RDFTriple(Convert.ToInt64(sm.Session().NodeID.ToString()));
        }
        public Utilities.ProfilesRNSDLL.BO.ORCID.Person GetPersonWithPageData()
        {
            Utilities.ProfilesRNSDLL.BO.ORCID.Person person = GetPerson();
            GetBioFromThePage(person);
            GetWorksFromThePage(person);
            GetAffiliationsFromThePage(person);
            return person;
        }

        public Utilities.ProfilesRNSDLL.BO.ORCID.Person GetPersonWithPageData(Utilities.ProfilesRNSDLL.BO.ORCID.Person person)
        {
            GetBioFromThePage(person);
            GetWorksFromThePage(person);
            GetAffiliationsFromThePage(person);
            return person;
        }

        public string ResearchExpertiseAndProfessionalInterestsErrors
        {
            get
            {
                return this.lblResearchExpertiseAndProfessionalInterestsErrors.Text;
            }
            set
            {
                this.lblResearchExpertiseAndProfessionalInterestsErrors.Text = value;
            }
        }
        public string ResearchExpertiseAndProfessionalInterests
        {
            get
            {
                return this.txtResearchExpertiseAndProfessionalInterests.Text;
            }
            set
            {
                this.txtResearchExpertiseAndProfessionalInterests.Text = value;
            }
        }
        public void Initialize(XmlDocument basedata, XmlNamespaceManager namespaces, RDFTriple rdftriple)
        {
            BaseData = basedata;
            Namespaces = namespaces;
            RDFTriple = rdftriple;
        }

    
        
        protected void rptPublications_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
            {
                DropDownList ddlPubVis = (DropDownList)e.Item.FindControl("ddlPubVis");
                Utilities.ProfilesRNSDLL.DevelopmentBase.UICommon.SetValue(DataBinder.Eval(e.Item, "DataItem.DecisionID").ToString(), false, ddlPubVis);
            }
        }

        private void GetBioFromThePage(Utilities.ProfilesRNSDLL.BO.ORCID.Person person)
        {
            //if (divResearchExpertiseAndProfessionalInterests.Visible)
            if (!this.txtResearchExpertiseAndProfessionalInterests.Text.Equals(""))
            {
                person.BiographyDecisionID = int.Parse(ddlResearchExpertiseAndProfessionalInterestsVis.SelectedValue);
                if (person.BiographyDecisionID == (int)Utilities.ProfilesRNSDLL.BO.ORCID.REFDecision.REFDecisions.Public)
                {
                    person.Biography = this.txtResearchExpertiseAndProfessionalInterests.Text;
                }
                person.PushBiographyToORCID = true;
            }
            
                if (rptPersonURLs.Items.Count > 0)
                {
                    Label lblWebPageTitle = null;
                    HyperLink hlURL = null;
                    DropDownList ddlPushType = null;

                    foreach (RepeaterItem ri in rptPersonURLs.Items)
                    {
                        switch (ri.ItemType)
                        {
                            case ListItemType.Item:
                            case ListItemType.AlternatingItem:
                                lblWebPageTitle = (Label)ri.FindControl("lblWebPageTitle");
                                hlURL = (HyperLink)ri.FindControl("hlURL");
                                ddlPushType = (DropDownList)ri.FindControl("ddlPushType");
                                Utilities.ProfilesRNSDLL.BO.ORCID.PersonURL personURL = new Utilities.ProfilesRNSDLL.BLL.ORCID.PersonURL().GetByPersonIDAndURL(person.PersonID, hlURL.Text);
                                personURL.URLName = lblWebPageTitle.Text;
                                personURL.URL = hlURL.Text;
                                personURL.PersonID = person.PersonID;
                                personURL.DecisionID = int.Parse(ddlPushType.SelectedValue);
                                person.URLs.Add(personURL);
                                break;
                        }
                    }
                }
            
        }
        private void GetWorksFromThePage(Utilities.ProfilesRNSDLL.BO.ORCID.Person person)
        {
            if (rptPublications.Items.Count > 0)
            {
                int counter = 0;
                const string WORK_TYPE = "journal-article";

                foreach (RepeaterItem ri in rptPublications.Items)
                {
                    counter += 1;
                    switch (ri.ItemType)
                    {
                        case ListItemType.Item:
                        case ListItemType.AlternatingItem:
                            // Get the controls for this item.
                            DropDownList ddlPubVis = (DropDownList)ri.FindControl("ddlPubVis");
                            Label lblCitation = (Label)ri.FindControl("lblCitation");
                            Label lblPubDate = (Label)ri.FindControl("lblPubDate");
                            Label lblPubID = (Label)ri.FindControl("lblPubID");
                            Label lblPMID = (Label)ri.FindControl("lblPMID");
                            Label lblDOI = (Label)ri.FindControl("lblDOI");
                            Label lblArticleTitle = (Label)ri.FindControl("lblArticleTitle");

                            // Pubdate is required.
                            if (!Utilities.ProfilesRNSDLL.DevelopmentBase.Helpers.Date.IsDate(lblPubDate.Text))
                            {
                                continue;
                            }
                            Utilities.ProfilesRNSDLL.BO.ORCID.PersonWork work = new Utilities.ProfilesRNSDLL.BO.ORCID.PersonWork();
                            work.DecisionID = int.Parse(ddlPubVis.SelectedValue.ToString());
                            work.WorkCitation = lblCitation.Text;
                            work.PubDate = DateTime.Parse(lblPubDate.Text);
                            work.WorkType = WORK_TYPE;
                            work.PersonID = person.PersonID;
                            work.PubID = lblPubID.Text;
                            work.WorkTitle = lblArticleTitle.Text;

                            // Add the identifiers
                            if (!lblPMID.Text.Trim().Equals(string.Empty))
                            {
                                Utilities.ProfilesRNSDLL.BLL.ORCID.PersonWork.AddIdentifier(work, Utilities.ProfilesRNSDLL.BO.ORCID.REFWorkExternalType.REFWorkExternalTypes.pmid, lblPMID.Text);
                            }
                            if (!lblDOI.Text.Equals(Utilities.ProfilesRNSDLL.BLL.ORCID.DOI.DOI_NOT_FOUND_MESSAGE))
                            {
                                Utilities.ProfilesRNSDLL.BLL.ORCID.PersonWork.AddIdentifier(work, Utilities.ProfilesRNSDLL.BO.ORCID.REFWorkExternalType.REFWorkExternalTypes.doi, lblDOI.Text);
                            }
                            person.Works.Add(work);
                            break;
                    }
                }
            }
        }
        private Utilities.ProfilesRNSDLL.BO.ORCID.PersonAffiliation GetAffiliationFromThePage(RepeaterItem ri)
        {
            // Get the controls for this item.
            DropDownList ddlEmpVis = (DropDownList)ri.FindControl("ddlEmpVis");

            Label lblProfilesID = (Label)ri.FindControl("lblProfilesID");
            Label lblAffiliationTypeID = (Label)ri.FindControl("lblAffiliationTypeID");
            Label lblDepartmentName = (Label)ri.FindControl("lblDepartmentName");
            Label lblRoleTitle = (Label)ri.FindControl("lblRoleTitle");
            Label lblStartDate = (Label)ri.FindControl("lblStartDate");
            Label lblEndDate = (Label)ri.FindControl("lblEndDate");
            Label lblOrganizationName = (Label)ri.FindControl("lblOrganizationName");
            Label lblOrganizationCity = (Label)ri.FindControl("lblOrganizationCity");
            Label lblOrganizationRegion = (Label)ri.FindControl("lblOrganizationRegion");
            Label lblOrganizationCountry = (Label)ri.FindControl("lblOrganizationCountry");
            Label lblDisambiguationID = (Label)ri.FindControl("lblDisambiguationID");
            Label lblDisambiguationSource = (Label)ri.FindControl("lblDisambiguationSource");

            Utilities.ProfilesRNSDLL.BO.ORCID.PersonAffiliation personAffiliation = new Utilities.ProfilesRNSDLL.BO.ORCID.PersonAffiliation();
            personAffiliation.DecisionID = int.Parse(ddlEmpVis.SelectedValue.ToString());
            personAffiliation.ProfilesID = int.Parse(lblProfilesID.Text);
            personAffiliation.AffiliationTypeID = int.Parse(lblAffiliationTypeID.Text);
            if (!lblDepartmentName.Text.Equals(string.Empty))
            {
                personAffiliation.DepartmentName = lblDepartmentName.Text;
            }
            personAffiliation.RoleTitle = lblRoleTitle.Text;
            if (!lblStartDate.Text.Equals(string.Empty))
            {
                personAffiliation.StartDate = DateTime.Parse(lblStartDate.Text);
            }
            if (!lblEndDate.Text.Equals(string.Empty))
            {
                personAffiliation.EndDate = DateTime.Parse(lblEndDate.Text);
            }
            personAffiliation.OrganizationName = lblOrganizationName.Text;
            if (!lblOrganizationCity.Text.Equals(string.Empty))
            {
                personAffiliation.OrganizationCity = lblOrganizationCity.Text;
            }
            if (!lblOrganizationRegion.Text.Equals(string.Empty))
            {
                personAffiliation.OrganizationRegion = lblOrganizationRegion.Text;
            }
            if (!lblOrganizationCountry.Text.Equals(string.Empty))
            {
                personAffiliation.OrganizationCountry = lblOrganizationCountry.Text;
            }

            if (!lblDisambiguationID.Text.Equals(string.Empty))
            {
                personAffiliation.DisambiguationID = lblDisambiguationID.Text;
                personAffiliation.DisambiguationSource = lblDisambiguationSource.Text;
            }
            return personAffiliation;
        }
        private void GetAffiliationsFromThePage(Utilities.ProfilesRNSDLL.BO.ORCID.Person person)
        {
            if (rptPersonAffiliations.Items.Count > 0)
            {
                int counter = 0;
                foreach (RepeaterItem ri in rptPersonAffiliations.Items)
                {
                    switch (ri.ItemType)
                    {
                        case ListItemType.Item:
                        case ListItemType.AlternatingItem:
                            counter += 1;
                            person.Affiliations.Add(GetAffiliationFromThePage(ri));
                            break;
                    }
                }
            }
        }
        private void LoadURLs(Utilities.ProfilesRNSDLL.BO.ORCID.Person orcidPerson)
        {
            this.divWebsites.Visible = (orcidPerson.URLs.Count > 0);
            if (orcidPerson.URLs.Count > 0)
            {
                rptPersonURLs.DataSource = orcidPerson.URLs;
                rptPersonURLs.DataBind();
            }
        }
        private void LoadBIO(Utilities.ProfilesRNSDLL.BO.ORCID.Person orcidPersonWithData)
        {
            if (!orcidPersonWithData.BiographyIsNull)
            {
                this.txtResearchExpertiseAndProfessionalInterests.Text = orcidPersonWithData.Biography;
                if (!orcidPersonWithData.BiographyDecisionIDIsNull)
                {
                    Utilities.ProfilesRNSDLL.DevelopmentBase.UICommon.SetValue(orcidPersonWithData.BiographyDecisionID.ToString(), false, this.ddlResearchExpertiseAndProfessionalInterestsVis);
                }
            }

            // Get what has been saved before
            Utilities.ProfilesRNSDLL.BO.ORCID.Person orcidPerson = GetPerson();
            divResearchExpertiseAndProfessionalInterests.Visible = this.txtResearchExpertiseAndProfessionalInterests.Text.Length > 0
                && (orcidPerson.BiographyIsNull || orcidPerson.Biography != this.txtResearchExpertiseAndProfessionalInterests.Text);
        }
        private int publicationsVisibility = (int)Utilities.ProfilesRNSDLL.BO.ORCID.REFDecision.REFDecisions.Public;
        private void LoadPublications(Utilities.ProfilesRNSDLL.BO.ORCID.Person person)
        {
            int defaultid = 0;
            List<Utilities.ProfilesRNSDLL.BO.ORCID.PersonWork> pubs = person.Works;
            
            if (pubs.Count > 0)
                divPublications.Visible = true;
            else
                divPublications.Visible = false;

            if (pubs.Count > 0)
            {
                publicationsVisibility = pubs[0].DecisionID;
                this.PublicationMessageWhenORCIDExists.Visible = !GetPerson().ORCIDIsNull;
                rptPublications.DataSource = pubs;
                rptPublications.DataBind();
                defaultid = pubs[0].DecisionID;

            }

            if (defaultid > 0) { defaultid -= 1; }

            selPrivacy.Items[defaultid].Selected = true;



        }
        private void LoadAffiliations(Utilities.ProfilesRNSDLL.BO.ORCID.Person orcidPerson)
        {
            //List<Utilities.ProfilesRNSDLL.BO.ORCID.PersonAffiliation> affiliations = Affiliations;
            divAffiliations.Visible = orcidPerson.Affiliations.Count > 0;
            if (orcidPerson.Affiliations.Count > 0)
            {
                this.AffiliationsMessageWhenORCIDExists.Visible = !orcidPerson.ORCIDIsNull;
                rptPersonAffiliations.DataSource = orcidPerson.Affiliations;
                rptPersonAffiliations.DataBind();
            }
        }
        private string _UserID = null;
        private string UserID
        {
            get
            {

                if (_UserID == null)
                {
                    _UserID = data.GetInternalUserID();
                }
                return _UserID;
            }
        }
        private Utilities.ProfilesRNSDLL.BO.ORCID.Person GetPersonWithDBData()
        {
            int profilePersonID = new Profiles.Edit.Utilities.DataIO().GetPersonID(base.RDFTriple.Subject);
            return new Utilities.ProfilesRNSDLL.BLL.ORCID.Person().GetPersonWithDBData(profilePersonID, sm.Session().SessionID);
        }

        private Utilities.ProfilesRNSDLL.BO.ORCID.Person GetPersonWithDBData(int subject)
        {
            int profilePersonID = new Profiles.Edit.Utilities.DataIO().GetPersonID(subject);
            return new Utilities.ProfilesRNSDLL.BLL.ORCID.Person().GetPersonWithDBData(profilePersonID, sm.Session().SessionID);
        }

        public string RootDomain()
        {
            return Root.Domain;
        }
    }
}