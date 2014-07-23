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
    public partial class PersonWork : DALGeneric<ProfilesRNSDLL.BO.ORCID.PersonWork>
    { 
     
        # region Constructors 
    
        internal PersonWork() : base() { } 
    
        # endregion // Constructors
     
        # region Methods 
 
        /*! Method to create parameters in order to add or edit a record. */
        public override void GetParamsAll(ref System.Data.Common.DbCommand cmd, ProfilesRNSDLL.BO.ORCID.PersonWork bo) 
        { 
            DbParameter Parm = cmd.CreateParameter(); 
            Parm.ParameterName = "@PersonWorkID";
            Parm.Size = 4;
            Parm.DbType = System.Data.DbType.Int32;
            if(!bo.PersonWorkIDIsNull) {
                 Parm.Direction = System.Data.ParameterDirection.InputOutput; 
                 Parm.Value = bo.PersonWorkID;
            } else { 
                 Parm.Direction = System.Data.ParameterDirection.Output; 
            }  
            cmd.Parameters.Add(Parm);
            AddParam(ref cmd, "@PersonID", bo.PersonID);
            if(!bo.PersonMessageIDIsNull) {
                 AddParam(ref cmd, "@PersonMessageID", bo.PersonMessageID);
            } 
            AddParam(ref cmd, "@DecisionID", bo.DecisionID);
            AddParam(ref cmd, "@WorkTitle", bo.WorkTitle);
            if(!bo.ShortDescriptionIsNull) {
                 AddParam(ref cmd, "@ShortDescription", bo.ShortDescription);
            } 
            if(!bo.WorkCitationIsNull) {
                 AddParam(ref cmd, "@WorkCitation", bo.WorkCitation);
            } 
            if(!bo.WorkTypeIsNull) {
                 AddParam(ref cmd, "@WorkType", bo.WorkType);
            } 
            if(!bo.URLIsNull) {
                 AddParam(ref cmd, "@URL", bo.URL);
            } 
            if(!bo.SubTitleIsNull) {
                 AddParam(ref cmd, "@SubTitle", bo.SubTitle);
            } 
            if(!bo.WorkCitationTypeIsNull) {
                 AddParam(ref cmd, "@WorkCitationType", bo.WorkCitationType);
            } 
            if(!bo.PubDateIsNull) {
                 AddParam(ref cmd, "@PubDate", bo.PubDate);
            } 
            if(!bo.PublicationMediaTypeIsNull) {
                 AddParam(ref cmd, "@PublicationMediaType", bo.PublicationMediaType);
            } 
            AddParam(ref cmd, "@PubID", bo.PubID);
        } 
 
        /*! Method to log changes to fields in a record. */
        public override void LogIfNecessary(DevelopmentBase.BaseClassBO.RecordLevelAuditTypes auditType, ProfilesRNSDLL.BO.ORCID.PersonWork boBefore, ProfilesRNSDLL.BO.ORCID.PersonWork bo, DbTransaction trans) 
        { 
            int recordLevelAuditTrailID = 0;
            if (auditType == DevelopmentBase.BaseClassBO.RecordLevelAuditTypes.Deleted)
            {
                recordLevelAuditTrailID = AddRecordLevelAuditTrail(bo.TableId, boBefore.PersonWorkID, auditType, trans);
            }
            else
            {
                recordLevelAuditTrailID = AddRecordLevelAuditTrail(bo.TableId, bo.PersonWorkID, auditType, trans);
            }
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.PersonWork.FieldNames.PersonID, bo.PersonIDIsNull, boBefore.PersonIDIsNull, bo.PersonID, boBefore.PersonID, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.PersonWork.FieldNames.PersonMessageID, bo.PersonMessageIDIsNull, boBefore.PersonMessageIDIsNull, bo.PersonMessageID, boBefore.PersonMessageID, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.PersonWork.FieldNames.DecisionID, bo.DecisionIDIsNull, boBefore.DecisionIDIsNull, bo.DecisionID, boBefore.DecisionID, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.PersonWork.FieldNames.WorkTitle, bo.WorkTitleIsNull, boBefore.WorkTitleIsNull, bo.WorkTitle, boBefore.WorkTitle, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.PersonWork.FieldNames.ShortDescription, bo.ShortDescriptionIsNull, boBefore.ShortDescriptionIsNull, bo.ShortDescription, boBefore.ShortDescription, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.PersonWork.FieldNames.WorkCitation, bo.WorkCitationIsNull, boBefore.WorkCitationIsNull, bo.WorkCitation, boBefore.WorkCitation, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.PersonWork.FieldNames.WorkType, bo.WorkTypeIsNull, boBefore.WorkTypeIsNull, bo.WorkType, boBefore.WorkType, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.PersonWork.FieldNames.URL, bo.URLIsNull, boBefore.URLIsNull, bo.URL, boBefore.URL, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.PersonWork.FieldNames.SubTitle, bo.SubTitleIsNull, boBefore.SubTitleIsNull, bo.SubTitle, boBefore.SubTitle, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.PersonWork.FieldNames.WorkCitationType, bo.WorkCitationTypeIsNull, boBefore.WorkCitationTypeIsNull, bo.WorkCitationType, boBefore.WorkCitationType, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.PersonWork.FieldNames.PubDate, bo.PubDateIsNull, boBefore.PubDateIsNull, bo.PubDate, boBefore.PubDate, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.PersonWork.FieldNames.PublicationMediaType, bo.PublicationMediaTypeIsNull, boBefore.PublicationMediaTypeIsNull, bo.PublicationMediaType, boBefore.PublicationMediaType, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.ORCID.PersonWork.FieldNames.PubID, bo.PubIDIsNull, boBefore.PubIDIsNull, bo.PubID, boBefore.PubID, trans);
        } 
 
        /*! Method to get the fields in the table in a select string. */
        internal static string GetSelectString() { return "SELECT TOP 100 PERCENT [ORCID.].[PersonWork].[PersonWorkID], [ORCID.].[PersonWork].[PersonID], [ORCID.].[PersonWork].[PersonMessageID], [ORCID.].[PersonWork].[DecisionID], [ORCID.].[PersonWork].[WorkTitle], [ORCID.].[PersonWork].[ShortDescription], [ORCID.].[PersonWork].[WorkCitation], [ORCID.].[PersonWork].[WorkType], [ORCID.].[PersonWork].[URL], [ORCID.].[PersonWork].[SubTitle], [ORCID.].[PersonWork].[WorkCitationType], [ORCID.].[PersonWork].[PubDate], [ORCID.].[PersonWork].[PublicationMediaType], [ORCID.].[PersonWork].[PubID]"; } 
 
        /*! Method to get identity(s) of the newly added database record. */
        public override void GetIdentity(System.Data.Common.DbCommand sqlCommand, ProfilesRNSDLL.BO.ORCID.PersonWork businessObj)
        { 
            businessObj.PersonWorkID = int.Parse(sqlCommand.Parameters["@PersonWorkID"].Value.ToString()); 
        } 
 
        /*! Method to create parameters in order to add or edit a record. */
        public override void GetParamsPrimaryKey(ref System.Data.Common.DbCommand cmd, ProfilesRNSDLL.BO.ORCID.PersonWork bo) 
        { 
            AddParam(ref cmd, "@PersonWorkID", bo.PersonWorkID);
        } 
 
        internal List<ProfilesRNSDLL.BO.ORCID.PersonWork> GetByDecisionID(int DecisionID, bool addBlank) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[ORCID.].cg2_PersonWorkGetByDecisionID");
            AddParam(ref cmd, "@DecisionID", DecisionID);
            return PopulateCollectionObject(FillTable(cmd), addBlank); 
        } 
        internal List<ProfilesRNSDLL.BO.ORCID.PersonWork> GetByPersonID(int PersonID, bool addBlank) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[ORCID.].cg2_PersonWorkGetByPersonID");
            AddParam(ref cmd, "@PersonID", PersonID);
            return PopulateCollectionObject(FillTable(cmd), addBlank); 
        } 
        internal ProfilesRNSDLL.BO.ORCID.PersonWork GetByPersonIDAndPubID(int PersonID, string PubID) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[ORCID.].cg2_PersonWorkGetByPersonIDAndPubID");
            AddParam(ref cmd, "@PersonID", PersonID);
            AddParam(ref cmd, "@PubID", PubID);
            return PopulateFromRow(FillTable(cmd), 0); 
        } 
        internal List<ProfilesRNSDLL.BO.ORCID.PersonWork> GetByPersonMessageID(int PersonMessageID, bool addBlank) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[ORCID.].cg2_PersonWorkGetByPersonMessageID");
            AddParam(ref cmd, "@PersonMessageID", PersonMessageID);
            return PopulateCollectionObject(FillTable(cmd), addBlank); 
        } 
        internal ProfilesRNSDLL.BO.ORCID.PersonWork Get(int PersonWorkID) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[ORCID.].cg2_PersonWorkGet");
            AddParam(ref cmd, "@PersonWorkID", PersonWorkID);
            return PopulateFromRow(FillTable(cmd), 0); 
        } 
 
        /*! Method to create a PersonWork object from a row in a dataset. */
        public override ProfilesRNSDLL.BO.ORCID.PersonWork PopulateFromRow(System.Data.DataRow dr) 
        { 
            ProfilesRNSDLL.BO.ORCID.PersonWork bo = new ProfilesRNSDLL.BO.ORCID.PersonWork();
            bo.PersonWorkID = int.Parse(dr["PersonWorkID"].ToString()); 
            bo.PersonID = int.Parse(dr["PersonID"].ToString()); 
            if(!dr.IsNull("PersonMessageID"))
            { 
                 bo.PersonMessageID = int.Parse(dr["PersonMessageID"].ToString()); 
            } 
            bo.DecisionID = int.Parse(dr["DecisionID"].ToString()); 
            bo.WorkTitle = dr["WorkTitle"].ToString(); 
            if(!dr.IsNull("ShortDescription"))
            { 
                 bo.ShortDescription = dr["ShortDescription"].ToString(); 
            } 
            if(!dr.IsNull("WorkCitation"))
            { 
                 bo.WorkCitation = dr["WorkCitation"].ToString(); 
            } 
            if(!dr.IsNull("WorkType"))
            { 
                 bo.WorkType = dr["WorkType"].ToString(); 
            } 
            if(!dr.IsNull("URL"))
            { 
                 bo.URL = dr["URL"].ToString(); 
            } 
            if(!dr.IsNull("SubTitle"))
            { 
                 bo.SubTitle = dr["SubTitle"].ToString(); 
            } 
            if(!dr.IsNull("WorkCitationType"))
            { 
                 bo.WorkCitationType = dr["WorkCitationType"].ToString(); 
            } 
            if(!dr.IsNull("PubDate"))
            { 
                 bo.PubDate = System.DateTime.Parse(dr["PubDate"].ToString()); 
            } 
            if(!dr.IsNull("PublicationMediaType"))
            { 
                 bo.PublicationMediaType = dr["PublicationMediaType"].ToString(); 
            } 
            bo.PubID = dr["PubID"].ToString(); 
            bo.Exists = true;
            return bo;
        } 
     
        /*! Method to get the business object before the datachange. */
        protected override ProfilesRNSDLL.BO.ORCID.PersonWork GetBOBefore(ProfilesRNSDLL.BO.ORCID.PersonWork businessObj)
        { 
            return this.Get(businessObj.PersonWorkID);
        } 
 
        # endregion // internal Method 
 
    } 
 
} 
