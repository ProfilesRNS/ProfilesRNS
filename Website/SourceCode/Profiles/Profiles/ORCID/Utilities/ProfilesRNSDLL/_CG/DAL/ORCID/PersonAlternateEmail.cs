using System.Collections.Generic;
using System.Data.Common;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DAL.ORCID
{
    public partial class PersonAlternateEmail : DALGeneric<ProfilesRNSDLL.BO.ORCID.PersonAlternateEmail>
    { 
     
        # region Constructors 
    
        internal PersonAlternateEmail() : base() { } 
    
        # endregion // Constructors
     
        # region Methods 
 
        /*! Method to create parameters in order to add or edit a record. */
        public override void GetParamsAll(ref System.Data.Common.DbCommand cmd, ProfilesRNSDLL.BO.ORCID.PersonAlternateEmail bo) 
        { 
            DbParameter Parm = cmd.CreateParameter(); 
            Parm.ParameterName = "@PersonAlternateEmailID";
            Parm.Size = 4;
            Parm.DbType = System.Data.DbType.Int32;
            if(!bo.PersonAlternateEmailIDIsNull) {
                 Parm.Direction = System.Data.ParameterDirection.InputOutput; 
                 Parm.Value = bo.PersonAlternateEmailID;
            } else { 
                 Parm.Direction = System.Data.ParameterDirection.Output; 
            }  
            cmd.Parameters.Add(Parm);
            AddParam(ref cmd, "@PersonID", bo.PersonID);
            AddParam(ref cmd, "@EmailAddress", bo.EmailAddress);
            if(!bo.PersonMessageIDIsNull) {
                 AddParam(ref cmd, "@PersonMessageID", bo.PersonMessageID);
            } 
        } 
 
        /*! Method to log changes to fields in a record. */
        public override void LogIfNecessary(DevelopmentBase.BaseClassBO.RecordLevelAuditTypes auditType, ProfilesRNSDLL.BO.ORCID.PersonAlternateEmail boBefore, ProfilesRNSDLL.BO.ORCID.PersonAlternateEmail bo, DbTransaction trans) 
        { 
            int recordLevelAuditTrailID = 0;
            if (auditType == DevelopmentBase.BaseClassBO.RecordLevelAuditTypes.Deleted)
            {
                recordLevelAuditTrailID = AddRecordLevelAuditTrail(bo.TableId, boBefore.PersonAlternateEmailID, auditType, trans);
            }
            else
            {
                recordLevelAuditTrailID = AddRecordLevelAuditTrail(bo.TableId, bo.PersonAlternateEmailID, auditType, trans);
            }
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.PersonAlternateEmail.FieldNames.PersonID, bo.PersonIDIsNull, boBefore.PersonIDIsNull, bo.PersonID, boBefore.PersonID, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.PersonAlternateEmail.FieldNames.EmailAddress, bo.EmailAddressIsNull, boBefore.EmailAddressIsNull, bo.EmailAddress, boBefore.EmailAddress, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.PersonAlternateEmail.FieldNames.PersonMessageID, bo.PersonMessageIDIsNull, boBefore.PersonMessageIDIsNull, bo.PersonMessageID, boBefore.PersonMessageID, trans);
        } 
 
        /*! Method to get the fields in the table in a select string. */
        internal static string GetSelectString() { return "SELECT TOP 100 PERCENT [ORCID.].[PersonAlternateEmail].[PersonAlternateEmailID], [ORCID.].[PersonAlternateEmail].[PersonID], [ORCID.].[PersonAlternateEmail].[EmailAddress], [ORCID.].[PersonAlternateEmail].[PersonMessageID]"; } 
 
        /*! Method to get identity(s) of the newly added database record. */
        public override void GetIdentity(System.Data.Common.DbCommand sqlCommand, ProfilesRNSDLL.BO.ORCID.PersonAlternateEmail businessObj)
        { 
            businessObj.PersonAlternateEmailID = int.Parse(sqlCommand.Parameters["@PersonAlternateEmailID"].Value.ToString()); 
        } 
 
        /*! Method to create parameters in order to add or edit a record. */
        public override void GetParamsPrimaryKey(ref System.Data.Common.DbCommand cmd, ProfilesRNSDLL.BO.ORCID.PersonAlternateEmail bo) 
        { 
            AddParam(ref cmd, "@PersonAlternateEmailID", bo.PersonAlternateEmailID);
        } 
 
        internal List<ProfilesRNSDLL.BO.ORCID.PersonAlternateEmail> GetByPersonID(int PersonID, bool addBlank) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[ORCID.].cg2_PersonAlternateEmailGetByPersonID");
            AddParam(ref cmd, "@PersonID", PersonID);
            return PopulateCollectionObject(FillTable(cmd), addBlank); 
        } 
        internal List<ProfilesRNSDLL.BO.ORCID.PersonAlternateEmail> GetByPersonMessageID(int PersonMessageID, bool addBlank) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[ORCID.].cg2_PersonAlternateEmailGetByPersonMessageID");
            AddParam(ref cmd, "@PersonMessageID", PersonMessageID);
            return PopulateCollectionObject(FillTable(cmd), addBlank); 
        } 
        internal ProfilesRNSDLL.BO.ORCID.PersonAlternateEmail Get(int PersonAlternateEmailID) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[ORCID.].cg2_PersonAlternateEmailGet");
            AddParam(ref cmd, "@PersonAlternateEmailID", PersonAlternateEmailID);
            return PopulateFromRow(FillTable(cmd), 0); 
        } 
 
        /*! Method to create a PersonAlternateEmail object from a row in a dataset. */
        public override ProfilesRNSDLL.BO.ORCID.PersonAlternateEmail PopulateFromRow(System.Data.DataRow dr) 
        { 
            ProfilesRNSDLL.BO.ORCID.PersonAlternateEmail bo = new ProfilesRNSDLL.BO.ORCID.PersonAlternateEmail();
            bo.PersonAlternateEmailID = int.Parse(dr["PersonAlternateEmailID"].ToString()); 
            bo.PersonID = int.Parse(dr["PersonID"].ToString()); 
            bo.EmailAddress = dr["EmailAddress"].ToString(); 
            if(!dr.IsNull("PersonMessageID"))
            { 
                 bo.PersonMessageID = int.Parse(dr["PersonMessageID"].ToString()); 
            } 
            bo.Exists = true;
            return bo;
        } 
     
        /*! Method to get the business object before the datachange. */
        protected override ProfilesRNSDLL.BO.ORCID.PersonAlternateEmail GetBOBefore(ProfilesRNSDLL.BO.ORCID.PersonAlternateEmail businessObj)
        { 
            return this.Get(businessObj.PersonAlternateEmailID);
        } 
 
        # endregion // internal Method 
 
    } 
 
} 
