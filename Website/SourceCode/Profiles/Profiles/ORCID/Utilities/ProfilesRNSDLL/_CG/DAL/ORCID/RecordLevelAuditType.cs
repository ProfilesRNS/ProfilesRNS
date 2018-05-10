using System.Data.Common;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DAL.ORCID
{
    public partial class RecordLevelAuditType : DALGeneric<ProfilesRNSDLL.BO.ORCID.RecordLevelAuditType>
    { 
     
        # region Constructors 
    
        internal RecordLevelAuditType() : base() { } 
    
        # endregion // Constructors
     
        # region Methods 
 
        /*! Method to create parameters in order to add or edit a record. */
        public override void GetParamsAll(ref System.Data.Common.DbCommand cmd, ProfilesRNSDLL.BO.ORCID.RecordLevelAuditType bo) 
        { 
            DbParameter Parm = cmd.CreateParameter(); 
            Parm.ParameterName = "@RecordLevelAuditTypeID";
            Parm.DbType = System.Data.DbType.Byte;
            Parm.Size = 1;
            if(!bo.RecordLevelAuditTypeIDIsNull) {
                 Parm.Direction = System.Data.ParameterDirection.InputOutput; 
                 Parm.Value = bo.RecordLevelAuditTypeID;
            } else { 
                 Parm.Direction = System.Data.ParameterDirection.Output; 
            }  
            cmd.Parameters.Add(Parm);
            AddParam(ref cmd, "@AuditType", bo.AuditType);
        } 
 
        /*! Method to log changes to fields in a record. */
        public override void LogIfNecessary(DevelopmentBase.BaseClassBO.RecordLevelAuditTypes auditType, ProfilesRNSDLL.BO.ORCID.RecordLevelAuditType boBefore, ProfilesRNSDLL.BO.ORCID.RecordLevelAuditType bo, DbTransaction trans) 
        { 
            int recordLevelAuditTrailID = 0;
            if (auditType == DevelopmentBase.BaseClassBO.RecordLevelAuditTypes.Deleted)
            {
                recordLevelAuditTrailID = AddRecordLevelAuditTrail(bo.TableId, boBefore.RecordLevelAuditTypeID, auditType, trans);
            }
            else
            {
                recordLevelAuditTrailID = AddRecordLevelAuditTrail(bo.TableId, bo.RecordLevelAuditTypeID, auditType, trans);
            }
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.RecordLevelAuditType.FieldNames.AuditType, bo.AuditTypeIsNull, boBefore.AuditTypeIsNull, bo.AuditType, boBefore.AuditType, trans);
        } 
 
        /*! Method to get the fields in the table in a select string. */
        internal static string GetSelectString() { return "SELECT TOP 100 PERCENT [ORCID.].[RecordLevelAuditType].[RecordLevelAuditTypeID], [ORCID.].[RecordLevelAuditType].[AuditType]"; } 
 
        /*! Method to get identity(s) of the newly added database record. */
        public override void GetIdentity(System.Data.Common.DbCommand sqlCommand, ProfilesRNSDLL.BO.ORCID.RecordLevelAuditType businessObj)
        { 
            businessObj.RecordLevelAuditTypeID = int.Parse(sqlCommand.Parameters["@RecordLevelAuditTypeID"].Value.ToString()); 
        } 
 
        /*! Method to create parameters in order to add or edit a record. */
        public override void GetParamsPrimaryKey(ref System.Data.Common.DbCommand cmd, ProfilesRNSDLL.BO.ORCID.RecordLevelAuditType bo) 
        { 
            AddParam(ref cmd, "@RecordLevelAuditTypeID", bo.RecordLevelAuditTypeID);
        } 
 
        internal ProfilesRNSDLL.BO.ORCID.RecordLevelAuditType Get(int RecordLevelAuditTypeID) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[ORCID.].cg2_RecordLevelAuditTypeGet");
            AddParam(ref cmd, "@RecordLevelAuditTypeID", RecordLevelAuditTypeID);
            return PopulateFromRow(FillTable(cmd), 0); 
        } 
 
        /*! Method to create a RecordLevelAuditType object from a row in a dataset. */
        public override ProfilesRNSDLL.BO.ORCID.RecordLevelAuditType PopulateFromRow(System.Data.DataRow dr) 
        { 
            ProfilesRNSDLL.BO.ORCID.RecordLevelAuditType bo = new ProfilesRNSDLL.BO.ORCID.RecordLevelAuditType();
            bo.RecordLevelAuditTypeID = int.Parse(dr["RecordLevelAuditTypeID"].ToString()); 
            bo.AuditType = dr["AuditType"].ToString(); 
            bo.Exists = true;
            return bo;
        } 
     
        /*! Method to get the business object before the datachange. */
        protected override ProfilesRNSDLL.BO.ORCID.RecordLevelAuditType GetBOBefore(ProfilesRNSDLL.BO.ORCID.RecordLevelAuditType businessObj)
        { 
            return this.Get(businessObj.RecordLevelAuditTypeID);
        } 
 
        # endregion // internal Method 
 
    } 
 
} 
