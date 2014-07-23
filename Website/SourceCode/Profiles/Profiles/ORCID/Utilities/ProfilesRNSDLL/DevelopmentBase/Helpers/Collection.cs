using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DevelopmentBase.Helpers
{
    public class Collection
    {
        public static List<string> GetListOfStringFromDataView(System.Data.DataView dv, string fieldName)
        {
            List<string> returnList = new List<string>();
            foreach (System.Data.DataRow dr in dv.Table.Rows)
            {
                if (!dr.IsNull(fieldName))
                {
                    returnList.Add(dr[fieldName].ToString());
                }
            }
            return returnList;
        }
    }
}

