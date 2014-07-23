using System; 
using System.Collections.Generic; 
using System.Data; 
using System.Data.Common; 
using System.Linq; 
using System.Text;
using System.Reflection;
using System.Diagnostics;
 
namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DAL.Profile.Data
{ 
    public partial class Person : DALGeneric<ProfilesRNSDLL.BO.Profile.Data.Person>
    { 
     
        # region Constructors 
    
        internal Person() : base() { } 
    
        # endregion // Constructors
     
        # region Methods 
 
        /*! Method to create parameters in order to add or edit a record. */
        public override void GetParamsAll(ref System.Data.Common.DbCommand cmd, ProfilesRNSDLL.BO.Profile.Data.Person bo) 
        { 
            DbParameter Parm = cmd.CreateParameter(); 
            Parm.ParameterName = "@PersonID";
            Parm.Size = 4;
            Parm.DbType = System.Data.DbType.Int32;
            if(!bo.PersonIDIsNull) {
                 Parm.Direction = System.Data.ParameterDirection.InputOutput; 
                 Parm.Value = bo.PersonID;
            } else { 
                 Parm.Direction = System.Data.ParameterDirection.Output; 
            }  
            cmd.Parameters.Add(Parm);
            if(!bo.UserIDIsNull) {
                 AddParam(ref cmd, "@UserID", bo.UserID);
            } 
            if(!bo.FirstNameIsNull) {
                 AddParam(ref cmd, "@FirstName", bo.FirstName);
            } 
            if(!bo.LastNameIsNull) {
                 AddParam(ref cmd, "@LastName", bo.LastName);
            } 
            if(!bo.MiddleNameIsNull) {
                 AddParam(ref cmd, "@MiddleName", bo.MiddleName);
            } 
            if(!bo.DisplayNameIsNull) {
                 AddParam(ref cmd, "@DisplayName", bo.DisplayName);
            } 
            if(!bo.SuffixIsNull) {
                 AddParam(ref cmd, "@Suffix", bo.Suffix);
            } 
            if(!bo.IsActiveIsNull) {
                 AddParam(ref cmd, "@IsActive", bo.IsActive);
            } 
            if(!bo.EmailAddrIsNull) {
                 AddParam(ref cmd, "@EmailAddr", bo.EmailAddr);
            } 
            if(!bo.PhoneIsNull) {
                 AddParam(ref cmd, "@Phone", bo.Phone);
            } 
            if(!bo.FaxIsNull) {
                 AddParam(ref cmd, "@Fax", bo.Fax);
            } 
            if(!bo.AddressLine1IsNull) {
                 AddParam(ref cmd, "@AddressLine1", bo.AddressLine1);
            } 
            if(!bo.AddressLine2IsNull) {
                 AddParam(ref cmd, "@AddressLine2", bo.AddressLine2);
            } 
            if(!bo.AddressLine3IsNull) {
                 AddParam(ref cmd, "@AddressLine3", bo.AddressLine3);
            } 
            if(!bo.AddressLine4IsNull) {
                 AddParam(ref cmd, "@AddressLine4", bo.AddressLine4);
            } 
            if(!bo.CityIsNull) {
                 AddParam(ref cmd, "@City", bo.City);
            } 
            if(!bo.StateIsNull) {
                 AddParam(ref cmd, "@State", bo.State);
            } 
            if(!bo.ZipIsNull) {
                 AddParam(ref cmd, "@Zip", bo.Zip);
            } 
            if(!bo.BuildingIsNull) {
                 AddParam(ref cmd, "@Building", bo.Building);
            } 
            if(!bo.FloorIsNull) {
                 AddParam(ref cmd, "@Floor", bo.Floor);
            } 
            if(!bo.RoomIsNull) {
                 AddParam(ref cmd, "@Room", bo.Room);
            } 
            if(!bo.AddressStringIsNull) {
                 AddParam(ref cmd, "@AddressString", bo.AddressString);
            } 
            if(!bo.LatitudeIsNull) {
                 AddParam(ref cmd, "@Latitude", bo.Latitude);
            } 
            if(!bo.LongitudeIsNull) {
                 AddParam(ref cmd, "@Longitude", bo.Longitude);
            } 
            if(!bo.GeoScoreIsNull) {
                 AddParam(ref cmd, "@GeoScore", bo.GeoScore);
            } 
            if(!bo.FacultyRankIDIsNull) {
                 AddParam(ref cmd, "@FacultyRankID", bo.FacultyRankID);
            } 
            if(!bo.InternalUsernameIsNull) {
                 AddParam(ref cmd, "@InternalUsername", bo.InternalUsername);
            } 
            if(!bo.VisibleIsNull) {
                 AddParam(ref cmd, "@Visible", bo.Visible);
            } 
        } 
 
        /*! Method to log changes to fields in a record. */
        public override void LogIfNecessary(DevelopmentBase.BaseClassBO.RecordLevelAuditTypes auditType, ProfilesRNSDLL.BO.Profile.Data.Person boBefore, ProfilesRNSDLL.BO.Profile.Data.Person bo, DbTransaction trans) 
        { 
            int recordLevelAuditTrailID = 0;
            if (auditType == DevelopmentBase.BaseClassBO.RecordLevelAuditTypes.Deleted)
            {
                recordLevelAuditTrailID = AddRecordLevelAuditTrail(bo.TableId, boBefore.PersonID, auditType, trans);
            }
            else
            {
                recordLevelAuditTrailID = AddRecordLevelAuditTrail(bo.TableId, bo.PersonID, auditType, trans);
            }
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Data.Person.FieldNames.UserID, bo.UserIDIsNull, boBefore.UserIDIsNull, bo.UserID, boBefore.UserID, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Data.Person.FieldNames.FirstName, bo.FirstNameIsNull, boBefore.FirstNameIsNull, bo.FirstName, boBefore.FirstName, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Data.Person.FieldNames.LastName, bo.LastNameIsNull, boBefore.LastNameIsNull, bo.LastName, boBefore.LastName, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Data.Person.FieldNames.MiddleName, bo.MiddleNameIsNull, boBefore.MiddleNameIsNull, bo.MiddleName, boBefore.MiddleName, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Data.Person.FieldNames.DisplayName, bo.DisplayNameIsNull, boBefore.DisplayNameIsNull, bo.DisplayName, boBefore.DisplayName, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Data.Person.FieldNames.Suffix, bo.SuffixIsNull, boBefore.SuffixIsNull, bo.Suffix, boBefore.Suffix, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Data.Person.FieldNames.IsActive, bo.IsActiveIsNull, boBefore.IsActiveIsNull, bo.IsActive, boBefore.IsActive, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Data.Person.FieldNames.EmailAddr, bo.EmailAddrIsNull, boBefore.EmailAddrIsNull, bo.EmailAddr, boBefore.EmailAddr, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Data.Person.FieldNames.Phone, bo.PhoneIsNull, boBefore.PhoneIsNull, bo.Phone, boBefore.Phone, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Data.Person.FieldNames.Fax, bo.FaxIsNull, boBefore.FaxIsNull, bo.Fax, boBefore.Fax, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Data.Person.FieldNames.AddressLine1, bo.AddressLine1IsNull, boBefore.AddressLine1IsNull, bo.AddressLine1, boBefore.AddressLine1, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Data.Person.FieldNames.AddressLine2, bo.AddressLine2IsNull, boBefore.AddressLine2IsNull, bo.AddressLine2, boBefore.AddressLine2, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Data.Person.FieldNames.AddressLine3, bo.AddressLine3IsNull, boBefore.AddressLine3IsNull, bo.AddressLine3, boBefore.AddressLine3, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Data.Person.FieldNames.AddressLine4, bo.AddressLine4IsNull, boBefore.AddressLine4IsNull, bo.AddressLine4, boBefore.AddressLine4, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Data.Person.FieldNames.City, bo.CityIsNull, boBefore.CityIsNull, bo.City, boBefore.City, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Data.Person.FieldNames.State, bo.StateIsNull, boBefore.StateIsNull, bo.State, boBefore.State, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Data.Person.FieldNames.Zip, bo.ZipIsNull, boBefore.ZipIsNull, bo.Zip, boBefore.Zip, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Data.Person.FieldNames.Building, bo.BuildingIsNull, boBefore.BuildingIsNull, bo.Building, boBefore.Building, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Data.Person.FieldNames.Floor, bo.FloorIsNull, boBefore.FloorIsNull, bo.Floor, boBefore.Floor, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Data.Person.FieldNames.Room, bo.RoomIsNull, boBefore.RoomIsNull, bo.Room, boBefore.Room, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Data.Person.FieldNames.AddressString, bo.AddressStringIsNull, boBefore.AddressStringIsNull, bo.AddressString, boBefore.AddressString, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Data.Person.FieldNames.Latitude, bo.LatitudeIsNull, boBefore.LatitudeIsNull, bo.Latitude, boBefore.Latitude, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Data.Person.FieldNames.Longitude, bo.LongitudeIsNull, boBefore.LongitudeIsNull, bo.Longitude, boBefore.Longitude, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Data.Person.FieldNames.GeoScore, bo.GeoScoreIsNull, boBefore.GeoScoreIsNull, bo.GeoScore, boBefore.GeoScore, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Data.Person.FieldNames.FacultyRankID, bo.FacultyRankIDIsNull, boBefore.FacultyRankIDIsNull, bo.FacultyRankID, boBefore.FacultyRankID, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Data.Person.FieldNames.InternalUsername, bo.InternalUsernameIsNull, boBefore.InternalUsernameIsNull, bo.InternalUsername, boBefore.InternalUsername, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Data.Person.FieldNames.Visible, bo.VisibleIsNull, boBefore.VisibleIsNull, bo.Visible, boBefore.Visible, trans);
        } 
 
        /*! Method to get the fields in the table in a select string. */
        internal static string GetSelectString() { return "SELECT TOP 100 PERCENT [Profile.Data].[Person].[PersonID], [Profile.Data].[Person].[UserID], [Profile.Data].[Person].[FirstName], [Profile.Data].[Person].[LastName], [Profile.Data].[Person].[MiddleName], [Profile.Data].[Person].[DisplayName], [Profile.Data].[Person].[Suffix], [Profile.Data].[Person].[IsActive], [Profile.Data].[Person].[EmailAddr], [Profile.Data].[Person].[Phone], [Profile.Data].[Person].[Fax], [Profile.Data].[Person].[AddressLine1], [Profile.Data].[Person].[AddressLine2], [Profile.Data].[Person].[AddressLine3], [Profile.Data].[Person].[AddressLine4], [Profile.Data].[Person].[City], [Profile.Data].[Person].[State], [Profile.Data].[Person].[Zip], [Profile.Data].[Person].[Building], [Profile.Data].[Person].[Floor], [Profile.Data].[Person].[Room], [Profile.Data].[Person].[AddressString], [Profile.Data].[Person].[Latitude], [Profile.Data].[Person].[Longitude], [Profile.Data].[Person].[GeoScore], [Profile.Data].[Person].[FacultyRankID], [Profile.Data].[Person].[InternalUsername], [Profile.Data].[Person].[Visible]"; } 
 
        /*! Method to get identity(s) of the newly added database record. */
        public override void GetIdentity(System.Data.Common.DbCommand sqlCommand, ProfilesRNSDLL.BO.Profile.Data.Person businessObj)
        { 
            businessObj.PersonID = int.Parse(sqlCommand.Parameters["@PersonID"].Value.ToString()); 
        } 
 
        /*! Method to create parameters in order to add or edit a record. */
        public override void GetParamsPrimaryKey(ref System.Data.Common.DbCommand cmd, ProfilesRNSDLL.BO.Profile.Data.Person bo) 
        { 
            AddParam(ref cmd, "@PersonID", bo.PersonID);
        } 
 
        internal ProfilesRNSDLL.BO.Profile.Data.Person GetByInternalUsername(string InternalUsername) 
        {
            System.Data.Common.DbCommand cmd = GetCommand("sp_executesql");
            AddParam(ref cmd, "@stmt", "SELECT TOP 100 PERCENT [Profile.Data].[Person].[PersonID], [Profile.Data].[Person].[UserID], [Profile.Data].[Person].[FirstName], [Profile.Data].[Person].[LastName], [Profile.Data].[Person].[MiddleName], [Profile.Data].[Person].[DisplayName], [Profile.Data].[Person].[Suffix], [Profile.Data].[Person].[IsActive], [Profile.Data].[Person].[EmailAddr], [Profile.Data].[Person].[Phone], [Profile.Data].[Person].[Fax], [Profile.Data].[Person].[AddressLine1], [Profile.Data].[Person].[AddressLine2], [Profile.Data].[Person].[AddressLine3], [Profile.Data].[Person].[AddressLine4], [Profile.Data].[Person].[City], [Profile.Data].[Person].[State], [Profile.Data].[Person].[Zip], [Profile.Data].[Person].[Building], [Profile.Data].[Person].[Floor], [Profile.Data].[Person].[Room], [Profile.Data].[Person].[AddressString], [Profile.Data].[Person].[Latitude], [Profile.Data].[Person].[Longitude], [Profile.Data].[Person].[GeoScore], [Profile.Data].[Person].[FacultyRankID], [Profile.Data].[Person].[InternalUsername], [Profile.Data].[Person].[Visible] FROM [Profile.Data].[Person] WHERE [Profile.Data].[Person].[InternalUsername] = '" + InternalUsername + "'");
            return PopulateFromRow(FillTable(cmd), 0); 
        } 
        internal ProfilesRNSDLL.BO.Profile.Data.Person Get(int PersonID) 
        {
            System.Data.Common.DbCommand cmd = GetCommand("sp_executesql");
            AddParam(ref cmd, "@stmt", "SELECT TOP 100 PERCENT [Profile.Data].[Person].[PersonID], [Profile.Data].[Person].[UserID], [Profile.Data].[Person].[FirstName], [Profile.Data].[Person].[LastName], [Profile.Data].[Person].[MiddleName], [Profile.Data].[Person].[DisplayName], [Profile.Data].[Person].[Suffix], [Profile.Data].[Person].[IsActive], [Profile.Data].[Person].[EmailAddr], [Profile.Data].[Person].[Phone], [Profile.Data].[Person].[Fax], [Profile.Data].[Person].[AddressLine1], [Profile.Data].[Person].[AddressLine2], [Profile.Data].[Person].[AddressLine3], [Profile.Data].[Person].[AddressLine4], [Profile.Data].[Person].[City], [Profile.Data].[Person].[State], [Profile.Data].[Person].[Zip], [Profile.Data].[Person].[Building], [Profile.Data].[Person].[Floor], [Profile.Data].[Person].[Room], [Profile.Data].[Person].[AddressString], [Profile.Data].[Person].[Latitude], [Profile.Data].[Person].[Longitude], [Profile.Data].[Person].[GeoScore], [Profile.Data].[Person].[FacultyRankID], [Profile.Data].[Person].[InternalUsername], [Profile.Data].[Person].[Visible] FROM [Profile.Data].[Person] WHERE [Profile.Data].[Person].[PersonID] = " + PersonID);
            return PopulateFromRow(FillTable(cmd), 0); 
        } 
 
        /*! Method to create a Person object from a row in a dataset. */
        public override ProfilesRNSDLL.BO.Profile.Data.Person PopulateFromRow(System.Data.DataRow dr) 
        { 
            ProfilesRNSDLL.BO.Profile.Data.Person bo = new ProfilesRNSDLL.BO.Profile.Data.Person();
            bo.PersonID = int.Parse(dr["PersonID"].ToString()); 
            if(!dr.IsNull("UserID"))
            { 
                 bo.UserID = int.Parse(dr["UserID"].ToString()); 
            } 
            if(!dr.IsNull("FirstName"))
            { 
                 bo.FirstName = dr["FirstName"].ToString(); 
            } 
            if(!dr.IsNull("LastName"))
            { 
                 bo.LastName = dr["LastName"].ToString(); 
            } 
            if(!dr.IsNull("MiddleName"))
            { 
                 bo.MiddleName = dr["MiddleName"].ToString(); 
            } 
            if(!dr.IsNull("DisplayName"))
            { 
                 bo.DisplayName = dr["DisplayName"].ToString(); 
            } 
            if(!dr.IsNull("Suffix"))
            { 
                 bo.Suffix = dr["Suffix"].ToString(); 
            } 
            if(!dr.IsNull("IsActive"))
            { 
                 bo.IsActive = bool.Parse(dr["IsActive"].ToString()); 
            } 
            if(!dr.IsNull("EmailAddr"))
            { 
                 bo.EmailAddr = dr["EmailAddr"].ToString(); 
            } 
            if(!dr.IsNull("Phone"))
            { 
                 bo.Phone = dr["Phone"].ToString(); 
            } 
            if(!dr.IsNull("Fax"))
            { 
                 bo.Fax = dr["Fax"].ToString(); 
            } 
            if(!dr.IsNull("AddressLine1"))
            { 
                 bo.AddressLine1 = dr["AddressLine1"].ToString(); 
            } 
            if(!dr.IsNull("AddressLine2"))
            { 
                 bo.AddressLine2 = dr["AddressLine2"].ToString(); 
            } 
            if(!dr.IsNull("AddressLine3"))
            { 
                 bo.AddressLine3 = dr["AddressLine3"].ToString(); 
            } 
            if(!dr.IsNull("AddressLine4"))
            { 
                 bo.AddressLine4 = dr["AddressLine4"].ToString(); 
            } 
            if(!dr.IsNull("City"))
            { 
                 bo.City = dr["City"].ToString(); 
            } 
            if(!dr.IsNull("State"))
            { 
                 bo.State = dr["State"].ToString(); 
            } 
            if(!dr.IsNull("Zip"))
            { 
                 bo.Zip = dr["Zip"].ToString(); 
            } 
            if(!dr.IsNull("Building"))
            { 
                 bo.Building = dr["Building"].ToString(); 
            } 
            if(!dr.IsNull("Floor"))
            { 
                 bo.Floor = int.Parse(dr["Floor"].ToString()); 
            } 
            if(!dr.IsNull("Room"))
            { 
                 bo.Room = dr["Room"].ToString(); 
            } 
            if(!dr.IsNull("AddressString"))
            { 
                 bo.AddressString = dr["AddressString"].ToString(); 
            } 
            if(!dr.IsNull("Latitude"))
            { 
                 bo.Latitude = double.Parse(dr["Latitude"].ToString()); 
            } 
            if(!dr.IsNull("Longitude"))
            { 
                 bo.Longitude = double.Parse(dr["Longitude"].ToString()); 
            } 
            if(!dr.IsNull("GeoScore"))
            { 
                 bo.GeoScore = int.Parse(dr["GeoScore"].ToString()); 
            } 
            if(!dr.IsNull("FacultyRankID"))
            { 
                 bo.FacultyRankID = int.Parse(dr["FacultyRankID"].ToString()); 
            } 
            if(!dr.IsNull("InternalUsername"))
            { 
                 bo.InternalUsername = dr["InternalUsername"].ToString(); 
            } 
            if(!dr.IsNull("Visible"))
            { 
                 bo.Visible = bool.Parse(dr["Visible"].ToString()); 
            } 
            bo.Exists = true;
            return bo;
        } 
     
        /*! Method to get the business object before the datachange. */
        protected override ProfilesRNSDLL.BO.Profile.Data.Person GetBOBefore(ProfilesRNSDLL.BO.Profile.Data.Person businessObj)
        { 
            return this.Get(businessObj.PersonID);
        } 
 
        # endregion // internal Method 
 
    } 
 
} 
