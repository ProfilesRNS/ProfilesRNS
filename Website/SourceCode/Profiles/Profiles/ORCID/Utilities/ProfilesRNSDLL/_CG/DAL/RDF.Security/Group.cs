using System; 
using System.Collections.Generic; 
using System.Data; 
using System.Data.Common; 
using System.Linq; 
using System.Text;
using System.Reflection;
using System.Diagnostics;
 
namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DAL.RDF.Security
{ 
    public partial class Group : DALGeneric<ProfilesRNSDLL.BO.RDF.Security.Group>
    { 
     
        # region Constructors 
    
        internal Group() : base() { } 
    
        # endregion // Constructors
     
        # region Methods 
 
        /*! Method to create parameters in order to add or edit a record. */
        public override void GetParamsAll(ref System.Data.Common.DbCommand cmd, ProfilesRNSDLL.BO.RDF.Security.Group bo) 
        { 
            AddParam(ref cmd, "@SecurityGroupID", bo.SecurityGroupID);
            AddParam(ref cmd, "@Label", bo.Label);
            if(!bo.HasSpecialViewAccessIsNull) {
                 AddParam(ref cmd, "@HasSpecialViewAccess", bo.HasSpecialViewAccess);
            } 
            if(!bo.HasSpecialEditAccessIsNull) {
                 AddParam(ref cmd, "@HasSpecialEditAccess", bo.HasSpecialEditAccess);
            } 
            if(!bo.DescriptionIsNull) {
                 AddParam(ref cmd, "@Description", bo.Description);
            } 
            if(!bo.DefaultORCIDDecisionIDIsNull) {
                 AddParam(ref cmd, "@DefaultORCIDDecisionID", bo.DefaultORCIDDecisionID);
            } 
        } 
 
        /*! Method to log changes to fields in a record. */
        public override void LogIfNecessary(DevelopmentBase.BaseClassBO.RecordLevelAuditTypes auditType, ProfilesRNSDLL.BO.RDF.Security.Group boBefore, ProfilesRNSDLL.BO.RDF.Security.Group bo, DbTransaction trans) 
        { 
        } 
 
        /*! Method to get the fields in the table in a select string. */
        internal static string GetSelectString() { return "SELECT TOP 100 PERCENT [RDF.Security].[Group].[SecurityGroupID], [RDF.Security].[Group].[Label], [RDF.Security].[Group].[HasSpecialViewAccess], [RDF.Security].[Group].[HasSpecialEditAccess], [RDF.Security].[Group].[Description], [RDF.Security].[Group].[DefaultORCIDDecisionID]"; } 
 
        /*! Method to get identity(s) of the newly added database record. */
        public override void GetIdentity(System.Data.Common.DbCommand sqlCommand, ProfilesRNSDLL.BO.RDF.Security.Group businessObj)
        { 
        } 
 
        /*! Method to create parameters in order to add or edit a record. */
        public override void GetParamsPrimaryKey(ref System.Data.Common.DbCommand cmd, ProfilesRNSDLL.BO.RDF.Security.Group bo) 
        { 
            AddParam(ref cmd, "@SecurityGroupID", bo.SecurityGroupID);
        } 
 
        internal ProfilesRNSDLL.BO.RDF.Security.Group Get(long SecurityGroupID) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[ORCID.].cg2_GroupGet");
            AddParam(ref cmd, "@SecurityGroupID", SecurityGroupID);
            return PopulateFromRow(FillTable(cmd), 0); 
        } 
 
        /*! Method to create a Group object from a row in a dataset. */
        public override ProfilesRNSDLL.BO.RDF.Security.Group PopulateFromRow(System.Data.DataRow dr) 
        { 
            ProfilesRNSDLL.BO.RDF.Security.Group bo = new ProfilesRNSDLL.BO.RDF.Security.Group();
            bo.SecurityGroupID = long.Parse(dr["SecurityGroupID"].ToString()); 
            bo.Label = dr["Label"].ToString(); 
/*            if(!dr.IsNull("HasSpecialViewAccess"))
            { 
                 bo.HasSpecialViewAccess = bool.Parse(dr["HasSpecialViewAccess"].ToString()); 
            } 
            if(!dr.IsNull("HasSpecialEditAccess"))
            { 
                 bo.HasSpecialEditAccess = bool.Parse(dr["HasSpecialEditAccess"].ToString()); 
            } 
            if(!dr.IsNull("Description"))
            { 
                 bo.Description = dr["Description"].ToString(); 
            } 
   */         if(!dr.IsNull("DefaultORCIDDecisionID"))
            { 
                 bo.DefaultORCIDDecisionID = int.Parse(dr["DefaultORCIDDecisionID"].ToString()); 
            } 
            bo.Exists = true;
            return bo;
        } 
     
        /*! Method to get the business object before the datachange. */
        protected override ProfilesRNSDLL.BO.RDF.Security.Group GetBOBefore(ProfilesRNSDLL.BO.RDF.Security.Group businessObj)
        { 
            return this.Get(businessObj.SecurityGroupID);
        } 
 
        # endregion // internal Method 
 
    } 
 
} 
