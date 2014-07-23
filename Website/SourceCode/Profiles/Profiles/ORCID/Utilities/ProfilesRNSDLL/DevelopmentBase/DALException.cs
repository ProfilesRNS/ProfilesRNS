using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DevelopmentBase
{
    public class DALException : Exception
    {
        public DALException(string message)
            : base(message)
        { }
    }
}
