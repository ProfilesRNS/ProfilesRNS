using System.Data.Common;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DAL.ORCID
{
    public partial class PersonOthername : DALGeneric<ProfilesRNSDLL.BO.ORCID.PersonOthername>
    { 
     
        # region Constructors 
    
        internal PersonOthername() : base() { } 
    
        # endregion // Constructors
     
        # region Methods 
 
        /*! Method to create parameters in order to add or edit a record. */
        public override void GetParamsAll(ref System.Data.Common.DbCommand cmd, ProfilesRNSDLL.BO.ORCID.PersonOthername bo) 
        { 
            DbParameter Parm = cmd.CreateParameter(); 
            Parm.ParameterName = "@PersonOthernameID";
            Parm.Size = 4;
            Parm.DbType = System.Data.DbType.Int32;
            if(!bo.PersonOthernameIDIsNull) {
                 Parm.Direction = System.Data.ParameterDirection.InputOutput; 
                 Parm.Value = bo.PersonOthernameID;
            } else { 
                 Parm.Direction = System.Data.ParameterDirection.Output; 
            }  
            cmd.Parameters.Add(Parm);
            AddParam(ref cmd, "@PersonID", bo.PersonID);
            if(!bo.OtherNameIsNull) {
                 AddParam(ref cmd, "@OtherName", bo.OtherName);
            } 
            if(!bo.PersonMessageIDIsNull) {
                 AddParam(ref cmd, "@PersonMessageID", bo.PersonMessageID);
            } 
        } 
 
        /*! Method to log changes to fields in a record. */
        public override void LogIfNecessary(DevelopmentBase.BaseClassBO.RecordLevelAuditTypes auditType, ProfilesRNSDLL.BO.ORCID.PersonOthername boBefore, ProfilesRNSDLL.BO.ORCID.PersonOthername bo, DbTransaction trans) 
        { 
            int recordLevelAuditTrailID = 0;
            if (auditType == DevelopmentBase.BaseClassBO.RecordLevelAuditTypes.Deleted)
            {
                recordLevelAuditTrailID = AddRecordLevelAuditTrail(bo.TableId, boBefore.PersonOthernameID, auditType, trans);
            }
            else
            {
                recordLevelAuditTrailID = AddRecordLevelAuditTrail(bo.TableId, bo.PersonOthernameID, auditType, trans);
            }
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.PersonOthername.FieldNames.PersonID, bo.PersonIDIsNull, boBefore.PersonIDIsNull, bo.PersonID, boBefore.PersonID, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.PersonOthername.FieldNames.OtherName, bo.OtherNameIsNull, boBefore.OtherNameIsNull, bo.OtherName, boBefore.OtherName, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.PersonOthername.FieldNames.PersonMessageID, bo.PersonMessageIDIsNull, boBefore.PersonMessageIDIsNull, bo.PersonMessageID, boBefore.PersonMessageID, trans);
        } 
 
        /*! Method to get the fields in the table in a select string. */
        internal static string GetSelectString() { return "SELECT TOP 100 PERCENT [ORCID.].[PersonOthername].[PersonOthernameID], [ORCID.].[PersonOthername].[PersonID], [ORCID.].[PersonOthername].[OtherName], [ORCID.].[PersonOthername].[PersonMessageID]"; } 
 
        /*! Method to get identity(s) of the newly added database record. */
        public override void GetIdentity(System.Data.Common.DbCommand sqlCommand, ProfilesRNSDLL.BO.ORCID.PersonOthername businessObj)
        { 
            businessObj.PersonOthernameID = int.Parse(sqlCommand.Parameters["@PersonOthernameID"].Value.ToString()); 
        } 
 
        /*! Method to create parameters in order to add or edit a record. */
        public override void GetParamsPrimaryKey(ref System.Data.Common.DbCommand cmd, ProfilesRNSDLL.BO.ORCID.PersonOthername bo) 
        { 
            AddParam(ref cmd, "@PersonOthernameID", bo.PersonOthernameID);
        } 
 
        internal ProfilesRNSDLL.BO.ORCID.PersonOthername Get(int PersonOthernameID) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[ORCID.].cg2_PersonOthernameGet");
            AddParam(ref cmd, "@PersonOthernameID", PersonOthernameID);
            return PopulateFromRow(FillTable(cmd), 0); 
        } 
 
        /*! Method to create a PersonOthername object from a row in a dataset. */
        public override ProfilesRNSDLL.BO.ORCID.PersonOthername PopulateFromRow(System.Data.DataRow dr) 
        { 
            ProfilesRNSDLL.BO.ORCID.PersonOthername bo = new ProfilesRNSDLL.BO.ORCID.PersonOthername();
            bo.PersonOthernameID = int.Parse(dr["PersonOthernameID"].ToString()); 
            bo.PersonID = int.Parse(dr["PersonID"].ToString()); 
            if(!dr.IsNull("OtherName"))
            { 
                 bo.OtherName = dr["OtherName"].ToString(); 
            } 
            if(!dr.IsNull("PersonMessageID"))
            { 
                 bo.PersonMessageID = int.Parse(dr["PersonMessageID"].ToString()); 
            } 
            bo.Exists = true;
            return bo;
        } 
     
        /*! Method to get the business object before the datachange. */
        protected override ProfilesRNSDLL.BO.ORCID.PersonOthername GetBOBefore(ProfilesRNSDLL.BO.ORCID.PersonOthername businessObj)
        { 
            return this.Get(businessObj.PersonOthernameID);
        } 
 
        # endregion // internal Method 
 
    } 
 
} 
