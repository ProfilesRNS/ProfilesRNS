using System; 
using System.Collections.Generic; 
using System.Data; 
using System.Data.Common; 
using System.Linq; 
using System.Text;
using System.Reflection;
using System.Diagnostics;
using Profiles.ORCID;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DAL.Profile.Import
{ 
    public partial class NIHAwards : DALGeneric<Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.Profile.Import.NIHAwards>
    { 
     
        # region Constructors 
    
        internal NIHAwards() : base() { } 
    
        # endregion // Constructors
     
        # region Methods 
 
        /*! Method to create parameters in order to add or edit a record. */
        public override void GetParamsAll(ref System.Data.Common.DbCommand cmd, Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.Profile.Import.NIHAwards bo) 
        { 
            DbParameter Parm = cmd.CreateParameter(); 
            Parm.ParameterName = "@NIHAwardsID";
            Parm.Size = 4;
            Parm.DbType = System.Data.DbType.Int32;
            if(!bo.NIHAwardsIDIsNull) {
                 Parm.Direction = System.Data.ParameterDirection.InputOutput; 
                 Parm.Value = bo.NIHAwardsID;
            } else { 
                 Parm.Direction = System.Data.ParameterDirection.Output; 
            }  
            cmd.Parameters.Add(Parm);
            AddParam(ref cmd, "@Application_Id", bo.Application_Id);
            AddParam(ref cmd, "@InternalUsername", bo.InternalUsername);
            if(!bo.ActivityIsNull) {
                 AddParam(ref cmd, "@Activity", bo.Activity);
            } 
            if(!bo.Administering_ICIsNull) {
                 AddParam(ref cmd, "@Administering_IC", bo.Administering_IC);
            } 
            if(!bo.Application_TypeIsNull) {
                 AddParam(ref cmd, "@Application_Type", bo.Application_Type);
            } 
            if(!bo.ARRAIsNull) {
                 AddParam(ref cmd, "@ARRA", bo.ARRA);
            } 
            if(!bo.Budget_StartIsNull) {
                 AddParam(ref cmd, "@Budget_Start", bo.Budget_Start);
            } 
            if(!bo.Budget_EndIsNull) {
                 AddParam(ref cmd, "@Budget_End", bo.Budget_End);
            } 
            if(!bo.FOA_NumberIsNull) {
                 AddParam(ref cmd, "@FOA_Number", bo.FOA_Number);
            } 
            if(!bo.Full_Project_Num_DCIsNull) {
                 AddParam(ref cmd, "@Full_Project_Num_DC", bo.Full_Project_Num_DC);
            } 
            if(!bo.SubProject_IdIsNull) {
                 AddParam(ref cmd, "@SubProject_Id", bo.SubProject_Id);
            } 
            if(!bo.Funding_ICsIsNull) {
                 AddParam(ref cmd, "@Funding_ICs", bo.Funding_ICs);
            } 
            if(!bo.FYIsNull) {
                 AddParam(ref cmd, "@FY", bo.FY);
            } 
            if(!bo.IC_NameIsNull) {
                 AddParam(ref cmd, "@IC_Name", bo.IC_Name);
            } 
            if(!bo.NIH_Reporting_CategoriesIsNull) {
                 AddParam(ref cmd, "@NIH_Reporting_Categories", bo.NIH_Reporting_Categories);
            } 
            if(!bo.Org_CityIsNull) {
                 AddParam(ref cmd, "@Org_City", bo.Org_City);
            } 
            if(!bo.Org_CountryIsNull) {
                 AddParam(ref cmd, "@Org_Country", bo.Org_Country);
            } 
            if(!bo.Org_DeptIsNull) {
                 AddParam(ref cmd, "@Org_Dept", bo.Org_Dept);
            } 
            if(!bo.Org_DistrictIsNull) {
                 AddParam(ref cmd, "@Org_District", bo.Org_District);
            } 
            if(!bo.Org_DUNSIsNull) {
                 AddParam(ref cmd, "@Org_DUNS", bo.Org_DUNS);
            } 
            if(!bo.Org_FIPSIsNull) {
                 AddParam(ref cmd, "@Org_FIPS", bo.Org_FIPS);
            } 
            if(!bo.Org_StateIsNull) {
                 AddParam(ref cmd, "@Org_State", bo.Org_State);
            } 
            if(!bo.Org_ZipCodeIsNull) {
                 AddParam(ref cmd, "@Org_ZipCode", bo.Org_ZipCode);
            } 
            if(!bo.OrganizationIsNull) {
                 AddParam(ref cmd, "@Organization", bo.Organization);
            } 
            if(!bo.PI_NamesIsNull) {
                 AddParam(ref cmd, "@PI_Names", bo.PI_Names);
            } 
            if(!bo.PI_PersonIdsIsNull) {
                 AddParam(ref cmd, "@PI_PersonIds", bo.PI_PersonIds);
            } 
            if(!bo.Project_StartIsNull) {
                 AddParam(ref cmd, "@Project_Start", bo.Project_Start);
            } 
            if(!bo.Project_EndIsNull) {
                 AddParam(ref cmd, "@Project_End", bo.Project_End);
            } 
            if(!bo.Project_NumIsNull) {
                 AddParam(ref cmd, "@Project_Num", bo.Project_Num);
            } 
            if(!bo.Project_TermsIsNull) {
                 AddParam(ref cmd, "@Project_Terms", bo.Project_Terms);
            } 
            if(!bo.Project_TitleIsNull) {
                 AddParam(ref cmd, "@Project_Title", bo.Project_Title);
            } 
            if(!bo.RelevanceIsNull) {
                 AddParam(ref cmd, "@Relevance", bo.Relevance);
            } 
            if(!bo.Serial_NumberIsNull) {
                 AddParam(ref cmd, "@Serial_Number", bo.Serial_Number);
            } 
            if(!bo.Study_SectionIsNull) {
                 AddParam(ref cmd, "@Study_Section", bo.Study_Section);
            } 
            if(!bo.Study_Section_NameIsNull) {
                 AddParam(ref cmd, "@Study_Section_Name", bo.Study_Section_Name);
            } 
            if(!bo.SuffixIsNull) {
                 AddParam(ref cmd, "@Suffix", bo.Suffix);
            } 
            if(!bo.Support_YearIsNull) {
                 AddParam(ref cmd, "@Support_Year", bo.Support_Year);
            } 
            if(!bo.Total_CostIsNull) {
                 AddParam(ref cmd, "@Total_Cost", bo.Total_Cost);
            } 
            if(!bo.Total_Cost_Sub_ProjectIsNull) {
                 AddParam(ref cmd, "@Total_Cost_Sub_Project", bo.Total_Cost_Sub_Project);
            } 
            AddParam(ref cmd, "@ImportID", bo.ImportID);
            if(!bo.Major_Component_NameIsNull) {
                 AddParam(ref cmd, "@Major_Component_Name", bo.Major_Component_Name);
            } 
            if(!bo.Award_Notice_DateIsNull) {
                 AddParam(ref cmd, "@Award_Notice_Date", bo.Award_Notice_Date);
            } 
            if(!bo.Core_Project_NumIsNull) {
                 AddParam(ref cmd, "@Core_Project_Num", bo.Core_Project_Num);
            } 
            if(!bo.CFDA_CodeIsNull) {
                 AddParam(ref cmd, "@CFDA_Code", bo.CFDA_Code);
            } 
            if(!bo.Ed_Inst_TypeIsNull) {
                 AddParam(ref cmd, "@Ed_Inst_Type", bo.Ed_Inst_Type);
            } 
            if(!bo.Program_Officer_NameIsNull) {
                 AddParam(ref cmd, "@Program_Officer_Name", bo.Program_Officer_Name);
            } 
            if(!bo.PHRIsNull) {
                 AddParam(ref cmd, "@PHR", bo.PHR);
            } 
            if(!bo.IsBUIsNull) {
                 AddParam(ref cmd, "@IsBU", bo.IsBU);
            } 
            if(!bo.IsBUMCIsNull) {
                 AddParam(ref cmd, "@IsBUMC", bo.IsBUMC);
            } 
            if(!bo.IsBMCIsNull) {
                 AddParam(ref cmd, "@IsBMC", bo.IsBMC);
            } 
            if(!bo.PubCountIsNull) {
                 AddParam(ref cmd, "@PubCount", bo.PubCount);
            } 
        } 
 
        /*! Method to log changes to fields in a record. */
        public override void LogIfNecessary(DevelopmentBase.BaseClassBO.RecordLevelAuditTypes auditType, Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.Profile.Import.NIHAwards boBefore, Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.Profile.Import.NIHAwards bo, DbTransaction trans) 
        { 
            int recordLevelAuditTrailID = 0;
            if (auditType == DevelopmentBase.BaseClassBO.RecordLevelAuditTypes.Deleted)
            {
                recordLevelAuditTrailID = AddRecordLevelAuditTrail(bo.TableId, boBefore.NIHAwardsID, auditType, trans);
            }
            else
            {
                recordLevelAuditTrailID = AddRecordLevelAuditTrail(bo.TableId, bo.NIHAwardsID, auditType, trans);
            }
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Import.NIHAwards.FieldNames.Application_Id, bo.Application_IdIsNull, boBefore.Application_IdIsNull, bo.Application_Id, boBefore.Application_Id, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Import.NIHAwards.FieldNames.InternalUsername, bo.InternalUsernameIsNull, boBefore.InternalUsernameIsNull, bo.InternalUsername, boBefore.InternalUsername, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Import.NIHAwards.FieldNames.Activity, bo.ActivityIsNull, boBefore.ActivityIsNull, bo.Activity, boBefore.Activity, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Import.NIHAwards.FieldNames.Administering_IC, bo.Administering_ICIsNull, boBefore.Administering_ICIsNull, bo.Administering_IC, boBefore.Administering_IC, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Import.NIHAwards.FieldNames.Application_Type, bo.Application_TypeIsNull, boBefore.Application_TypeIsNull, bo.Application_Type, boBefore.Application_Type, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Import.NIHAwards.FieldNames.ARRA, bo.ARRAIsNull, boBefore.ARRAIsNull, bo.ARRA, boBefore.ARRA, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Import.NIHAwards.FieldNames.Budget_Start, bo.Budget_StartIsNull, boBefore.Budget_StartIsNull, bo.Budget_Start, boBefore.Budget_Start, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Import.NIHAwards.FieldNames.Budget_End, bo.Budget_EndIsNull, boBefore.Budget_EndIsNull, bo.Budget_End, boBefore.Budget_End, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Import.NIHAwards.FieldNames.FOA_Number, bo.FOA_NumberIsNull, boBefore.FOA_NumberIsNull, bo.FOA_Number, boBefore.FOA_Number, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Import.NIHAwards.FieldNames.Full_Project_Num_DC, bo.Full_Project_Num_DCIsNull, boBefore.Full_Project_Num_DCIsNull, bo.Full_Project_Num_DC, boBefore.Full_Project_Num_DC, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Import.NIHAwards.FieldNames.SubProject_Id, bo.SubProject_IdIsNull, boBefore.SubProject_IdIsNull, bo.SubProject_Id, boBefore.SubProject_Id, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Import.NIHAwards.FieldNames.Funding_ICs, bo.Funding_ICsIsNull, boBefore.Funding_ICsIsNull, bo.Funding_ICs, boBefore.Funding_ICs, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Import.NIHAwards.FieldNames.FY, bo.FYIsNull, boBefore.FYIsNull, bo.FY, boBefore.FY, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Import.NIHAwards.FieldNames.IC_Name, bo.IC_NameIsNull, boBefore.IC_NameIsNull, bo.IC_Name, boBefore.IC_Name, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Import.NIHAwards.FieldNames.NIH_Reporting_Categories, bo.NIH_Reporting_CategoriesIsNull, boBefore.NIH_Reporting_CategoriesIsNull, bo.NIH_Reporting_Categories, boBefore.NIH_Reporting_Categories, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Import.NIHAwards.FieldNames.Org_City, bo.Org_CityIsNull, boBefore.Org_CityIsNull, bo.Org_City, boBefore.Org_City, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Import.NIHAwards.FieldNames.Org_Country, bo.Org_CountryIsNull, boBefore.Org_CountryIsNull, bo.Org_Country, boBefore.Org_Country, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Import.NIHAwards.FieldNames.Org_Dept, bo.Org_DeptIsNull, boBefore.Org_DeptIsNull, bo.Org_Dept, boBefore.Org_Dept, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Import.NIHAwards.FieldNames.Org_District, bo.Org_DistrictIsNull, boBefore.Org_DistrictIsNull, bo.Org_District, boBefore.Org_District, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Import.NIHAwards.FieldNames.Org_DUNS, bo.Org_DUNSIsNull, boBefore.Org_DUNSIsNull, bo.Org_DUNS, boBefore.Org_DUNS, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Import.NIHAwards.FieldNames.Org_FIPS, bo.Org_FIPSIsNull, boBefore.Org_FIPSIsNull, bo.Org_FIPS, boBefore.Org_FIPS, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Import.NIHAwards.FieldNames.Org_State, bo.Org_StateIsNull, boBefore.Org_StateIsNull, bo.Org_State, boBefore.Org_State, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Import.NIHAwards.FieldNames.Org_ZipCode, bo.Org_ZipCodeIsNull, boBefore.Org_ZipCodeIsNull, bo.Org_ZipCode, boBefore.Org_ZipCode, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Import.NIHAwards.FieldNames.Organization, bo.OrganizationIsNull, boBefore.OrganizationIsNull, bo.Organization, boBefore.Organization, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Import.NIHAwards.FieldNames.PI_Names, bo.PI_NamesIsNull, boBefore.PI_NamesIsNull, bo.PI_Names, boBefore.PI_Names, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Import.NIHAwards.FieldNames.PI_PersonIds, bo.PI_PersonIdsIsNull, boBefore.PI_PersonIdsIsNull, bo.PI_PersonIds, boBefore.PI_PersonIds, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Import.NIHAwards.FieldNames.Project_Start, bo.Project_StartIsNull, boBefore.Project_StartIsNull, bo.Project_Start, boBefore.Project_Start, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Import.NIHAwards.FieldNames.Project_End, bo.Project_EndIsNull, boBefore.Project_EndIsNull, bo.Project_End, boBefore.Project_End, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Import.NIHAwards.FieldNames.Project_Num, bo.Project_NumIsNull, boBefore.Project_NumIsNull, bo.Project_Num, boBefore.Project_Num, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Import.NIHAwards.FieldNames.Project_Terms, bo.Project_TermsIsNull, boBefore.Project_TermsIsNull, bo.Project_Terms, boBefore.Project_Terms, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Import.NIHAwards.FieldNames.Project_Title, bo.Project_TitleIsNull, boBefore.Project_TitleIsNull, bo.Project_Title, boBefore.Project_Title, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Import.NIHAwards.FieldNames.Relevance, bo.RelevanceIsNull, boBefore.RelevanceIsNull, bo.Relevance, boBefore.Relevance, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Import.NIHAwards.FieldNames.Serial_Number, bo.Serial_NumberIsNull, boBefore.Serial_NumberIsNull, bo.Serial_Number, boBefore.Serial_Number, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Import.NIHAwards.FieldNames.Study_Section, bo.Study_SectionIsNull, boBefore.Study_SectionIsNull, bo.Study_Section, boBefore.Study_Section, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Import.NIHAwards.FieldNames.Study_Section_Name, bo.Study_Section_NameIsNull, boBefore.Study_Section_NameIsNull, bo.Study_Section_Name, boBefore.Study_Section_Name, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Import.NIHAwards.FieldNames.Suffix, bo.SuffixIsNull, boBefore.SuffixIsNull, bo.Suffix, boBefore.Suffix, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Import.NIHAwards.FieldNames.Support_Year, bo.Support_YearIsNull, boBefore.Support_YearIsNull, bo.Support_Year, boBefore.Support_Year, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Import.NIHAwards.FieldNames.Total_Cost, bo.Total_CostIsNull, boBefore.Total_CostIsNull, bo.Total_Cost, boBefore.Total_Cost, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Import.NIHAwards.FieldNames.Total_Cost_Sub_Project, bo.Total_Cost_Sub_ProjectIsNull, boBefore.Total_Cost_Sub_ProjectIsNull, bo.Total_Cost_Sub_Project, boBefore.Total_Cost_Sub_Project, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Import.NIHAwards.FieldNames.ImportID, bo.ImportIDIsNull, boBefore.ImportIDIsNull, bo.ImportID, boBefore.ImportID, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Import.NIHAwards.FieldNames.Major_Component_Name, bo.Major_Component_NameIsNull, boBefore.Major_Component_NameIsNull, bo.Major_Component_Name, boBefore.Major_Component_Name, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Import.NIHAwards.FieldNames.Award_Notice_Date, bo.Award_Notice_DateIsNull, boBefore.Award_Notice_DateIsNull, bo.Award_Notice_Date, boBefore.Award_Notice_Date, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Import.NIHAwards.FieldNames.Core_Project_Num, bo.Core_Project_NumIsNull, boBefore.Core_Project_NumIsNull, bo.Core_Project_Num, boBefore.Core_Project_Num, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Import.NIHAwards.FieldNames.CFDA_Code, bo.CFDA_CodeIsNull, boBefore.CFDA_CodeIsNull, bo.CFDA_Code, boBefore.CFDA_Code, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Import.NIHAwards.FieldNames.Ed_Inst_Type, bo.Ed_Inst_TypeIsNull, boBefore.Ed_Inst_TypeIsNull, bo.Ed_Inst_Type, boBefore.Ed_Inst_Type, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Import.NIHAwards.FieldNames.Program_Officer_Name, bo.Program_Officer_NameIsNull, boBefore.Program_Officer_NameIsNull, bo.Program_Officer_Name, boBefore.Program_Officer_Name, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Import.NIHAwards.FieldNames.PHR, bo.PHRIsNull, boBefore.PHRIsNull, bo.PHR, boBefore.PHR, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Import.NIHAwards.FieldNames.IsBU, bo.IsBUIsNull, boBefore.IsBUIsNull, bo.IsBU, boBefore.IsBU, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Import.NIHAwards.FieldNames.IsBUMC, bo.IsBUMCIsNull, boBefore.IsBUMCIsNull, bo.IsBUMC, boBefore.IsBUMC, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Import.NIHAwards.FieldNames.IsBMC, bo.IsBMCIsNull, boBefore.IsBMCIsNull, bo.IsBMC, boBefore.IsBMC, trans);
            LogIfChanged(recordLevelAuditTrailID, (int)ProfilesRNSDLL.BO.Profile.Import.NIHAwards.FieldNames.PubCount, bo.PubCountIsNull, boBefore.PubCountIsNull, bo.PubCount, boBefore.PubCount, trans);
        } 
 
        /*! Method to get the fields in the table in a select string. */
        internal static string GetSelectString() { return "SELECT TOP 100 PERCENT [Profile.Import].[NIHAwards].[NIHAwardsID], [Profile.Import].[NIHAwards].[Application_Id], [Profile.Import].[NIHAwards].[InternalUsername], [Profile.Import].[NIHAwards].[Activity], [Profile.Import].[NIHAwards].[Administering_IC], [Profile.Import].[NIHAwards].[Application_Type], [Profile.Import].[NIHAwards].[ARRA], [Profile.Import].[NIHAwards].[Budget_Start], [Profile.Import].[NIHAwards].[Budget_End], [Profile.Import].[NIHAwards].[FOA_Number], [Profile.Import].[NIHAwards].[Full_Project_Num_DC], [Profile.Import].[NIHAwards].[SubProject_Id], [Profile.Import].[NIHAwards].[Funding_ICs], [Profile.Import].[NIHAwards].[FY], [Profile.Import].[NIHAwards].[IC_Name], [Profile.Import].[NIHAwards].[NIH_Reporting_Categories], [Profile.Import].[NIHAwards].[Org_City], [Profile.Import].[NIHAwards].[Org_Country], [Profile.Import].[NIHAwards].[Org_Dept], [Profile.Import].[NIHAwards].[Org_District], [Profile.Import].[NIHAwards].[Org_DUNS], [Profile.Import].[NIHAwards].[Org_FIPS], [Profile.Import].[NIHAwards].[Org_State], [Profile.Import].[NIHAwards].[Org_ZipCode], [Profile.Import].[NIHAwards].[Organization], [Profile.Import].[NIHAwards].[PI_Names], [Profile.Import].[NIHAwards].[PI_PersonIds], [Profile.Import].[NIHAwards].[Project_Start], [Profile.Import].[NIHAwards].[Project_End], [Profile.Import].[NIHAwards].[Project_Num], [Profile.Import].[NIHAwards].[Project_Terms], [Profile.Import].[NIHAwards].[Project_Title], [Profile.Import].[NIHAwards].[Relevance], [Profile.Import].[NIHAwards].[Serial_Number], [Profile.Import].[NIHAwards].[Study_Section], [Profile.Import].[NIHAwards].[Study_Section_Name], [Profile.Import].[NIHAwards].[Suffix], [Profile.Import].[NIHAwards].[Support_Year], [Profile.Import].[NIHAwards].[Total_Cost], [Profile.Import].[NIHAwards].[Total_Cost_Sub_Project], [Profile.Import].[NIHAwards].[ImportID], [Profile.Import].[NIHAwards].[Major_Component_Name], [Profile.Import].[NIHAwards].[Award_Notice_Date], [Profile.Import].[NIHAwards].[Core_Project_Num], [Profile.Import].[NIHAwards].[CFDA_Code], [Profile.Import].[NIHAwards].[Ed_Inst_Type], [Profile.Import].[NIHAwards].[Program_Officer_Name], [Profile.Import].[NIHAwards].[PHR], [Profile.Import].[NIHAwards].[IsBU], [Profile.Import].[NIHAwards].[IsBUMC], [Profile.Import].[NIHAwards].[IsBMC], [Profile.Import].[NIHAwards].[PubCount]"; } 
 
        /*! Method to get identity(s) of the newly added database record. */
        public override void GetIdentity(System.Data.Common.DbCommand sqlCommand, Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.Profile.Import.NIHAwards businessObj)
        { 
            businessObj.NIHAwardsID = int.Parse(sqlCommand.Parameters["@NIHAwardsID"].Value.ToString()); 
        } 
 
        /*! Method to create parameters in order to add or edit a record. */
        public override void GetParamsPrimaryKey(ref System.Data.Common.DbCommand cmd, Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.Profile.Import.NIHAwards bo) 
        { 
            AddParam(ref cmd, "@NIHAwardsID", bo.NIHAwardsID);
        } 
 
        internal ProfilesRNSDLL.BO.Profile.Import.NIHAwards Get(int NIHAwardsID) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[Profile.Import].cg2_NIHAwardsGet");
            AddParam(ref cmd, "@NIHAwardsID", NIHAwardsID);
            return PopulateFromRow(FillTable(cmd), 0); 
        } 
        internal List<ProfilesRNSDLL.BO.Profile.Import.NIHAwards> GetByInternalUsername(string InternalUsername, bool addBlank) 
        { 
            System.Data.Common.DbCommand cmd = GetCommand("[Profile.Import].cg2_NIHAwardsGetByInternalUsername");
            AddParam(ref cmd, "@InternalUsername", InternalUsername);
            return PopulateCollectionObject(FillTable(cmd), addBlank); 
        } 
 
        /*! Method to create a NIHAwards object from a row in a dataset. */
        public override ProfilesRNSDLL.BO.Profile.Import.NIHAwards PopulateFromRow(System.Data.DataRow dr) 
        { 
            ProfilesRNSDLL.BO.Profile.Import.NIHAwards bo = new ProfilesRNSDLL.BO.Profile.Import.NIHAwards();
            bo.NIHAwardsID = int.Parse(dr["NIHAwardsID"].ToString()); 
            bo.Application_Id = int.Parse(dr["Application_Id"].ToString()); 
            bo.InternalUsername = dr["InternalUsername"].ToString(); 
            if(!dr.IsNull("Activity"))
            { 
                 bo.Activity = dr["Activity"].ToString(); 
            } 
            if(!dr.IsNull("Administering_IC"))
            { 
                 bo.Administering_IC = dr["Administering_IC"].ToString(); 
            } 
            if(!dr.IsNull("Application_Type"))
            { 
                 bo.Application_Type = int.Parse(dr["Application_Type"].ToString()); 
            } 
            if(!dr.IsNull("ARRA"))
            { 
                 bo.ARRA = dr["ARRA"].ToString(); 
            } 
            if(!dr.IsNull("Budget_Start"))
            { 
                 bo.Budget_Start = System.DateTime.Parse(dr["Budget_Start"].ToString()); 
            } 
            if(!dr.IsNull("Budget_End"))
            { 
                 bo.Budget_End = System.DateTime.Parse(dr["Budget_End"].ToString()); 
            } 
            if(!dr.IsNull("FOA_Number"))
            { 
                 bo.FOA_Number = dr["FOA_Number"].ToString(); 
            } 
            if(!dr.IsNull("Full_Project_Num_DC"))
            { 
                 bo.Full_Project_Num_DC = dr["Full_Project_Num_DC"].ToString(); 
            } 
            if(!dr.IsNull("SubProject_Id"))
            { 
                 bo.SubProject_Id = int.Parse(dr["SubProject_Id"].ToString()); 
            } 
            if(!dr.IsNull("Funding_ICs"))
            { 
                 bo.Funding_ICs = dr["Funding_ICs"].ToString(); 
            } 
            if(!dr.IsNull("FY"))
            { 
                 bo.FY = int.Parse(dr["FY"].ToString()); 
            } 
            if(!dr.IsNull("IC_Name"))
            { 
                 bo.IC_Name = dr["IC_Name"].ToString(); 
            } 
            if(!dr.IsNull("NIH_Reporting_Categories"))
            { 
                 bo.NIH_Reporting_Categories = dr["NIH_Reporting_Categories"].ToString(); 
            } 
            if(!dr.IsNull("Org_City"))
            { 
                 bo.Org_City = dr["Org_City"].ToString(); 
            } 
            if(!dr.IsNull("Org_Country"))
            { 
                 bo.Org_Country = dr["Org_Country"].ToString(); 
            } 
            if(!dr.IsNull("Org_Dept"))
            { 
                 bo.Org_Dept = dr["Org_Dept"].ToString(); 
            } 
            if(!dr.IsNull("Org_District"))
            { 
                 bo.Org_District = int.Parse(dr["Org_District"].ToString()); 
            } 
            if(!dr.IsNull("Org_DUNS"))
            { 
                 bo.Org_DUNS = dr["Org_DUNS"].ToString(); 
            } 
            if(!dr.IsNull("Org_FIPS"))
            { 
                 bo.Org_FIPS = dr["Org_FIPS"].ToString(); 
            } 
            if(!dr.IsNull("Org_State"))
            { 
                 bo.Org_State = dr["Org_State"].ToString(); 
            } 
            if(!dr.IsNull("Org_ZipCode"))
            { 
                 bo.Org_ZipCode = dr["Org_ZipCode"].ToString(); 
            } 
            if(!dr.IsNull("Organization"))
            { 
                 bo.Organization = dr["Organization"].ToString(); 
            } 
            if(!dr.IsNull("PI_Names"))
            { 
                 bo.PI_Names = dr["PI_Names"].ToString(); 
            } 
            if(!dr.IsNull("PI_PersonIds"))
            { 
                 bo.PI_PersonIds = dr["PI_PersonIds"].ToString(); 
            } 
            if(!dr.IsNull("Project_Start"))
            { 
                 bo.Project_Start = System.DateTime.Parse(dr["Project_Start"].ToString()); 
            } 
            if(!dr.IsNull("Project_End"))
            { 
                 bo.Project_End = System.DateTime.Parse(dr["Project_End"].ToString()); 
            } 
            if(!dr.IsNull("Project_Num"))
            { 
                 bo.Project_Num = dr["Project_Num"].ToString(); 
            } 
            if(!dr.IsNull("Project_Terms"))
            { 
                 bo.Project_Terms = dr["Project_Terms"].ToString(); 
            } 
            if(!dr.IsNull("Project_Title"))
            { 
                 bo.Project_Title = dr["Project_Title"].ToString(); 
            } 
            if(!dr.IsNull("Relevance"))
            { 
                 bo.Relevance = dr["Relevance"].ToString(); 
            } 
            if(!dr.IsNull("Serial_Number"))
            { 
                 bo.Serial_Number = int.Parse(dr["Serial_Number"].ToString()); 
            } 
            if(!dr.IsNull("Study_Section"))
            { 
                 bo.Study_Section = dr["Study_Section"].ToString(); 
            } 
            if(!dr.IsNull("Study_Section_Name"))
            { 
                 bo.Study_Section_Name = dr["Study_Section_Name"].ToString(); 
            } 
            if(!dr.IsNull("Suffix"))
            { 
                 bo.Suffix = dr["Suffix"].ToString(); 
            } 
            if(!dr.IsNull("Support_Year"))
            { 
                 bo.Support_Year = int.Parse(dr["Support_Year"].ToString()); 
            } 
            if(!dr.IsNull("Total_Cost"))
            { 
                 bo.Total_Cost = int.Parse(dr["Total_Cost"].ToString()); 
            } 
            if(!dr.IsNull("Total_Cost_Sub_Project"))
            { 
                 bo.Total_Cost_Sub_Project = int.Parse(dr["Total_Cost_Sub_Project"].ToString()); 
            } 
            bo.ImportID = int.Parse(dr["ImportID"].ToString()); 
            if(!dr.IsNull("Major_Component_Name"))
            { 
                 bo.Major_Component_Name = dr["Major_Component_Name"].ToString(); 
            } 
            if(!dr.IsNull("Award_Notice_Date"))
            { 
                 bo.Award_Notice_Date = System.DateTime.Parse(dr["Award_Notice_Date"].ToString()); 
            } 
            if(!dr.IsNull("Core_Project_Num"))
            { 
                 bo.Core_Project_Num = dr["Core_Project_Num"].ToString(); 
            } 
            if(!dr.IsNull("CFDA_Code"))
            { 
                 bo.CFDA_Code = dr["CFDA_Code"].ToString(); 
            } 
            if(!dr.IsNull("Ed_Inst_Type"))
            { 
                 bo.Ed_Inst_Type = dr["Ed_Inst_Type"].ToString(); 
            } 
            if(!dr.IsNull("Program_Officer_Name"))
            { 
                 bo.Program_Officer_Name = dr["Program_Officer_Name"].ToString(); 
            } 
            if(!dr.IsNull("PHR"))
            { 
                 bo.PHR = dr["PHR"].ToString(); 
            } 
            if(!dr.IsNull("IsBU"))
            { 
                 bo.IsBU = bool.Parse(dr["IsBU"].ToString()); 
            } 
            if(!dr.IsNull("IsBUMC"))
            { 
                 bo.IsBUMC = bool.Parse(dr["IsBUMC"].ToString()); 
            } 
            if(!dr.IsNull("IsBMC"))
            { 
                 bo.IsBMC = bool.Parse(dr["IsBMC"].ToString()); 
            } 
            if(!dr.IsNull("PubCount"))
            { 
                 bo.PubCount = int.Parse(dr["PubCount"].ToString()); 
            } 
            bo.Exists = true;
            return bo;
        } 
     
        /*! Method to get the business object before the datachange. */
        protected override ProfilesRNSDLL.BO.Profile.Import.NIHAwards GetBOBefore(ProfilesRNSDLL.BO.Profile.Import.NIHAwards businessObj)
        { 
            return this.Get(businessObj.NIHAwardsID);
        } 
 
        # endregion // internal Method 
 
    } 
 
} 
