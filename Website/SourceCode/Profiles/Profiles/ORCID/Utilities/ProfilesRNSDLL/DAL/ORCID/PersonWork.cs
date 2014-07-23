using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DAL.ORCID
{
    public partial class PersonWork
    {
        internal List<ProfilesRNSDLL.BO.ORCID.PersonWork> GetSuccessfullyProcessedWorks(int personID)
        {
            System.Data.Common.DbCommand cmd = GetCommand();
            string sql = GetSelectString();
            sql += "FROM ";
            sql += "    [ORCID.].PersonWork  ";
            sql += "    INNER JOIN [ORCID.].PersonMessage ON [ORCID.].PersonWork.PersonMessageID = [ORCID.].PersonMessage.PersonMessageID   ";
            sql += "WHERE ";
            sql += "    [ORCID.].PersonWork.PersonID = @PersonID ";
            sql += "    AND [ORCID.].PersonMessage.RecordStatusID = " + ((int)BO.ORCID.REFRecordStatus.REFRecordStatuss.Success).ToString();
            cmd.CommandText = sql;
            cmd.CommandType = System.Data.CommandType.Text;
            AddParam(ref cmd, "@PersonID", personID);
            return PopulateCollectionObject(FillTable(cmd), false);
        }
        internal System.Data.DataView GetPublications(long subject, string sessionID)
        {
            System.Data.Common.DbCommand cmd = GetCommand("[ORCID.].[AuthorInAuthorshipForORCID.GetList]");
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            AddParam(ref cmd, "@nodeid", subject);
            AddParam(ref cmd, "@sessionid", sessionID);
            return FillTable(cmd).DefaultView;
        }
    }
}
