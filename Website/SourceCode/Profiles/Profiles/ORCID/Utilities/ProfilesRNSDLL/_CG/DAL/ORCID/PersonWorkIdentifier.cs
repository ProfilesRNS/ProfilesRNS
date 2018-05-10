using System.Collections.Generic;
using System.Data.Common;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DAL.ORCID
{
    public partial class PersonWorkIdentifier : DALGeneric<ProfilesRNSDLL.BO.ORCID.PersonWorkIdentifier>
    { 
     
        # region Constructors 
    
        internal PersonWorkIdentifier() : base() { } 
    
        # endregion // Constructors
     
        # region Methods 
 
        /*! Method to create parameters in order to add or edit a record. */
        public override void GetParamsAll(ref System.Data.Common.DbCommand cmd, ProfilesRNSDLL.BO.ORCID.PersonWorkIdentifier bo) 
        { 
            DbParameter Parm = cmd.CreateParameter(); 
            Parm.ParameterName = "@PersonWorkIdentifierID";
            Parm.Size = 4;
            Parm.DbType = System.Data.DbType.Int32;
            if(!bo.PersonWorkIdentifierIDIsNull) {
                 Parm.Direction = System.Data.ParameterDirection.InputOutput; 
                 Parm.Value = bo.PersonWorkIdentifierID;
            } else { 
                 Parm.Direction = System.Data.ParameterDirection.Output; 
            }  
            cmd.Parameters.Add(Parm);
            AddParam(ref cmd, "@PersonWorkID", bo.PersonWorkID);
            AddParam(ref cmd, "@WorkExternalTypeID", bo.WorkExternalTypeID);
            AddParam(ref cmd, "@Identifier", bo.Identifier);
        } 
 
        /*! Method to log changes to fields in a record. */
        public override void LogIfNecessary(DevelopmentBase.BaseClassBO.RecordLevelAuditTypes auditType, ProfilesRNSDLL.BO.ORCID.PersonWorkIdentifier boBefore, ProfilesRNSDLL.BO.ORCID.PersonWorkIdentifier bo, DbTransaction trans) 
        { 
            int recordLevelAuditTrailID = 0;
            if (auditType == DevelopmentBase.BaseClassBO.RecordLevelAuditTypes.Deleted)
            {
                recordLevelAuditTrailID = AddRecordLevelAuditTrail(bo.TableId, boBefore.PersonWorkIdentifierID, auditType, trans);
            }
            else
            {
                recordLevelAuditTrailID = AddRecordLevelAuditTrail(bo.TableId, bo.PersonWorkIdentifierID, auditType, trans);
            }
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.PersonWorkIdentifier.FieldNames.PersonWorkID, bo.PersonWorkIDIsNull, boBefore.PersonWorkIDIsNull, bo.PersonWorkID, boBefore.PersonWorkID, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.PersonWorkIdentifier.FieldNames.WorkExternalTypeID, bo.WorkExternalTypeIDIsNull, boBefore.WorkExternalTypeIDIsNull, bo.WorkExternalTypeID, boBefore.WorkExternalTypeID, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.PersonWorkIdentifier.FieldNames.Identifier, bo.IdentifierIsNull, boBefore.IdentifierIsNull, bo.Identifier, boBefore.Identifier, trans);
        } 
 
        /*! Method to get the fields in the table in a select string. */
        internal static string GetSelectString() { return "SELECT TOP 100 PERCENT [ORCID.].[PersonWorkIdentifier].[PersonWorkIdentifierID], [ORCID.].[PersonWorkIdentifier].[PersonWorkID], [ORCID.].[PersonWorkIdentifier].[WorkExternalTypeID], [ORCID.].[PersonWorkIdentifier].[Identifier]"; } 
 
        /*! Method to get identity(s) of the newly added database record. */
        public override void GetIdentity(System.Data.Common.DbCommand sqlCommand, ProfilesRNSDLL.BO.ORCID.PersonWorkIdentifier businessObj)
        { 
            businessObj.PersonWorkIdentifierID = int.Parse(sqlCommand.Parameters["@PersonWorkIdentifierID"].Value.ToString()); 
        } 
 
        /*! Method to create parameters in order to add or edit a record. */
        public override void GetParamsPrimaryKey(ref System.Data.Common.DbCommand cmd, ProfilesRNSDLL.BO.ORCID.PersonWorkIdentifier bo) 
        { 
            AddParam(ref cmd, "@PersonWorkIdentifierID", bo.PersonWorkIdentifierID);
        } 
 
        internal List<ProfilesRNSDLL.BO.ORCID.PersonWorkIdentifier> GetByPersonWorkID(int PersonWorkID, bool addBlank) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[ORCID.].cg2_PersonWorkIdentifierGetByPersonWorkID");
            AddParam(ref cmd, "@PersonWorkID", PersonWorkID);
            return PopulateCollectionObject(FillTable(cmd), addBlank); 
        } 
        internal List<ProfilesRNSDLL.BO.ORCID.PersonWorkIdentifier> GetByWorkExternalTypeID(int WorkExternalTypeID, bool addBlank) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[ORCID.].cg2_PersonWorkIdentifierGetByWorkExternalTypeID");
            AddParam(ref cmd, "@WorkExternalTypeID", WorkExternalTypeID);
            return PopulateCollectionObject(FillTable(cmd), addBlank); 
        } 
        internal ProfilesRNSDLL.BO.ORCID.PersonWorkIdentifier GetByPersonWorkIDAndWorkExternalTypeIDAndIdentifier(int PersonWorkID, int WorkExternalTypeID, string Identifier) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[ORCID.].cg2_PersonWorkIdentifierGetByPersonWorkIDAndWorkExternalTypeIDAndIdentifier");
            AddParam(ref cmd, "@PersonWorkID", PersonWorkID);
            AddParam(ref cmd, "@WorkExternalTypeID", WorkExternalTypeID);
            AddParam(ref cmd, "@Identifier", Identifier);
            return PopulateFromRow(FillTable(cmd), 0); 
        } 
        internal ProfilesRNSDLL.BO.ORCID.PersonWorkIdentifier Get(int PersonWorkIdentifierID) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[ORCID.].cg2_PersonWorkIdentifierGet");
            AddParam(ref cmd, "@PersonWorkIdentifierID", PersonWorkIdentifierID);
            return PopulateFromRow(FillTable(cmd), 0); 
        } 
 
        /*! Method to create a PersonWorkIdentifier object from a row in a dataset. */
        public override ProfilesRNSDLL.BO.ORCID.PersonWorkIdentifier PopulateFromRow(System.Data.DataRow dr) 
        { 
            ProfilesRNSDLL.BO.ORCID.PersonWorkIdentifier bo = new ProfilesRNSDLL.BO.ORCID.PersonWorkIdentifier();
            bo.PersonWorkIdentifierID = int.Parse(dr["PersonWorkIdentifierID"].ToString()); 
            bo.PersonWorkID = int.Parse(dr["PersonWorkID"].ToString()); 
            bo.WorkExternalTypeID = int.Parse(dr["WorkExternalTypeID"].ToString()); 
            bo.Identifier = dr["Identifier"].ToString(); 
            bo.Exists = true;
            return bo;
        } 
     
        /*! Method to get the business object before the datachange. */
        protected override ProfilesRNSDLL.BO.ORCID.PersonWorkIdentifier GetBOBefore(ProfilesRNSDLL.BO.ORCID.PersonWorkIdentifier businessObj)
        { 
            return this.Get(businessObj.PersonWorkIdentifierID);
        } 
 
        # endregion // internal Method 
 
    } 
 
} 
