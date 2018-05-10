using System.Collections.Generic;
using System.Linq;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.ORCID
{
    public partial class PersonURL
    {
        private string GetFieldValueFromJsonString(ref string inputString, string fieldName)
        {
            string fieldValue = string.Empty;
            int positionOfLinkName = 0;
            int positionOfStartQuoteFieldName = 0;
            int positionOfEndQuoteFieldName = 0;

            if (inputString.ToLower().Contains("\"" + fieldName + "\""))
            {
                positionOfLinkName = inputString.ToLower().IndexOf("\"" + fieldName + "\"");
                positionOfStartQuoteFieldName = inputString.ToLower().IndexOf("\"", positionOfLinkName + fieldName.Length + 3);
                positionOfEndQuoteFieldName = inputString.ToLower().IndexOf("\"", positionOfStartQuoteFieldName + 1);

                fieldValue = inputString.Substring(positionOfStartQuoteFieldName + 1, positionOfEndQuoteFieldName - positionOfStartQuoteFieldName - 1);
                inputString = inputString.Substring(positionOfEndQuoteFieldName, inputString.Length - positionOfEndQuoteFieldName);
            }
            return fieldValue;
        }

        public new List<BO.ORCID.PersonURL> GetForORCIDUpdate(BO.ORCID.Person orcidPerson, long subjectID)
        {
            List<ProfilesRNSDLL.BO.ORCID.PersonURL> webSites = new List<ProfilesRNSDLL.BO.ORCID.PersonURL>();
            try
            {
                ProfilesRNSDLL.BO.ORNG.AppData appData = new ProfilesRNSDLL.BLL.ORNG.AppData().GetWebsites(subjectID);
                //value = [{"link_name":"Clinical and Translational Science Institute Leadership","link_url":"http://ctsi.bu.edu/index.php/about-us/leadership/"}, {"link_name":"My Google","link_url":"www.google.com"}]

                string webSitesJSON = appData.value;

                while (webSitesJSON.ToLower().Contains("\"link_name\""))
                {
                    BO.ORCID.PersonURL website = new BO.ORCID.PersonURL();
                    if (webSitesJSON.ToLower().IndexOf("\"link_name\"") < webSitesJSON.ToLower().IndexOf("\"link_url\""))
                    {
                        website.URLName = GetFieldValueFromJsonString(ref webSitesJSON, "link_name");
                        website.URL = GetFieldValueFromJsonString(ref webSitesJSON, "link_url");
                    }
                    else
                    {
                        website.URL = GetFieldValueFromJsonString(ref webSitesJSON, "link_url");
                        website.URLName = GetFieldValueFromJsonString(ref webSitesJSON, "link_name");
                    }
                    // Default to Public
                    website.DecisionID = (int)BO.ORCID.REFDecision.REFDecisions.Public;
                    webSites.Add(website);
                }
            }
            catch //(Exception ex)
            {
                // unable to get links from the Open Social.
                return new List<ProfilesRNSDLL.BO.ORCID.PersonURL>();
            }

            // Get the list of processed affiliations
            List<ProfilesRNSDLL.BO.ORCID.PersonURL> processedWebsites = GetSuccessfullyProcessedURLs(orcidPerson.PersonID);

            // Get the affiliations that have not been processed
            return (from w in webSites where !processedWebsites.Any(pw => pw.URL == w.URL) select w).ToList();
        }

        private new List<BO.ORCID.PersonURL> GetSuccessfullyProcessedURLs(int orcidPersonID)
        {
            return base.GetSuccessfullyProcessedURLs(orcidPersonID);
        }
        public new BO.ORCID.PersonURL GetByPersonIDAndURL(int personID, string url)
        {
            return base.GetByPersonIDAndURL(personID, url);
        }
        //public List<BO.ORCID.PersonURL> GetByPersonID(int personID)
        //{
        //    return base.GetByPersonID(personID, false);
        //}

        internal bool AddIfAny(BO.ORCID.Person person, System.Data.Common.DbTransaction trans)
        {
            if (person.AlternateEmails != null)
            {
                foreach (BO.ORCID.PersonURL personURL in person.URLs)
                {
                    // get id if it already exists
                    personURL.PersonID = person.PersonID;
                    GetPersonURLID(personURL);
                    // Add the new person message id

                    if (!Save(personURL, trans))
                    {
                        return false;
                    }
                }    
            }
            return true;
        }
        internal bool AddIfAny(BO.ORCID.Person person)
        {
            if (person.AlternateEmails != null)
            {
                foreach (BO.ORCID.PersonURL personURL in person.URLs)
                {
                    // get id if it already exists
                    personURL.PersonID = person.PersonID;
                    GetPersonURLID(personURL);
                    // Add the new person message id

                    if (!Save(personURL))
                    {
                        return false;
                    }
                }
            }
            return true;
        }
        internal static void SetPersonMessageID(BO.ORCID.Person person)
        {
            if (person.URLs != null && person.URLs.Count > 0)
            {
                foreach (BO.ORCID.PersonURL personURL in person.URLs)
                {
                    personURL.PersonMessageID = person.PersonMessage.PersonMessageID;
                }
            }
        }

        private bool Save(BO.ORCID.PersonURL bo)
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
        private bool Save(BO.ORCID.PersonURL bo, System.Data.Common.DbTransaction trans)
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
        private void GetPersonURLID(BO.ORCID.PersonURL personURL)
        {
            BO.ORCID.PersonURL personURLExisting = base.GetByPersonIDAndURL(personURL.PersonID, personURL.URL);
            if (personURLExisting.Exists)
            {
                personURL.PersonURLID = personURLExisting.PersonURLID;
            }
        }
    }
}
