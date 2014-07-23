using System; 
using System.Collections.Generic; 
using System.Data; 
using System.Data.Common; 
using System.Linq; 
using System.Text;
using System.Reflection;
using System.Diagnostics;
 
namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DAL.RDF
{ 
    public partial class Node : DALGeneric<ProfilesRNSDLL.BO.RDF.Node>
    { 
     
        # region Constructors 
    
        internal Node() : base() { } 
    
        # endregion // Constructors
     
        # region Methods 
 
        /*! Method to create parameters in order to add or edit a record. */
        public override void GetParamsAll(ref System.Data.Common.DbCommand cmd, ProfilesRNSDLL.BO.RDF.Node bo) 
        { 
            DbParameter Parm = cmd.CreateParameter(); 
            Parm.ParameterName = "@NodeID";
            Parm.Size = 8;
            Parm.DbType = System.Data.DbType.Int64;
            if(!bo.NodeIDIsNull) {
                 Parm.Direction = System.Data.ParameterDirection.InputOutput; 
                 Parm.Value = bo.NodeID;
            } else { 
                 Parm.Direction = System.Data.ParameterDirection.Output; 
            }  
            cmd.Parameters.Add(Parm);
            AddParam(ref cmd, "@ValueHash", bo.ValueHash);
            if(!bo.LanguageIsNull) {
                 AddParam(ref cmd, "@Language", bo.Language);
            } 
            if(!bo.DataTypeIsNull) {
                 AddParam(ref cmd, "@DataType", bo.DataType);
            } 
            AddParam(ref cmd, "@Value", bo.Value);
            if(!bo.InternalNodeMapIDIsNull) {
                 AddParam(ref cmd, "@InternalNodeMapID", bo.InternalNodeMapID);
            } 
            if(!bo.ObjectTypeIsNull) {
                 AddParam(ref cmd, "@ObjectType", bo.ObjectType);
            } 
            if(!bo.ViewSecurityGroupIsNull) {
                 AddParam(ref cmd, "@ViewSecurityGroup", bo.ViewSecurityGroup);
            } 
            if(!bo.EditSecurityGroupIsNull) {
                 AddParam(ref cmd, "@EditSecurityGroup", bo.EditSecurityGroup);
            } 
        } 
 
        /*! Method to log changes to fields in a record. */
        public override void LogIfNecessary(DevelopmentBase.BaseClassBO.RecordLevelAuditTypes auditType, ProfilesRNSDLL.BO.RDF.Node boBefore, ProfilesRNSDLL.BO.RDF.Node bo, DbTransaction trans) 
        { 
            int recordLevelAuditTrailID = 0;
            if (auditType == DevelopmentBase.BaseClassBO.RecordLevelAuditTypes.Deleted)
            {
                recordLevelAuditTrailID = AddRecordLevelAuditTrail(bo.TableId, boBefore.NodeID, auditType, trans);
            }
            else
            {
                recordLevelAuditTrailID = AddRecordLevelAuditTrail(bo.TableId, bo.NodeID, auditType, trans);
            }
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.RDF.Node.FieldNames.ValueHash, bo.ValueHashIsNull, boBefore.ValueHashIsNull, bo.ValueHash, boBefore.ValueHash, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.RDF.Node.FieldNames.Language, bo.LanguageIsNull, boBefore.LanguageIsNull, bo.Language, boBefore.Language, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.RDF.Node.FieldNames.DataType, bo.DataTypeIsNull, boBefore.DataTypeIsNull, bo.DataType, boBefore.DataType, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.RDF.Node.FieldNames.Value, bo.ValueIsNull, boBefore.ValueIsNull, bo.Value, boBefore.Value, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.RDF.Node.FieldNames.InternalNodeMapID, bo.InternalNodeMapIDIsNull, boBefore.InternalNodeMapIDIsNull, bo.InternalNodeMapID, boBefore.InternalNodeMapID, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.RDF.Node.FieldNames.ObjectType, bo.ObjectTypeIsNull, boBefore.ObjectTypeIsNull, bo.ObjectType, boBefore.ObjectType, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.RDF.Node.FieldNames.ViewSecurityGroup, bo.ViewSecurityGroupIsNull, boBefore.ViewSecurityGroupIsNull, bo.ViewSecurityGroup, boBefore.ViewSecurityGroup, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.RDF.Node.FieldNames.EditSecurityGroup, bo.EditSecurityGroupIsNull, boBefore.EditSecurityGroupIsNull, bo.EditSecurityGroup, boBefore.EditSecurityGroup, trans);
        } 
 
        /*! Method to get the fields in the table in a select string. */
        internal static string GetSelectString() { return "SELECT TOP 100 PERCENT [RDF.].[Node].[NodeID], [RDF.].[Node].[ValueHash], [RDF.].[Node].[Language], [RDF.].[Node].[DataType], [RDF.].[Node].[Value], [RDF.].[Node].[InternalNodeMapID], [RDF.].[Node].[ObjectType], [RDF.].[Node].[ViewSecurityGroup], [RDF.].[Node].[EditSecurityGroup]"; } 
 
        /*! Method to get identity(s) of the newly added database record. */
        public override void GetIdentity(System.Data.Common.DbCommand sqlCommand, ProfilesRNSDLL.BO.RDF.Node businessObj)
        { 
            businessObj.NodeID = long.Parse(sqlCommand.Parameters["@NodeID"].Value.ToString()); 
        } 
 
        /*! Method to create parameters in order to add or edit a record. */
        public override void GetParamsPrimaryKey(ref System.Data.Common.DbCommand cmd, ProfilesRNSDLL.BO.RDF.Node bo) 
        { 
            AddParam(ref cmd, "@NodeID", bo.NodeID);
        } 
 
        internal ProfilesRNSDLL.BO.RDF.Node GetByValueHash(System.Byte[] ValueHash) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[RDF.].cg2_NodeGetByValueHash");
            AddParam(ref cmd, "@ValueHash", ValueHash);
            return PopulateFromRow(FillTable(cmd), 0); 
        } 
        internal ProfilesRNSDLL.BO.RDF.Node Get(long NodeID) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[RDF.].cg2_NodeGet");
            AddParam(ref cmd, "@NodeID", NodeID);
            return PopulateFromRow(FillTable(cmd), 0); 
        } 
 
        /*! Method to create a Node object from a row in a dataset. */
        public override ProfilesRNSDLL.BO.RDF.Node PopulateFromRow(System.Data.DataRow dr) 
        { 
            ProfilesRNSDLL.BO.RDF.Node bo = new ProfilesRNSDLL.BO.RDF.Node();
            bo.NodeID = long.Parse(dr["NodeID"].ToString()); 
            bo.ValueHash = (System.Byte[])dr["ValueHash"]; 
            if(!dr.IsNull("Language"))
            { 
                 bo.Language = dr["Language"].ToString(); 
            } 
            if(!dr.IsNull("DataType"))
            { 
                 bo.DataType = dr["DataType"].ToString(); 
            } 
            bo.Value = dr["Value"].ToString(); 
            if(!dr.IsNull("InternalNodeMapID"))
            { 
                 bo.InternalNodeMapID = int.Parse(dr["InternalNodeMapID"].ToString()); 
            } 
            if(!dr.IsNull("ObjectType"))
            { 
                 bo.ObjectType = bool.Parse(dr["ObjectType"].ToString()); 
            } 
            if(!dr.IsNull("ViewSecurityGroup"))
            { 
                 bo.ViewSecurityGroup = long.Parse(dr["ViewSecurityGroup"].ToString()); 
            } 
            if(!dr.IsNull("EditSecurityGroup"))
            { 
                 bo.EditSecurityGroup = long.Parse(dr["EditSecurityGroup"].ToString()); 
            } 
            bo.Exists = true;
            return bo;
        } 
     
        /*! Method to get the business object before the datachange. */
        protected override ProfilesRNSDLL.BO.RDF.Node GetBOBefore(ProfilesRNSDLL.BO.RDF.Node businessObj)
        { 
            return this.Get(businessObj.NodeID);
        } 
 
        # endregion // internal Method 
 
    } 
 
} 
