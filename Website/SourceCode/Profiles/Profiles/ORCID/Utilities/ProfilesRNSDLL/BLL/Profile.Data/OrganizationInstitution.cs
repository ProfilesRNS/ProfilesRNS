using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.Profile.Data
{
    public partial class OrganizationInstitution
    {
        public List<BO.Profile.Data.OrganizationInstitution> Gets()
        {
            return (from i in base.Gets(false) orderby i.InstitutionName select i).ToList();
        }
    }
}
