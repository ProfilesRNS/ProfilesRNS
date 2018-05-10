using System.Collections.Generic;
using System.Data.Common;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DAL.ORCID
{
    public partial class PersonMessage : DALGeneric<ProfilesRNSDLL.BO.ORCID.PersonMessage>
    { 
     
        # region Constructors 
    
        internal PersonMessage() : base() { } 
    
        # endregion // Constructors
     
        # region Methods 
 
        /*! Method to create parameters in order to add or edit a record. */
        public override void GetParamsAll(ref System.Data.Common.DbCommand cmd, ProfilesRNSDLL.BO.ORCID.PersonMessage bo) 
        { 
            DbParameter Parm = cmd.CreateParameter(); 
            Parm.ParameterName = "@PersonMessageID";
            Parm.Size = 4;
            Parm.DbType = System.Data.DbType.Int32;
            if(!bo.PersonMessageIDIsNull) {
                 Parm.Direction = System.Data.ParameterDirection.InputOutput; 
                 Parm.Value = bo.PersonMessageID;
            } else { 
                 Parm.Direction = System.Data.ParameterDirection.Output; 
            }  
            cmd.Parameters.Add(Parm);
            AddParam(ref cmd, "@PersonID", bo.PersonID);
            if(!bo.XML_SentIsNull) {
                 AddParam(ref cmd, "@XML_Sent", bo.XML_Sent);
            } 
            if(!bo.XML_ResponseIsNull) {
                 AddParam(ref cmd, "@XML_Response", bo.XML_Response);
            } 
            if(!bo.ErrorMessageIsNull) {
                 AddParam(ref cmd, "@ErrorMessage", bo.ErrorMessage);
            } 
            if(!bo.HttpResponseCodeIsNull) {
                 AddParam(ref cmd, "@HttpResponseCode", bo.HttpResponseCode);
            } 
            if(!bo.MessagePostSuccessIsNull) {
                 AddParam(ref cmd, "@MessagePostSuccess", bo.MessagePostSuccess);
            } 
            if(!bo.RecordStatusIDIsNull) {
                 AddParam(ref cmd, "@RecordStatusID", bo.RecordStatusID);
            } 
            if(!bo.PermissionIDIsNull) {
                 AddParam(ref cmd, "@PermissionID", bo.PermissionID);
            } 
            if(!bo.RequestURLIsNull) {
                 AddParam(ref cmd, "@RequestURL", bo.RequestURL);
            } 
            if(!bo.HeaderPostIsNull) {
                 AddParam(ref cmd, "@HeaderPost", bo.HeaderPost);
            } 
            if(!bo.UserMessageIsNull) {
                 AddParam(ref cmd, "@UserMessage", bo.UserMessage);
            } 
            if(!bo.PostDateIsNull) {
                 AddParam(ref cmd, "@PostDate", bo.PostDate);
            } 
        } 
 
        /*! Method to log changes to fields in a record. */
        public override void LogIfNecessary(DevelopmentBase.BaseClassBO.RecordLevelAuditTypes auditType, ProfilesRNSDLL.BO.ORCID.PersonMessage boBefore, ProfilesRNSDLL.BO.ORCID.PersonMessage bo, DbTransaction trans) 
        { 
            int recordLevelAuditTrailID = 0;
            if (auditType == DevelopmentBase.BaseClassBO.RecordLevelAuditTypes.Deleted)
            {
                recordLevelAuditTrailID = AddRecordLevelAuditTrail(bo.TableId, boBefore.PersonMessageID, auditType, trans);
            }
            else
            {
                recordLevelAuditTrailID = AddRecordLevelAuditTrail(bo.TableId, bo.PersonMessageID, auditType, trans);
            }
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.PersonMessage.FieldNames.PersonID, bo.PersonIDIsNull, boBefore.PersonIDIsNull, bo.PersonID, boBefore.PersonID, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.PersonMessage.FieldNames.XML_Sent, bo.XML_SentIsNull, boBefore.XML_SentIsNull, bo.XML_Sent, boBefore.XML_Sent, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.PersonMessage.FieldNames.XML_Response, bo.XML_ResponseIsNull, boBefore.XML_ResponseIsNull, bo.XML_Response, boBefore.XML_Response, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.PersonMessage.FieldNames.ErrorMessage, bo.ErrorMessageIsNull, boBefore.ErrorMessageIsNull, bo.ErrorMessage, boBefore.ErrorMessage, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.PersonMessage.FieldNames.HttpResponseCode, bo.HttpResponseCodeIsNull, boBefore.HttpResponseCodeIsNull, bo.HttpResponseCode, boBefore.HttpResponseCode, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.PersonMessage.FieldNames.MessagePostSuccess, bo.MessagePostSuccessIsNull, boBefore.MessagePostSuccessIsNull, bo.MessagePostSuccess, boBefore.MessagePostSuccess, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.PersonMessage.FieldNames.RecordStatusID, bo.RecordStatusIDIsNull, boBefore.RecordStatusIDIsNull, bo.RecordStatusID, boBefore.RecordStatusID, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.PersonMessage.FieldNames.PermissionID, bo.PermissionIDIsNull, boBefore.PermissionIDIsNull, bo.PermissionID, boBefore.PermissionID, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.PersonMessage.FieldNames.RequestURL, bo.RequestURLIsNull, boBefore.RequestURLIsNull, bo.RequestURL, boBefore.RequestURL, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.PersonMessage.FieldNames.HeaderPost, bo.HeaderPostIsNull, boBefore.HeaderPostIsNull, bo.HeaderPost, boBefore.HeaderPost, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.PersonMessage.FieldNames.UserMessage, bo.UserMessageIsNull, boBefore.UserMessageIsNull, bo.UserMessage, boBefore.UserMessage, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.PersonMessage.FieldNames.PostDate, bo.PostDateIsNull, boBefore.PostDateIsNull, bo.PostDate, boBefore.PostDate, trans);
        } 
 
        /*! Method to get the fields in the table in a select string. */
        internal static string GetSelectString() { return "SELECT TOP 100 PERCENT [ORCID.].[PersonMessage].[PersonMessageID], [ORCID.].[PersonMessage].[PersonID], [ORCID.].[PersonMessage].[XML_Sent], [ORCID.].[PersonMessage].[XML_Response], [ORCID.].[PersonMessage].[ErrorMessage], [ORCID.].[PersonMessage].[HttpResponseCode], [ORCID.].[PersonMessage].[MessagePostSuccess], [ORCID.].[PersonMessage].[RecordStatusID], [ORCID.].[PersonMessage].[PermissionID], [ORCID.].[PersonMessage].[RequestURL], [ORCID.].[PersonMessage].[HeaderPost], [ORCID.].[PersonMessage].[UserMessage], [ORCID.].[PersonMessage].[PostDate]"; } 
 
        /*! Method to get identity(s) of the newly added database record. */
        public override void GetIdentity(System.Data.Common.DbCommand sqlCommand, ProfilesRNSDLL.BO.ORCID.PersonMessage businessObj)
        { 
            businessObj.PersonMessageID = int.Parse(sqlCommand.Parameters["@PersonMessageID"].Value.ToString()); 
        } 
 
        /*! Method to create parameters in order to add or edit a record. */
        public override void GetParamsPrimaryKey(ref System.Data.Common.DbCommand cmd, ProfilesRNSDLL.BO.ORCID.PersonMessage bo) 
        { 
            AddParam(ref cmd, "@PersonMessageID", bo.PersonMessageID);
        } 
 
        internal List<ProfilesRNSDLL.BO.ORCID.PersonMessage> GetByPersonID(int PersonID, bool addBlank) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[ORCID.].cg2_PersonMessageGetByPersonID");
            AddParam(ref cmd, "@PersonID", PersonID);
            return PopulateCollectionObject(FillTable(cmd), addBlank); 
        } 
        internal List<ProfilesRNSDLL.BO.ORCID.PersonMessage> GetByPersonIDAndRecordStatusIDAndPermissionID(int PersonID, int RecordStatusID, int PermissionID, bool addBlank) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[ORCID.].cg2_PersonMessageGetByPersonIDAndRecordStatusIDAndPermissionID");
            AddParam(ref cmd, "@PersonID", PersonID);
            AddParam(ref cmd, "@RecordStatusID", RecordStatusID);
            AddParam(ref cmd, "@PermissionID", PermissionID);
            return PopulateCollectionObject(FillTable(cmd), addBlank); 
        } 
        internal List<ProfilesRNSDLL.BO.ORCID.PersonMessage> GetByPersonIDAndRecordStatusID(int PersonID, int RecordStatusID, bool addBlank) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[ORCID.].cg2_PersonMessageGetByPersonIDAndRecordStatusID");
            AddParam(ref cmd, "@PersonID", PersonID);
            AddParam(ref cmd, "@RecordStatusID", RecordStatusID);
            return PopulateCollectionObject(FillTable(cmd), addBlank); 
        } 
        internal ProfilesRNSDLL.BO.ORCID.PersonMessage Get(int PersonMessageID) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[ORCID.].cg2_PersonMessageGet");
            AddParam(ref cmd, "@PersonMessageID", PersonMessageID);
            return PopulateFromRow(FillTable(cmd), 0); 
        } 
 
        /*! Method to create a PersonMessage object from a row in a dataset. */
        public override ProfilesRNSDLL.BO.ORCID.PersonMessage PopulateFromRow(System.Data.DataRow dr) 
        { 
            ProfilesRNSDLL.BO.ORCID.PersonMessage bo = new ProfilesRNSDLL.BO.ORCID.PersonMessage();
            bo.PersonMessageID = int.Parse(dr["PersonMessageID"].ToString()); 
            bo.PersonID = int.Parse(dr["PersonID"].ToString()); 
            if(!dr.IsNull("XML_Sent"))
            { 
                 bo.XML_Sent = dr["XML_Sent"].ToString(); 
            } 
            if(!dr.IsNull("XML_Response"))
            { 
                 bo.XML_Response = dr["XML_Response"].ToString(); 
            } 
            if(!dr.IsNull("ErrorMessage"))
            { 
                 bo.ErrorMessage = dr["ErrorMessage"].ToString(); 
            } 
            if(!dr.IsNull("HttpResponseCode"))
            { 
                 bo.HttpResponseCode = dr["HttpResponseCode"].ToString(); 
            } 
            if(!dr.IsNull("MessagePostSuccess"))
            { 
                 bo.MessagePostSuccess = bool.Parse(dr["MessagePostSuccess"].ToString()); 
            } 
            if(!dr.IsNull("RecordStatusID"))
            { 
                 bo.RecordStatusID = int.Parse(dr["RecordStatusID"].ToString()); 
            } 
            if(!dr.IsNull("PermissionID"))
            { 
                 bo.PermissionID = int.Parse(dr["PermissionID"].ToString()); 
            } 
            if(!dr.IsNull("RequestURL"))
            { 
                 bo.RequestURL = dr["RequestURL"].ToString(); 
            } 
            if(!dr.IsNull("HeaderPost"))
            { 
                 bo.HeaderPost = dr["HeaderPost"].ToString(); 
            } 
            if(!dr.IsNull("UserMessage"))
            { 
                 bo.UserMessage = dr["UserMessage"].ToString(); 
            } 
            if(!dr.IsNull("PostDate"))
            { 
                 bo.PostDate = System.DateTime.Parse(dr["PostDate"].ToString()); 
            } 
            bo.Exists = true;
            return bo;
        } 
     
        /*! Method to get the business object before the datachange. */
        protected override ProfilesRNSDLL.BO.ORCID.PersonMessage GetBOBefore(ProfilesRNSDLL.BO.ORCID.PersonMessage businessObj)
        { 
            return this.Get(businessObj.PersonMessageID);
        } 
 
        # endregion // internal Method 
 
    } 
 
} 
