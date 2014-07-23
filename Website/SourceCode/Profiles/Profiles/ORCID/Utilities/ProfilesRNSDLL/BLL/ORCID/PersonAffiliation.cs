using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.ORCID
{
    public partial class PersonAffiliation
    {
        public List<ProfilesRNSDLL.BO.ORCID.PersonAffiliation> GetForORCIDUpdate(ProfilesRNSDLL.BO.ORCID.Person orcidPerson, long subject, int profileDataPersonID)
        {
            List<ProfilesRNSDLL.BO.ORCID.PersonAffiliation> affiliations = GetAffiliations(profileDataPersonID);

            // Get the list of processed affiliations
            List<ProfilesRNSDLL.BO.ORCID.PersonAffiliation> processedAffiliations = GetSuccessfullyProcessedAffiliations(orcidPerson.PersonID);

            // Get the affiliations that have not been processed
            return (from p in affiliations where !processedAffiliations.Any(pa => pa.AffiliationTypeID == p.AffiliationTypeID && pa.ProfilesID == p.ProfilesID) select p).ToList();
        }

        internal bool AddIfAny(BO.ORCID.Person person, System.Data.Common.DbTransaction trans)
        {
            if (person.AlternateEmails != null)
            {
                foreach (BO.ORCID.PersonAffiliation personAffiliation in person.Affiliations)
                {
                    // get id if it already exists
                    personAffiliation.PersonID = person.PersonID;
                    GetPersonAffiliationID(personAffiliation);
                    // Add the new person message id

                    if (!Save(personAffiliation, trans))
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
                foreach (BO.ORCID.PersonAffiliation personAffiliation in person.Affiliations)
                {
                    // get id if it already exists
                    personAffiliation.PersonID = person.PersonID;
                    GetPersonAffiliationID(personAffiliation);
                    // Add the new person message id

                    if (!Save(personAffiliation))
                    {
                        return false;
                    }
                }
            }
            return true;
        }
        internal static void SetPersonMessageID(BO.ORCID.Person person)
        {
            if (person.Affiliations != null && person.Affiliations.Count > 0)
            {
                foreach (BO.ORCID.PersonAffiliation personAffiliation in person.Affiliations)
                {
                    personAffiliation.PersonMessageID = person.PersonMessage.PersonMessageID;
                }
            }
        }

        private bool Save(BO.ORCID.PersonAffiliation bo)
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
        private bool Save(BO.ORCID.PersonAffiliation bo, System.Data.Common.DbTransaction trans)
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
        private void GetPersonAffiliationID(BO.ORCID.PersonAffiliation personAffiliation)
        {
            BO.ORCID.PersonAffiliation personAffiliationExisting = base.GetByProfilesIDAndAffiliationTypeID(personAffiliation.ProfilesID, personAffiliation.AffiliationTypeID);
            if (personAffiliationExisting.Exists)
            {
                personAffiliation.PersonAffiliationID = personAffiliationExisting.PersonAffiliationID;
            }
        }
        private new List<BO.ORCID.PersonAffiliation> GetSuccessfullyProcessedAffiliations(int orcidPersonID)
        {
            return base.GetSuccessfullyProcessedAffiliations(orcidPersonID);
        }
        private new List<BO.ORCID.PersonAffiliation> GetAffiliations(int profileDataPersonID)
        {
            return base.GetAffiliations(profileDataPersonID);
        }
    }
}
