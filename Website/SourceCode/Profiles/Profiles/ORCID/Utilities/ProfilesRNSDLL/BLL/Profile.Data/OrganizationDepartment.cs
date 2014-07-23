using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.Profile.Data
{
    public partial class OrganizationDepartment
    {
        public new List<BO.Profile.Data.OrganizationDepartment> Gets()
        {
            return (from d in base.Gets(false) orderby d.DepartmentName select d).ToList();   
        }
    }
}
