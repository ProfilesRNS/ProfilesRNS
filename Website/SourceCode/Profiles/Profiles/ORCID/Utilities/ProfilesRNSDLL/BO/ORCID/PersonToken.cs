using System;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID
{
    public partial class PersonToken
    {
        public bool IsExpired
        {
            get
            {
                return this.TokenExpirationIsNull || this.TokenExpiration < DateTime.Now;
            }
        }
    }
}
