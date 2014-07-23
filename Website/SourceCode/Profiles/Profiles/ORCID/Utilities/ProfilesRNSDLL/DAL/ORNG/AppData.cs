using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.Common;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DAL.ORNG
{
    public partial class AppData
    {
        internal BO.ORNG.AppData GetWebsites(long subjectID)
        {
            DbCommand cmd = GetCommand("[ORNG].[GetWebsites]");
            AddParam(ref cmd, "@NodeID", subjectID);
            return PopulateFromRow(FillTable(cmd), 0);
        }
    }
}
