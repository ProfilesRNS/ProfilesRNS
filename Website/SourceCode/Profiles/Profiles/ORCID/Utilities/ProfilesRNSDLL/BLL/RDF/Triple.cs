using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.RDF
{
    public partial class Triple
    {
        public new System.Data.DataView GetPublications(Int64 subject)
        {
            return base.GetPublications(subject);
        }
        public new BO.ORCID.Narrative GetNarrative(Int64 subject)
        {
            return base.GetNarrative(subject);
        }
    }
}
