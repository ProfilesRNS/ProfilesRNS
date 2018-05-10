using System.Collections.Generic;
using System.Data.Common;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DAL.ORNG
{
    public partial class AppData : DALGeneric<ProfilesRNSDLL.BO.ORNG.AppData>
    { 
     
        # region Constructors 
    
        internal AppData() : base() { } 
    
        # endregion // Constructors
     
        # region Methods 
 
        /*! Method to create parameters in order to add or edit a record. */
        public override void GetParamsAll(ref System.Data.Common.DbCommand cmd, ProfilesRNSDLL.BO.ORNG.AppData bo) 
        { 
            AddParam(ref cmd, "@nodeId", bo.nodeId);
            AddParam(ref cmd, "@appId", bo.appId);
            AddParam(ref cmd, "@keyname", bo.keyname);
            if(!bo.valueIsNull) {
                 AddParam(ref cmd, "@value", bo.value);
            } 
            if(!bo.createdDTIsNull) {
                 AddParam(ref cmd, "@createdDT", bo.createdDT);
            } 
            if(!bo.updatedDTIsNull) {
                 AddParam(ref cmd, "@updatedDT", bo.updatedDT);
            } 
        } 
 
        /*! Method to log changes to fields in a record. */
        public override void LogIfNecessary(DevelopmentBase.BaseClassBO.RecordLevelAuditTypes auditType, ProfilesRNSDLL.BO.ORNG.AppData boBefore, ProfilesRNSDLL.BO.ORNG.AppData bo, DbTransaction trans) 
        { 
        } 
 
        /*! Method to get the fields in the table in a select string. */
        internal static string GetSelectString() { return "SELECT TOP 100 PERCENT [ORNG].[AppData].[nodeId], [ORNG].[AppData].[appId], [ORNG].[AppData].[keyname], [ORNG].[AppData].[value], [ORNG].[AppData].[createdDT], [ORNG].[AppData].[updatedDT]"; } 
 
        /*! Method to get identity(s) of the newly added database record. */
        public override void GetIdentity(System.Data.Common.DbCommand sqlCommand, ProfilesRNSDLL.BO.ORNG.AppData businessObj)
        { 
        } 
 
        /*! Method to create parameters in order to add or edit a record. */
        public override void GetParamsPrimaryKey(ref System.Data.Common.DbCommand cmd, ProfilesRNSDLL.BO.ORNG.AppData bo) 
        { 
        } 
 
        internal List<ProfilesRNSDLL.BO.ORNG.AppData> GetBykeynameAndvalueAndnodeIdAndappId(string keyname, string value, long nodeId, int appId, bool addBlank) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[ORNG].cg2_AppDataGetBykeynameAndvalueAndnodeIdAndappId");
            AddParam(ref cmd, "@keyname", keyname);
            AddParam(ref cmd, "@value", value);
            AddParam(ref cmd, "@nodeId", nodeId);
            AddParam(ref cmd, "@appId", appId);
            return PopulateCollectionObject(FillTable(cmd), addBlank); 
        } 
 
        /*! Method to create a AppData object from a row in a dataset. */
        public override ProfilesRNSDLL.BO.ORNG.AppData PopulateFromRow(System.Data.DataRow dr) 
        { 
            ProfilesRNSDLL.BO.ORNG.AppData bo = new ProfilesRNSDLL.BO.ORNG.AppData();
            bo.nodeId = long.Parse(dr["nodeId"].ToString()); 
            bo.appId = int.Parse(dr["appId"].ToString()); 
            bo.keyname = dr["keyname"].ToString(); 
            if(!dr.IsNull("value"))
            { 
                 bo.value = dr["value"].ToString(); 
            } 
            if(!dr.IsNull("createdDT"))
            { 
                 bo.createdDT = System.DateTime.Parse(dr["createdDT"].ToString()); 
            } 
            if(!dr.IsNull("updatedDT"))
            { 
                 bo.updatedDT = System.DateTime.Parse(dr["updatedDT"].ToString()); 
            } 
            bo.Exists = true;
            return bo;
        } 
     
        # endregion // internal Method 
 
    } 
 
} 
