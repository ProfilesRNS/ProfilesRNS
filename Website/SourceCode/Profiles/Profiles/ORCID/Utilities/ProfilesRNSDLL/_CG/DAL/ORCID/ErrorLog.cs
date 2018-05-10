using System.Data.Common;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DAL.ORCID
{
    public partial class ErrorLog : DALGeneric<ProfilesRNSDLL.BO.ORCID.ErrorLog>
    { 
     
        # region Constructors 
    
        internal ErrorLog() : base() { } 
    
        # endregion // Constructors
     
        # region Methods 
 
        /*! Method to create parameters in order to add or edit a record. */
        public override void GetParamsAll(ref System.Data.Common.DbCommand cmd, Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID.ErrorLog bo) 
        { 
            DbParameter Parm = cmd.CreateParameter(); 
            Parm.ParameterName = "@ErrorLogID";
            Parm.Size = 4;
            Parm.DbType = System.Data.DbType.Int32;
            if(!bo.ErrorLogIDIsNull) {
                 Parm.Direction = System.Data.ParameterDirection.InputOutput; 
                 Parm.Value = bo.ErrorLogID;
            } else { 
                 Parm.Direction = System.Data.ParameterDirection.Output; 
            }  
            cmd.Parameters.Add(Parm);
            if(!bo.InternalUsernameIsNull) {
                 AddParam(ref cmd, "@InternalUsername", bo.InternalUsername);
            } 
            AddParam(ref cmd, "@Exception", bo.Exception);
            AddParam(ref cmd, "@OccurredOn", bo.OccurredOn);
            AddParam(ref cmd, "@Processed", bo.Processed);
        } 
 
        /*! Method to log changes to fields in a record. */
        public override void LogIfNecessary(DevelopmentBase.BaseClassBO.RecordLevelAuditTypes auditType, Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID.ErrorLog boBefore, Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID.ErrorLog bo, DbTransaction trans) 
        { 
            int recordLevelAuditTrailID = 0;
            if (auditType == DevelopmentBase.BaseClassBO.RecordLevelAuditTypes.Deleted)
            {
                recordLevelAuditTrailID = AddRecordLevelAuditTrail(bo.TableId, boBefore.ErrorLogID, auditType, trans);
            }
            else
            {
                recordLevelAuditTrailID = AddRecordLevelAuditTrail(bo.TableId, bo.ErrorLogID, auditType, trans);
            }
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.ErrorLog.FieldNames.InternalUsername, bo.InternalUsernameIsNull, boBefore.InternalUsernameIsNull, bo.InternalUsername, boBefore.InternalUsername, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.ErrorLog.FieldNames.Exception, bo.ExceptionIsNull, boBefore.ExceptionIsNull, bo.Exception, boBefore.Exception, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.ErrorLog.FieldNames.OccurredOn, bo.OccurredOnIsNull, boBefore.OccurredOnIsNull, bo.OccurredOn, boBefore.OccurredOn, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.ErrorLog.FieldNames.Processed, bo.ProcessedIsNull, boBefore.ProcessedIsNull, bo.Processed, boBefore.Processed, trans);
        } 
 
        /*! Method to get the fields in the table in a select string. */
        internal static string GetSelectString() { return "SELECT TOP 100 PERCENT [ORCID.].[ErrorLog].[ErrorLogID], [ORCID.].[ErrorLog].[InternalUsername], [ORCID.].[ErrorLog].[Exception], [ORCID.].[ErrorLog].[OccurredOn], [ORCID.].[ErrorLog].[Processed]"; } 
 
        /*! Method to get identity(s) of the newly added database record. */
        public override void GetIdentity(System.Data.Common.DbCommand sqlCommand, Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID.ErrorLog businessObj)
        { 
            businessObj.ErrorLogID = int.Parse(sqlCommand.Parameters["@ErrorLogID"].Value.ToString()); 
        } 
 
        /*! Method to create parameters in order to add or edit a record. */
        public override void GetParamsPrimaryKey(ref System.Data.Common.DbCommand cmd, Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID.ErrorLog bo) 
        { 
            AddParam(ref cmd, "@ErrorLogID", bo.ErrorLogID);
        } 
 
        internal ProfilesRNSDLL.BO.ORCID.ErrorLog Get(int ErrorLogID) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[ORCID.].cg2_ErrorLogGet");
            AddParam(ref cmd, "@ErrorLogID", ErrorLogID);
            return PopulateFromRow(FillTable(cmd), 0); 
        } 
 
        /*! Method to create a ErrorLog object from a row in a dataset. */
        public override ProfilesRNSDLL.BO.ORCID.ErrorLog PopulateFromRow(System.Data.DataRow dr) 
        { 
            ProfilesRNSDLL.BO.ORCID.ErrorLog bo = new ProfilesRNSDLL.BO.ORCID.ErrorLog();
            bo.ErrorLogID = int.Parse(dr["ErrorLogID"].ToString()); 
            if(!dr.IsNull("InternalUsername"))
            { 
                 bo.InternalUsername = dr["InternalUsername"].ToString(); 
            } 
            bo.Exception = dr["Exception"].ToString(); 
            bo.OccurredOn = System.DateTime.Parse(dr["OccurredOn"].ToString()); 
            bo.Processed = bool.Parse(dr["Processed"].ToString()); 
            bo.Exists = true;
            return bo;
        } 
     
        /*! Method to get the business object before the datachange. */
        protected override ProfilesRNSDLL.BO.ORCID.ErrorLog GetBOBefore(ProfilesRNSDLL.BO.ORCID.ErrorLog businessObj)
        { 
            return this.Get(businessObj.ErrorLogID);
        } 
 
        # endregion // internal Method 
 
    } 
 
} 
