using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net;
using System.IO;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.ORCID
{
    public partial class Person
    {
        public static string EmailRequiredMessage
        {
            get
            {
                // string emailformat = "(@" + DevelopmentBase.Common.GetConfig("ORCID.OrganizationNameEmailSuffix").ToString() + " or *." + DevelopmentBase.Common.GetConfig("ORCID.OrganizationNameEmailSuffix").ToString() + ")";
                int checkForOrgEmail = DevelopmentBase.Common.GetConfigInt("ORCID.CheckOrganizationNameEmailSuffix");
                if (checkForOrgEmail.Equals(1))
                {
                    return
                        "The primary email will be used by ORCID to contact you. "
                        + "Alternate emails are used to confirm you don’t already have an ORCID. "
                        + DevelopmentBase.Common.GetConfig("ORCID.OrganizationNameAorAn").ToString().ToUpper() + " " + DevelopmentBase.Common.GetConfig("ORCID.OrganizationNameShort").ToString() + " email address is required in either the primary email or one of the alternate email addresses. "
                        + "Unless you update the defaults below, your email address(es) will be publicly visible in ORCID. "
                        + "For more information on the privacy settings for email fields  <a href='ORCIDPrivacySettingsandProfiles.pdf' Target='_blank'>click here </a> (opens in new window). ";
                }
                else
                {
                    return
                        "The primary email will be used by ORCID to contact you. "
                        + "Alternate emails are used to confirm you don’t already have an ORCID. "
                        + "Unless you update the defaults below, your email address(es) will be publicly visible in ORCID. "
                        + "For more information on the privacy settings for email fields  <a href='http://support.orcid.org/knowledgebase/articles/124518-orcid-privacy-settings\' Target='_blank'>click here </a> (opens in new window). ";
                }
            }
        }

        public ProfilesRNSDLL.BO.ORCID.Person GetByPersonID(int profilePersonID)
        {
            BLL.Profile.Data.Person profilePersonBLL = new BLL.Profile.Data.Person();
            BO.Profile.Data.Person profilePerson = profilePersonBLL.Get(profilePersonID);
            string internalUsername = profilePerson.InternalUsername;
            long profileSubjectID = profilePersonBLL.GetNodeId(internalUsername);

            return GetByInternalUsername(internalUsername);
        }

        public new ProfilesRNSDLL.BO.ORCID.Person GetByInternalUsername(string internalUsername)
        {
            ProfilesRNSDLL.BO.ORCID.Person person = base.GetByInternalUsername(internalUsername);

            // if no record for the person already exists in the database, we need to set the required fields.
            if (!person.Exists)
            {
                ProfilesRNSDLL.BO.Profile.Data.Person profilePerson = new BLL.Profile.Data.Person().GetByInternalUsername(internalUsername);
                person.InternalUsername = internalUsername;
                if (!profilePerson.FirstNameIsNull)
                {
                    person.FirstName = profilePerson.FirstName;
                }
                if (!profilePerson.LastNameIsNull)
                {
                    person.LastName = profilePerson.LastName;
                }
                if (!profilePerson.EmailAddrIsNull)
                {
                    person.EmailAddress = profilePerson.EmailAddr;
                }
                person.CreateUnlessOptOut = false;
                person.PersonStatusTypeID = (int)ProfilesRNSDLL.BO.ORCID.REFPersonStatusType.REFPersonStatusTypes.Unknown;
                Add(person);
                person.Exists = true;
            }
            return person;
        }
        public ProfilesRNSDLL.BO.ORCID.Person GetPersonWithDBData(int profilePersonID, string sessionID)
        {
            BLL.Profile.Data.Person profilePersonBLL = new BLL.Profile.Data.Person();
            BO.Profile.Data.Person profilePerson = profilePersonBLL.Get(profilePersonID);
            string internalUsername = profilePerson.InternalUsername;
            long profileSubjectID = profilePersonBLL.GetNodeId(internalUsername);

            ProfilesRNSDLL.BO.ORCID.Person orcidPerson = GetByInternalUsername(internalUsername);

            ProfilesRNSDLL.BO.ORCID.Narrative narrative = new ProfilesRNSDLL.BLL.RDF.Triple().GetNarrative(profileSubjectID);
            if (!string.IsNullOrEmpty(narrative.Overview) && !narrative.Overview.Trim().Equals(string.Empty))
            {
                orcidPerson.Biography = narrative.Overview;
                if (!narrative.Decision.DecisionIDIsNull)
                {
                    orcidPerson.BiographyDecisionID = narrative.Decision.DecisionID;
                }
                else
                {
                    orcidPerson.BiographyDecisionID = (int)BO.ORCID.REFDecision.REFDecisions.Public;
                }
            }
            orcidPerson.Affiliations = new ProfilesRNSDLL.BLL.ORCID.PersonAffiliation().GetForORCIDUpdate(orcidPerson, profileSubjectID, profilePersonID);
            orcidPerson.URLs = new ProfilesRNSDLL.BLL.ORCID.PersonURL().GetForORCIDUpdate(orcidPerson, profileSubjectID);
            orcidPerson.Works = new ProfilesRNSDLL.BLL.ORCID.PersonWork().GetForORCIDUpdate(orcidPerson, profileSubjectID, sessionID);
            if (BO.ORCID.Config.UseMailinatorEmailAddressForTestingOnStagingEnvironment)
            {
                orcidPerson.EmailAddress = System.Text.RegularExpressions.Regex.Split(profilePerson.EmailAddr, "@")[0] + DateTime.Now.ToString("yyyyMMdd") + "_" + DateTime.Now.ToString("hhmmss") + "@mailinator.com";
            }
            else
            {
                orcidPerson.EmailAddress = profilePerson.EmailAddr;
            }
            return orcidPerson;
        }
        public new bool Add(BO.ORCID.Person person)
        {
            return base.Add(person);
        }
        public bool CreateNewORCID(BO.ORCID.Person person, string loggedInInternalUsername, ProfilesRNSDLL.BO.ORCID.REFPersonStatusType.REFPersonStatusTypes failedStatus)
        {
            // Make sure an institution email has been provided.
            // Ensure that the new ORCID information can be saved in the database as it doesn't violate any business rules, e.g. missing internal username.
            if (!BizRulesForCreation(person))
            {
                try
                {
                    person.HasError = false;
                    person.PersonStatusTypeID = (int)failedStatus;
                    Edit(person, false);
                }
                catch
                {

                }
                return false;
            }
            try
            {
                ProfilesRNSDLL.BLL.ORCID.PersonMessage personMessageBLL = new PersonMessage();
                ProfilesRNSDLL.BLL.ORCID.PersonOthername personOthernameBLL = new PersonOthername();
                ProfilesRNSDLL.BLL.ORCID.PersonAlternateEmail personAlternateEmailBLL = new PersonAlternateEmail();
                ProfilesRNSDLL.BLL.ORCID.PersonURL personURLBLL = new PersonURL();
                ProfilesRNSDLL.BLL.ORCID.PersonWork personWorkBLL = new PersonWork();
                ProfilesRNSDLL.BLL.ORCID.PersonAffiliation personAffiliationBLL = new PersonAffiliation();

                if (PostNewORCIDRequestToORCIDAPI(person, loggedInInternalUsername))
                {
                    // Save the person record (includes the narrative, aka biography, if one was provided).
                    person.PersonStatusTypeID = (int)ProfilesRNSDLL.BO.ORCID.REFPersonStatusType.REFPersonStatusTypes.ORCID_Created;
                    person.ORCIDRecorded = DateTime.Now;
                    if (!Save(person))
                    {
                        person.Error += "The ORCID was created but a problem (person save failed) occurred while saving the data in the BU database. ";
                        return false;
                    }
                    // Create a message to save what was sent to ORCID. 
                    // Also mark the person with the person message ID
                    if (!personMessageBLL.CreatePersonMessage(person))
                    {
                        person.Error += "The ORCID was created but a problem (person message save failed) occurred while saving the data in the BU database. ";
                        return false;
                    }
                    BLL.ORCID.PersonMessage.SetPersonMessageID(person);
                    // Save the other names
                    if (!personOthernameBLL.AddIfAny(person))
                    {
                        person.Error += "The ORCID was created but a problem (saving of other names failed) occurred while saving the data in the BU database. ";
                        return false;
                    }
                    // Save the alternate email addresses
                    if (!personAlternateEmailBLL.AddIfAny(person))
                    {
                        person.Error += "The ORCID was created but a problem (saving of alternate emails failed) occurred while saving the data in the BU database. ";
                        return false;
                    }
                    // Save the urls
                    if (!personURLBLL.AddIfAny(person))
                    {
                        person.Error += "The ORCID was created but a problem (saving of urls failed) occurred while saving the data in the BU database. ";
                        return false;
                    }
                    // Save the works
                    if (!personWorkBLL.AddIfAny(person))
                    {
                        person.Error += "The ORCID was created but a problem (saving of works failed) occurred while saving the data in the BU database. ";
                        return false;
                    }
                    // Save the works
                    if (!personAffiliationBLL.AddIfAny(person))
                    {
                        person.Error += "The ORCID was created but a problem (saving of affiliations failed) occurred while saving the data in the BU database. ";
                        return false;
                    }
                    return true;
                }
                else
                {
                    person.HasError = false;
                    person.PersonStatusTypeID = (int)failedStatus;
                    try
                    {
                        Save(person, false);
                    }
                    catch (Exception ex)
                    {
                        throw BLL.ORCID.ErrorLog.LogError(ex, loggedInInternalUsername, "An error occurred while saving the fact that the batch push failed.");
                    }
                    return false;
                }
            }
            catch (Exception ex)
            {
                throw ErrorLog.LogError(ex, loggedInInternalUsername, "An error occurred while generating the messages to send to ORCID.");
            }
        }
        public BO.ORCID.Person GetByORCID(string orcid)
        {
            return base.GetByORCID(orcid, false).FirstOrDefault();
        }
        public override void BizRules(BO.ORCID.Person bo, BO.ORCID.Person boBefore)
        {
            if (!string.IsNullOrEmpty(bo.Biography))
            {
                if (bo.Biography.Length > ORCID_MAX_BIOGRAPHY_LENGTH)
                {
                    bo.BiographyErrors = "ORCID can only accept Biography's that have 5000 or fewer characters.";
                    bo.HasError = true;
                }
            }
            if (string.IsNullOrEmpty(bo.InternalUsername) || bo.InternalUsername.Trim().Equals(string.Empty))
            {
                bo.HasError = true;
                bo.Error += "Missing internal username identifier." + Environment.NewLine;
            }
            CheckAlternateEmails(bo);
        }
        public void CheckAlternateEmails(BO.ORCID.Person bo)
        {
            if (bo.AlternateEmails != null && bo.AlternateEmails.Count > 0)
            {
                foreach (BO.ORCID.PersonAlternateEmail email in bo.AlternateEmails)
                {
                    if (!DevelopmentBase.RegEx.GeneralValidation.isValidEmail(email.EmailAddress))
                    {
                        bo.HasError = true;
                        bo.AlternateEmailDecisionIDErrors += "Please check the email address as at least one is not valid. " + Environment.NewLine;
                        break;
                    }
                }
            }
        }
        public bool Save(BO.ORCID.Person bo)
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
        public bool Save(BO.ORCID.Person bo, bool checkBizRules)
        {
            if (bo.Exists)
            {
                return base.Edit(bo, checkBizRules);
            }
            else
            {
                return base.Add(bo, checkBizRules);
            }
        }
        public List<BO.ORCID.Person> GetByPersonStatusTypeID(int personStatusTypeID)
        {
            return base.GetByPersonStatusTypeID(personStatusTypeID, false);
        }
        public System.Xml.XmlDocument GetORCIDRecord(BO.ORCID.Person orcidPerson, string loggedInInternalUsername)
        {
            try
            {
                return GetORCIDRecordLimited(orcidPerson, loggedInInternalUsername);
            }
            catch
            { 
            }
            try
            {
                return GetORCIDRecordPublic(orcidPerson, loggedInInternalUsername);
            }
            catch
            {
                return null;
            }
        }
        public System.Xml.XmlDocument GetORCIDRecordLimited(BO.ORCID.Person orcidPerson, string loggedInInternalUsername)
        {
            BO.ORCID.REFPermission refPermission = new BLL.ORCID.REFPermission().Get((int)BO.ORCID.REFPermission.REFPermissions.orcid_profile_read_limited);

            // Make sure we have either created the ORCID or the user has provided the ORCID.
            if (orcidPerson.ORCIDIsNull)
            {
                throw new ProfilesRNSDLL.DevelopmentBase.BO.ExceptionSafeToDisplay("Cannot return the ORCID record, the ORCID identifier has not been recorded.");
            }

            // Make sure the users has granted the permission to read the profile.
            BO.ORCID.PersonToken personToken = new BLL.ORCID.PersonToken().GetByPersonIDAndPermissionID(orcidPerson.PersonID, (int)BO.ORCID.REFPermission.REFPermissions.orcid_profile_read_limited);
            if (personToken.Exists && !personToken.IsExpired)
            {
                try
                {
                    string ORCIDCreateProfileURL = ProfilesRNSDLL.BO.ORCID.Config.ORCID_API_URL_WITH_VERSION + "/" + orcidPerson.ORCID + "/" + refPermission.MethodAndRequest;

                    var httpWebRequest = WebRequest.Create(ORCIDCreateProfileURL);
                    httpWebRequest.ContentType = "application/vdn.orcid+xml";
                    httpWebRequest.Method = System.Net.WebRequestMethods.Http.Get;

                    httpWebRequest.Headers.Add("Authorization", " Bearer " + personToken.AccessToken);

                    using (WebResponse response = httpWebRequest.GetResponse())
                    {
                        using (var reader = new StreamReader(response.GetResponseStream()))
                        {
                            string result = reader.ReadToEnd();
                            System.Xml.XmlDocument xml = new System.Xml.XmlDocument();
                            xml.LoadXml(result);
                            return xml;
                        }
                    }
                    // curl -H 'Content-Type: application/vdn.orcid+xml' -H 'Authorization: Bearer f6d49570-c048-45a9-951f-a81ebb1fa543' -X GET 'http://api.sandbox-1.orcid.org/v1.0.23/0000-0003-1495-7122/orcid-profile' -L -i 
                }
                catch (Exception ex)
                {
                    throw BLL.ORCID.ErrorLog.LogError(ex, loggedInInternalUsername, "An error occurred while connecting to ORCID.  Unable to retrieve token information to save.");
                }
            }
            else
            {
                throw new ProfilesRNSDLL.DevelopmentBase.BO.ExceptionSafeToDisplay("Cannot return the ORCID record, permission has not been granted to read the record.");
            }
        }
        public System.Xml.XmlDocument GetORCIDRecordPublic(BO.ORCID.Person orcidPerson, string loggedInInternalUsername)
        {
            BO.ORCID.REFPermission refPermission = new BLL.ORCID.REFPermission().Get((int)BO.ORCID.REFPermission.REFPermissions.read_public);

            // Make sure we have either created the ORCID or the user has provided the ORCID.
            if (orcidPerson.ORCIDIsNull)
            {
                throw new ProfilesRNSDLL.DevelopmentBase.BO.ExceptionSafeToDisplay("Cannot return the ORCID record, the ORCID identifier has not been recorded.");
            }

            try
            {
                string ORCIDCreateProfileURL = ProfilesRNSDLL.BO.ORCID.Config.ORCID_API_URL + "/" + orcidPerson.ORCID + "/";

                var httpWebRequest = WebRequest.Create(ORCIDCreateProfileURL);
                httpWebRequest.ContentType = "application/vdn.orcid+xml";
                httpWebRequest.Method = System.Net.WebRequestMethods.Http.Get;

                //string authToken = BLL.ORCID.OAuth.SetToken(refPermission.PermissionScope, loggedInInternalUsername);

                //httpWebRequest.Headers.Add("client_id", ProfilesRNSDLL.BO.ORCID.Config.ClientID);
                //httpWebRequest.Headers.Add("client_secret", ProfilesRNSDLL.BO.ORCID.Config.ClientSecret);
                //httpWebRequest.Headers.Add("scope", SCOPE_READ_PUBLIC);
                //httpWebRequest.Headers.Add("grant_type", "client_credentials");

                string token = BLL.ORCID.OAuth.GetClientToken(refPermission.PermissionScope, loggedInInternalUsername);
                httpWebRequest.Headers.Add("Authorization", " Bearer " + token);
                httpWebRequest.Headers.Add("Scope", refPermission.PermissionScope);

                using (WebResponse response = httpWebRequest.GetResponse())
                {
                    using (var reader = new StreamReader(response.GetResponseStream()))
                    {
                        string result = reader.ReadToEnd();
                        System.Xml.XmlDocument xml = new System.Xml.XmlDocument();
                        xml.LoadXml(result);
                        return xml;
                    }
                }
                // curl -H 'Content-Type: application/vdn.orcid+xml' -H 'Authorization: Bearer f6d49570-c048-45a9-951f-a81ebb1fa543' -X GET 'http://api.sandbox-1.orcid.org/v1.0.23/0000-0003-1495-7122/orcid-profile' -L -i 
            }
            catch (Exception ex)
            {
                throw BLL.ORCID.ErrorLog.LogError(ex, loggedInInternalUsername, "An error occurred while connecting to ORCID.  Unable to retrieve token information to save.");
            }
        }


        internal new bool Edit(BO.ORCID.Person person, System.Data.Common.DbTransaction trans)
        {
            return base.Edit(person, trans);
        }

        private const string ERROR_MESSAGE_BEFORE_MESSAGE_SENT_TO_ORCID = "An error occurred (failure to save message) before the request was made to ORCID";
        private const int ORCID_MAX_BIOGRAPHY_LENGTH = 5000;
        private bool OneEmailIsOrgEmail(BO.ORCID.Person bo)
        {
            if (!bo.EmailAddressIsNull && !bo.EmailAddress.Trim().Equals(string.Empty))
            {
                if (EmailIsOrgEmail(bo.EmailAddress))
                {
                    return true;
                }
            }
            foreach (BO.ORCID.PersonAlternateEmail email in bo.AlternateEmails)
            {
                if (EmailIsOrgEmail(email.EmailAddress))
                {
                    return true;
                }
            }
            return false;
        }
        private bool EmailIsOrgEmail(string email)
        {
            string[] emailSuffixes = System.Text.RegularExpressions.Regex.Split(DevelopmentBase.Common.GetConfig("ORCID.OrganizationNameEmailSuffix").ToString(), ";");

            foreach (string emailSuffix in emailSuffixes)
            {
                if (email.EndsWith("@" + emailSuffix))
                {
                    return true;
                }
                if (email.EndsWith("." + emailSuffix))
                {
                    return true;
                }
            }
            return false;
        }
        private bool BizRulesForCreation(BO.ORCID.Person person)
        {
            int checkForOrgEmail = DevelopmentBase.Common.GetConfigInt("ORCID.CheckOrganizationNameEmailSuffix");
            if (checkForOrgEmail.Equals(1) && !OneEmailIsOrgEmail(person))
            {
                person.EmailAddressErrors += BLL.ORCID.Person.EmailRequiredMessage;
                person.HasError = true;
            }
            if (person.FirstNameIsNull || person.FirstName.Trim().Equals(string.Empty))
            {
                person.HasError = true;
                person.FirstNameErrors += "Required." + Environment.NewLine;
            }
            if (person.LastNameIsNull || person.LastName.Trim().Equals(string.Empty))
            {
                person.HasError = true;
                person.LastNameErrors += "Required." + Environment.NewLine;
            }
            BizRules(person, new BO.ORCID.Person());
            DBRulesCG(person);
            return !person.HasError;
        }
        private bool PostNewORCIDRequestToORCIDAPI(BO.ORCID.Person person, string loggedInInternalUsername)
        {
            BO.ORCID.REFPermission refPermission = new ProfilesRNSDLL.BLL.ORCID.REFPermission().Get((int)BO.ORCID.REFPermission.REFPermissions.orcid_profile_create);
            string ORCIDCreateProfileURL = ProfilesRNSDLL.BO.ORCID.Config.ORCID_API_URL_WITH_VERSION + "/" + "orcid-profile";

            var httpWebRequest = WebRequest.Create(ORCIDCreateProfileURL);
            httpWebRequest.ContentType = "application/orcid+xml";
            httpWebRequest.Method = System.Net.WebRequestMethods.Http.Post.ToString();

            string authToken = BLL.ORCID.OAuth.GetClientToken(refPermission.PermissionScope, loggedInInternalUsername);

            httpWebRequest.Headers.Add("Authorization", " Bearer " + authToken);

            byte[] xmlBytes = Encoding.UTF8.GetBytes(PersonMessage.CreateNewBasicORCIDMessage(person));
            using (var requestStream = httpWebRequest.GetRequestStream())
            {
                requestStream.Write(xmlBytes, 0, xmlBytes.Length);
                requestStream.Close();
            }
            try
            {
                using (WebResponse response = httpWebRequest.GetResponse())
                {
                    // Example of response.Headers["Location"] is 'http://api.orcid.org/0000-0002-4523-3823/orcid-profile'
                    person.ORCID = System.Text.RegularExpressions.Regex.Split(response.Headers["Location"].ToString(), "/")[3];
                }
            }
            catch (WebException en)
            {
                using (WebResponse response = en.Response)
                {
                    HttpWebResponse httpResponse = (HttpWebResponse)response;

                    person.Error += string.Format("Error code: {0}", httpResponse.StatusCode);
                    using (Stream data = response.GetResponseStream())
                    {
                        string text = new StreamReader(data).ReadToEnd();
                        person.Error += text;
                    }
                }
            }
            if (string.IsNullOrEmpty(person.Error))
            {
                if (!person.HasValidORCID)
                {
                    person.Error = "Error! Invalid ORCID value";
                }
            }
            if (person.Error.Contains("Cannot create ORCID"))
            {

                person.Error = "An error occured creating your ORCID. This email address has already been registed with ORCID.";
            }
            person.HasError = !person.Error.Equals(string.Empty);
            return !person.HasError;
        }
    }
}