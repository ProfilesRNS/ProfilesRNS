using System.Data.Common;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DAL.ORNG
{
    public partial class Apps : DALGeneric<ProfilesRNSDLL.BO.ORNG.Apps>
    { 
     
        # region Constructors 
    
        internal Apps() : base() { } 
    
        # endregion // Constructors
     
        # region Methods 
 
        /*! Method to create parameters in order to add or edit a record. */
        public override void GetParamsAll(ref System.Data.Common.DbCommand cmd, ProfilesRNSDLL.BO.ORNG.Apps bo) 
        { 
            AddParam(ref cmd, "@appId", bo.appId);
            AddParam(ref cmd, "@name", bo.name);
            if(!bo.urlIsNull) {
                 AddParam(ref cmd, "@url", bo.url);
            } 
            if(!bo.PersonFilterIDIsNull) {
                 AddParam(ref cmd, "@PersonFilterID", bo.PersonFilterID);
            } 
            AddParam(ref cmd, "@enabled", bo.enabled);
        } 
 
        /*! Method to log changes to fields in a record. */
        public override void LogIfNecessary(DevelopmentBase.BaseClassBO.RecordLevelAuditTypes auditType, ProfilesRNSDLL.BO.ORNG.Apps boBefore, ProfilesRNSDLL.BO.ORNG.Apps bo, DbTransaction trans) 
        { 
        } 
 
        /*! Method to get the fields in the table in a select string. */
        internal static string GetSelectString() { return "SELECT TOP 100 PERCENT [ORNG].[Apps].[appId], [ORNG].[Apps].[name], [ORNG].[Apps].[url], [ORNG].[Apps].[PersonFilterID], [ORNG].[Apps].[enabled]"; } 
 
        /*! Method to get identity(s) of the newly added database record. */
        public override void GetIdentity(System.Data.Common.DbCommand sqlCommand, ProfilesRNSDLL.BO.ORNG.Apps businessObj)
        { 
        } 
 
        /*! Method to create parameters in order to add or edit a record. */
        public override void GetParamsPrimaryKey(ref System.Data.Common.DbCommand cmd, ProfilesRNSDLL.BO.ORNG.Apps bo) 
        { 
            AddParam(ref cmd, "@appId", bo.appId);
        } 
 
        internal ProfilesRNSDLL.BO.ORNG.Apps Get(int appId) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[ORNG].cg2_AppsGet");
            AddParam(ref cmd, "@appId", appId);
            return PopulateFromRow(FillTable(cmd), 0); 
        } 
 
        /*! Method to create a Apps object from a row in a dataset. */
        public override ProfilesRNSDLL.BO.ORNG.Apps PopulateFromRow(System.Data.DataRow dr) 
        { 
            ProfilesRNSDLL.BO.ORNG.Apps bo = new ProfilesRNSDLL.BO.ORNG.Apps();
            bo.appId = int.Parse(dr["appId"].ToString()); 
            bo.name = dr["name"].ToString(); 
            if(!dr.IsNull("url"))
            { 
                 bo.url = dr["url"].ToString(); 
            } 
            if(!dr.IsNull("PersonFilterID"))
            { 
                 bo.PersonFilterID = int.Parse(dr["PersonFilterID"].ToString()); 
            } 
            bo.enabled = bool.Parse(dr["enabled"].ToString()); 
            bo.Exists = true;
            return bo;
        } 
     
        /*! Method to get the business object before the datachange. */
        protected override ProfilesRNSDLL.BO.ORNG.Apps GetBOBefore(ProfilesRNSDLL.BO.ORNG.Apps businessObj)
        { 
            return this.Get(businessObj.appId);
        } 
 
        # endregion // internal Method 
 
    } 
 
} 
