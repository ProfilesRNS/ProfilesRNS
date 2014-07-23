using System; 
using System.Collections.Generic; 
using System.Data; 
using System.Data.Common; 
using System.Linq; 
using System.Text;
using System.Reflection;
using System.Diagnostics;
 
namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DAL.ORCID
{ 
    public partial class PersonToken : DALGeneric<ProfilesRNSDLL.BO.ORCID.PersonToken>
    { 
     
        # region Constructors 
    
        internal PersonToken() : base() { } 
    
        # endregion // Constructors
     
        # region Methods 
 
        /*! Method to create parameters in order to add or edit a record. */
        public override void GetParamsAll(ref System.Data.Common.DbCommand cmd, ProfilesRNSDLL.BO.ORCID.PersonToken bo) 
        { 
            DbParameter Parm = cmd.CreateParameter(); 
            Parm.ParameterName = "@PersonTokenID";
            Parm.Size = 4;
            Parm.DbType = System.Data.DbType.Int32;
            if(!bo.PersonTokenIDIsNull) {
                 Parm.Direction = System.Data.ParameterDirection.InputOutput; 
                 Parm.Value = bo.PersonTokenID;
            } else { 
                 Parm.Direction = System.Data.ParameterDirection.Output; 
            }  
            cmd.Parameters.Add(Parm);
            AddParam(ref cmd, "@PersonID", bo.PersonID);
            AddParam(ref cmd, "@PermissionID", bo.PermissionID);
            AddParam(ref cmd, "@AccessToken", bo.AccessToken);
            AddParam(ref cmd, "@TokenExpiration", bo.TokenExpiration);
            if(!bo.RefreshTokenIsNull) {
                 AddParam(ref cmd, "@RefreshToken", bo.RefreshToken);
            } 
        } 
 
        /*! Method to log changes to fields in a record. */
        public override void LogIfNecessary(DevelopmentBase.BaseClassBO.RecordLevelAuditTypes auditType, ProfilesRNSDLL.BO.ORCID.PersonToken boBefore, ProfilesRNSDLL.BO.ORCID.PersonToken bo, DbTransaction trans) 
        { 
            int recordLevelAuditTrailID = 0;
            if (auditType == DevelopmentBase.BaseClassBO.RecordLevelAuditTypes.Deleted)
            {
                recordLevelAuditTrailID = AddRecordLevelAuditTrail(bo.TableId, boBefore.PersonTokenID, auditType, trans);
            }
            else
            {
                recordLevelAuditTrailID = AddRecordLevelAuditTrail(bo.TableId, bo.PersonTokenID, auditType, trans);
            }
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.PersonToken.FieldNames.PersonID, bo.PersonIDIsNull, boBefore.PersonIDIsNull, bo.PersonID, boBefore.PersonID, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.PersonToken.FieldNames.PermissionID, bo.PermissionIDIsNull, boBefore.PermissionIDIsNull, bo.PermissionID, boBefore.PermissionID, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.PersonToken.FieldNames.AccessToken, bo.AccessTokenIsNull, boBefore.AccessTokenIsNull, bo.AccessToken, boBefore.AccessToken, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.PersonToken.FieldNames.TokenExpiration, bo.TokenExpirationIsNull, boBefore.TokenExpirationIsNull, bo.TokenExpiration, boBefore.TokenExpiration, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.PersonToken.FieldNames.RefreshToken, bo.RefreshTokenIsNull, boBefore.RefreshTokenIsNull, bo.RefreshToken, boBefore.RefreshToken, trans);
        } 
 
        /*! Method to get the fields in the table in a select string. */
        internal static string GetSelectString() { return "SELECT TOP 100 PERCENT [ORCID.].[PersonToken].[PersonTokenID], [ORCID.].[PersonToken].[PersonID], [ORCID.].[PersonToken].[PermissionID], [ORCID.].[PersonToken].[AccessToken], [ORCID.].[PersonToken].[TokenExpiration], [ORCID.].[PersonToken].[RefreshToken]"; } 
 
        /*! Method to get identity(s) of the newly added database record. */
        public override void GetIdentity(System.Data.Common.DbCommand sqlCommand, ProfilesRNSDLL.BO.ORCID.PersonToken businessObj)
        { 
            businessObj.PersonTokenID = int.Parse(sqlCommand.Parameters["@PersonTokenID"].Value.ToString()); 
        } 
 
        /*! Method to create parameters in order to add or edit a record. */
        public override void GetParamsPrimaryKey(ref System.Data.Common.DbCommand cmd, ProfilesRNSDLL.BO.ORCID.PersonToken bo) 
        { 
            AddParam(ref cmd, "@PersonTokenID", bo.PersonTokenID);
        } 
 
        internal List<ProfilesRNSDLL.BO.ORCID.PersonToken> GetByPermissionID(int PermissionID, bool addBlank) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[ORCID.].cg2_PersonTokenGetByPermissionID");
            AddParam(ref cmd, "@PermissionID", PermissionID);
            return PopulateCollectionObject(FillTable(cmd), addBlank); 
        } 
        internal List<ProfilesRNSDLL.BO.ORCID.PersonToken> GetByPersonID(int PersonID, bool addBlank) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[ORCID.].cg2_PersonTokenGetByPersonID");
            AddParam(ref cmd, "@PersonID", PersonID);
            return PopulateCollectionObject(FillTable(cmd), addBlank); 
        } 
        internal ProfilesRNSDLL.BO.ORCID.PersonToken GetByPersonIDAndPermissionID(int PersonID, int PermissionID) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[ORCID.].cg2_PersonTokenGetByPersonIDAndPermissionID");
            AddParam(ref cmd, "@PersonID", PersonID);
            AddParam(ref cmd, "@PermissionID", PermissionID);
            return PopulateFromRow(FillTable(cmd), 0); 
        } 
        internal ProfilesRNSDLL.BO.ORCID.PersonToken Get(int PersonTokenID) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[ORCID.].cg2_PersonTokenGet");
            AddParam(ref cmd, "@PersonTokenID", PersonTokenID);
            return PopulateFromRow(FillTable(cmd), 0); 
        } 
 
        /*! Method to create a PersonToken object from a row in a dataset. */
        public override ProfilesRNSDLL.BO.ORCID.PersonToken PopulateFromRow(System.Data.DataRow dr) 
        { 
            ProfilesRNSDLL.BO.ORCID.PersonToken bo = new ProfilesRNSDLL.BO.ORCID.PersonToken();
            bo.PersonTokenID = int.Parse(dr["PersonTokenID"].ToString()); 
            bo.PersonID = int.Parse(dr["PersonID"].ToString()); 
            bo.PermissionID = int.Parse(dr["PermissionID"].ToString()); 
            bo.AccessToken = dr["AccessToken"].ToString(); 
            bo.TokenExpiration = System.DateTime.Parse(dr["TokenExpiration"].ToString()); 
            if(!dr.IsNull("RefreshToken"))
            { 
                 bo.RefreshToken = dr["RefreshToken"].ToString(); 
            } 
            bo.Exists = true;
            return bo;
        } 
     
        /*! Method to get the business object before the datachange. */
        protected override ProfilesRNSDLL.BO.ORCID.PersonToken GetBOBefore(ProfilesRNSDLL.BO.ORCID.PersonToken businessObj)
        { 
            return this.Get(businessObj.PersonTokenID);
        } 
 
        # endregion // internal Method 
 
    } 
 
} 
