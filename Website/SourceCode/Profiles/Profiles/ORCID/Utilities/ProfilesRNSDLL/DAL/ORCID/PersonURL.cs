using System.Collections.Generic;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DAL.ORCID
{
    public partial class PersonURL
    {
        internal List<ProfilesRNSDLL.BO.ORCID.PersonURL> GetSuccessfullyProcessedURLs(int orcidPersonID)
        {
            System.Data.Common.DbCommand cmd = GetCommand();
            string sql = GetSelectString();
            sql += "FROM ";
            sql += "    [ORCID.].PersonURL  ";
            sql += "    INNER JOIN [ORCID.].PersonMessage ON [ORCID.].PersonURL.PersonMessageID = [ORCID.].PersonMessage.PersonMessageID   ";
            sql += "WHERE ";
            sql += "    [ORCID.].PersonURL.PersonID = @PersonID ";
            sql += "    AND [ORCID.].PersonMessage.RecordStatusID = " + ((int)BO.ORCID.REFRecordStatus.REFRecordStatuss.Success).ToString();
            cmd.CommandText = sql;
            cmd.CommandType = System.Data.CommandType.Text;
            AddParam(ref cmd, "@PersonID", orcidPersonID);
            return PopulateCollectionObject(FillTable(cmd), false);
        }
    }
}
