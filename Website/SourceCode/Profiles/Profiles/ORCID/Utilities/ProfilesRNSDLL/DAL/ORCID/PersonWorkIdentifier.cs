using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DAL.ORCID
{
    public partial class PersonWorkIdentifier
    {
        internal List<BO.ORCID.PersonWorkIdentifier> GetProcessedPMIDs(string internalUsername)
        { 
            string sql = GetSelectString();
            sql += " FROM ";
            sql += "    PersonWorkIdentifier  ";
            sql += "    INNER JOIN PersonWork ON PersonWorkIdentifier.PersonWorkID = PersonWork.PersonWorkID  ";
            sql += "    INNER JOIN Person ON Person.PersonID = PersonWork.PersonID  ";
            sql += "WHERE   ";
            sql += "    Person.InternalUsername = @InternalUsername ";
            sql += "    AND PersonWorkIdentifier.WorkExternalTypeID = @WorkExternalTypeID ";

            System.Data.Common.DbCommand cmd = GetCommand();
            cmd.CommandText = sql;
            cmd.CommandType = System.Data.CommandType.Text;
            AddParam(ref cmd, "@InternalUsername", internalUsername);
            AddParam(ref cmd, "@WorkExternalTypeID", (int)BO.ORCID.REFWorkExternalType.REFWorkExternalTypes.pmid);
            return PopulateCollectionObject(FillTable(cmd)); 
        } 
    }
}
