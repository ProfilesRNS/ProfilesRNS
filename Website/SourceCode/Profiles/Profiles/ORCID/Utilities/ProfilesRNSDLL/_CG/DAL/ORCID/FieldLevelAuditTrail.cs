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
    public partial class FieldLevelAuditTrail : DALGeneric<ProfilesRNSDLL.BO.ORCID.FieldLevelAuditTrail>
    { 
     
        # region Constructors 
    
        internal FieldLevelAuditTrail() : base() { } 
    
        # endregion // Constructors
     
        # region Methods 
 
        /*! Method to create parameters in order to add or edit a record. */
        public override void GetParamsAll(ref System.Data.Common.DbCommand cmd, Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID.FieldLevelAuditTrail bo) 
        { 
            DbParameter Parm = cmd.CreateParameter(); 
            Parm.ParameterName = "@FieldLevelAuditTrailID";
            Parm.Size = 8;
            Parm.DbType = System.Data.DbType.Int64;
            if(!bo.FieldLevelAuditTrailIDIsNull) {
                 Parm.Direction = System.Data.ParameterDirection.InputOutput; 
                 Parm.Value = bo.FieldLevelAuditTrailID;
            } else { 
                 Parm.Direction = System.Data.ParameterDirection.Output; 
            }  
            cmd.Parameters.Add(Parm);
            AddParam(ref cmd, "@RecordLevelAuditTrailID", bo.RecordLevelAuditTrailID);
            AddParam(ref cmd, "@MetaFieldID", bo.MetaFieldID);
            if(!bo.ValueBeforeIsNull) {
                 AddParam(ref cmd, "@ValueBefore", bo.ValueBefore);
            } 
            if(!bo.ValueAfterIsNull) {
                 AddParam(ref cmd, "@ValueAfter", bo.ValueAfter);
            } 
        } 
 
        /*! Method to log changes to fields in a record. */
        public override void LogIfNecessary(DevelopmentBase.BaseClassBO.RecordLevelAuditTypes auditType, ProfilesRNSDLL.BO.ORCID.FieldLevelAuditTrail boBefore, ProfilesRNSDLL.BO.ORCID.FieldLevelAuditTrail bo, DbTransaction trans) 
        { 
        } 
 
        /*! Method to get the fields in the table in a select string. */
        internal static string GetSelectString() { return "SELECT TOP 100 PERCENT [ORCID.].[FieldLevelAuditTrail].[FieldLevelAuditTrailID], [ORCID.].[FieldLevelAuditTrail].[RecordLevelAuditTrailID], [ORCID.].[FieldLevelAuditTrail].[MetaFieldID], [ORCID.].[FieldLevelAuditTrail].[ValueBefore], [ORCID.].[FieldLevelAuditTrail].[ValueAfter]"; } 
 
        /*! Method to get identity(s) of the newly added database record. */
        public override void GetIdentity(System.Data.Common.DbCommand sqlCommand, ProfilesRNSDLL.BO.ORCID.FieldLevelAuditTrail businessObj)
        { 
            businessObj.FieldLevelAuditTrailID = long.Parse(sqlCommand.Parameters["@FieldLevelAuditTrailID"].Value.ToString()); 
        } 
 
        /*! Method to create parameters in order to add or edit a record. */
        public override void GetParamsPrimaryKey(ref System.Data.Common.DbCommand cmd, ProfilesRNSDLL.BO.ORCID.FieldLevelAuditTrail bo) 
        { 
            AddParam(ref cmd, "@FieldLevelAuditTrailID", bo.FieldLevelAuditTrailID);
        } 
 
        internal ProfilesRNSDLL.BO.ORCID.FieldLevelAuditTrail Get(long FieldLevelAuditTrailID) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[ORCID.].cg2_FieldLevelAuditTrailGet");
            AddParam(ref cmd, "@FieldLevelAuditTrailID", FieldLevelAuditTrailID);
            return PopulateFromRow(FillTable(cmd), 0); 
        } 
 
        /*! Method to create a FieldLevelAuditTrail object from a row in a dataset. */
        public override ProfilesRNSDLL.BO.ORCID.FieldLevelAuditTrail PopulateFromRow(System.Data.DataRow dr) 
        { 
            ProfilesRNSDLL.BO.ORCID.FieldLevelAuditTrail bo = new ProfilesRNSDLL.BO.ORCID.FieldLevelAuditTrail();
            bo.FieldLevelAuditTrailID = long.Parse(dr["FieldLevelAuditTrailID"].ToString()); 
            bo.RecordLevelAuditTrailID = long.Parse(dr["RecordLevelAuditTrailID"].ToString()); 
            bo.MetaFieldID = int.Parse(dr["MetaFieldID"].ToString()); 
            if(!dr.IsNull("ValueBefore"))
            { 
                 bo.ValueBefore = dr["ValueBefore"].ToString(); 
            } 
            if(!dr.IsNull("ValueAfter"))
            { 
                 bo.ValueAfter = dr["ValueAfter"].ToString(); 
            } 
            bo.Exists = true;
            return bo;
        } 
     
        /*! Method to get the business object before the datachange. */
        protected override ProfilesRNSDLL.BO.ORCID.FieldLevelAuditTrail GetBOBefore(ProfilesRNSDLL.BO.ORCID.FieldLevelAuditTrail businessObj)
        { 
            return this.Get(businessObj.FieldLevelAuditTrailID);
        } 
 
        # endregion // internal Method 
 
    } 
 
} 
