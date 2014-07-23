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
    public partial class REFPermission : DALGeneric<ProfilesRNSDLL.BO.ORCID.REFPermission>
    { 
     
        # region Constructors 
    
        internal REFPermission() : base() { } 
    
        # endregion // Constructors
     
        # region Methods 
 
        /*! Method to create parameters in order to add or edit a record. */
        public override void GetParamsAll(ref System.Data.Common.DbCommand cmd, ProfilesRNSDLL.BO.ORCID.REFPermission bo) 
        { 
            DbParameter Parm = cmd.CreateParameter(); 
            Parm.ParameterName = "@PermissionID";
            Parm.DbType = System.Data.DbType.Byte;
            Parm.Size = 1;
            if(!bo.PermissionIDIsNull) {
                 Parm.Direction = System.Data.ParameterDirection.InputOutput; 
                 Parm.Value = bo.PermissionID;
            } else { 
                 Parm.Direction = System.Data.ParameterDirection.Output; 
            }  
            cmd.Parameters.Add(Parm);
            AddParam(ref cmd, "@PermissionScope", bo.PermissionScope);
            AddParam(ref cmd, "@PermissionDescription", bo.PermissionDescription);
            if(!bo.MethodAndRequestIsNull) {
                 AddParam(ref cmd, "@MethodAndRequest", bo.MethodAndRequest);
            } 
            if(!bo.SuccessMessageIsNull) {
                 AddParam(ref cmd, "@SuccessMessage", bo.SuccessMessage);
            } 
            if(!bo.FailedMessageIsNull) {
                 AddParam(ref cmd, "@FailedMessage", bo.FailedMessage);
            } 
        } 
 
        /*! Method to log changes to fields in a record. */
        public override void LogIfNecessary(DevelopmentBase.BaseClassBO.RecordLevelAuditTypes auditType, ProfilesRNSDLL.BO.ORCID.REFPermission boBefore, ProfilesRNSDLL.BO.ORCID.REFPermission bo, DbTransaction trans) 
        { 
            int recordLevelAuditTrailID = 0;
            if (auditType == DevelopmentBase.BaseClassBO.RecordLevelAuditTypes.Deleted)
            {
                recordLevelAuditTrailID = AddRecordLevelAuditTrail(bo.TableId, boBefore.PermissionID, auditType, trans);
            }
            else
            {
                recordLevelAuditTrailID = AddRecordLevelAuditTrail(bo.TableId, bo.PermissionID, auditType, trans);
            }
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.REFPermission.FieldNames.PermissionScope, bo.PermissionScopeIsNull, boBefore.PermissionScopeIsNull, bo.PermissionScope, boBefore.PermissionScope, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.REFPermission.FieldNames.PermissionDescription, bo.PermissionDescriptionIsNull, boBefore.PermissionDescriptionIsNull, bo.PermissionDescription, boBefore.PermissionDescription, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.REFPermission.FieldNames.MethodAndRequest, bo.MethodAndRequestIsNull, boBefore.MethodAndRequestIsNull, bo.MethodAndRequest, boBefore.MethodAndRequest, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.REFPermission.FieldNames.SuccessMessage, bo.SuccessMessageIsNull, boBefore.SuccessMessageIsNull, bo.SuccessMessage, boBefore.SuccessMessage, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.REFPermission.FieldNames.FailedMessage, bo.FailedMessageIsNull, boBefore.FailedMessageIsNull, bo.FailedMessage, boBefore.FailedMessage, trans);
        } 
 
        /*! Method to get the fields in the table in a select string. */
        internal static string GetSelectString() { return "SELECT TOP 100 PERCENT [ORCID.].[REF_Permission].[PermissionID], [ORCID.].[REF_Permission].[PermissionScope], [ORCID.].[REF_Permission].[PermissionDescription], [ORCID.].[REF_Permission].[MethodAndRequest], [ORCID.].[REF_Permission].[SuccessMessage], [ORCID.].[REF_Permission].[FailedMessage]"; } 
 
        /*! Method to get identity(s) of the newly added database record. */
        public override void GetIdentity(System.Data.Common.DbCommand sqlCommand, ProfilesRNSDLL.BO.ORCID.REFPermission businessObj)
        { 
            businessObj.PermissionID = int.Parse(sqlCommand.Parameters["@PermissionID"].Value.ToString()); 
        } 
 
        /*! Method to create parameters in order to add or edit a record. */
        public override void GetParamsPrimaryKey(ref System.Data.Common.DbCommand cmd, ProfilesRNSDLL.BO.ORCID.REFPermission bo) 
        { 
            AddParam(ref cmd, "@PermissionID", bo.PermissionID);
        } 
 
        internal ProfilesRNSDLL.BO.ORCID.REFPermission GetByPermissionScope(string PermissionScope) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[ORCID.].cg2_REFPermissionGetByPermissionScope");
            AddParam(ref cmd, "@PermissionScope", PermissionScope);
            return PopulateFromRow(FillTable(cmd), 0); 
        } 
        internal ProfilesRNSDLL.BO.ORCID.REFPermission Get(int PermissionID) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[ORCID.].cg2_REFPermissionGet");
            AddParam(ref cmd, "@PermissionID", PermissionID);
            return PopulateFromRow(FillTable(cmd), 0); 
        } 
 
        /*! Method to create a REFPermission object from a row in a dataset. */
        public override ProfilesRNSDLL.BO.ORCID.REFPermission PopulateFromRow(System.Data.DataRow dr) 
        { 
            ProfilesRNSDLL.BO.ORCID.REFPermission bo = new ProfilesRNSDLL.BO.ORCID.REFPermission();
            bo.PermissionID = int.Parse(dr["PermissionID"].ToString()); 
            bo.PermissionScope = dr["PermissionScope"].ToString(); 
            bo.PermissionDescription = dr["PermissionDescription"].ToString(); 
            if(!dr.IsNull("MethodAndRequest"))
            { 
                 bo.MethodAndRequest = dr["MethodAndRequest"].ToString(); 
            } 
            if(!dr.IsNull("SuccessMessage"))
            { 
                 bo.SuccessMessage = dr["SuccessMessage"].ToString(); 
            } 
            if(!dr.IsNull("FailedMessage"))
            { 
                 bo.FailedMessage = dr["FailedMessage"].ToString(); 
            } 
            bo.Exists = true;
            return bo;
        } 
     
        /*! Method to get the business object before the datachange. */
        protected override ProfilesRNSDLL.BO.ORCID.REFPermission GetBOBefore(ProfilesRNSDLL.BO.ORCID.REFPermission businessObj)
        { 
            return this.Get(businessObj.PermissionID);
        } 
 
        # endregion // internal Method 
 
    } 
 
} 
