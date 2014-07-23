using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DevelopmentBase
{
    public class PermissionException : Exception
    {
        public PermissionException(string msg)
            : base(msg)
        { 
        }
    }
}
