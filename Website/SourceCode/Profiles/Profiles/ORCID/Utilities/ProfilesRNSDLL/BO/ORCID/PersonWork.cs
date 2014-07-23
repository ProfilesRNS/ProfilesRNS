using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID
{
    public partial class PersonWork
    {
        public List<BO.ORCID.PersonWorkIdentifier> Identifiers { get; set; }
        public int PMID { get; set; }
        public string PMIDDesc
        {
            get
            {
                if (PMID == 0)
                {
                    return string.Empty;
                }
                return PMID.ToString();
            }
        }
        public string DOI { get; set; }

        protected override void InitializeProperties()
        {
            Identifiers = new List<PersonWorkIdentifier>();
        }
    }
}
