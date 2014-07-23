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
    public partial class Triple : DALGeneric<ProfilesRNSDLL.BO.RDF.Triple>
    { 
     
        # region Constructors 
    
        internal Triple() : base() { } 
    
        # endregion // Constructors
     
        # region Methods 
 
        /*! Method to create parameters in order to add or edit a record. */
        public override void GetParamsAll(ref System.Data.Common.DbCommand cmd, ProfilesRNSDLL.BO.RDF.Triple bo) 
        { 
            DbParameter Parm = cmd.CreateParameter(); 
            Parm.ParameterName = "@TripleID";
            Parm.Size = 8;
            Parm.DbType = System.Data.DbType.Int64;
            if(!bo.TripleIDIsNull) {
                 Parm.Direction = System.Data.ParameterDirection.InputOutput; 
                 Parm.Value = bo.TripleID;
            } else { 
                 Parm.Direction = System.Data.ParameterDirection.Output; 
            }  
            cmd.Parameters.Add(Parm);
            AddParam(ref cmd, "@Subject", bo.Subject);
            AddParam(ref cmd, "@Predicate", bo.Predicate);
            AddParam(ref cmd, "@Object", bo.Object);
            AddParam(ref cmd, "@TripleHash", bo.TripleHash);
            AddParam(ref cmd, "@Weight", bo.Weight);
            if(!bo.ReitificationIsNull) {
                 AddParam(ref cmd, "@Reitification", bo.Reitification);
            } 
            if(!bo.ObjectTypeIsNull) {
                 AddParam(ref cmd, "@ObjectType", bo.ObjectType);
            } 
            if(!bo.SortOrderIsNull) {
                 AddParam(ref cmd, "@SortOrder", bo.SortOrder);
            } 
            if(!bo.ViewSecurityGroupIsNull) {
                 AddParam(ref cmd, "@ViewSecurityGroup", bo.ViewSecurityGroup);
            } 
            if(!bo.GraphIsNull) {
                 AddParam(ref cmd, "@Graph", bo.Graph);
            } 
        } 
 
        /*! Method to log changes to fields in a record. */
        public override void LogIfNecessary(DevelopmentBase.BaseClassBO.RecordLevelAuditTypes auditType, ProfilesRNSDLL.BO.RDF.Triple boBefore, ProfilesRNSDLL.BO.RDF.Triple bo, DbTransaction trans) 
        { 
            int recordLevelAuditTrailID = 0;
            if (auditType == DevelopmentBase.BaseClassBO.RecordLevelAuditTypes.Deleted)
            {
                recordLevelAuditTrailID = AddRecordLevelAuditTrail(bo.TableId, boBefore.TripleID, auditType, trans);
            }
            else
            {
                recordLevelAuditTrailID = AddRecordLevelAuditTrail(bo.TableId, bo.TripleID, auditType, trans);
            }
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.RDF.Triple.FieldNames.Subject, bo.SubjectIsNull, boBefore.SubjectIsNull, bo.Subject, boBefore.Subject, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.RDF.Triple.FieldNames.Predicate, bo.PredicateIsNull, boBefore.PredicateIsNull, bo.Predicate, boBefore.Predicate, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.RDF.Triple.FieldNames.Object, bo.ObjectIsNull, boBefore.ObjectIsNull, bo.Object, boBefore.Object, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.RDF.Triple.FieldNames.TripleHash, bo.TripleHashIsNull, boBefore.TripleHashIsNull, bo.TripleHash, boBefore.TripleHash, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.RDF.Triple.FieldNames.Weight, bo.WeightIsNull, boBefore.WeightIsNull, bo.Weight, boBefore.Weight, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.RDF.Triple.FieldNames.Reitification, bo.ReitificationIsNull, boBefore.ReitificationIsNull, bo.Reitification, boBefore.Reitification, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.RDF.Triple.FieldNames.ObjectType, bo.ObjectTypeIsNull, boBefore.ObjectTypeIsNull, bo.ObjectType, boBefore.ObjectType, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.RDF.Triple.FieldNames.SortOrder, bo.SortOrderIsNull, boBefore.SortOrderIsNull, bo.SortOrder, boBefore.SortOrder, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.RDF.Triple.FieldNames.ViewSecurityGroup, bo.ViewSecurityGroupIsNull, boBefore.ViewSecurityGroupIsNull, bo.ViewSecurityGroup, boBefore.ViewSecurityGroup, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.RDF.Triple.FieldNames.Graph, bo.GraphIsNull, boBefore.GraphIsNull, bo.Graph, boBefore.Graph, trans);
        } 
 
        /*! Method to get the fields in the table in a select string. */
        internal static string GetSelectString() { return "SELECT TOP 100 PERCENT [RDF.].[Triple].[TripleID], [RDF.].[Triple].[Subject], [RDF.].[Triple].[Predicate], [RDF.].[Triple].[Object], [RDF.].[Triple].[TripleHash], [RDF.].[Triple].[Weight], [RDF.].[Triple].[Reitification], [RDF.].[Triple].[ObjectType], [RDF.].[Triple].[SortOrder], [RDF.].[Triple].[ViewSecurityGroup], [RDF.].[Triple].[Graph]"; } 
 
        /*! Method to get identity(s) of the newly added database record. */
        public override void GetIdentity(System.Data.Common.DbCommand sqlCommand, ProfilesRNSDLL.BO.RDF.Triple businessObj)
        { 
            businessObj.TripleID = long.Parse(sqlCommand.Parameters["@TripleID"].Value.ToString()); 
        } 
 
        /*! Method to create parameters in order to add or edit a record. */
        public override void GetParamsPrimaryKey(ref System.Data.Common.DbCommand cmd, ProfilesRNSDLL.BO.RDF.Triple bo) 
        { 
            AddParam(ref cmd, "@TripleID", bo.TripleID);
        } 
 
        internal List<ProfilesRNSDLL.BO.RDF.Triple> GetByPredicateAndViewSecurityGroupAndWeightAndSubjectAndObject(long Predicate, long ViewSecurityGroup, double Weight, long Subject, long Object, bool addBlank) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[RDF.].cg2_TripleGetByPredicateAndViewSecurityGroupAndWeightAndSubjectAndObject");
            AddParam(ref cmd, "@Predicate", Predicate);
            AddParam(ref cmd, "@ViewSecurityGroup", ViewSecurityGroup);
            AddParam(ref cmd, "@Weight", Weight);
            AddParam(ref cmd, "@Subject", Subject);
            AddParam(ref cmd, "@Object", Object);
            return PopulateCollectionObject(FillTable(cmd), addBlank); 
        } 
        internal ProfilesRNSDLL.BO.RDF.Triple GetByPredicateAndObjectAndSubject(long Predicate, long Object, long Subject) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[RDF.].cg2_TripleGetByPredicateAndObjectAndSubject");
            AddParam(ref cmd, "@Predicate", Predicate);
            AddParam(ref cmd, "@Object", Object);
            AddParam(ref cmd, "@Subject", Subject);
            return PopulateFromRow(FillTable(cmd), 0); 
        } 
        internal List<ProfilesRNSDLL.BO.RDF.Triple> GetByReitification(long Reitification, bool addBlank) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[RDF.].cg2_TripleGetByReitification");
            AddParam(ref cmd, "@Reitification", Reitification);
            return PopulateCollectionObject(FillTable(cmd), addBlank); 
        } 
        internal List<ProfilesRNSDLL.BO.RDF.Triple> GetBySubjectAndPredicateAndObject(long Subject, long Predicate, long Object, bool addBlank) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[RDF.].cg2_TripleGetBySubjectAndPredicateAndObject");
            AddParam(ref cmd, "@Subject", Subject);
            AddParam(ref cmd, "@Predicate", Predicate);
            AddParam(ref cmd, "@Object", Object);
            return PopulateCollectionObject(FillTable(cmd), addBlank); 
        } 
        internal List<ProfilesRNSDLL.BO.RDF.Triple> GetByPredicate(long Predicate, bool addBlank) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[RDF.].cg2_TripleGetByPredicate");
            AddParam(ref cmd, "@Predicate", Predicate);
            return PopulateCollectionObject(FillTable(cmd), addBlank); 
        } 
        internal ProfilesRNSDLL.BO.RDF.Triple GetByTripleHash(System.Byte[] TripleHash) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[RDF.].cg2_TripleGetByTripleHash");
            AddParam(ref cmd, "@TripleHash", TripleHash);
            return PopulateFromRow(FillTable(cmd), 0); 
        } 
        internal List<ProfilesRNSDLL.BO.RDF.Triple> GetByObjectAndSubjectAndPredicateAndReitification(long Object, long Subject, long Predicate, long Reitification, bool addBlank) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[RDF.].cg2_TripleGetByObjectAndSubjectAndPredicateAndReitification");
            AddParam(ref cmd, "@Object", Object);
            AddParam(ref cmd, "@Subject", Subject);
            AddParam(ref cmd, "@Predicate", Predicate);
            AddParam(ref cmd, "@Reitification", Reitification);
            return PopulateCollectionObject(FillTable(cmd), addBlank); 
        } 
        internal List<ProfilesRNSDLL.BO.RDF.Triple> GetBySubject(long Subject, bool addBlank) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[RDF.].cg2_TripleGetBySubject");
            AddParam(ref cmd, "@Subject", Subject);
            return PopulateCollectionObject(FillTable(cmd), addBlank); 
        } 
        internal ProfilesRNSDLL.BO.RDF.Triple Get(long TripleID) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[RDF.].cg2_TripleGet");
            AddParam(ref cmd, "@TripleID", TripleID);
            return PopulateFromRow(FillTable(cmd), 0); 
        } 
 
        /*! Method to create a Triple object from a row in a dataset. */
        public override ProfilesRNSDLL.BO.RDF.Triple PopulateFromRow(System.Data.DataRow dr) 
        { 
            ProfilesRNSDLL.BO.RDF.Triple bo = new ProfilesRNSDLL.BO.RDF.Triple();
            bo.TripleID = long.Parse(dr["TripleID"].ToString()); 
            bo.Subject = long.Parse(dr["Subject"].ToString()); 
            bo.Predicate = long.Parse(dr["Predicate"].ToString()); 
            bo.Object = long.Parse(dr["Object"].ToString()); 
            bo.TripleHash = (System.Byte[])dr["TripleHash"]; 
            bo.Weight = double.Parse(dr["Weight"].ToString()); 
            if(!dr.IsNull("Reitification"))
            { 
                 bo.Reitification = long.Parse(dr["Reitification"].ToString()); 
            } 
            if(!dr.IsNull("ObjectType"))
            { 
                 bo.ObjectType = bool.Parse(dr["ObjectType"].ToString()); 
            } 
            if(!dr.IsNull("SortOrder"))
            { 
                 bo.SortOrder = int.Parse(dr["SortOrder"].ToString()); 
            } 
            if(!dr.IsNull("ViewSecurityGroup"))
            { 
                 bo.ViewSecurityGroup = long.Parse(dr["ViewSecurityGroup"].ToString()); 
            } 
            if(!dr.IsNull("Graph"))
            { 
                 bo.Graph = long.Parse(dr["Graph"].ToString()); 
            } 
            bo.Exists = true;
            return bo;
        } 
     
        /*! Method to get the business object before the datachange. */
        protected override ProfilesRNSDLL.BO.RDF.Triple GetBOBefore(ProfilesRNSDLL.BO.RDF.Triple businessObj)
        { 
            return this.Get(businessObj.TripleID);
        } 
 
        # endregion // internal Method 
 
    } 
 
} 
