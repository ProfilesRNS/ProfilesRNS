using System;
using System.Collections.Generic;
using System.Linq;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.ORCID
{
    public partial class PersonMessage : BLL.ORCID.Interfaces.IPersonMessage
    {
        public List<BO.ORCID.PersonMessage> GetByPersonID(int personID)
        {
            return base.GetByPersonID(personID, false);
        }
        public List<BO.ORCID.PersonMessage> GetByPersonIDAndRecordStatusID(int personID, int recordStatusID)
        {
            return base.GetByPersonIDAndRecordStatusID(personID, recordStatusID, false);
        }
        public BO.ORCID.PersonMessage Create(BO.ORCID.Person person, BO.ORCID.REFPermission refPermission)
        {
            ProfilesRNSDLL.BO.ORCID.PersonMessage personMessage = new ProfilesRNSDLL.BO.ORCID.PersonMessage();
            personMessage.PermissionID = refPermission.PermissionID;
            personMessage.RecordStatusID = (int)ProfilesRNSDLL.BO.ORCID.REFRecordStatus.REFRecordStatuss.Waiting_for_ORCID_User_for_approval;
            personMessage.PersonID = person.PersonID;
            personMessage.RequestURL = ProfilesRNSDLL.BO.ORCID.Config.ORCID_API_URL_WITH_VERSION + "/" + person.ORCID + "/" + refPermission.MethodAndRequest;
            new BLL.ORCID.PersonMessage().Save(personMessage);
            return personMessage;
        }
        public void CreateUploadMessages(BO.ORCID.Person person, string loggedInInternalUsername)
        {
            // Before opening the transaction get the 'read limited' token if it exists.
            // if it does not exist or is expired we will create a message to update it.
            BO.ORCID.PersonToken personToken = new BLL.ORCID.PersonToken().GetByPersonIDAndPermissionID(person.PersonID, (int)BO.ORCID.REFPermission.REFPermissions.orcid_profile_read_limited);

            using (System.Data.Common.DbTransaction trans = base.GetEditTransaction())
            {
                try
                {
                    new ProfilesRNSDLL.BLL.ORCID.Person().Edit(person, trans);
                    if (!personToken.Exists || personToken.IsExpired)
                    {
                        CreateMessageToReadLimited(person, trans);
                    }
                    if (person.PushBiographyToORCID || (person.HasURLsToPush))
                    {
                        CreateBioUpdateMessage(person, trans, loggedInInternalUsername);
                    }
                    WorksUpdate(person, trans);
                    AffiliationsUpdate(person, trans);
                    trans.Commit();
                }
                catch (Exception ex)
                {
                    trans.Rollback();
                    throw ErrorLog.LogError(ex, loggedInInternalUsername, "An error occurred while generating the messages to send to ORCID.");
                }
            }
        }
        public void ProcessORCID_ResponseError(BO.ORCID.PersonMessage personMessage, string error, string errorDescription)
        {
            if (!error.Equals(string.Empty))
            {
                switch (errorDescription.ToLower())
                {
                    case "user denied access":
                        personMessage.RecordStatusID = (int)BO.ORCID.REFRecordStatus.REFRecordStatuss.ORCID_User_Denied;
                        break;
                    default:
                        personMessage.RecordStatusID = (int)BO.ORCID.REFRecordStatus.REFRecordStatuss.Denied_Access;
                        break;
                }
                Save(personMessage);
            }
        }

        internal static void SetPersonMessageID(BO.ORCID.Person person)
        {
            BLL.ORCID.PersonURL.SetPersonMessageID(person);
            BLL.ORCID.PersonAlternateEmail.SetPersonMessageID(person);
            BLL.ORCID.PersonWork.SetPersonMessageID(person);
            BLL.ORCID.PersonOthername.SetPersonMessageID(person);
            BLL.ORCID.PersonAffiliation.SetPersonMessageID(person);
        }        
        internal static string CreateNewBasicORCIDMessage(BO.ORCID.Person person)
        {
            string msg = XML_MESSAGE_HEADER;
            msg += ORCID_MESSAGE_BEGIN;
            {
                msg += "<message-version>" + BO.ORCID.Config.MessageVersion + "</message-version>";
                msg += "<!-- <error-desc>No researcher found.</error-desc> --> ";
                # region orcid-profile
                msg += "<orcid-profile>";
                {
                    # region orcid-bio
                    msg += "<orcid-bio>";
                    {
                        AddPersonDetails(ref msg, person);
                        AddBioFieldNewORCID(ref msg, person);
                        AddContactDetails(ref msg, person);
                    }
                    msg += "</orcid-bio>";
                    # endregion orcid-bio

                    AddActivities(ref msg, person);
                }
                msg += "</orcid-profile>";
                # endregion orcid-profile
            }
            msg += ORCID_MESSAGE_END;
            return msg;
        }
        internal bool CreatePersonMessage(BO.ORCID.Person person)
        {
            person.PersonMessage = new BO.ORCID.PersonMessage();
            person.PersonMessage.PersonID = person.PersonID;
            person.PersonMessage.XML_Sent = PersonMessage.CreateNewBasicORCIDMessage(person);
            person.PersonMessage.PermissionID = (int)ProfilesRNSDLL.BO.ORCID.REFPermission.REFPermissions.orcid_profile_create;
            person.PersonMessage.RecordStatusID = (int)ProfilesRNSDLL.BO.ORCID.REFRecordStatus.REFRecordStatuss.Success;
            return Save(person.PersonMessage);
        }        
        internal bool Save(BO.ORCID.PersonMessage bo)
        {
            if (bo.Exists)
            {
                return base.Edit(bo);
            }
            else
            {
                return base.Add(bo);
            }
        }
        internal bool Save(BO.ORCID.PersonMessage bo, System.Data.Common.DbTransaction trans)
        {
            if (bo.Exists)
            {
                return base.Edit(bo, trans);
            }
            else
            {
                return base.Add(bo, trans);
            }
        }

        private const string XML_MESSAGE_HEADER = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>";
        private const string ORCID_MESSAGE_BEGIN = "<orcid-message xmlns=\"http://www.orcid.org/ns/orcid\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://www.orcid.org/ns/orcid http://orcid.github.com/ORCID-Parent/schemas/orcid-message/1.0.7/orcid-message-1.0.23.xsd\" >";
        private const string ORCID_MESSAGE_END = "</orcid-message>";
        private static void AddContactDetails(ref string msg, BO.ORCID.Person person)
        {
            msg += "<contact-details>";
            {
                msg += "<email visibility=\"" + person.EmailDecision.ToLower() + "\" primary=\"true\">" + person.EmailAddress + "</email>";
                foreach (string alternateEmail in person.AlternateEmails.Select(ae => ae.EmailAddress).ToList())
                {
                    msg += "<email visibility=\"" + person.AlternateEmailDecision.ToLower() + "\" primary=\"false\">" + alternateEmail + "</email>";
                }
            }
            msg += "</contact-details>";
        }
        private static void AddPersonDetails(ref string msg, BO.ORCID.Person person)
        {
            msg += "<personal-details>";
            {
                msg += "<given-names>" + System.Web.HttpContext.Current.Server.HtmlEncode(person.FirstName) + "</given-names>";
                msg += "<family-name>" + System.Web.HttpContext.Current.Server.HtmlEncode(person.LastName) + "</family-name>";
                if (!string.IsNullOrEmpty(person.PublishedName))
                {
                    msg += "<credit-name>" + System.Web.HttpContext.Current.Server.HtmlEncode(person.PublishedName) + "</credit-name>";
                }
                if (person.Othernames.Count > 0)
                {
                    msg += "<other-names>";

                    foreach (BO.ORCID.PersonOthername othername in person.Othernames)
                    {
                        msg += "<other-name>" + System.Web.HttpContext.Current.Server.HtmlEncode(othername.OtherName) + "</other-name>";
                    }
                    msg += "</other-names>";
                }
            }
            msg += "</personal-details>";
        }
        private static void AddBioFieldNewORCID(ref string msg, BO.ORCID.Person person)
        {
            if (person.BiographyDecisionID != (int)BO.ORCID.REFDecision.REFDecisions.Exclude && person.PushBiographyToORCID)
            {
                msg += "<biography visibility=\"" + person.BiographyDecision.ToLower() + "\">" + System.Web.HttpContext.Current.Server.HtmlEncode(person.Biography) + "</biography>";
            }
            if (person.HasURLsToPush)
            {
                msg += "<researcher-urls>";
                {
                    foreach (BO.ORCID.PersonURL personURL in person.URLsToPush)
                    {
                        msg += "<researcher-url>";
                        {
                            msg += "<url-name>" + System.Web.HttpContext.Current.Server.HtmlEncode(personURL.URLName) + "</url-name>";
                            msg += "<url>" + System.Web.HttpContext.Current.Server.HtmlEncode(personURL.URL) + "</url>";
                        }
                        msg += "</researcher-url>";
                    }
                }
                msg += "</researcher-urls>";
            }
        }
        private static void AddBioFieldExistingORCID(ref string msg, BO.ORCID.Person person, string loggedInInternalUsername)
        {
            System.Xml.XmlDocument orcidXML = new ProfilesRNSDLL.BLL.ORCID.Person().GetORCIDRecord(person, loggedInInternalUsername);

            System.Xml.XmlNamespaceManager nsmgr = new System.Xml.XmlNamespaceManager(orcidXML.NameTable);
            nsmgr.AddNamespace("a", "http://www.orcid.org/ns/orcid");

            System.Xml.XmlNodeList biographyNodes = null;
            System.Xml.XmlNodeList urlNodes = null;

            if (orcidXML != null)
            {
                //biographyNodes = orcidXML.SelectNodes("/orcid-message/orcid-profile/orcid-bio/biography", nsmgr);
                biographyNodes = orcidXML.SelectNodes("//a:orcid-message/a:orcid-profile/a:orcid-bio/a:biography", nsmgr);
                urlNodes = orcidXML.SelectNodes("//a:orcid-message/a:orcid-profile/a:orcid-bio/a:researcher-urls", nsmgr);
            }

            if (person.BiographyDecisionID != (int)BO.ORCID.REFDecision.REFDecisions.Exclude && person.PushBiographyToORCID)
            {
                msg += "<biography visibility=\"" + person.BiographyDecision.ToLower() + "\">" + System.Web.HttpContext.Current.Server.HtmlEncode(person.Biography) + "</biography>";
            }
            else if (biographyNodes != null && biographyNodes.Count > 0)
            {
                msg += biographyNodes[0].OuterXml;
            }

            // if there are existing urls add the new ones to the list
            if (urlNodes != null && urlNodes.Count > 0)
            {
                msg += "<researcher-urls visibility=\"public\"> ";
                msg += urlNodes[0].InnerXml;
                GetNewURLs(ref msg, person);
                msg += "</researcher-urls>";
                return;
            }

            // otherwise just push the new ones.
            if (person.HasURLsToPush)
            {
                msg += "<researcher-urls visibility=\"public\"> ";
                {
                    GetNewURLs(ref msg, person);
                }
                msg += "</researcher-urls>";
            }
        }
        private static void GetNewURLs(ref string msg, BO.ORCID.Person person)
        {
            foreach (BO.ORCID.PersonURL personURL in person.URLsToPush)
            {
                msg += "<researcher-url visibility=\"public\">";
                {
                    msg += "<url-name>" + System.Web.HttpContext.Current.Server.HtmlEncode(personURL.URLName) + "</url-name>";
                    msg += "<url>" + System.Web.HttpContext.Current.Server.HtmlEncode(personURL.URL) + "</url>";
                }
                msg += "</researcher-url>";
            }
        }
        private static void AddWorks(ref string msg, BO.ORCID.Person person)
        {
            if (person.HasWorksToPush)
            {
                msg += "<orcid-works>";
                {
                    foreach (BO.ORCID.PersonWork personWork in person.WorksToPush)
                    {
                        if (personWork.Identifiers != null && personWork.Identifiers.Count != 0)
                        {
                            msg += "<orcid-work visibility=\"" + personWork.Decision.ToLower() + "\">";
                            {
                                msg += "<work-title>";
                                {
                                    msg += "<title>" + System.Web.HttpContext.Current.Server.HtmlEncode(personWork.WorkTitle) + "</title>";
                                    //msg += "<subtitle>" + personWork.WorkTitle + "</subtitle>";
                                }
                                msg += "</work-title>";
                                //msg += "<short-description>" + personWork.ShortDescription + "</short-description>";
                                if (!personWork.WorkCitationIsNull)
                                {
                                    msg += "<work-citation>";
                                    msg += "  <work-citation-type>formatted-unspecified</work-citation-type>";
                                    msg += "  <citation>" + System.Web.HttpContext.Current.Server.HtmlEncode(personWork.WorkCitation) + "</citation>";
                                    msg += "</work-citation>";
                                }
                                msg += "<work-type>" + System.Web.HttpContext.Current.Server.HtmlEncode(personWork.WorkType) + "</work-type>";
                                msg += "<publication-date>";
                                {
                                    if (!personWork.PubDateIsNull)
                                    {
                                        msg += "<year>" + personWork.PubDate.Year.ToString() + "</year>";
                                        msg += "<month>" + personWork.PubDate.ToString("MM") + "</month>";
                                        msg += "<day>" + personWork.PubDate.ToString("dd") + "</day>";
                                    }
                                }
                                msg += "</publication-date>";

                                msg += "<work-external-identifiers>";
                                {
                                    foreach (BO.ORCID.PersonWorkIdentifier personWorkIdentifier in personWork.Identifiers)
                                    {
                                        msg += "<work-external-identifier>";
                                        {
                                            msg += "<work-external-identifier-type>" + personWorkIdentifier.WorkExternalType + "</work-external-identifier-type>";
                                            msg += "<work-external-identifier-id>" + System.Web.HttpContext.Current.Server.HtmlEncode(personWorkIdentifier.Identifier) + "</work-external-identifier-id>";
                                        }
                                        msg += "</work-external-identifier>";
                                    }
                                }
                                msg += "</work-external-identifiers>";
                                //<work-contributors>
                                //  <contributor>
                                //    <credit-name>LastName, FirstName</credit-name>
                                //    <contributor-attributes>
                                //      <contributor-sequence>first</contributor-sequence>
                                //      <contributor-role>author</contributor-role>
                                //    </contributor-attributes>
                                //  </contributor>
                                //</work-contributors>
                            }
                            msg += "</orcid-work>";
                        }

                    }
                }
                msg += "</orcid-works>";
            }
        }
        private static void AddAffiliations(ref string msg, BO.ORCID.Person person)
        {
            if (person.HasAffiliationsToPush)
            {
                msg += "<affiliations>";
                {
                    foreach (BO.ORCID.PersonAffiliation personAffiliation in person.AffiliationsToPush)
                    {
                        msg += "    <affiliation visibility=\"" + personAffiliation.Decision.ToLower() + "\">";
                        msg += "      <type>" + System.Web.HttpUtility.HtmlEncode(personAffiliation.AffiliationType) + "</type>";
                        if (!personAffiliation.DepartmentNameIsNull)
                        {
                            msg += "      <department-name>" + System.Web.HttpUtility.HtmlEncode(personAffiliation.DepartmentName) + "</department-name>";
                        }
                        msg += "      <role-title>" + System.Web.HttpUtility.HtmlEncode(personAffiliation.RoleTitle) + "</role-title>";
                        if (!personAffiliation.StartDateIsNull)
                        {
                            msg += "      <start-date>";
                            msg += "        <year>" + personAffiliation.StartDate.Year.ToString() + "</year>";
                            msg += "        <month>" + personAffiliation.StartDate.Month.ToString() + "</month>";
                            msg += "        <day>" + personAffiliation.StartDate.Day.ToString() + "</day>";
                            msg += "      </start-date>";
                        }
                        if (!personAffiliation.EndDateIsNull)
                        {
                            msg += "      <end-date>";
                            msg += "        <year>" + personAffiliation.EndDate.Year.ToString() + "</year>";
                            msg += "        <month>" + personAffiliation.EndDate.Month.ToString() + "</month>";
                            msg += "        <day>" + personAffiliation.EndDate.Day.ToString() + "</day>";
                            msg += "      </end-date>";
                        }

                        msg += "      <organization>";
                        msg += "        <name>" + System.Web.HttpUtility.HtmlEncode(personAffiliation.OrganizationName) + "</name>";
                        if (!personAffiliation.Address.Equals(string.Empty))
                        {
                            msg += "        <address>";
                            if (!personAffiliation.OrganizationCityIsNull && !personAffiliation.OrganizationCity.Equals(string.Empty))
                            {
                                msg += "            <city>" + System.Web.HttpUtility.HtmlEncode(personAffiliation.OrganizationCity) + "</city>";
                            }
                            if (!personAffiliation.OrganizationRegionIsNull && !personAffiliation.OrganizationRegion.Equals(string.Empty))
                            {
                                msg += "            <region>" + System.Web.HttpUtility.HtmlEncode(personAffiliation.OrganizationRegion) + "</region>";
                            }
                            if (!personAffiliation.OrganizationCountryIsNull && !personAffiliation.OrganizationCountry.Equals(string.Empty))
                            {
                                msg += "            <country>" + System.Web.HttpUtility.HtmlEncode(personAffiliation.OrganizationCountry) + "</country>";
                            }
                            msg += "        </address>";
                        }
                        if (!personAffiliation.DisambiguationIDIsNull && !personAffiliation.DisambiguationID.Equals(string.Empty))
                        {
                            msg += "        <disambiguated-organization>";
                            msg += "            <disambiguated-organization-identifier>" + System.Web.HttpUtility.HtmlEncode(personAffiliation.DisambiguationID) + "</disambiguated-organization-identifier>";
                            msg += "            <disambiguation-source>" + personAffiliation.DisambiguationSource + "</disambiguation-source>";
                            msg += "        </disambiguated-organization>";
                        }
                        msg += "      </organization>";
                        msg += "    </affiliation>";
                    }
                }
                msg += "</affiliations>";
            }
        }
        private static void AddActivities(ref string msg, BO.ORCID.Person person)
        {
            if (person.HasWorksToPush || person.HasAffiliationsToPush)
            {
                msg += "<orcid-activities>";
                {
                    AddWorks(ref msg, person);
                    AddAffiliations(ref msg, person);
                }
                msg += "</orcid-activities>";
            }
        }
        private static string GetORCIDBioUpdateMessage(BO.ORCID.Person person, string loggedInInternalUsername)
        {
            string msg = XML_MESSAGE_HEADER;
            msg += ORCID_MESSAGE_BEGIN;
            {
                msg += "<message-version>" + BO.ORCID.Config.MessageVersion + "</message-version>";
                msg += "<!-- <error-desc>No researcher found.</error-desc> --> ";
                msg += "<orcid-profile>";
                {
                    msg += "<orcid-bio>";
                    {
                        AddBioFieldExistingORCID(ref msg, person, loggedInInternalUsername);
                    }
                    msg += "</orcid-bio>";
                }
                msg += "</orcid-profile>";
            }
            msg += ORCID_MESSAGE_END;
            return msg;
        }
        private string GetORCIDActivitiesWorksUpdateMessage(BO.ORCID.Person person)
        {
            string msg = XML_MESSAGE_HEADER;
            msg += ORCID_MESSAGE_BEGIN;
            {
                msg += "<message-version>" + BO.ORCID.Config.MessageVersion + "</message-version>";
                msg += "<!-- <error-desc>No researcher found.</error-desc> --> ";
                msg += "<orcid-profile>";
                {
                    if (person.HasWorksToPush)
                    {
                        msg += "<orcid-activities>";
                        {
                            AddWorks(ref msg, person);
                        }
                        msg += "</orcid-activities>";
                    }
                }
                msg += "</orcid-profile>";
            }
            msg += ORCID_MESSAGE_END;
            return msg;
        }
        private string GetORCIDActivitiesAffiliationsUpdateMessage(BO.ORCID.Person person)
        {
            string msg = XML_MESSAGE_HEADER;
            msg += ORCID_MESSAGE_BEGIN;
            {
                msg += "<message-version>" + BO.ORCID.Config.MessageVersion + "</message-version>";
                msg += "<!-- <error-desc>No researcher found.</error-desc> --> ";
                msg += "<orcid-profile>";
                {
                    if (person.HasAffiliationsToPush)
                    {
                        msg += "<orcid-activities>";
                        {
                            AddAffiliations(ref msg, person);
                        }
                        msg += "</orcid-activities>";
                    }
                }
                msg += "</orcid-profile>";
            }
            msg += ORCID_MESSAGE_END;
            return msg;
        }
        private void CreateMessageToReadLimited(BO.ORCID.Person person, System.Data.Common.DbTransaction trans)
        {
            if (!ReadLimitedMessageAlreadyCreated(person))
            {
                BO.ORCID.PersonMessage personMessage = new BO.ORCID.PersonMessage();
                personMessage.PersonID = person.PersonID;
                personMessage.RecordStatusID = (int)BO.ORCID.REFRecordStatus.REFRecordStatuss.Waiting_for_ORCID_User_for_approval;
                personMessage.PermissionID = (int)BO.ORCID.REFPermission.REFPermissions.orcid_profile_read_limited;
                Add(personMessage, trans);
            }
        }
        private bool ReadLimitedMessageAlreadyCreated(BO.ORCID.Person person)
        {
            List<BO.ORCID.PersonMessage> readLimitedMessage = GetByPersonID(person.PersonID).Where(pm => pm.PermissionID == (int)BO.ORCID.REFPermission.REFPermissions.orcid_profile_read_limited).ToList();
            return (readLimitedMessage.Count > 0);
        }
        private void CreateWorksUpdateMessage(BO.ORCID.Person person, System.Data.Common.DbTransaction trans)
        {
            BO.ORCID.PersonMessage personMessage = new BO.ORCID.PersonMessage();
            personMessage.PersonID = person.PersonID;
            personMessage.RecordStatusID = (int)ProfilesRNSDLL.BO.ORCID.REFRecordStatus.REFRecordStatuss.Waiting_for_ORCID_User_for_approval;
            personMessage.XML_Sent = GetORCIDActivitiesWorksUpdateMessage(person);
            personMessage.PermissionID = (int)ProfilesRNSDLL.BO.ORCID.REFPermission.REFPermissions.orcid_works_create;

            if (Add(personMessage, trans))
            {
                foreach (BO.ORCID.PersonWork personWork in person.WorksToPush)
                {
                    personWork.PersonID = person.PersonID;
                    personWork.PersonMessageID = personMessage.PersonMessageID;
                }
            }
            else
            {
                throw new DevelopmentBase.BO.ExceptionSafeToDisplay("Unable to log the work message to ORCID");
            }
        }
        private void CreateAffiliationsUpdateMessage(BO.ORCID.Person person, System.Data.Common.DbTransaction trans)
        {
            BLL.ORCID.PersonAffiliation personAffiliationBLL = new PersonAffiliation();

            BO.ORCID.PersonMessage personMessage = new BO.ORCID.PersonMessage();
            personMessage.PersonID = person.PersonID;
            personMessage.RecordStatusID = (int)ProfilesRNSDLL.BO.ORCID.REFRecordStatus.REFRecordStatuss.Waiting_for_ORCID_User_for_approval;
            personMessage.XML_Sent = GetORCIDActivitiesAffiliationsUpdateMessage(person);
            personMessage.PermissionID = (int)ProfilesRNSDLL.BO.ORCID.REFPermission.REFPermissions.affiliations_create;

            if (Add(personMessage, trans))
            {
                foreach (BO.ORCID.PersonAffiliation personAffiliation in person.AffiliationsToPush)
                {
                    personAffiliation.PersonMessageID = personMessage.PersonMessageID;
                }
            }
            else
            {
                throw new DevelopmentBase.BO.ExceptionSafeToDisplay("Unable to log the affiliation message to ORCID");
            }
        }
        private void WorksUpdate(BO.ORCID.Person person, System.Data.Common.DbTransaction trans)
        {
            BLL.ORCID.PersonWork personWorkBLL = new PersonWork();
            foreach (BO.ORCID.PersonWork personWork in person.Works)
            {
                personWork.PersonID = person.PersonID;
            }
            if (person.HasWorksToPush)
            {
                CreateWorksUpdateMessage(person, trans);
            }
            if (!personWorkBLL.AddIfAny(person, trans))
            {
                throw new DevelopmentBase.BO.ExceptionSafeToDisplay("Unable to save the work info while creating a work message to ORCID");
            }
        }
        private void AffiliationsUpdate(BO.ORCID.Person person, System.Data.Common.DbTransaction trans)
        {
            BLL.ORCID.PersonAffiliation personAffiliationBLL = new PersonAffiliation();
            foreach (BO.ORCID.PersonAffiliation personAffiliation in person.Affiliations)
            {
                personAffiliation.PersonID = person.PersonID;
            }
            if (person.HasAffiliationsToPush)
            {
                CreateAffiliationsUpdateMessage(person, trans);
            }
            if (!personAffiliationBLL.AddIfAny(person, trans))
            {
                throw new DevelopmentBase.BO.ExceptionSafeToDisplay("Unable to save the work info while creating a work message to ORCID");
            }
        }
        private void CreateBioUpdateMessage(BO.ORCID.Person person, System.Data.Common.DbTransaction trans, string loggedInInternalUsername)
        {
            //BLL.ORCID.Person personBLL = new Person();
            BLL.ORCID.PersonURL personURLBLL = new PersonURL();
            person.PersonMessage = new BO.ORCID.PersonMessage();
            person.PersonMessage.PersonID = person.PersonID;
            person.PersonMessage.RecordStatusID = (int)ProfilesRNSDLL.BO.ORCID.REFRecordStatus.REFRecordStatuss.Waiting_for_ORCID_User_for_approval;
            person.PersonMessage.XML_Sent = GetORCIDBioUpdateMessage(person, loggedInInternalUsername);
            person.PersonMessage.PermissionID = (int)ProfilesRNSDLL.BO.ORCID.REFPermission.REFPermissions.orcid_bio_update;

            if (Add(person.PersonMessage, trans))
            {
                foreach (BO.ORCID.PersonURL personURL in person.URLs)
                {
                    personURL.PersonID = person.PersonID;
                    personURL.PersonMessageID = person.PersonMessage.PersonMessageID;
                }

                if (!(new BLL.ORCID.PersonURL().AddIfAny(person, trans)))
                {
                    throw new DevelopmentBase.BO.ExceptionSafeToDisplay("Unable to save the website info while creating a bio message to ORCID");
                }
            }
            else
            {
                throw new DevelopmentBase.BO.ExceptionSafeToDisplay("Unable to log the bio message to ORCID");
            }
        }
    }
}