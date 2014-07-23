using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.RDF.Security
{
    public partial class Group
    {
        public new List<BO.RDF.Security.Group> Gets()
        {
            return base.Gets(false);
        }
        public BO.RDF.Security.Group Get(int securityGroupID)
        {
            return base.Get(securityGroupID);
        }
        public new bool Edit(BO.RDF.Security.Group bo)
        {
            return base.Edit(bo);
        }
    }
}
