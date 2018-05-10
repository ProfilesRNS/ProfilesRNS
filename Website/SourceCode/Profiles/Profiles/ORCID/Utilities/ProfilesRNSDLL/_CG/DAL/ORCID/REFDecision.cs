using System.Data.Common;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DAL.ORCID
{
    public partial class REFDecision : DALGeneric<ProfilesRNSDLL.BO.ORCID.REFDecision>
    { 
     
        # region Constructors 
    
        internal REFDecision() : base() { } 
    
        # endregion // Constructors
     
        # region Methods 
 
        /*! Method to create parameters in order to add or edit a record. */
        public override void GetParamsAll(ref System.Data.Common.DbCommand cmd, ProfilesRNSDLL.BO.ORCID.REFDecision bo) 
        { 
            DbParameter Parm = cmd.CreateParameter(); 
            Parm.ParameterName = "@DecisionID";
            Parm.DbType = System.Data.DbType.Byte;
            Parm.Size = 1;
            if(!bo.DecisionIDIsNull) {
                 Parm.Direction = System.Data.ParameterDirection.InputOutput; 
                 Parm.Value = bo.DecisionID;
            } else { 
                 Parm.Direction = System.Data.ParameterDirection.Output; 
            }  
            cmd.Parameters.Add(Parm);
            AddParam(ref cmd, "@DecisionDescription", bo.DecisionDescription);
            AddParam(ref cmd, "@DecisionDescriptionLong", bo.DecisionDescriptionLong);
        } 
 
        /*! Method to log changes to fields in a record. */
        public override void LogIfNecessary(DevelopmentBase.BaseClassBO.RecordLevelAuditTypes auditType, ProfilesRNSDLL.BO.ORCID.REFDecision boBefore, ProfilesRNSDLL.BO.ORCID.REFDecision bo, DbTransaction trans) 
        { 
            int recordLevelAuditTrailID = 0;
            if (auditType == DevelopmentBase.BaseClassBO.RecordLevelAuditTypes.Deleted)
            {
                recordLevelAuditTrailID = AddRecordLevelAuditTrail(bo.TableId, boBefore.DecisionID, auditType, trans);
            }
            else
            {
                recordLevelAuditTrailID = AddRecordLevelAuditTrail(bo.TableId, bo.DecisionID, auditType, trans);
            }
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.REFDecision.FieldNames.DecisionDescription, bo.DecisionDescriptionIsNull, boBefore.DecisionDescriptionIsNull, bo.DecisionDescription, boBefore.DecisionDescription, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.REFDecision.FieldNames.DecisionDescriptionLong, bo.DecisionDescriptionLongIsNull, boBefore.DecisionDescriptionLongIsNull, bo.DecisionDescriptionLong, boBefore.DecisionDescriptionLong, trans);
        } 
 
        /*! Method to get the fields in the table in a select string. */
        internal static string GetSelectString() { return "SELECT TOP 100 PERCENT [ORCID.].[REF_Decision].[DecisionID], [ORCID.].[REF_Decision].[DecisionDescription], [ORCID.].[REF_Decision].[DecisionDescriptionLong]"; } 
 
        /*! Method to get identity(s) of the newly added database record. */
        public override void GetIdentity(System.Data.Common.DbCommand sqlCommand, ProfilesRNSDLL.BO.ORCID.REFDecision businessObj)
        { 
            businessObj.DecisionID = int.Parse(sqlCommand.Parameters["@DecisionID"].Value.ToString()); 
        } 
 
        /*! Method to create parameters in order to add or edit a record. */
        public override void GetParamsPrimaryKey(ref System.Data.Common.DbCommand cmd, ProfilesRNSDLL.BO.ORCID.REFDecision bo) 
        { 
            AddParam(ref cmd, "@DecisionID", bo.DecisionID);
        } 
 
        internal ProfilesRNSDLL.BO.ORCID.REFDecision Get(int DecisionID) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[ORCID.].cg2_REFDecisionGet");
            AddParam(ref cmd, "@DecisionID", DecisionID);
            return PopulateFromRow(FillTable(cmd), 0); 
        } 
 
        /*! Method to create a REFDecision object from a row in a dataset. */
        public override ProfilesRNSDLL.BO.ORCID.REFDecision PopulateFromRow(System.Data.DataRow dr) 
        { 
            ProfilesRNSDLL.BO.ORCID.REFDecision bo = new ProfilesRNSDLL.BO.ORCID.REFDecision();
            bo.DecisionID = int.Parse(dr["DecisionID"].ToString()); 
            bo.DecisionDescription = dr["DecisionDescription"].ToString(); 
            bo.DecisionDescriptionLong = dr["DecisionDescriptionLong"].ToString(); 
            bo.Exists = true;
            return bo;
        } 
     
        /*! Method to get the business object before the datachange. */
        protected override ProfilesRNSDLL.BO.ORCID.REFDecision GetBOBefore(ProfilesRNSDLL.BO.ORCID.REFDecision businessObj)
        { 
            return this.Get(businessObj.DecisionID);
        } 
 
        # endregion // internal Method 
 
    } 
 
} 
