/*  
 
    Copyright (c) 2008-2012 by the President and Fellows of Harvard College. All rights reserved.  
    Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
    and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
    National Center for Research Resources and Harvard University.


    Code licensed under a BSD License. 
    For details, see: LICENSE.txt 
  
*/
using System;
using System.Linq;
using System.Web.UI.WebControls;
using System.Xml;
using Profiles.Framework.Utilities;

using System.Data;

namespace Profiles.ORCID.Modules.CreateBatch
{
    public partial class CreateBatch : ORCIDBaseModule
    {
        public CreateBatch()
        {
            base.RDFTriple = new RDFTriple(Convert.ToInt64(sm.Session().NodeID.ToString()));             
        }
        public void Initialize(XmlDocument basedata, XmlNamespaceManager namespaces, RDFTriple rdftriple)
        {
            BaseData = basedata;
            Namespaces = namespaces;
            RDFTriple = rdftriple;
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
            }
            catch (Exception ex)
            {
                LogException(ex);
            }
        }
        protected void DrawProfilesModule()
        {
            this.listBoxInstitutionID.DataSource = new Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.Profile.Data.OrganizationInstitution().Gets();
            this.listBoxInstitutionID.DataBind();
            for (int i = 0; i < listBoxInstitutionID.Items.Count; i++)
            {
                listBoxInstitutionID.Items[i].Selected = true;
            }
            this.listBoxDepartmentID.DataSource = new Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.Profile.Data.OrganizationDepartment().Gets();
            this.listBoxDepartmentID.DataBind();
            for (int i = 0; i < listBoxDepartmentID.Items.Count; i++)
            {
                listBoxDepartmentID.Items[i].Selected = true;
            }
            this.listBoxDivisionID.DataSource = new Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.Profile.Data.OrganizationDivision().Gets();
            this.listBoxDivisionID.DataBind();
            for (int i = 0; i < listBoxDivisionID.Items.Count; i++)
            {
                listBoxDivisionID.Items[i].Selected = true;
            }
            this.listBoxFacultyRankID.DataSource = new Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.Profile.Data.PersonFacultyRank().Gets();
            this.listBoxFacultyRankID.DataBind();
            for (int i = 0; i < listBoxFacultyRankID.Items.Count; i++)
            {
                listBoxFacultyRankID.Items[i].Selected = true;
            }
            ChangeVisibility();
        }
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            if (rbSearchTypeAll.Checked)
            {
                PopulateSearchResults(ProfilePersonBLL.GetPeopleWithoutAnORCID());
            }
            else if (rbSearchTypeClass.Checked)
            {
                System.Data.DataView dv = ProfilePersonBLL.GetSearchResults(PrimaryAffiliationOnly, SelectedInstitutionIDs,
                                                                            SelectedDepartmentIDs, SelectedDivisionIDs,
                                                                            SelectedFacultyRankIDs);
                PopulateSearchResults(dv);
            }
            else
            {
                System.Data.DataView dv = ProfilePersonBLL.GetPeopleWithoutAnORCIDByName(this.txtName.Text);
                PopulateSearchResults(dv);
            }
        }
        protected void rbSearchTypeAll_CheckedChanged(object sender, EventArgs e)
        {
            ChangeVisibility();
        }
        protected void rbSearchTypeClass_CheckedChanged(object sender, EventArgs e)
        {
            ChangeVisibility();
        }
        protected void rbSearchTypeParticularPerson_CheckedChanged(object sender, EventArgs e)
        {
            ChangeVisibility();
        }
        protected void btnCreateORCIDs_Click(object sender, EventArgs e)
        {
            Profiles.Framework.Utilities.DataIO data = new Profiles.Framework.Utilities.DataIO();
            if (data.GetSessionSecurityGroup() != -50)
            {
                this.AddError("Only Administrators can push records to ORCID");
            }
            else
            {
                foreach (RepeaterItem ri in this.rptSearchResults.Items)
                {
                    switch (ri.ItemType)
                    {
                        case ListItemType.Item:
                        case ListItemType.AlternatingItem:
                            CheckBox chkSelected = (CheckBox)ri.FindControl("chkSelected");
                            if (chkSelected.Checked)
                            {
                                Label lblPersonID = (Label)ri.FindControl("lblPersonID");
                                Label lblErrors = (Label)ri.FindControl("lblErrors");
                                Label lblMessages = (Label)ri.FindControl("lblMessages");

                                try
                                {
                                    Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID.Person bo = new Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.ORCID.Person().GetPersonWithDBData(int.Parse(lblPersonID.Text), sm.Session().SessionID);
                                    if (!bo.BiographyIsNull && !bo.Biography.Equals(string.Empty))
                                    {
                                        bo.PushBiographyToORCID = true;
                                    }

                                    //System.Threading.Thread.Sleep(2000);

                                    if (new Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.ORCID.Person().CreateNewORCID(bo, LoggedInInternalUsername, Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID.REFPersonStatusType.REFPersonStatusTypes.User_Push_Failed))
                                    {
                                        Edit.Utilities.DataIO dataio = new Edit.Utilities.DataIO();
                                        long subjectID = Profiles.ORCID.Utilities.DataIO.getNodeIdFromPersonID(int.Parse(lblPersonID.Text));
                                        dataio.AddLiteral(subjectID, dataio.GetStoreNode("http://vivoweb.org/ontology/core#orcidId"), dataio.GetStoreNode(bo.ORCID), this.PropertyListXML);
                                        lblMessages.Text = "Success";
                                    }
                                    else
                                    {
                                        lblErrors.Text = bo.Error + bo.AllErrors + "<br /><br />";
                                    }
                                }
                                catch (Exception ex)
                                {
                                    // todo remove
                                    lblErrors.Text = ex.Message;                                    
                                    //this.lblErrors.Text = "An error occurred while creating the ORCID.";
                                }
                            }
                            break;
                    }
                }
            }
        }

        private Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.Profile.Data.Person _ProfilePersonBLL = null;
        private Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.Profile.Data.Person ProfilePersonBLL
        {
            get
            {
                if (_ProfilePersonBLL == null)
                {
                    _ProfilePersonBLL = new Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.Profile.Data.Person();
                }
                return _ProfilePersonBLL;

            }
        }
        private bool PrimaryAffiliationOnly
        {
            get
            {
                return this.rbSearchTypePrimaryAffiliationOnly.Checked;
            }
        }
        private string SelectedInstitutionIDs
        {
            get
            {
                return string.Join(", ", Profiles.ORCID.Utilities.ProfilesRNSDLL.DevelopmentBase.UICommon.GetSelectedValues(listBoxInstitutionID.Items).ToArray());
            }
        }
        private string SelectedDepartmentIDs
        {
            get
            {
                if (listBoxDepartmentID.GetSelectedIndices().Count() == listBoxDepartmentID.Items.Count)
                {
                    return "All";
                }
                return string.Join(", ", Profiles.ORCID.Utilities.ProfilesRNSDLL.DevelopmentBase.UICommon.GetSelectedValues(listBoxDepartmentID.Items).ToArray());
            }
        }
        private string SelectedDivisionIDs
        {
            get
            {
                if (listBoxDivisionID.GetSelectedIndices().Count() == listBoxDivisionID.Items.Count)
                {
                    return "All";
                }
                return string.Join(", ", Profiles.ORCID.Utilities.ProfilesRNSDLL.DevelopmentBase.UICommon.GetSelectedValues(listBoxDivisionID.Items).ToArray());
            }
        }
        private string SelectedFacultyRankIDs
        {
            get
            {
                return string.Join(", ", Profiles.ORCID.Utilities.ProfilesRNSDLL.DevelopmentBase.UICommon.GetSelectedValues(listBoxFacultyRankID.Items).ToArray());
            }
        }
        private void PopulateSearchResults(System.Data.DataView dv)
        {
            int MAX_NUMBER_TO_PUSH = Profiles.ORCID.Utilities.config.BatchCreateSize;
            divSearchResults.Visible = true;
            if (dv.Table.Rows.Count > 0)
            {
                this.btnCreateORCIDs.Visible = true;
                this.rptSearchResults.Visible = true;
                if (dv.Table.Rows.Count > MAX_NUMBER_TO_PUSH)
                {
                    this.lblSearhResultsCount.Visible = true;
                    this.lblSearhResultsCount.Text = "This site is currently configured (ORCID.BatchCreateSize setting in the web.config) to allow a maximum of " +
                        MAX_NUMBER_TO_PUSH.ToString() +
                        " profiles to be pushed at a time.  The list below shows the first " + MAX_NUMBER_TO_PUSH.ToString() + " results of the " + 
                        dv.Table.Rows.Count.ToString() +" total.<br />";
                    this.rptSearchResults.DataSource = dv.Table.AsEnumerable().Take(MAX_NUMBER_TO_PUSH).CopyToDataTable();
                }
                else
                {
                    this.rptSearchResults.DataSource = dv;
                    this.lblSearhResultsCount.Visible = false;
                }
                this.rptSearchResults.DataBind();
            }
            else
            {
                this.rptSearchResults.Visible = false;
                this.lblSearhResultsCount.Visible = false;
                this.lblSearchResultsNone.Text = "There were no profiles to push.";
                this.btnCreateORCIDs.Visible = false;
            }
        }
        private void ChangeVisibility()
        {
            this.divParticularPerson.Visible = this.rbSearchTypeParticularPerson.Checked;
            this.divSearch.Visible = this.rbSearchTypeClass.Checked;
        }        
    }
}