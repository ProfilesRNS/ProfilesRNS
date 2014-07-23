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
    public partial class OrganizationInstitution : DALGeneric<ProfilesRNSDLL.BO.Profile.Data.OrganizationInstitution>
    { 
     
        # region Constructors 
    
        internal OrganizationInstitution() : base() { } 
    
        # endregion // Constructors
     
        # region Methods 
 
        /*! Method to create parameters in order to add or edit a record. */
        public override void GetParamsAll(ref System.Data.Common.DbCommand cmd, ProfilesRNSDLL.BO.Profile.Data.OrganizationInstitution bo) 
        { 
            DbParameter Parm = cmd.CreateParameter(); 
            Parm.ParameterName = "@InstitutionID";
            Parm.Size = 4;
            Parm.DbType = System.Data.DbType.Int32;
            if(!bo.InstitutionIDIsNull) {
                 Parm.Direction = System.Data.ParameterDirection.InputOutput; 
                 Parm.Value = bo.InstitutionID;
            } else { 
                 Parm.Direction = System.Data.ParameterDirection.Output; 
            }  
            cmd.Parameters.Add(Parm);
            if(!bo.InstitutionNameIsNull) {
                 AddParam(ref cmd, "@InstitutionName", bo.InstitutionName);
            } 
            if(!bo.InstitutionAbbreviationIsNull) {
                 AddParam(ref cmd, "@InstitutionAbbreviation", bo.InstitutionAbbreviation);
            } 
/*            if(!bo.CityIsNull) {
                 AddParam(ref cmd, "@City", bo.City);
            } 
            if(!bo.StateIsNull) {
                 AddParam(ref cmd, "@State", bo.State);
            } 
            if(!bo.CountryIsNull) {
                 AddParam(ref cmd, "@Country", bo.Country);
            } 
            if(!bo.RingGoldIDIsNull) {
                 AddParam(ref cmd, "@RingGoldID", bo.RingGoldID);
            } 
  */      } 
 
        /*! Method to log changes to fields in a record. */
        public override void LogIfNecessary(DevelopmentBase.BaseClassBO.RecordLevelAuditTypes auditType, ProfilesRNSDLL.BO.Profile.Data.OrganizationInstitution boBefore, ProfilesRNSDLL.BO.Profile.Data.OrganizationInstitution bo, DbTransaction trans) 
        { 
            int recordLevelAuditTrailID = 0;
            if (auditType == DevelopmentBase.BaseClassBO.RecordLevelAuditTypes.Deleted)
            {
                recordLevelAuditTrailID = AddRecordLevelAuditTrail(bo.TableId, boBefore.InstitutionID, auditType, trans);
            }
            else
            {
                recordLevelAuditTrailID = AddRecordLevelAuditTrail(bo.TableId, bo.InstitutionID, auditType, trans);
            }
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Data.OrganizationInstitution.FieldNames.InstitutionName, bo.InstitutionNameIsNull, boBefore.InstitutionNameIsNull, bo.InstitutionName, boBefore.InstitutionName, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Data.OrganizationInstitution.FieldNames.InstitutionAbbreviation, bo.InstitutionAbbreviationIsNull, boBefore.InstitutionAbbreviationIsNull, bo.InstitutionAbbreviation, boBefore.InstitutionAbbreviation, trans);
 /*           LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Data.OrganizationInstitution.FieldNames.City, bo.CityIsNull, boBefore.CityIsNull, bo.City, boBefore.City, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Data.OrganizationInstitution.FieldNames.State, bo.StateIsNull, boBefore.StateIsNull, bo.State, boBefore.State, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Data.OrganizationInstitution.FieldNames.Country, bo.CountryIsNull, boBefore.CountryIsNull, bo.Country, boBefore.Country, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Data.OrganizationInstitution.FieldNames.RingGoldID, bo.RingGoldIDIsNull, boBefore.RingGoldIDIsNull, bo.RingGoldID, boBefore.RingGoldID, trans);
   */     } 
 
        /*! Method to get the fields in the table in a select string. */
        internal static string GetSelectString() { return "SELECT TOP 100 PERCENT [Profile.Data].[Organization.Institution].[InstitutionID], [Profile.Data].[Organization.Institution].[InstitutionName], [Profile.Data].[Organization.Institution].[InstitutionAbbreviation], [Profile.Data].[Organization.Institution].[City], [Profile.Data].[Organization.Institution].[State], [Profile.Data].[Organization.Institution].[Country], [Profile.Data].[Organization.Institution].[RingGoldID]"; } 
 
        /*! Method to get identity(s) of the newly added database record. */
        public override void GetIdentity(System.Data.Common.DbCommand sqlCommand, ProfilesRNSDLL.BO.Profile.Data.OrganizationInstitution businessObj)
        { 
            businessObj.InstitutionID = int.Parse(sqlCommand.Parameters["@InstitutionID"].Value.ToString()); 
        } 
 
        /*! Method to create parameters in order to add or edit a record. */
        public override void GetParamsPrimaryKey(ref System.Data.Common.DbCommand cmd, ProfilesRNSDLL.BO.Profile.Data.OrganizationInstitution bo) 
        { 
            AddParam(ref cmd, "@InstitutionID", bo.InstitutionID);
        } 
 
        internal ProfilesRNSDLL.BO.Profile.Data.OrganizationInstitution Get(int InstitutionID) 
        { 
//            System.Data.Common.DbCommand cmd = GetCommand("[Profile.Data].cg2_OrganizationInstitutionGet");
//            AddParam(ref cmd, "@InstitutionID", InstitutionID);
            System.Data.Common.DbCommand cmd = GetCommand("sp_executesql");
            AddParam(ref cmd, "@stmt", "select [InstitutionID],[InstitutionName],[InstitutionAbbreviation] from [Profile.Data].[Organization.Institution] where [InstitutionID] = " + InstitutionID);

            return PopulateFromRow(FillTable(cmd), 0); 
        } 
 
        /*! Method to create a OrganizationInstitution object from a row in a dataset. */
        public override ProfilesRNSDLL.BO.Profile.Data.OrganizationInstitution PopulateFromRow(System.Data.DataRow dr) 
        { 
            ProfilesRNSDLL.BO.Profile.Data.OrganizationInstitution bo = new ProfilesRNSDLL.BO.Profile.Data.OrganizationInstitution();
            bo.InstitutionID = int.Parse(dr["InstitutionID"].ToString()); 
            if(!dr.IsNull("InstitutionName"))
            { 
                 bo.InstitutionName = dr["InstitutionName"].ToString(); 
            } 
            if(!dr.IsNull("InstitutionAbbreviation"))
            { 
                 bo.InstitutionAbbreviation = dr["InstitutionAbbreviation"].ToString(); 
            } 
 /*           if(!dr.IsNull("City"))
            { 
                 bo.City = dr["City"].ToString(); 
            } 
            if(!dr.IsNull("State"))
            { 
                 bo.State = dr["State"].ToString(); 
            } 
            if(!dr.IsNull("Country"))
            { 
                 bo.Country = dr["Country"].ToString(); 
            } 
            if(!dr.IsNull("RingGoldID"))
            { 
                 bo.RingGoldID = dr["RingGoldID"].ToString(); 
            } 
   */         bo.Exists = true;
            return bo;
        } 
     
        /*! Method to get the business object before the datachange. */
        protected override ProfilesRNSDLL.BO.Profile.Data.OrganizationInstitution GetBOBefore(ProfilesRNSDLL.BO.Profile.Data.OrganizationInstitution businessObj)
        { 
            return this.Get(businessObj.InstitutionID);
        } 
 
        # endregion // internal Method 
 
    } 
 
} 
