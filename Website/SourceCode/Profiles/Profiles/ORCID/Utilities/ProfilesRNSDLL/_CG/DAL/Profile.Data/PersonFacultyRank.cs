using System.Data.Common;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DAL.Profile.Data
{
    public partial class PersonFacultyRank : DALGeneric<ProfilesRNSDLL.BO.Profile.Data.PersonFacultyRank>
    { 
     
        # region Constructors 
    
        internal PersonFacultyRank() : base() { } 
    
        # endregion // Constructors
     
        # region Methods 
 
        /*! Method to create parameters in order to add or edit a record. */
        public override void GetParamsAll(ref System.Data.Common.DbCommand cmd, ProfilesRNSDLL.BO.Profile.Data.PersonFacultyRank bo) 
        { 
            DbParameter Parm = cmd.CreateParameter(); 
            Parm.ParameterName = "@FacultyRankID";
            Parm.Size = 4;
            Parm.DbType = System.Data.DbType.Int32;
            if(!bo.FacultyRankIDIsNull) {
                 Parm.Direction = System.Data.ParameterDirection.InputOutput; 
                 Parm.Value = bo.FacultyRankID;
            } else { 
                 Parm.Direction = System.Data.ParameterDirection.Output; 
            }  
            cmd.Parameters.Add(Parm);
            if(!bo.FacultyRankIsNull) {
                 AddParam(ref cmd, "@FacultyRank", bo.FacultyRank);
            } 
            if(!bo.FacultyRankSortIsNull) {
                 AddParam(ref cmd, "@FacultyRankSort", bo.FacultyRankSort);
            } 
            if(!bo.VisibleIsNull) {
                 AddParam(ref cmd, "@Visible", bo.Visible);
            } 
        } 
 
        /*! Method to log changes to fields in a record. */
        public override void LogIfNecessary(DevelopmentBase.BaseClassBO.RecordLevelAuditTypes auditType, ProfilesRNSDLL.BO.Profile.Data.PersonFacultyRank boBefore, ProfilesRNSDLL.BO.Profile.Data.PersonFacultyRank bo, DbTransaction trans) 
        { 
            int recordLevelAuditTrailID = 0;
            if (auditType == DevelopmentBase.BaseClassBO.RecordLevelAuditTypes.Deleted)
            {
                recordLevelAuditTrailID = AddRecordLevelAuditTrail(bo.TableId, boBefore.FacultyRankID, auditType, trans);
            }
            else
            {
                recordLevelAuditTrailID = AddRecordLevelAuditTrail(bo.TableId, bo.FacultyRankID, auditType, trans);
            }
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Data.PersonFacultyRank.FieldNames.FacultyRank, bo.FacultyRankIsNull, boBefore.FacultyRankIsNull, bo.FacultyRank, boBefore.FacultyRank, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Data.PersonFacultyRank.FieldNames.FacultyRankSort, bo.FacultyRankSortIsNull, boBefore.FacultyRankSortIsNull, bo.FacultyRankSort, boBefore.FacultyRankSort, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Data.PersonFacultyRank.FieldNames.Visible, bo.VisibleIsNull, boBefore.VisibleIsNull, bo.Visible, boBefore.Visible, trans);
        } 
 
        /*! Method to get the fields in the table in a select string. */
        internal static string GetSelectString() { return "SELECT TOP 100 PERCENT [Profile.Data].[Person.FacultyRank].[FacultyRankID], [Profile.Data].[Person.FacultyRank].[FacultyRank], [Profile.Data].[Person.FacultyRank].[FacultyRankSort], [Profile.Data].[Person.FacultyRank].[Visible]"; } 
 
        /*! Method to get identity(s) of the newly added database record. */
        public override void GetIdentity(System.Data.Common.DbCommand sqlCommand, ProfilesRNSDLL.BO.Profile.Data.PersonFacultyRank businessObj)
        { 
            businessObj.FacultyRankID = int.Parse(sqlCommand.Parameters["@FacultyRankID"].Value.ToString()); 
        } 
 
        /*! Method to create parameters in order to add or edit a record. */
        public override void GetParamsPrimaryKey(ref System.Data.Common.DbCommand cmd, ProfilesRNSDLL.BO.Profile.Data.PersonFacultyRank bo) 
        { 
            AddParam(ref cmd, "@FacultyRankID", bo.FacultyRankID);
        } 
 
        internal ProfilesRNSDLL.BO.Profile.Data.PersonFacultyRank Get(int FacultyRankID) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[Profile.Data].cg2_PersonFacultyRankGet");
            AddParam(ref cmd, "@FacultyRankID", FacultyRankID);
            return PopulateFromRow(FillTable(cmd), 0); 
        } 
 
        /*! Method to create a PersonFacultyRank object from a row in a dataset. */
        public override ProfilesRNSDLL.BO.Profile.Data.PersonFacultyRank PopulateFromRow(System.Data.DataRow dr) 
        { 
            ProfilesRNSDLL.BO.Profile.Data.PersonFacultyRank bo = new ProfilesRNSDLL.BO.Profile.Data.PersonFacultyRank();
            bo.FacultyRankID = int.Parse(dr["FacultyRankID"].ToString()); 
            if(!dr.IsNull("FacultyRank"))
            { 
                 bo.FacultyRank = dr["FacultyRank"].ToString(); 
            } 
            if(!dr.IsNull("FacultyRankSort"))
            { 
                 bo.FacultyRankSort = int.Parse(dr["FacultyRankSort"].ToString()); 
            } 
            if(!dr.IsNull("Visible"))
            { 
                 bo.Visible = bool.Parse(dr["Visible"].ToString()); 
            } 
            bo.Exists = true;
            return bo;
        } 
     
        /*! Method to get the business object before the datachange. */
        protected override ProfilesRNSDLL.BO.Profile.Data.PersonFacultyRank GetBOBefore(ProfilesRNSDLL.BO.Profile.Data.PersonFacultyRank businessObj)
        { 
            return this.Get(businessObj.FacultyRankID);
        } 
 
        # endregion // internal Method 
 
    } 
 
} 
