using System.Collections.Generic;
using System.Linq;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.Profile.Data
{
    public partial class PersonFacultyRank
    {
        public List<BO.Profile.Data.PersonFacultyRank> Gets()
        {
            return (from pfr in base.Gets(false) orderby pfr.FacultyRank select pfr).ToList();
        }
    }
}
