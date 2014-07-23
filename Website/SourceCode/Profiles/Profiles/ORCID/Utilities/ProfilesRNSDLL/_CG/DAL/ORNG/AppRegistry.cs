using System; 
using System.Collections.Generic; 
using System.Data; 
using System.Data.Common; 
using System.Linq; 
using System.Text;
using System.Reflection;
using System.Diagnostics;
 
namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DAL.ORNG
{ 
    public partial class AppRegistry : DALGeneric<ProfilesRNSDLL.BO.ORNG.AppRegistry>
    { 
     
        # region Constructors 
    
        internal AppRegistry() : base() { } 
    
        # endregion // Constructors
     
        # region Methods 
 
        /*! Method to create parameters in order to add or edit a record. */
        public override void GetParamsAll(ref System.Data.Common.DbCommand cmd, ProfilesRNSDLL.BO.ORNG.AppRegistry bo) 
        { 
            AddParam(ref cmd, "@nodeid", bo.nodeid);
            AddParam(ref cmd, "@appId", bo.appId);
            if(!bo.visibilityIsNull) {
                 AddParam(ref cmd, "@visibility", bo.visibility);
            } 
            if(!bo.createdDTIsNull) {
                 AddParam(ref cmd, "@createdDT", bo.createdDT);
            } 
        } 
 
        /*! Method to log changes to fields in a record. */
        public override void LogIfNecessary(DevelopmentBase.BaseClassBO.RecordLevelAuditTypes auditType, ProfilesRNSDLL.BO.ORNG.AppRegistry boBefore, ProfilesRNSDLL.BO.ORNG.AppRegistry bo, DbTransaction trans) 
        { 
        } 
 
        /*! Method to get the fields in the table in a select string. */
        internal static string GetSelectString() { return "SELECT TOP 100 PERCENT [ORNG].[AppRegistry].[nodeid], [ORNG].[AppRegistry].[appId], [ORNG].[AppRegistry].[visibility], [ORNG].[AppRegistry].[createdDT]"; } 
 
        /*! Method to get identity(s) of the newly added database record. */
        public override void GetIdentity(System.Data.Common.DbCommand sqlCommand, ProfilesRNSDLL.BO.ORNG.AppRegistry businessObj)
        { 
        } 
 
        /*! Method to create parameters in order to add or edit a record. */
        public override void GetParamsPrimaryKey(ref System.Data.Common.DbCommand cmd, ProfilesRNSDLL.BO.ORNG.AppRegistry bo) 
        { 
        } 
 
        internal List<ProfilesRNSDLL.BO.ORNG.AppRegistry> GetBynodeid(long nodeid, bool addBlank) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[ORNG].cg2_AppRegistryGetBynodeid");
            AddParam(ref cmd, "@nodeid", nodeid);
            return PopulateCollectionObject(FillTable(cmd), addBlank); 
        } 
 
        /*! Method to create a AppRegistry object from a row in a dataset. */
        public override ProfilesRNSDLL.BO.ORNG.AppRegistry PopulateFromRow(System.Data.DataRow dr) 
        { 
            ProfilesRNSDLL.BO.ORNG.AppRegistry bo = new ProfilesRNSDLL.BO.ORNG.AppRegistry();
            bo.nodeid = long.Parse(dr["nodeid"].ToString()); 
            bo.appId = int.Parse(dr["appId"].ToString()); 
            if(!dr.IsNull("visibility"))
            { 
                 bo.visibility = dr["visibility"].ToString(); 
            } 
            if(!dr.IsNull("createdDT"))
            { 
                 bo.createdDT = System.DateTime.Parse(dr["createdDT"].ToString()); 
            } 
            bo.Exists = true;
            return bo;
        } 
     
        # endregion // internal Method 
 
    } 
 
} 
