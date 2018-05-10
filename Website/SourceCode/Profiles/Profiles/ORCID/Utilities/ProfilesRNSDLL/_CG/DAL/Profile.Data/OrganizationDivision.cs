using System.Data.Common;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DAL.Profile.Data
{
    public partial class OrganizationDivision : DALGeneric<ProfilesRNSDLL.BO.Profile.Data.OrganizationDivision>
    { 
     
        # region Constructors 
    
        internal OrganizationDivision() : base() { } 
    
        # endregion // Constructors
     
        # region Methods 
 
        /*! Method to create parameters in order to add or edit a record. */
        public override void GetParamsAll(ref System.Data.Common.DbCommand cmd, ProfilesRNSDLL.BO.Profile.Data.OrganizationDivision bo) 
        { 
            DbParameter Parm = cmd.CreateParameter(); 
            Parm.ParameterName = "@DivisionID";
            Parm.Size = 4;
            Parm.DbType = System.Data.DbType.Int32;
            if(!bo.DivisionIDIsNull) {
                 Parm.Direction = System.Data.ParameterDirection.InputOutput; 
                 Parm.Value = bo.DivisionID;
            } else { 
                 Parm.Direction = System.Data.ParameterDirection.Output; 
            }  
            cmd.Parameters.Add(Parm);
            if(!bo.DivisionNameIsNull) {
                 AddParam(ref cmd, "@DivisionName", bo.DivisionName);
            } 
        } 
 
        /*! Method to log changes to fields in a record. */
        public override void LogIfNecessary(DevelopmentBase.BaseClassBO.RecordLevelAuditTypes auditType, ProfilesRNSDLL.BO.Profile.Data.OrganizationDivision boBefore, ProfilesRNSDLL.BO.Profile.Data.OrganizationDivision bo, DbTransaction trans) 
        { 
            int recordLevelAuditTrailID = 0;
            if (auditType == DevelopmentBase.BaseClassBO.RecordLevelAuditTypes.Deleted)
            {
                recordLevelAuditTrailID = AddRecordLevelAuditTrail(bo.TableId, boBefore.DivisionID, auditType, trans);
            }
            else
            {
                recordLevelAuditTrailID = AddRecordLevelAuditTrail(bo.TableId, bo.DivisionID, auditType, trans);
            }
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Data.OrganizationDivision.FieldNames.DivisionName, bo.DivisionNameIsNull, boBefore.DivisionNameIsNull, bo.DivisionName, boBefore.DivisionName, trans);
        } 
 
        /*! Method to get the fields in the table in a select string. */
        internal static string GetSelectString() { return "SELECT TOP 100 PERCENT [Profile.Data].[Organization.Division].[DivisionID], [Profile.Data].[Organization.Division].[DivisionName]"; } 
 
        /*! Method to get identity(s) of the newly added database record. */
        public override void GetIdentity(System.Data.Common.DbCommand sqlCommand, ProfilesRNSDLL.BO.Profile.Data.OrganizationDivision businessObj)
        { 
            businessObj.DivisionID = int.Parse(sqlCommand.Parameters["@DivisionID"].Value.ToString()); 
        } 
 
        /*! Method to create parameters in order to add or edit a record. */
        public override void GetParamsPrimaryKey(ref System.Data.Common.DbCommand cmd, ProfilesRNSDLL.BO.Profile.Data.OrganizationDivision bo) 
        { 
            AddParam(ref cmd, "@DivisionID", bo.DivisionID);
        } 
 
        internal ProfilesRNSDLL.BO.Profile.Data.OrganizationDivision Get(int DivisionID) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[Profile.Data].cg2_OrganizationDivisionGet");
            AddParam(ref cmd, "@DivisionID", DivisionID);
            return PopulateFromRow(FillTable(cmd), 0); 
        } 
 
        /*! Method to create a OrganizationDivision object from a row in a dataset. */
        public override ProfilesRNSDLL.BO.Profile.Data.OrganizationDivision PopulateFromRow(System.Data.DataRow dr) 
        { 
            ProfilesRNSDLL.BO.Profile.Data.OrganizationDivision bo = new ProfilesRNSDLL.BO.Profile.Data.OrganizationDivision();
            bo.DivisionID = int.Parse(dr["DivisionID"].ToString()); 
            if(!dr.IsNull("DivisionName"))
            { 
                 bo.DivisionName = dr["DivisionName"].ToString(); 
            } 
            bo.Exists = true;
            return bo;
        } 
     
        /*! Method to get the business object before the datachange. */
        protected override ProfilesRNSDLL.BO.Profile.Data.OrganizationDivision GetBOBefore(ProfilesRNSDLL.BO.Profile.Data.OrganizationDivision businessObj)
        { 
            return this.Get(businessObj.DivisionID);
        } 
 
        # endregion // internal Method 
 
    } 
 
} 
