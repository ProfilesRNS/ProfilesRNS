using System; 
using System.Collections.Generic; 
using System.Data; 
using System.Data.Common; 
using System.Linq; 
using System.Text;
using System.Reflection;
using System.Diagnostics;
 
namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DAL.Profile.Import
{ 
    public partial class FreetextKeywords : DALGeneric<ProfilesRNSDLL.BO.Profile.Import.FreetextKeywords>
    { 
     
        # region Constructors 
    
        internal FreetextKeywords() : base() { } 
    
        # endregion // Constructors
     
        # region Methods 
 
        /*! Method to create parameters in order to add or edit a record. */
        public override void GetParamsAll(ref System.Data.Common.DbCommand cmd, Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.Profile.Import.FreetextKeywords bo) 
        { 
            DbParameter Parm = cmd.CreateParameter(); 
            Parm.ParameterName = "@PersonKeywordID";
            Parm.Size = 4;
            Parm.DbType = System.Data.DbType.Int32;
            if(!bo.PersonKeywordIDIsNull) {
                 Parm.Direction = System.Data.ParameterDirection.InputOutput; 
                 Parm.Value = bo.PersonKeywordID;
            } else { 
                 Parm.Direction = System.Data.ParameterDirection.Output; 
            }  
            cmd.Parameters.Add(Parm);
            AddParam(ref cmd, "@InternalUsername", bo.InternalUsername);
            AddParam(ref cmd, "@Keyword", bo.Keyword);
            AddParam(ref cmd, "@DisplaySecurityGroupID", bo.DisplaySecurityGroupID);
        } 
 
        /*! Method to log changes to fields in a record. */
        public override void LogIfNecessary(DevelopmentBase.BaseClassBO.RecordLevelAuditTypes auditType, Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.Profile.Import.FreetextKeywords boBefore, Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.Profile.Import.FreetextKeywords bo, DbTransaction trans) 
        { 
            int recordLevelAuditTrailID = 0;
            if (auditType == DevelopmentBase.BaseClassBO.RecordLevelAuditTypes.Deleted)
            {
                recordLevelAuditTrailID = AddRecordLevelAuditTrail(bo.TableId, boBefore.PersonKeywordID, auditType, trans);
            }
            else
            {
                recordLevelAuditTrailID = AddRecordLevelAuditTrail(bo.TableId, bo.PersonKeywordID, auditType, trans);
            }
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Import.FreetextKeywords.FieldNames.InternalUsername, bo.InternalUsernameIsNull, boBefore.InternalUsernameIsNull, bo.InternalUsername, boBefore.InternalUsername, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Import.FreetextKeywords.FieldNames.Keyword, bo.KeywordIsNull, boBefore.KeywordIsNull, bo.Keyword, boBefore.Keyword, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Import.FreetextKeywords.FieldNames.DisplaySecurityGroupID, bo.DisplaySecurityGroupIDIsNull, boBefore.DisplaySecurityGroupIDIsNull, bo.DisplaySecurityGroupID, boBefore.DisplaySecurityGroupID, trans);
        } 
 
        /*! Method to get the fields in the table in a select string. */
        internal static string GetSelectString() { return "SELECT TOP 100 PERCENT [Profile.Import].[FreetextKeywords].[PersonKeywordID], [Profile.Import].[FreetextKeywords].[InternalUsername], [Profile.Import].[FreetextKeywords].[Keyword], [Profile.Import].[FreetextKeywords].[DisplaySecurityGroupID]"; } 
 
        /*! Method to get identity(s) of the newly added database record. */
        public override void GetIdentity(System.Data.Common.DbCommand sqlCommand, Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.Profile.Import.FreetextKeywords businessObj)
        { 
            businessObj.PersonKeywordID = int.Parse(sqlCommand.Parameters["@PersonKeywordID"].Value.ToString()); 
        } 
 
        /*! Method to create parameters in order to add or edit a record. */
        public override void GetParamsPrimaryKey(ref System.Data.Common.DbCommand cmd, Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.Profile.Import.FreetextKeywords bo) 
        { 
            AddParam(ref cmd, "@PersonKeywordID", bo.PersonKeywordID);
        } 
 
        internal ProfilesRNSDLL.BO.Profile.Import.FreetextKeywords Get(int PersonKeywordID) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[Profile.Import].cg2_FreetextKeywordsGet");
            AddParam(ref cmd, "@PersonKeywordID", PersonKeywordID);
            return PopulateFromRow(FillTable(cmd), 0); 
        } 
        internal List<ProfilesRNSDLL.BO.Profile.Import.FreetextKeywords> GetByInternalUsername(string InternalUsername, bool addBlank) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[Profile.Import].cg2_FreetextKeywordsGetByInternalUsername");
            AddParam(ref cmd, "@InternalUsername", InternalUsername);
            return PopulateCollectionObject(FillTable(cmd), addBlank); 
        } 
        internal List<ProfilesRNSDLL.BO.Profile.Import.FreetextKeywords> GetByDisplaySecurityGroupID(int DisplaySecurityGroupID, bool addBlank) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[Profile.Import].cg2_FreetextKeywordsGetByDisplaySecurityGroupID");
            AddParam(ref cmd, "@DisplaySecurityGroupID", DisplaySecurityGroupID);
            return PopulateCollectionObject(FillTable(cmd), addBlank); 
        } 
        internal ProfilesRNSDLL.BO.Profile.Import.FreetextKeywords GetByInternalUsernameAndKeyword(string InternalUsername, string Keyword) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[Profile.Import].cg2_FreetextKeywordsGetByInternalUsernameAndKeyword");
            AddParam(ref cmd, "@InternalUsername", InternalUsername);
            AddParam(ref cmd, "@Keyword", Keyword);
            return PopulateFromRow(FillTable(cmd), 0); 
        } 
 
        /*! Method to create a FreetextKeywords object from a row in a dataset. */
        public override ProfilesRNSDLL.BO.Profile.Import.FreetextKeywords PopulateFromRow(System.Data.DataRow dr) 
        { 
            ProfilesRNSDLL.BO.Profile.Import.FreetextKeywords bo = new ProfilesRNSDLL.BO.Profile.Import.FreetextKeywords();
            bo.PersonKeywordID = int.Parse(dr["PersonKeywordID"].ToString()); 
            bo.InternalUsername = dr["InternalUsername"].ToString(); 
            bo.Keyword = dr["Keyword"].ToString(); 
            bo.DisplaySecurityGroupID = int.Parse(dr["DisplaySecurityGroupID"].ToString()); 
            bo.Exists = true;
            return bo;
        } 
     
        /*! Method to get the business object before the datachange. */
        protected override ProfilesRNSDLL.BO.Profile.Import.FreetextKeywords GetBOBefore(ProfilesRNSDLL.BO.Profile.Import.FreetextKeywords businessObj)
        { 
            return this.Get(businessObj.PersonKeywordID);
        } 
 
        # endregion // internal Method 
 
    } 
 
} 
