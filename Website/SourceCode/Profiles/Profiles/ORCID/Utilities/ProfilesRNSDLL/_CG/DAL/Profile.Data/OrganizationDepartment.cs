using System; 
using System.Collections.Generic; 
using System.Data; 
using System.Data.Common; 
using System.Linq; 
using System.Text;
using System.Reflection;
using System.Diagnostics;
 
namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DAL.Profile.Data
{ 
    public partial class OrganizationDepartment : DALGeneric<ProfilesRNSDLL.BO.Profile.Data.OrganizationDepartment>
    { 
     
        # region Constructors 
    
        internal OrganizationDepartment() : base() { } 
    
        # endregion // Constructors
     
        # region Methods 
 
        /*! Method to create parameters in order to add or edit a record. */
        public override void GetParamsAll(ref System.Data.Common.DbCommand cmd, ProfilesRNSDLL.BO.Profile.Data.OrganizationDepartment bo) 
        { 
            DbParameter Parm = cmd.CreateParameter(); 
            Parm.ParameterName = "@DepartmentID";
            Parm.Size = 4;
            Parm.DbType = System.Data.DbType.Int32;
            if(!bo.DepartmentIDIsNull) {
                 Parm.Direction = System.Data.ParameterDirection.InputOutput; 
                 Parm.Value = bo.DepartmentID;
            } else { 
                 Parm.Direction = System.Data.ParameterDirection.Output; 
            }  
            cmd.Parameters.Add(Parm);
            if(!bo.DepartmentNameIsNull) {
                 AddParam(ref cmd, "@DepartmentName", bo.DepartmentName);
            } 
            if(!bo.VisibleIsNull) {
                 AddParam(ref cmd, "@Visible", bo.Visible);
            } 
        } 
 
        /*! Method to log changes to fields in a record. */
        public override void LogIfNecessary(DevelopmentBase.BaseClassBO.RecordLevelAuditTypes auditType, ProfilesRNSDLL.BO.Profile.Data.OrganizationDepartment boBefore, ProfilesRNSDLL.BO.Profile.Data.OrganizationDepartment bo, DbTransaction trans) 
        { 
            int recordLevelAuditTrailID = 0;
            if (auditType == DevelopmentBase.BaseClassBO.RecordLevelAuditTypes.Deleted)
            {
                recordLevelAuditTrailID = AddRecordLevelAuditTrail(bo.TableId, boBefore.DepartmentID, auditType, trans);
            }
            else
            {
                recordLevelAuditTrailID = AddRecordLevelAuditTrail(bo.TableId, bo.DepartmentID, auditType, trans);
            }
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Data.OrganizationDepartment.FieldNames.DepartmentName, bo.DepartmentNameIsNull, boBefore.DepartmentNameIsNull, bo.DepartmentName, boBefore.DepartmentName, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Data.OrganizationDepartment.FieldNames.Visible, bo.VisibleIsNull, boBefore.VisibleIsNull, bo.Visible, boBefore.Visible, trans);
        } 
 
        /*! Method to get the fields in the table in a select string. */
        internal static string GetSelectString() { return "SELECT TOP 100 PERCENT [Profile.Data].[Organization.Department].[DepartmentID], [Profile.Data].[Organization.Department].[DepartmentName], [Profile.Data].[Organization.Department].[Visible]"; } 
 
        /*! Method to get identity(s) of the newly added database record. */
        public override void GetIdentity(System.Data.Common.DbCommand sqlCommand, ProfilesRNSDLL.BO.Profile.Data.OrganizationDepartment businessObj)
        { 
            businessObj.DepartmentID = int.Parse(sqlCommand.Parameters["@DepartmentID"].Value.ToString()); 
        } 
 
        /*! Method to create parameters in order to add or edit a record. */
        public override void GetParamsPrimaryKey(ref System.Data.Common.DbCommand cmd, ProfilesRNSDLL.BO.Profile.Data.OrganizationDepartment bo) 
        { 
            AddParam(ref cmd, "@DepartmentID", bo.DepartmentID);
        } 
 
        internal ProfilesRNSDLL.BO.Profile.Data.OrganizationDepartment Get(int DepartmentID) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[Profile.Data].cg2_OrganizationDepartmentGet");
            AddParam(ref cmd, "@DepartmentID", DepartmentID);
            return PopulateFromRow(FillTable(cmd), 0); 
        } 
 
        /*! Method to create a OrganizationDepartment object from a row in a dataset. */
        public override ProfilesRNSDLL.BO.Profile.Data.OrganizationDepartment PopulateFromRow(System.Data.DataRow dr) 
        { 
            ProfilesRNSDLL.BO.Profile.Data.OrganizationDepartment bo = new ProfilesRNSDLL.BO.Profile.Data.OrganizationDepartment();
            bo.DepartmentID = int.Parse(dr["DepartmentID"].ToString()); 
            if(!dr.IsNull("DepartmentName"))
            { 
                 bo.DepartmentName = dr["DepartmentName"].ToString(); 
            } 
            if(!dr.IsNull("Visible"))
            { 
                 bo.Visible = bool.Parse(dr["Visible"].ToString()); 
            } 
            bo.Exists = true;
            return bo;
        } 
     
        /*! Method to get the business object before the datachange. */
        protected override ProfilesRNSDLL.BO.Profile.Data.OrganizationDepartment GetBOBefore(ProfilesRNSDLL.BO.Profile.Data.OrganizationDepartment businessObj)
        { 
            return this.Get(businessObj.DepartmentID);
        } 
 
        # endregion // internal Method 
 
    } 
 
} 
