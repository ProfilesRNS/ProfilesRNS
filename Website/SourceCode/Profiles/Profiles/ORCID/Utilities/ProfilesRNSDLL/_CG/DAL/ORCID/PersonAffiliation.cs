using System.Collections.Generic;
using System.Data.Common;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DAL.ORCID
{
    public partial class PersonAffiliation : DALGeneric<ProfilesRNSDLL.BO.ORCID.PersonAffiliation>
    { 
     
        # region Constructors 
    
        internal PersonAffiliation() : base() { } 
    
        # endregion // Constructors
     
        # region Methods 
 
        /*! Method to create parameters in order to add or edit a record. */
        public override void GetParamsAll(ref System.Data.Common.DbCommand cmd, ProfilesRNSDLL.BO.ORCID.PersonAffiliation bo) 
        { 
            DbParameter Parm = cmd.CreateParameter(); 
            Parm.ParameterName = "@PersonAffiliationID";
            Parm.Size = 4;
            Parm.DbType = System.Data.DbType.Int32;
            if(!bo.PersonAffiliationIDIsNull) {
                 Parm.Direction = System.Data.ParameterDirection.InputOutput; 
                 Parm.Value = bo.PersonAffiliationID;
            } else { 
                 Parm.Direction = System.Data.ParameterDirection.Output; 
            }  
            cmd.Parameters.Add(Parm);
            AddParam(ref cmd, "@ProfilesID", bo.ProfilesID);
            AddParam(ref cmd, "@AffiliationTypeID", bo.AffiliationTypeID);
            AddParam(ref cmd, "@PersonID", bo.PersonID);
            if(!bo.PersonMessageIDIsNull) {
                 AddParam(ref cmd, "@PersonMessageID", bo.PersonMessageID);
            } 
            AddParam(ref cmd, "@DecisionID", bo.DecisionID);
            if(!bo.DepartmentNameIsNull) {
                 AddParam(ref cmd, "@DepartmentName", bo.DepartmentName);
            } 
            if(!bo.RoleTitleIsNull) {
                 AddParam(ref cmd, "@RoleTitle", bo.RoleTitle);
            } 
            if(!bo.StartDateIsNull) {
                 AddParam(ref cmd, "@StartDate", bo.StartDate);
            } 
            if(!bo.EndDateIsNull) {
                 AddParam(ref cmd, "@EndDate", bo.EndDate);
            } 
            AddParam(ref cmd, "@OrganizationName", bo.OrganizationName);
            if(!bo.OrganizationCityIsNull) {
                 AddParam(ref cmd, "@OrganizationCity", bo.OrganizationCity);
            } 
            if(!bo.OrganizationRegionIsNull) {
                 AddParam(ref cmd, "@OrganizationRegion", bo.OrganizationRegion);
            } 
            if(!bo.OrganizationCountryIsNull) {
                 AddParam(ref cmd, "@OrganizationCountry", bo.OrganizationCountry);
            } 
            if(!bo.DisambiguationIDIsNull) {
                 AddParam(ref cmd, "@DisambiguationID", bo.DisambiguationID);
            } 
            if(!bo.DisambiguationSourceIsNull) {
                 AddParam(ref cmd, "@DisambiguationSource", bo.DisambiguationSource);
            } 
        } 
 
        /*! Method to log changes to fields in a record. */
        public override void LogIfNecessary(DevelopmentBase.BaseClassBO.RecordLevelAuditTypes auditType, ProfilesRNSDLL.BO.ORCID.PersonAffiliation boBefore, ProfilesRNSDLL.BO.ORCID.PersonAffiliation bo, DbTransaction trans) 
        { 
            int recordLevelAuditTrailID = 0;
            if (auditType == DevelopmentBase.BaseClassBO.RecordLevelAuditTypes.Deleted)
            {
                recordLevelAuditTrailID = AddRecordLevelAuditTrail(bo.TableId, boBefore.PersonAffiliationID, auditType, trans);
            }
            else
            {
                recordLevelAuditTrailID = AddRecordLevelAuditTrail(bo.TableId, bo.PersonAffiliationID, auditType, trans);
            }
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.PersonAffiliation.FieldNames.ProfilesID, bo.ProfilesIDIsNull, boBefore.ProfilesIDIsNull, bo.ProfilesID, boBefore.ProfilesID, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.PersonAffiliation.FieldNames.AffiliationTypeID, bo.AffiliationTypeIDIsNull, boBefore.AffiliationTypeIDIsNull, bo.AffiliationTypeID, boBefore.AffiliationTypeID, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.PersonAffiliation.FieldNames.PersonID, bo.PersonIDIsNull, boBefore.PersonIDIsNull, bo.PersonID, boBefore.PersonID, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.PersonAffiliation.FieldNames.PersonMessageID, bo.PersonMessageIDIsNull, boBefore.PersonMessageIDIsNull, bo.PersonMessageID, boBefore.PersonMessageID, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.PersonAffiliation.FieldNames.DecisionID, bo.DecisionIDIsNull, boBefore.DecisionIDIsNull, bo.DecisionID, boBefore.DecisionID, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.PersonAffiliation.FieldNames.DepartmentName, bo.DepartmentNameIsNull, boBefore.DepartmentNameIsNull, bo.DepartmentName, boBefore.DepartmentName, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.PersonAffiliation.FieldNames.RoleTitle, bo.RoleTitleIsNull, boBefore.RoleTitleIsNull, bo.RoleTitle, boBefore.RoleTitle, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.PersonAffiliation.FieldNames.StartDate, bo.StartDateIsNull, boBefore.StartDateIsNull, bo.StartDate, boBefore.StartDate, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.PersonAffiliation.FieldNames.EndDate, bo.EndDateIsNull, boBefore.EndDateIsNull, bo.EndDate, boBefore.EndDate, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.PersonAffiliation.FieldNames.OrganizationName, bo.OrganizationNameIsNull, boBefore.OrganizationNameIsNull, bo.OrganizationName, boBefore.OrganizationName, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.PersonAffiliation.FieldNames.OrganizationCity, bo.OrganizationCityIsNull, boBefore.OrganizationCityIsNull, bo.OrganizationCity, boBefore.OrganizationCity, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.PersonAffiliation.FieldNames.OrganizationRegion, bo.OrganizationRegionIsNull, boBefore.OrganizationRegionIsNull, bo.OrganizationRegion, boBefore.OrganizationRegion, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.PersonAffiliation.FieldNames.OrganizationCountry, bo.OrganizationCountryIsNull, boBefore.OrganizationCountryIsNull, bo.OrganizationCountry, boBefore.OrganizationCountry, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.PersonAffiliation.FieldNames.DisambiguationID, bo.DisambiguationIDIsNull, boBefore.DisambiguationIDIsNull, bo.DisambiguationID, boBefore.DisambiguationID, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.PersonAffiliation.FieldNames.DisambiguationSource, bo.DisambiguationSourceIsNull, boBefore.DisambiguationSourceIsNull, bo.DisambiguationSource, boBefore.DisambiguationSource, trans);
        } 
 
        /*! Method to get the fields in the table in a select string. */
        internal static string GetSelectString() { return "SELECT TOP 100 PERCENT [ORCID.].[PersonAffiliation].[PersonAffiliationID], [ORCID.].[PersonAffiliation].[ProfilesID], [ORCID.].[PersonAffiliation].[AffiliationTypeID], [ORCID.].[PersonAffiliation].[PersonID], [ORCID.].[PersonAffiliation].[PersonMessageID], [ORCID.].[PersonAffiliation].[DecisionID], [ORCID.].[PersonAffiliation].[DepartmentName], [ORCID.].[PersonAffiliation].[RoleTitle], [ORCID.].[PersonAffiliation].[StartDate], [ORCID.].[PersonAffiliation].[EndDate], [ORCID.].[PersonAffiliation].[OrganizationName], [ORCID.].[PersonAffiliation].[OrganizationCity], [ORCID.].[PersonAffiliation].[OrganizationRegion], [ORCID.].[PersonAffiliation].[OrganizationCountry], [ORCID.].[PersonAffiliation].[DisambiguationID], [ORCID.].[PersonAffiliation].[DisambiguationSource]"; } 
 
        /*! Method to get identity(s) of the newly added database record. */
        public override void GetIdentity(System.Data.Common.DbCommand sqlCommand, ProfilesRNSDLL.BO.ORCID.PersonAffiliation businessObj)
        { 
            businessObj.PersonAffiliationID = int.Parse(sqlCommand.Parameters["@PersonAffiliationID"].Value.ToString()); 
        } 
 
        /*! Method to create parameters in order to add or edit a record. */
        public override void GetParamsPrimaryKey(ref System.Data.Common.DbCommand cmd, ProfilesRNSDLL.BO.ORCID.PersonAffiliation bo) 
        { 
            AddParam(ref cmd, "@PersonAffiliationID", bo.PersonAffiliationID);
        } 
 
        internal List<ProfilesRNSDLL.BO.ORCID.PersonAffiliation> GetByDecisionID(int DecisionID, bool addBlank) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[ORCID.].cg2_PersonAffiliationGetByDecisionID");
            AddParam(ref cmd, "@DecisionID", DecisionID);
            return PopulateCollectionObject(FillTable(cmd), addBlank); 
        } 
        internal List<ProfilesRNSDLL.BO.ORCID.PersonAffiliation> GetByPersonID(int PersonID, bool addBlank) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[ORCID.].cg2_PersonAffiliationGetByPersonID");
            AddParam(ref cmd, "@PersonID", PersonID);
            return PopulateCollectionObject(FillTable(cmd), addBlank); 
        } 
        internal List<ProfilesRNSDLL.BO.ORCID.PersonAffiliation> GetByPersonMessageID(int PersonMessageID, bool addBlank) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[ORCID.].cg2_PersonAffiliationGetByPersonMessageID");
            AddParam(ref cmd, "@PersonMessageID", PersonMessageID);
            return PopulateCollectionObject(FillTable(cmd), addBlank); 
        } 
        internal ProfilesRNSDLL.BO.ORCID.PersonAffiliation GetByProfilesIDAndAffiliationTypeID(int ProfilesID, int AffiliationTypeID) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[ORCID.].cg2_PersonAffiliationGetByProfilesIDAndAffiliationTypeID");
            AddParam(ref cmd, "@ProfilesID", ProfilesID);
            AddParam(ref cmd, "@AffiliationTypeID", AffiliationTypeID);
            return PopulateFromRow(FillTable(cmd), 0); 
        } 
        internal ProfilesRNSDLL.BO.ORCID.PersonAffiliation Get(int PersonAffiliationID) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[ORCID.].cg2_PersonAffiliationGet");
            AddParam(ref cmd, "@PersonAffiliationID", PersonAffiliationID);
            return PopulateFromRow(FillTable(cmd), 0); 
        } 
 
        /*! Method to create a PersonAffiliation object from a row in a dataset. */
        public override ProfilesRNSDLL.BO.ORCID.PersonAffiliation PopulateFromRow(System.Data.DataRow dr) 
        { 
            ProfilesRNSDLL.BO.ORCID.PersonAffiliation bo = new ProfilesRNSDLL.BO.ORCID.PersonAffiliation();
            bo.PersonAffiliationID = int.Parse(dr["PersonAffiliationID"].ToString()); 
            bo.ProfilesID = int.Parse(dr["ProfilesID"].ToString()); 
            bo.AffiliationTypeID = int.Parse(dr["AffiliationTypeID"].ToString()); 
            bo.PersonID = int.Parse(dr["PersonID"].ToString()); 
            if(!dr.IsNull("PersonMessageID"))
            { 
                 bo.PersonMessageID = int.Parse(dr["PersonMessageID"].ToString()); 
            } 
            bo.DecisionID = int.Parse(dr["DecisionID"].ToString()); 
            if(!dr.IsNull("DepartmentName"))
            { 
                 bo.DepartmentName = dr["DepartmentName"].ToString(); 
            } 
            if(!dr.IsNull("RoleTitle"))
            { 
                 bo.RoleTitle = dr["RoleTitle"].ToString(); 
            } 
            if(!dr.IsNull("StartDate"))
            { 
                 bo.StartDate = System.DateTime.Parse(dr["StartDate"].ToString()); 
            } 
            if(!dr.IsNull("EndDate"))
            { 
                 bo.EndDate = System.DateTime.Parse(dr["EndDate"].ToString()); 
            } 
            bo.OrganizationName = dr["OrganizationName"].ToString(); 
            if(!dr.IsNull("OrganizationCity"))
            { 
                 bo.OrganizationCity = dr["OrganizationCity"].ToString(); 
            } 
            if(!dr.IsNull("OrganizationRegion"))
            { 
                 bo.OrganizationRegion = dr["OrganizationRegion"].ToString(); 
            } 
            if(!dr.IsNull("OrganizationCountry"))
            { 
                 bo.OrganizationCountry = dr["OrganizationCountry"].ToString(); 
            } 
            if(!dr.IsNull("DisambiguationID"))
            { 
                 bo.DisambiguationID = dr["DisambiguationID"].ToString(); 
            } 
            if(!dr.IsNull("DisambiguationSource"))
            { 
                 bo.DisambiguationSource = dr["DisambiguationSource"].ToString(); 
            } 
            bo.Exists = true;
            return bo;
        } 
     
        /*! Method to get the business object before the datachange. */
        protected override ProfilesRNSDLL.BO.ORCID.PersonAffiliation GetBOBefore(ProfilesRNSDLL.BO.ORCID.PersonAffiliation businessObj)
        { 
            return this.Get(businessObj.PersonAffiliationID);
        } 
 
        # endregion // internal Method 
 
    } 
 
} 
