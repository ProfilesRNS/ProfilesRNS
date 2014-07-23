using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.ORCID
{
    public partial class PersonAlternateEmail
    {
        internal bool AddIfAny(BO.ORCID.Person person)
        {
            if (person.AlternateEmails != null)
            {
                foreach (BO.ORCID.PersonAlternateEmail altEmail in person.AlternateEmails)
                {
                    altEmail.PersonID = person.PersonID;
                    if (!this.Add(altEmail))
                    {
                        return false;
                    }
                }
            }
            return true;
        }
        internal static void SetPersonMessageID(BO.ORCID.Person person)
        {
            if (person.AlternateEmails != null && person.AlternateEmails.Count > 0)
            {
                foreach (BO.ORCID.PersonAlternateEmail personAlternateEmail in person.AlternateEmails)
                {
                    personAlternateEmail.PersonMessageID = person.PersonMessage.PersonMessageID;
                }
            }
        }
    }
}
