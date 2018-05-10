namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.ORCID
{
    public partial class PersonOthername
    {
        internal bool AddIfAny(BO.ORCID.Person person)
        {
            if (person.Othernames != null)
            {
                foreach (BO.ORCID.PersonOthername otherName in person.Othernames)
                {
                    otherName.PersonID = person.PersonID;
                    if (!this.Add(otherName))
                    {
                        return false;
                    }
                }
            }
            return true;
        }
        internal static void SetPersonMessageID(BO.ORCID.Person person)
        {
            if (person.Othernames != null && person.Othernames.Count > 0)
            {
                foreach (BO.ORCID.PersonOthername personOthername in person.Othernames)
                {
                    personOthername.PersonMessageID = person.PersonMessage.PersonMessageID;
                }
            }
        }
    }
}
