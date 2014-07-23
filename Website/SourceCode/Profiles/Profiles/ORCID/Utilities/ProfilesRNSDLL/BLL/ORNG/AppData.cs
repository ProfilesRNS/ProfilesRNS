using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.ORNG
{
    public partial class AppData
    {
        public BO.ORNG.AppData GetWebsites(long subjectID)
        {
            return base.GetWebsites(subjectID);
        }
    }
}
