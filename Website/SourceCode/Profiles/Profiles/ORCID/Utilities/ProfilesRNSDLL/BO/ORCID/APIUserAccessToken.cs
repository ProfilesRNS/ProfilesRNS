using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID
{
    public class APIUserAccessToken
    {
        public string ORCID { get; set; }
        public string PermissionScope { get; set; }
        public int PermissionID { get; set; }
        public DateTime TokenExpiration { get; set; }
        public string AccessToken { get; set; }
        public string RefreshToken { get; set; }
    }
}
