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
    public partial class Person : DALGeneric<ProfilesRNSDLL.BO.ORCID.Person>
    { 
     
        # region Constructors 
    
        internal Person() : base() { } 
    
        # endregion // Constructors
     
        # region Methods 
 
        /*! Method to create parameters in order to add or edit a record. */
        public override void GetParamsAll(ref System.Data.Common.DbCommand cmd, ProfilesRNSDLL.BO.ORCID.Person bo) 
        { 
            DbParameter Parm = cmd.CreateParameter(); 
            Parm.ParameterName = "@PersonID";
            Parm.Size = 4;
            Parm.DbType = System.Data.DbType.Int32;
            if(!bo.PersonIDIsNull) {
                 Parm.Direction = System.Data.ParameterDirection.InputOutput; 
                 Parm.Value = bo.PersonID;
            } else { 
                 Parm.Direction = System.Data.ParameterDirection.Output; 
            }  
            cmd.Parameters.Add(Parm);
            AddParam(ref cmd, "@InternalUsername", bo.InternalUsername);
            AddParam(ref cmd, "@PersonStatusTypeID", bo.PersonStatusTypeID);
            AddParam(ref cmd, "@CreateUnlessOptOut", bo.CreateUnlessOptOut);
            if(!bo.ORCIDIsNull) {
                 AddParam(ref cmd, "@ORCID", bo.ORCID);
            } 
            if(!bo.ORCIDRecordedIsNull) {
                 AddParam(ref cmd, "@ORCIDRecorded", bo.ORCIDRecorded);
            } 
            if(!bo.FirstNameIsNull) {
                 AddParam(ref cmd, "@FirstName", bo.FirstName);
            } 
            if(!bo.LastNameIsNull) {
                 AddParam(ref cmd, "@LastName", bo.LastName);
            } 
            if(!bo.PublishedNameIsNull) {
                 AddParam(ref cmd, "@PublishedName", bo.PublishedName);
            } 
            if(!bo.EmailDecisionIDIsNull) {
                 AddParam(ref cmd, "@EmailDecisionID", bo.EmailDecisionID);
            } 
            if(!bo.EmailAddressIsNull) {
                 AddParam(ref cmd, "@EmailAddress", bo.EmailAddress);
            } 
            if(!bo.AlternateEmailDecisionIDIsNull) {
                 AddParam(ref cmd, "@AlternateEmailDecisionID", bo.AlternateEmailDecisionID);
            } 
            if(!bo.AgreementAcknowledgedIsNull) {
                 AddParam(ref cmd, "@AgreementAcknowledged", bo.AgreementAcknowledged);
            } 
            if(!bo.BiographyIsNull) {
                 AddParam(ref cmd, "@Biography", bo.Biography);
            } 
            if(!bo.BiographyDecisionIDIsNull) {
                 AddParam(ref cmd, "@BiographyDecisionID", bo.BiographyDecisionID);
            } 
        } 
 
        /*! Method to log changes to fields in a record. */
        public override void LogIfNecessary(DevelopmentBase.BaseClassBO.RecordLevelAuditTypes auditType, ProfilesRNSDLL.BO.ORCID.Person boBefore, ProfilesRNSDLL.BO.ORCID.Person bo, DbTransaction trans) 
        { 
            int recordLevelAuditTrailID = 0;
            if (auditType == DevelopmentBase.BaseClassBO.RecordLevelAuditTypes.Deleted)
            {
                recordLevelAuditTrailID = AddRecordLevelAuditTrail(bo.TableId, boBefore.PersonID, auditType, trans);
            }
            else
            {
                recordLevelAuditTrailID = AddRecordLevelAuditTrail(bo.TableId, bo.PersonID, auditType, trans);
            }
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.Person.FieldNames.InternalUsername, bo.InternalUsernameIsNull, boBefore.InternalUsernameIsNull, bo.InternalUsername, boBefore.InternalUsername, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.Person.FieldNames.PersonStatusTypeID, bo.PersonStatusTypeIDIsNull, boBefore.PersonStatusTypeIDIsNull, bo.PersonStatusTypeID, boBefore.PersonStatusTypeID, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.Person.FieldNames.CreateUnlessOptOut, bo.CreateUnlessOptOutIsNull, boBefore.CreateUnlessOptOutIsNull, bo.CreateUnlessOptOut, boBefore.CreateUnlessOptOut, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.Person.FieldNames.ORCID, bo.ORCIDIsNull, boBefore.ORCIDIsNull, bo.ORCID, boBefore.ORCID, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.Person.FieldNames.ORCIDRecorded, bo.ORCIDRecordedIsNull, boBefore.ORCIDRecordedIsNull, bo.ORCIDRecorded, boBefore.ORCIDRecorded, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.Person.FieldNames.FirstName, bo.FirstNameIsNull, boBefore.FirstNameIsNull, bo.FirstName, boBefore.FirstName, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.Person.FieldNames.LastName, bo.LastNameIsNull, boBefore.LastNameIsNull, bo.LastName, boBefore.LastName, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.Person.FieldNames.PublishedName, bo.PublishedNameIsNull, boBefore.PublishedNameIsNull, bo.PublishedName, boBefore.PublishedName, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.Person.FieldNames.EmailDecisionID, bo.EmailDecisionIDIsNull, boBefore.EmailDecisionIDIsNull, bo.EmailDecisionID, boBefore.EmailDecisionID, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.Person.FieldNames.EmailAddress, bo.EmailAddressIsNull, boBefore.EmailAddressIsNull, bo.EmailAddress, boBefore.EmailAddress, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.Person.FieldNames.AlternateEmailDecisionID, bo.AlternateEmailDecisionIDIsNull, boBefore.AlternateEmailDecisionIDIsNull, bo.AlternateEmailDecisionID, boBefore.AlternateEmailDecisionID, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.Person.FieldNames.AgreementAcknowledged, bo.AgreementAcknowledgedIsNull, boBefore.AgreementAcknowledgedIsNull, bo.AgreementAcknowledged, boBefore.AgreementAcknowledged, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.Person.FieldNames.Biography, bo.BiographyIsNull, boBefore.BiographyIsNull, bo.Biography, boBefore.Biography, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.Person.FieldNames.BiographyDecisionID, bo.BiographyDecisionIDIsNull, boBefore.BiographyDecisionIDIsNull, bo.BiographyDecisionID, boBefore.BiographyDecisionID, trans);
        } 
 
        /*! Method to get the fields in the table in a select string. */
        internal static string GetSelectString() { return "SELECT TOP 100 PERCENT [ORCID.].[Person].[PersonID], [ORCID.].[Person].[InternalUsername], [ORCID.].[Person].[PersonStatusTypeID], [ORCID.].[Person].[CreateUnlessOptOut], [ORCID.].[Person].[ORCID.], [ORCID.].[Person].[ORCIDRecorded], [ORCID.].[Person].[FirstName], [ORCID.].[Person].[LastName], [ORCID.].[Person].[PublishedName], [ORCID.].[Person].[EmailDecisionID], [ORCID.].[Person].[EmailAddress], [ORCID.].[Person].[AlternateEmailDecisionID], [ORCID.].[Person].[AgreementAcknowledged], [ORCID.].[Person].[Biography], [ORCID.].[Person].[BiographyDecisionID]"; } 
 
        /*! Method to get identity(s) of the newly added database record. */
        public override void GetIdentity(System.Data.Common.DbCommand sqlCommand, ProfilesRNSDLL.BO.ORCID.Person businessObj)
        { 
            businessObj.PersonID = int.Parse(sqlCommand.Parameters["@PersonID"].Value.ToString()); 
        } 
 
        /*! Method to create parameters in order to add or edit a record. */
        public override void GetParamsPrimaryKey(ref System.Data.Common.DbCommand cmd, ProfilesRNSDLL.BO.ORCID.Person bo) 
        { 
            AddParam(ref cmd, "@PersonID", bo.PersonID);
        } 
 
        internal List<ProfilesRNSDLL.BO.ORCID.Person> GetByCreateUnlessOptOut(bool CreateUnlessOptOut, bool addBlank) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[ORCID.].cg2_PersonGetByCreateUnlessOptOut");
            AddParam(ref cmd, "@CreateUnlessOptOut", CreateUnlessOptOut);
            return PopulateCollectionObject(FillTable(cmd), addBlank); 
        } 
        internal ProfilesRNSDLL.BO.ORCID.Person GetByInternalUsername(string InternalUsername) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[ORCID.].cg2_PersonGetByInternalUsername");
            AddParam(ref cmd, "@InternalUsername", InternalUsername);
            return PopulateFromRow(FillTable(cmd), 0); 
        } 
        internal List<ProfilesRNSDLL.BO.ORCID.Person> GetByORCID(string ORCID, bool addBlank) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[ORCID.].cg2_PersonGetByORCID");
            AddParam(ref cmd, "@ORCID", ORCID);
            return PopulateCollectionObject(FillTable(cmd), addBlank); 
        } 
        internal List<ProfilesRNSDLL.BO.ORCID.Person> GetByPersonStatusTypeID(int PersonStatusTypeID, bool addBlank) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[ORCID.].cg2_PersonGetByPersonStatusTypeID");
            AddParam(ref cmd, "@PersonStatusTypeID", PersonStatusTypeID);
            return PopulateCollectionObject(FillTable(cmd), addBlank); 
        } 
        internal ProfilesRNSDLL.BO.ORCID.Person Get(int PersonID) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[ORCID.].cg2_PersonGet");
            AddParam(ref cmd, "@PersonID", PersonID);
            return PopulateFromRow(FillTable(cmd), 0); 
        } 
 
        /*! Method to create a Person object from a row in a dataset. */
        public override ProfilesRNSDLL.BO.ORCID.Person PopulateFromRow(System.Data.DataRow dr) 
        { 
            ProfilesRNSDLL.BO.ORCID.Person bo = new ProfilesRNSDLL.BO.ORCID.Person();
            bo.PersonID = int.Parse(dr["PersonID"].ToString()); 
            bo.InternalUsername = dr["InternalUsername"].ToString(); 
            bo.PersonStatusTypeID = int.Parse(dr["PersonStatusTypeID"].ToString()); 
            bo.CreateUnlessOptOut = bool.Parse(dr["CreateUnlessOptOut"].ToString()); 
            if(!dr.IsNull("ORCID"))
            { 
                 bo.ORCID = dr["ORCID"].ToString(); 
            } 
            if(!dr.IsNull("ORCIDRecorded"))
            { 
                 bo.ORCIDRecorded = System.DateTime.Parse(dr["ORCIDRecorded"].ToString()); 
            } 
            if(!dr.IsNull("FirstName"))
            { 
                 bo.FirstName = dr["FirstName"].ToString(); 
            } 
            if(!dr.IsNull("LastName"))
            { 
                 bo.LastName = dr["LastName"].ToString(); 
            } 
            if(!dr.IsNull("PublishedName"))
            { 
                 bo.PublishedName = dr["PublishedName"].ToString(); 
            } 
            if(!dr.IsNull("EmailDecisionID"))
            { 
                 bo.EmailDecisionID = int.Parse(dr["EmailDecisionID"].ToString()); 
            } 
            if(!dr.IsNull("EmailAddress"))
            { 
                 bo.EmailAddress = dr["EmailAddress"].ToString(); 
            } 
            if(!dr.IsNull("AlternateEmailDecisionID"))
            { 
                 bo.AlternateEmailDecisionID = int.Parse(dr["AlternateEmailDecisionID"].ToString()); 
            } 
            if(!dr.IsNull("AgreementAcknowledged"))
            { 
                 bo.AgreementAcknowledged = bool.Parse(dr["AgreementAcknowledged"].ToString()); 
            } 
            if(!dr.IsNull("Biography"))
            { 
                 bo.Biography = dr["Biography"].ToString(); 
            } 
            if(!dr.IsNull("BiographyDecisionID"))
            { 
                 bo.BiographyDecisionID = int.Parse(dr["BiographyDecisionID"].ToString()); 
            } 
            bo.Exists = true;
            return bo;
        } 
     
        /*! Method to get the business object before the datachange. */
        protected override ProfilesRNSDLL.BO.ORCID.Person GetBOBefore(ProfilesRNSDLL.BO.ORCID.Person businessObj)
        { 
            return this.Get(businessObj.PersonID);
        } 
 
        # endregion // internal Method 
 
    } 
 
} 
