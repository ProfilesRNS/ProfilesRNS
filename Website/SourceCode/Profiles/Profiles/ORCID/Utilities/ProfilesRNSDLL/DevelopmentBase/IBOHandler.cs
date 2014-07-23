using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DevelopmentBase
{
    public interface IBOHandler<BO> where BO : DevelopmentBase.BaseClassBO
    {
        bool Add(BO bo);
        bool Edit(BO bo);
        void Delete(BO bo);
        BO Get(int id);
    }
}
