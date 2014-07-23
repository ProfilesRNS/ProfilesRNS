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
    public partial class PersonURL : DALGeneric<ProfilesRNSDLL.BO.ORCID.PersonURL>
    { 
     
        # region Constructors 
    
        internal PersonURL() : base() { } 
    
        # endregion // Constructors
     
        # region Methods 
 
        /*! Method to create parameters in order to add or edit a record. */
        public override void GetParamsAll(ref System.Data.Common.DbCommand cmd, ProfilesRNSDLL.BO.ORCID.PersonURL bo) 
        { 
            DbParameter Parm = cmd.CreateParameter(); 
            Parm.ParameterName = "@PersonURLID";
            Parm.Size = 4;
            Parm.DbType = System.Data.DbType.Int32;
            if(!bo.PersonURLIDIsNull) {
                 Parm.Direction = System.Data.ParameterDirection.InputOutput; 
                 Parm.Value = bo.PersonURLID;
            } else { 
                 Parm.Direction = System.Data.ParameterDirection.Output; 
            }  
            cmd.Parameters.Add(Parm);
            AddParam(ref cmd, "@PersonID", bo.PersonID);
            if(!bo.PersonMessageIDIsNull) {
                 AddParam(ref cmd, "@PersonMessageID", bo.PersonMessageID);
            } 
            if(!bo.URLNameIsNull) {
                 AddParam(ref cmd, "@URLName", bo.URLName);
            } 
            AddParam(ref cmd, "@URL", bo.URL);
            AddParam(ref cmd, "@DecisionID", bo.DecisionID);
        } 
 
        /*! Method to log changes to fields in a record. */
        public override void LogIfNecessary(DevelopmentBase.BaseClassBO.RecordLevelAuditTypes auditType, ProfilesRNSDLL.BO.ORCID.PersonURL boBefore, ProfilesRNSDLL.BO.ORCID.PersonURL bo, DbTransaction trans) 
        { 
            int recordLevelAuditTrailID = 0;
            if (auditType == DevelopmentBase.BaseClassBO.RecordLevelAuditTypes.Deleted)
            {
                recordLevelAuditTrailID = AddRecordLevelAuditTrail(bo.TableId, boBefore.PersonURLID, auditType, trans);
            }
            else
            {
                recordLevelAuditTrailID = AddRecordLevelAuditTrail(bo.TableId, bo.PersonURLID, auditType, trans);
            }
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.PersonURL.FieldNames.PersonID, bo.PersonIDIsNull, boBefore.PersonIDIsNull, bo.PersonID, boBefore.PersonID, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.PersonURL.FieldNames.PersonMessageID, bo.PersonMessageIDIsNull, boBefore.PersonMessageIDIsNull, bo.PersonMessageID, boBefore.PersonMessageID, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.PersonURL.FieldNames.URLName, bo.URLNameIsNull, boBefore.URLNameIsNull, bo.URLName, boBefore.URLName, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.PersonURL.FieldNames.URL, bo.URLIsNull, boBefore.URLIsNull, bo.URL, boBefore.URL, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.PersonURL.FieldNames.DecisionID, bo.DecisionIDIsNull, boBefore.DecisionIDIsNull, bo.DecisionID, boBefore.DecisionID, trans);
        } 
 
        /*! Method to get the fields in the table in a select string. */
        internal static string GetSelectString() { return "SELECT TOP 100 PERCENT [ORCID.].[PersonURL].[PersonURLID], [ORCID.].[PersonURL].[PersonID], [ORCID.].[PersonURL].[PersonMessageID], [ORCID.].[PersonURL].[URLName], [ORCID.].[PersonURL].[URL], [ORCID.].[PersonURL].[DecisionID]"; } 
 
        /*! Method to get identity(s) of the newly added database record. */
        public override void GetIdentity(System.Data.Common.DbCommand sqlCommand, ProfilesRNSDLL.BO.ORCID.PersonURL businessObj)
        { 
            businessObj.PersonURLID = int.Parse(sqlCommand.Parameters["@PersonURLID"].Value.ToString()); 
        } 
 
        /*! Method to create parameters in order to add or edit a record. */
        public override void GetParamsPrimaryKey(ref System.Data.Common.DbCommand cmd, ProfilesRNSDLL.BO.ORCID.PersonURL bo) 
        { 
            AddParam(ref cmd, "@PersonURLID", bo.PersonURLID);
        } 
 
        internal List<ProfilesRNSDLL.BO.ORCID.PersonURL> GetByPersonID(int PersonID, bool addBlank) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[ORCID.].cg2_PersonURLGetByPersonID");
            AddParam(ref cmd, "@PersonID", PersonID);
            return PopulateCollectionObject(FillTable(cmd), addBlank); 
        } 
        internal ProfilesRNSDLL.BO.ORCID.PersonURL GetByPersonIDAndURL(int PersonID, string URL) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[ORCID.].cg2_PersonURLGetByPersonIDAndURL");
            AddParam(ref cmd, "@PersonID", PersonID);
            AddParam(ref cmd, "@URL", URL);
            return PopulateFromRow(FillTable(cmd), 0); 
        } 
        internal List<ProfilesRNSDLL.BO.ORCID.PersonURL> GetByPersonMessageID(int PersonMessageID, bool addBlank) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[ORCID.].cg2_PersonURLGetByPersonMessageID");
            AddParam(ref cmd, "@PersonMessageID", PersonMessageID);
            return PopulateCollectionObject(FillTable(cmd), addBlank); 
        } 
        internal ProfilesRNSDLL.BO.ORCID.PersonURL Get(int PersonURLID) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[ORCID.].cg2_PersonURLGet");
            AddParam(ref cmd, "@PersonURLID", PersonURLID);
            return PopulateFromRow(FillTable(cmd), 0); 
        } 
 
        /*! Method to create a PersonURL object from a row in a dataset. */
        public override ProfilesRNSDLL.BO.ORCID.PersonURL PopulateFromRow(System.Data.DataRow dr) 
        { 
            ProfilesRNSDLL.BO.ORCID.PersonURL bo = new ProfilesRNSDLL.BO.ORCID.PersonURL();
            bo.PersonURLID = int.Parse(dr["PersonURLID"].ToString()); 
            bo.PersonID = int.Parse(dr["PersonID"].ToString()); 
            if(!dr.IsNull("PersonMessageID"))
            { 
                 bo.PersonMessageID = int.Parse(dr["PersonMessageID"].ToString()); 
            } 
            if(!dr.IsNull("URLName"))
            { 
                 bo.URLName = dr["URLName"].ToString(); 
            } 
            bo.URL = dr["URL"].ToString(); 
            bo.DecisionID = int.Parse(dr["DecisionID"].ToString()); 
            bo.Exists = true;
            return bo;
        } 
     
        /*! Method to get the business object before the datachange. */
        protected override ProfilesRNSDLL.BO.ORCID.PersonURL GetBOBefore(ProfilesRNSDLL.BO.ORCID.PersonURL businessObj)
        { 
            return this.Get(businessObj.PersonURLID);
        } 
 
        # endregion // internal Method 
 
    } 
 
} 
