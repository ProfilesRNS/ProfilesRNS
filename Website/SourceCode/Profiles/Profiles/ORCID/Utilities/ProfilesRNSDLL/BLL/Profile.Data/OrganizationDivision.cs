using System.Collections.Generic;
using System.Linq;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.Profile.Data
{
    public partial class OrganizationDivision
    {
        public List<BO.Profile.Data.OrganizationDivision> Gets()
        {
            return (from d in base.Gets(false) orderby d.DivisionName select d).ToList();
        }
    }
}
