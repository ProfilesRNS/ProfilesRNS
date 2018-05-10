using System.Collections.Generic;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.ORCID
{
    public partial class PersonWorkIdentifier
    {
        public new List<BO.ORCID.PersonWorkIdentifier> GetProcessedPMIDs(string internalUsername)
        {
            return base.GetProcessedPMIDs(internalUsername);
        }
        public BO.ORCID.PersonWorkIdentifier GetByPersonWorkIDAndWorkExternalTypeIDAndIdentifier(int personWorkID, int workExternalTypeID, string identifier) 
        {
            return base.GetByPersonWorkIDAndWorkExternalTypeIDAndIdentifier(personWorkID, workExternalTypeID, identifier);
        }

        internal bool Save(BO.ORCID.PersonWorkIdentifier bo)
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
        internal bool Save(BO.ORCID.PersonWorkIdentifier bo, System.Data.Common.DbTransaction trans)
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
    }
}
