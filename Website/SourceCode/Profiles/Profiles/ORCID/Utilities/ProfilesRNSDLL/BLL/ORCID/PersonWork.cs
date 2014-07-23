using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.ORCID
{
    public partial class PersonWork
    {
        public static void AddIdentifier(ProfilesRNSDLL.BO.ORCID.PersonWork personWork, ProfilesRNSDLL.BO.ORCID.REFWorkExternalType.REFWorkExternalTypes workExternalType, string identifier)
        {
            ProfilesRNSDLL.BO.ORCID.PersonWorkIdentifier workIdentifier = new ProfilesRNSDLL.BLL.ORCID.PersonWorkIdentifier().GetByPersonWorkIDAndWorkExternalTypeIDAndIdentifier(personWork.PersonWorkID, (int)workExternalType, identifier);
            workIdentifier.WorkExternalTypeID = (int)workExternalType;
            workIdentifier.Identifier = identifier;
            personWork.Identifiers.Add(workIdentifier);
        }
        public List<BO.ORCID.PersonWork> GetForORCIDUpdate(string internalUserName, long subject, string sessionID)
        {
            ProfilesRNSDLL.BO.ORCID.Person orcidPerson = new ProfilesRNSDLL.BLL.ORCID.Person().GetByInternalUsername(internalUserName);
            return GetForORCIDUpdate(orcidPerson, subject, sessionID);
        }
        public List<BO.ORCID.PersonWork> GetForORCIDUpdate(ProfilesRNSDLL.BO.ORCID.Person orcidPerson, long subject, string sessionID)
        {
            const string WORK_TYPE = "journal-article";

            List<BO.ORCID.PersonWork> pubs = new List<BO.ORCID.PersonWork>();

            ProfilesRNSDLL.BO.ORCID.REFDecision visibilityForPublications = GetPublicationVisibility(subject);

            foreach (System.Data.DataRow dr in base.GetPublications(subject, sessionID).Table.Rows)
            {

                BO.ORCID.PersonWork pub = new BO.ORCID.PersonWork();
                if (!dr.IsNull("prns_informationResourceReference"))
                {
                    pub.WorkCitation = dr["prns_informationResourceReference"].ToString();
                }
                if (!dr.IsNull("prns_publicationDate"))
                {
                    pub.PubDate = DateTime.Parse(dr["prns_publicationDate"].ToString());
                }
                if (!dr.IsNull("EntityID"))
                {
                    pub.PubID = dr["EntityID"].ToString();
                }
                if (!dr.IsNull("bibo_pmid") && dr["bibo_pmid"].ToString().Trim().Equals(string.Empty))
                {
                    pub.PMID = int.Parse(dr["bibo_pmid"].ToString());
                    pub.DOI = ProfilesRNSDLL.BLL.ORCID.DOI.Get(pub.PMID.ToString());
                    AddIdentifier(pub, ProfilesRNSDLL.BO.ORCID.REFWorkExternalType.REFWorkExternalTypes.pmid, pub.PMID.ToString());
                }
                else
                {
                    pub.DOI = GetDOI(pub, "http://dx.doi.org/");
                }
                if (pub.DOI != ProfilesRNSDLL.BLL.ORCID.DOI.DOI_NOT_FOUND_MESSAGE)
                {
                    AddIdentifier(pub, ProfilesRNSDLL.BO.ORCID.REFWorkExternalType.REFWorkExternalTypes.doi, pub.DOI);
                }

                if (!dr.IsNull("URL"))
                {
                    pub.URL = dr["URL"].ToString();
                }
                if (!dr.IsNull("rdfs_label"))
                {
                    pub.WorkTitle = dr["rdfs_label"].ToString();
                }
                if (visibilityForPublications.Exists)
                {
                    pub.DecisionID = visibilityForPublications.DecisionID;
                }
                pub.WorkType = WORK_TYPE;
                pubs.Add(pub);
            }

            // Get the list of processed pubs
            List<ProfilesRNSDLL.BO.ORCID.PersonWork> processedWorks = GetSuccessfullyProcessedWorks(orcidPerson.PersonID);

            // Get the pubmed pubs that haven't been processed.
            return (from p in pubs where !processedWorks.Any(pa => pa.PubID == p.PubID) select p).ToList();
        }
        public bool Save(BO.ORCID.PersonWork bo)
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
        public List<BO.ORCID.PersonWork> GetByPersonID(int personID)
        {
            return base.GetByPersonID(personID, false);
        }
        public new List<BO.ORCID.PersonWork> GetSuccessfullyProcessedWorks(int personID)
        {
            return base.GetSuccessfullyProcessedWorks(personID);
        }
        public new ProfilesRNSDLL.BO.ORCID.PersonWork GetByPersonIDAndPubID(int personID, string pubID)
        {
            return base.GetByPersonIDAndPubID(personID, pubID);
        }

        internal static void SetPersonMessageID(BO.ORCID.Person person)
        {
            if (person.Works != null && person.Works.Count > 0)
            {
                foreach (BO.ORCID.PersonWork personWork in person.Works)
                {
                    personWork.PersonMessageID = person.PersonMessage.PersonMessageID;
                }
            }
        }
        internal bool AddIfAny(BO.ORCID.Person person, System.Data.Common.DbTransaction trans)
        {
            if (person.Works != null)
            {
                BLL.ORCID.PersonWorkIdentifier personWorkIdentifierBLL = new PersonWorkIdentifier();
                for (int i = 0; i < person.Works.Count; i++)
                {
                    person.Works[i].PersonID = person.PersonID;
                    if (this.Save(person.Works[i], trans))
                    {
                        foreach (BO.ORCID.PersonWorkIdentifier personWorkIdentifier in person.Works[i].Identifiers)
                        {
                            personWorkIdentifier.PersonWorkID = person.Works[i].PersonWorkID;
                            if (!personWorkIdentifierBLL.Save(personWorkIdentifier, trans))
                            {
                                throw new ProfilesRNSDLL.DevelopmentBase.BO.ExceptionSafeToDisplay("Unable to save the work identifier info while creating a work message to ORCID");
                            }
                        }
                    }
                    else
                    {
                        return false;
                    }
                }
            }
            return true;
        }
        internal bool AddIfAny(BO.ORCID.Person person)
        {
            if (person.Works != null)
            {
                BLL.ORCID.PersonWorkIdentifier personWorkIdentifierBLL = new PersonWorkIdentifier();
                for (int i = 0; i < person.Works.Count; i++)
                {
                    person.Works[i].PersonID = person.PersonID;
                    if (this.Add(person.Works[i]))
                    {
                        foreach (BO.ORCID.PersonWorkIdentifier personWorkIdentifier in person.Works[i].Identifiers)
                        {
                            personWorkIdentifier.PersonWorkID = person.Works[i].PersonWorkID;
                            if (!personWorkIdentifierBLL.Save(personWorkIdentifier))
                            {
                                throw new DevelopmentBase.BO.ExceptionSafeToDisplay("Unable to save the work identifier info while creating a work message to ORCID");
                            }
                        }
                    }
                    else
                    {
                        return false;
                    }
                }
            }
            return true;
        }

        private static ProfilesRNSDLL.BO.ORCID.REFDecision GetPublicationVisibility(long subject)
        {
            System.Data.DataView dv = new ProfilesRNSDLL.BLL.RDF.Triple().GetPublications(subject);
            if (dv.Table.Rows.Count > 0)
            {
                int securityGroup = 1;
                int.TryParse(dv.Table.Rows[0]["ViewSecurityGroup"].ToString(), out securityGroup);
                if (securityGroup != 1)
                {
                    ProfilesRNSDLL.BO.RDF.Security.Group group = new ProfilesRNSDLL.BLL.RDF.Security.Group().Get(securityGroup);
                    ProfilesRNSDLL.BO.ORCID.REFDecision decision = new ProfilesRNSDLL.BLL.ORCID.REFDecision().Get(group.DefaultORCIDDecisionID);
                    if (decision.Exists)
                    {
                        return decision;
                    }
                }
            }
            // default to private if unable to find the default for the publications security group.
            return new ProfilesRNSDLL.BLL.ORCID.REFDecision().Get((int)ProfilesRNSDLL.BO.ORCID.REFDecision.REFDecisions.Private);
        }
        private bool Save(BO.ORCID.PersonWork bo, System.Data.Common.DbTransaction trans)
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
        private string GetDOI(ProfilesRNSDLL.BO.ORCID.PersonWork pub, string partialUrl)
        {
            if (pub.URL != null && pub.URL.Contains(partialUrl))
            {
                string[] urlSplit = System.Text.RegularExpressions.Regex.Split(pub.URL, partialUrl);
                if (urlSplit.Count() > 1)
                {
                    return urlSplit[1];
                }
                //return pub.URL.Substring(pub.URL.IndexOf(partialUrl), pub.URL.Length - pub.URL.IndexOf(partialUrl));
            }
            return ProfilesRNSDLL.BLL.ORCID.DOI.DOI_NOT_FOUND_MESSAGE;
        }
    }
}
