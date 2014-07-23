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
    public partial class RecordLevelAuditTrail : DALGeneric<ProfilesRNSDLL.BO.ORCID.RecordLevelAuditTrail>
    { 
     
        # region Constructors 
    
        internal RecordLevelAuditTrail() : base() { } 
    
        # endregion // Constructors
     
        # region Methods 
 
        /*! Method to create parameters in order to add or edit a record. */
        public override void GetParamsAll(ref System.Data.Common.DbCommand cmd, ProfilesRNSDLL.BO.ORCID.RecordLevelAuditTrail bo) 
        { 
            DbParameter Parm = cmd.CreateParameter(); 
            Parm.ParameterName = "@RecordLevelAuditTrailID";
            Parm.Size = 8;
            Parm.DbType = System.Data.DbType.Int64;
            if(!bo.RecordLevelAuditTrailIDIsNull) {
                 Parm.Direction = System.Data.ParameterDirection.InputOutput; 
                 Parm.Value = bo.RecordLevelAuditTrailID;
            } else { 
                 Parm.Direction = System.Data.ParameterDirection.Output; 
            }  
            cmd.Parameters.Add(Parm);
            AddParam(ref cmd, "@MetaTableID", bo.MetaTableID);
            AddParam(ref cmd, "@RowIdentifier", bo.RowIdentifier);
            AddParam(ref cmd, "@RecordLevelAuditTypeID", bo.RecordLevelAuditTypeID);
            AddParam(ref cmd, "@CreatedDate", bo.CreatedDate);
            AddParam(ref cmd, "@CreatedBy", bo.CreatedBy);
        } 
 
        /*! Method to log changes to fields in a record. */
        public override void LogIfNecessary(DevelopmentBase.BaseClassBO.RecordLevelAuditTypes auditType, ProfilesRNSDLL.BO.ORCID.RecordLevelAuditTrail boBefore, ProfilesRNSDLL.BO.ORCID.RecordLevelAuditTrail bo, DbTransaction trans) 
        { 
        } 
 
        /*! Method to get the fields in the table in a select string. */
        internal static string GetSelectString() { return "SELECT TOP 100 PERCENT [ORCID.].[RecordLevelAuditTrail].[RecordLevelAuditTrailID], [ORCID.].[RecordLevelAuditTrail].[MetaTableID], [ORCID.].[RecordLevelAuditTrail].[RowIdentifier], [ORCID.].[RecordLevelAuditTrail].[RecordLevelAuditTypeID], [ORCID.].[RecordLevelAuditTrail].[CreatedDate], [ORCID.].[RecordLevelAuditTrail].[CreatedBy]"; } 
 
        /*! Method to get identity(s) of the newly added database record. */
        public override void GetIdentity(System.Data.Common.DbCommand sqlCommand, ProfilesRNSDLL.BO.ORCID.RecordLevelAuditTrail businessObj)
        { 
            businessObj.RecordLevelAuditTrailID = long.Parse(sqlCommand.Parameters["@RecordLevelAuditTrailID"].Value.ToString()); 
        } 
 
        /*! Method to create parameters in order to add or edit a record. */
        public override void GetParamsPrimaryKey(ref System.Data.Common.DbCommand cmd, ProfilesRNSDLL.BO.ORCID.RecordLevelAuditTrail bo) 
        { 
            AddParam(ref cmd, "@RecordLevelAuditTrailID", bo.RecordLevelAuditTrailID);
        } 
 
        internal ProfilesRNSDLL.BO.ORCID.RecordLevelAuditTrail Get(long RecordLevelAuditTrailID) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[ORCID.].cg2_RecordLevelAuditTrailGet");
            AddParam(ref cmd, "@RecordLevelAuditTrailID", RecordLevelAuditTrailID);
            return PopulateFromRow(FillTable(cmd), 0); 
        } 
 
        /*! Method to create a RecordLevelAuditTrail object from a row in a dataset. */
        public override ProfilesRNSDLL.BO.ORCID.RecordLevelAuditTrail PopulateFromRow(System.Data.DataRow dr) 
        { 
            ProfilesRNSDLL.BO.ORCID.RecordLevelAuditTrail bo = new ProfilesRNSDLL.BO.ORCID.RecordLevelAuditTrail();
            bo.RecordLevelAuditTrailID = long.Parse(dr["RecordLevelAuditTrailID"].ToString()); 
            bo.MetaTableID = int.Parse(dr["MetaTableID"].ToString()); 
            bo.RowIdentifier = long.Parse(dr["RowIdentifier"].ToString()); 
            bo.RecordLevelAuditTypeID = int.Parse(dr["RecordLevelAuditTypeID"].ToString()); 
            bo.CreatedDate = System.DateTime.Parse(dr["CreatedDate"].ToString()); 
            bo.CreatedBy = dr["CreatedBy"].ToString(); 
            bo.Exists = true;
            return bo;
        } 
     
        /*! Method to get the business object before the datachange. */
        protected override ProfilesRNSDLL.BO.ORCID.RecordLevelAuditTrail GetBOBefore(ProfilesRNSDLL.BO.ORCID.RecordLevelAuditTrail businessObj)
        { 
            return this.Get(businessObj.RecordLevelAuditTrailID);
        } 
 
        # endregion // internal Method 
 
    } 
 
} 
