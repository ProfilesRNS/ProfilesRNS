using System; 
using System.Collections.Generic; 
using System.Text; 
using System.Runtime.Serialization; 
using System.ComponentModel; 
 
namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.Profile.Import
{ 
    public partial class NIHAwards : ProfilesRNSBaseClassBO, BO.Interfaces.Profile.Import.INIHAwards, IEqualityComparer<NIHAwards>, IEquatable<NIHAwards> 
    { 
        # region Private variables 
          /*! NIHAwardsID state (N I H AwardsID) */ 
          private int _NIHAwardsID;
          /*! Application_Id state (Application Id) */ 
          private int _Application_Id;
          /*! InternalUsername state (Internal Username) */ 
          private string _InternalUsername;
          /*! Activity state (Activity) */ 
          private string _Activity;
          /*! Administering_IC state (Administering I C) */ 
          private string _Administering_IC;
          /*! Application_Type state (Application Type) */ 
          private int _Application_Type;
          /*! ARRA state (A R R A) */ 
          private string _ARRA;
          /*! Budget_Start state (Budget Start) */ 
          private System.DateTime _Budget_Start;
          /*! Budget_End state (Budget End) */ 
          private System.DateTime _Budget_End;
          /*! FOA_Number state (F O A Number) */ 
          private string _FOA_Number;
          /*! Full_Project_Num_DC state (Full Project Num D C) */ 
          private string _Full_Project_Num_DC;
          /*! SubProject_Id state (Sub Project Id) */ 
          private int _SubProject_Id;
          /*! Funding_ICs state (Funding I Cs) */ 
          private string _Funding_ICs;
          /*! FY state (F Y) */ 
          private int _FY;
          /*! IC_Name state (I C Name) */ 
          private string _IC_Name;
          /*! NIH_Reporting_Categories state (N I H Reporting Categories) */ 
          private string _NIH_Reporting_Categories;
          /*! Org_City state (Org City) */ 
          private string _Org_City;
          /*! Org_Country state (Org Country) */ 
          private string _Org_Country;
          /*! Org_Dept state (Org Dept) */ 
          private string _Org_Dept;
          /*! Org_District state (Org District) */ 
          private int _Org_District;
          /*! Org_DUNS state (Org D U N S) */ 
          private string _Org_DUNS;
          /*! Org_FIPS state (Org F I P S) */ 
          private string _Org_FIPS;
          /*! Org_State state (Org State) */ 
          private string _Org_State;
          /*! Org_ZipCode state (Org Zip Code) */ 
          private string _Org_ZipCode;
          /*! Organization state (Organization) */ 
          private string _Organization;
          /*! PI_Names state (P I Names) */ 
          private string _PI_Names;
          /*! PI_PersonIds state (P I Person Ids) */ 
          private string _PI_PersonIds;
          /*! Project_Start state (Project Start) */ 
          private System.DateTime _Project_Start;
          /*! Project_End state (Project End) */ 
          private System.DateTime _Project_End;
          /*! Project_Num state (Project Num) */ 
          private string _Project_Num;
          /*! Project_Terms state (Project Terms) */ 
          private string _Project_Terms;
          /*! Project_Title state (Project Title) */ 
          private string _Project_Title;
          /*! Relevance state (Relevance) */ 
          private string _Relevance;
          /*! Serial_Number state (Serial Number) */ 
          private int _Serial_Number;
          /*! Study_Section state (Study Section) */ 
          private string _Study_Section;
          /*! Study_Section_Name state (Study Section Name) */ 
          private string _Study_Section_Name;
          /*! Suffix state (Suffix) */ 
          private string _Suffix;
          /*! Support_Year state (Support Year) */ 
          private int _Support_Year;
          /*! Total_Cost state (Total Cost) */ 
          private int _Total_Cost;
          /*! Total_Cost_Sub_Project state (Total Cost Sub Project) */ 
          private int _Total_Cost_Sub_Project;
          /*! ImportID state (ImportID) */ 
          private int _ImportID;
          /*! Major_Component_Name state (Major Component Name) */ 
          private string _Major_Component_Name;
          /*! Award_Notice_Date state (Award Notice Date) */ 
          private System.DateTime _Award_Notice_Date;
          /*! Core_Project_Num state (Core Project Num) */ 
          private string _Core_Project_Num;
          /*! CFDA_Code state (C F D A Code) */ 
          private string _CFDA_Code;
          /*! Ed_Inst_Type state (Ed Inst Type) */ 
          private string _Ed_Inst_Type;
          /*! Program_Officer_Name state (Program Officer Name) */ 
          private string _Program_Officer_Name;
          /*! PHR state (P H R) */ 
          private string _PHR;
          /*! IsBU state (Is B U) */ 
          private bool _IsBU;
          /*! IsBUMC state (Is B U M C) */ 
          private bool _IsBUMC;
          /*! IsBMC state (Is B M C) */ 
          private bool _IsBMC;
          /*! PubCount state (Pub Count) */ 
          private int _PubCount;
        # endregion //Private variables 
     
        # region Public Properties 
     
        
        public int NIHAwardsID 
        { 
              get { return _NIHAwardsID; } 
              set { _NIHAwardsID = value; NIHAwardsIDIsNull = false; } 
        } 
        public bool NIHAwardsIDIsNull { get; set; }
        public string NIHAwardsIDErrors { get; set; }
        public string NIHAwardsIDText { get { if (NIHAwardsIDIsNull){ return string.Empty; } return NIHAwardsID.ToString(); } } 
        public override string IdentityValue { get { if (NIHAwardsIDIsNull){ return string.Empty; } return NIHAwardsID.ToString(); } } 
        public override bool IdentityIsNull { get { return NIHAwardsIDIsNull; } } 
        
        public int Application_Id 
        { 
              get { return _Application_Id; } 
              set { _Application_Id = value; Application_IdIsNull = false; } 
        } 
        public bool Application_IdIsNull { get; set; }
        public string Application_IdErrors { get; set; }
        
        public string InternalUsername 
        { 
              get { return _InternalUsername; } 
              set { _InternalUsername = value; InternalUsernameIsNull = false; } 
        } 
        public bool InternalUsernameIsNull { get; set; }
        public string InternalUsernameErrors { get; set; }
        
        public string Activity 
        { 
              get { return _Activity; } 
              set { _Activity = value; ActivityIsNull = false; } 
        } 
        public bool ActivityIsNull { get; set; }
        public string ActivityErrors { get; set; }
        
        public string Administering_IC 
        { 
              get { return _Administering_IC; } 
              set { _Administering_IC = value; Administering_ICIsNull = false; } 
        } 
        public bool Administering_ICIsNull { get; set; }
        public string Administering_ICErrors { get; set; }
        
        public int Application_Type 
        { 
              get { return _Application_Type; } 
              set { _Application_Type = value; Application_TypeIsNull = false; } 
        } 
        public bool Application_TypeIsNull { get; set; }
        public string Application_TypeErrors { get; set; }
        
        public string ARRA 
        { 
              get { return _ARRA; } 
              set { _ARRA = value; ARRAIsNull = false; } 
        } 
        public bool ARRAIsNull { get; set; }
        public string ARRAErrors { get; set; }
        
        public System.DateTime Budget_Start 
        { 
              get { return _Budget_Start; } 
              set { _Budget_Start = value; Budget_StartIsNull = false; } 
        } 
        public bool Budget_StartIsNull { get; set; }
        public string Budget_StartErrors { get; set; }
        public string Budget_StartDesc { get { if (Budget_StartIsNull){ return string.Empty; } return Budget_Start.ToShortDateString(); } } 
        public string Budget_StartTime { get { if (Budget_StartIsNull){ return string.Empty; } return Budget_Start.ToShortTimeString(); } } 
        
        public System.DateTime Budget_End 
        { 
              get { return _Budget_End; } 
              set { _Budget_End = value; Budget_EndIsNull = false; } 
        } 
        public bool Budget_EndIsNull { get; set; }
        public string Budget_EndErrors { get; set; }
        public string Budget_EndDesc { get { if (Budget_EndIsNull){ return string.Empty; } return Budget_End.ToShortDateString(); } } 
        public string Budget_EndTime { get { if (Budget_EndIsNull){ return string.Empty; } return Budget_End.ToShortTimeString(); } } 
        
        public string FOA_Number 
        { 
              get { return _FOA_Number; } 
              set { _FOA_Number = value; FOA_NumberIsNull = false; } 
        } 
        public bool FOA_NumberIsNull { get; set; }
        public string FOA_NumberErrors { get; set; }
        
        public string Full_Project_Num_DC 
        { 
              get { return _Full_Project_Num_DC; } 
              set { _Full_Project_Num_DC = value; Full_Project_Num_DCIsNull = false; } 
        } 
        public bool Full_Project_Num_DCIsNull { get; set; }
        public string Full_Project_Num_DCErrors { get; set; }
        
        public int SubProject_Id 
        { 
              get { return _SubProject_Id; } 
              set { _SubProject_Id = value; SubProject_IdIsNull = false; } 
        } 
        public bool SubProject_IdIsNull { get; set; }
        public string SubProject_IdErrors { get; set; }
        
        public string Funding_ICs 
        { 
              get { return _Funding_ICs; } 
              set { _Funding_ICs = value; Funding_ICsIsNull = false; } 
        } 
        public bool Funding_ICsIsNull { get; set; }
        public string Funding_ICsErrors { get; set; }
        
        public int FY 
        { 
              get { return _FY; } 
              set { _FY = value; FYIsNull = false; } 
        } 
        public bool FYIsNull { get; set; }
        public string FYErrors { get; set; }
        
        public string IC_Name 
        { 
              get { return _IC_Name; } 
              set { _IC_Name = value; IC_NameIsNull = false; } 
        } 
        public bool IC_NameIsNull { get; set; }
        public string IC_NameErrors { get; set; }
        
        public string NIH_Reporting_Categories 
        { 
              get { return _NIH_Reporting_Categories; } 
              set { _NIH_Reporting_Categories = value; NIH_Reporting_CategoriesIsNull = false; } 
        } 
        public bool NIH_Reporting_CategoriesIsNull { get; set; }
        public string NIH_Reporting_CategoriesErrors { get; set; }
        
        public string Org_City 
        { 
              get { return _Org_City; } 
              set { _Org_City = value; Org_CityIsNull = false; } 
        } 
        public bool Org_CityIsNull { get; set; }
        public string Org_CityErrors { get; set; }
        
        public string Org_Country 
        { 
              get { return _Org_Country; } 
              set { _Org_Country = value; Org_CountryIsNull = false; } 
        } 
        public bool Org_CountryIsNull { get; set; }
        public string Org_CountryErrors { get; set; }
        
        public string Org_Dept 
        { 
              get { return _Org_Dept; } 
              set { _Org_Dept = value; Org_DeptIsNull = false; } 
        } 
        public bool Org_DeptIsNull { get; set; }
        public string Org_DeptErrors { get; set; }
        
        public int Org_District 
        { 
              get { return _Org_District; } 
              set { _Org_District = value; Org_DistrictIsNull = false; } 
        } 
        public bool Org_DistrictIsNull { get; set; }
        public string Org_DistrictErrors { get; set; }
        
        public string Org_DUNS 
        { 
              get { return _Org_DUNS; } 
              set { _Org_DUNS = value; Org_DUNSIsNull = false; } 
        } 
        public bool Org_DUNSIsNull { get; set; }
        public string Org_DUNSErrors { get; set; }
        
        public string Org_FIPS 
        { 
              get { return _Org_FIPS; } 
              set { _Org_FIPS = value; Org_FIPSIsNull = false; } 
        } 
        public bool Org_FIPSIsNull { get; set; }
        public string Org_FIPSErrors { get; set; }
        
        public string Org_State 
        { 
              get { return _Org_State; } 
              set { _Org_State = value; Org_StateIsNull = false; } 
        } 
        public bool Org_StateIsNull { get; set; }
        public string Org_StateErrors { get; set; }
        
        public string Org_ZipCode 
        { 
              get { return _Org_ZipCode; } 
              set { _Org_ZipCode = value; Org_ZipCodeIsNull = false; } 
        } 
        public bool Org_ZipCodeIsNull { get; set; }
        public string Org_ZipCodeErrors { get; set; }
        
        public string Organization 
        { 
              get { return _Organization; } 
              set { _Organization = value; OrganizationIsNull = false; } 
        } 
        public bool OrganizationIsNull { get; set; }
        public string OrganizationErrors { get; set; }
        
        public string PI_Names 
        { 
              get { return _PI_Names; } 
              set { _PI_Names = value; PI_NamesIsNull = false; } 
        } 
        public bool PI_NamesIsNull { get; set; }
        public string PI_NamesErrors { get; set; }
        
        public string PI_PersonIds 
        { 
              get { return _PI_PersonIds; } 
              set { _PI_PersonIds = value; PI_PersonIdsIsNull = false; } 
        } 
        public bool PI_PersonIdsIsNull { get; set; }
        public string PI_PersonIdsErrors { get; set; }
        
        public System.DateTime Project_Start 
        { 
              get { return _Project_Start; } 
              set { _Project_Start = value; Project_StartIsNull = false; } 
        } 
        public bool Project_StartIsNull { get; set; }
        public string Project_StartErrors { get; set; }
        public string Project_StartDesc { get { if (Project_StartIsNull){ return string.Empty; } return Project_Start.ToShortDateString(); } } 
        public string Project_StartTime { get { if (Project_StartIsNull){ return string.Empty; } return Project_Start.ToShortTimeString(); } } 
        
        public System.DateTime Project_End 
        { 
              get { return _Project_End; } 
              set { _Project_End = value; Project_EndIsNull = false; } 
        } 
        public bool Project_EndIsNull { get; set; }
        public string Project_EndErrors { get; set; }
        public string Project_EndDesc { get { if (Project_EndIsNull){ return string.Empty; } return Project_End.ToShortDateString(); } } 
        public string Project_EndTime { get { if (Project_EndIsNull){ return string.Empty; } return Project_End.ToShortTimeString(); } } 
        
        public string Project_Num 
        { 
              get { return _Project_Num; } 
              set { _Project_Num = value; Project_NumIsNull = false; } 
        } 
        public bool Project_NumIsNull { get; set; }
        public string Project_NumErrors { get; set; }
        
        public string Project_Terms 
        { 
              get { return _Project_Terms; } 
              set { _Project_Terms = value; Project_TermsIsNull = false; } 
        } 
        public bool Project_TermsIsNull { get; set; }
        public string Project_TermsErrors { get; set; }
        
        public string Project_Title 
        { 
              get { return _Project_Title; } 
              set { _Project_Title = value; Project_TitleIsNull = false; } 
        } 
        public bool Project_TitleIsNull { get; set; }
        public string Project_TitleErrors { get; set; }
        
        public string Relevance 
        { 
              get { return _Relevance; } 
              set { _Relevance = value; RelevanceIsNull = false; } 
        } 
        public bool RelevanceIsNull { get; set; }
        public string RelevanceErrors { get; set; }
        
        public int Serial_Number 
        { 
              get { return _Serial_Number; } 
              set { _Serial_Number = value; Serial_NumberIsNull = false; } 
        } 
        public bool Serial_NumberIsNull { get; set; }
        public string Serial_NumberErrors { get; set; }
        
        public string Study_Section 
        { 
              get { return _Study_Section; } 
              set { _Study_Section = value; Study_SectionIsNull = false; } 
        } 
        public bool Study_SectionIsNull { get; set; }
        public string Study_SectionErrors { get; set; }
        
        public string Study_Section_Name 
        { 
              get { return _Study_Section_Name; } 
              set { _Study_Section_Name = value; Study_Section_NameIsNull = false; } 
        } 
        public bool Study_Section_NameIsNull { get; set; }
        public string Study_Section_NameErrors { get; set; }
        
        public string Suffix 
        { 
              get { return _Suffix; } 
              set { _Suffix = value; SuffixIsNull = false; } 
        } 
        public bool SuffixIsNull { get; set; }
        public string SuffixErrors { get; set; }
        
        public int Support_Year 
        { 
              get { return _Support_Year; } 
              set { _Support_Year = value; Support_YearIsNull = false; } 
        } 
        public bool Support_YearIsNull { get; set; }
        public string Support_YearErrors { get; set; }
        
        public int Total_Cost 
        { 
              get { return _Total_Cost; } 
              set { _Total_Cost = value; Total_CostIsNull = false; } 
        } 
        public bool Total_CostIsNull { get; set; }
        public string Total_CostErrors { get; set; }
        
        public int Total_Cost_Sub_Project 
        { 
              get { return _Total_Cost_Sub_Project; } 
              set { _Total_Cost_Sub_Project = value; Total_Cost_Sub_ProjectIsNull = false; } 
        } 
        public bool Total_Cost_Sub_ProjectIsNull { get; set; }
        public string Total_Cost_Sub_ProjectErrors { get; set; }
        
        public int ImportID 
        { 
              get { return _ImportID; } 
              set { _ImportID = value; ImportIDIsNull = false; } 
        } 
        public bool ImportIDIsNull { get; set; }
        public string ImportIDErrors { get; set; }
        
        public string Major_Component_Name 
        { 
              get { return _Major_Component_Name; } 
              set { _Major_Component_Name = value; Major_Component_NameIsNull = false; } 
        } 
        public bool Major_Component_NameIsNull { get; set; }
        public string Major_Component_NameErrors { get; set; }
        
        public System.DateTime Award_Notice_Date 
        { 
              get { return _Award_Notice_Date; } 
              set { _Award_Notice_Date = value; Award_Notice_DateIsNull = false; } 
        } 
        public bool Award_Notice_DateIsNull { get; set; }
        public string Award_Notice_DateErrors { get; set; }
        public string Award_Notice_DateDesc { get { if (Award_Notice_DateIsNull){ return string.Empty; } return Award_Notice_Date.ToShortDateString(); } } 
        public string Award_Notice_DateTime { get { if (Award_Notice_DateIsNull){ return string.Empty; } return Award_Notice_Date.ToShortTimeString(); } } 
        
        public string Core_Project_Num 
        { 
              get { return _Core_Project_Num; } 
              set { _Core_Project_Num = value; Core_Project_NumIsNull = false; } 
        } 
        public bool Core_Project_NumIsNull { get; set; }
        public string Core_Project_NumErrors { get; set; }
        
        public string CFDA_Code 
        { 
              get { return _CFDA_Code; } 
              set { _CFDA_Code = value; CFDA_CodeIsNull = false; } 
        } 
        public bool CFDA_CodeIsNull { get; set; }
        public string CFDA_CodeErrors { get; set; }
        
        public string Ed_Inst_Type 
        { 
              get { return _Ed_Inst_Type; } 
              set { _Ed_Inst_Type = value; Ed_Inst_TypeIsNull = false; } 
        } 
        public bool Ed_Inst_TypeIsNull { get; set; }
        public string Ed_Inst_TypeErrors { get; set; }
        
        public string Program_Officer_Name 
        { 
              get { return _Program_Officer_Name; } 
              set { _Program_Officer_Name = value; Program_Officer_NameIsNull = false; } 
        } 
        public bool Program_Officer_NameIsNull { get; set; }
        public string Program_Officer_NameErrors { get; set; }
        
        public string PHR 
        { 
              get { return _PHR; } 
              set { _PHR = value; PHRIsNull = false; } 
        } 
        public bool PHRIsNull { get; set; }
        public string PHRErrors { get; set; }
        
        public bool IsBU 
        { 
              get { return _IsBU; } 
              set { _IsBU = value; IsBUIsNull = false; } 
        } 
        public bool IsBUIsNull { get; set; }
        public string IsBUErrors { get; set; }
        public string IsBUDesc { get { if (IsBUIsNull){ return string.Empty; } else if (IsBU){ return "Yes"; } else { return "No"; } } } 
        
        public bool IsBUMC 
        { 
              get { return _IsBUMC; } 
              set { _IsBUMC = value; IsBUMCIsNull = false; } 
        } 
        public bool IsBUMCIsNull { get; set; }
        public string IsBUMCErrors { get; set; }
        public string IsBUMCDesc { get { if (IsBUMCIsNull){ return string.Empty; } else if (IsBUMC){ return "Yes"; } else { return "No"; } } } 
        
        public bool IsBMC 
        { 
              get { return _IsBMC; } 
              set { _IsBMC = value; IsBMCIsNull = false; } 
        } 
        public bool IsBMCIsNull { get; set; }
        public string IsBMCErrors { get; set; }
        public string IsBMCDesc { get { if (IsBMCIsNull){ return string.Empty; } else if (IsBMC){ return "Yes"; } else { return "No"; } } } 
        
        public int PubCount 
        { 
              get { return _PubCount; } 
              set { _PubCount = value; PubCountIsNull = false; } 
        } 
        public bool PubCountIsNull { get; set; }
        public string PubCountErrors { get; set; }
        public string AllErrors 
        { 
              get 
              { 
                  string returnString = string.Empty;
                  if (!NIHAwardsIDErrors.Equals(string.Empty))
                  { 
                      returnString += "N I H AwardsID: " + NIHAwardsIDErrors; 
                  } 
                  if (!Application_IdErrors.Equals(string.Empty))
                  { 
                      returnString += "Application Id: " + Application_IdErrors; 
                  } 
                  if (!InternalUsernameErrors.Equals(string.Empty))
                  { 
                      returnString += "Internal Username: " + InternalUsernameErrors; 
                  } 
                  if (!ActivityErrors.Equals(string.Empty))
                  { 
                      returnString += "Activity: " + ActivityErrors; 
                  } 
                  if (!Administering_ICErrors.Equals(string.Empty))
                  { 
                      returnString += "Administering I C: " + Administering_ICErrors; 
                  } 
                  if (!Application_TypeErrors.Equals(string.Empty))
                  { 
                      returnString += "Application Type: " + Application_TypeErrors; 
                  } 
                  if (!ARRAErrors.Equals(string.Empty))
                  { 
                      returnString += "A R R A: " + ARRAErrors; 
                  } 
                  if (!Budget_StartErrors.Equals(string.Empty))
                  { 
                      returnString += "Budget Start: " + Budget_StartErrors; 
                  } 
                  if (!Budget_EndErrors.Equals(string.Empty))
                  { 
                      returnString += "Budget End: " + Budget_EndErrors; 
                  } 
                  if (!FOA_NumberErrors.Equals(string.Empty))
                  { 
                      returnString += "F O A Number: " + FOA_NumberErrors; 
                  } 
                  if (!Full_Project_Num_DCErrors.Equals(string.Empty))
                  { 
                      returnString += "Full Project Num D C: " + Full_Project_Num_DCErrors; 
                  } 
                  if (!SubProject_IdErrors.Equals(string.Empty))
                  { 
                      returnString += "Sub Project Id: " + SubProject_IdErrors; 
                  } 
                  if (!Funding_ICsErrors.Equals(string.Empty))
                  { 
                      returnString += "Funding I Cs: " + Funding_ICsErrors; 
                  } 
                  if (!FYErrors.Equals(string.Empty))
                  { 
                      returnString += "F Y: " + FYErrors; 
                  } 
                  if (!IC_NameErrors.Equals(string.Empty))
                  { 
                      returnString += "I C Name: " + IC_NameErrors; 
                  } 
                  if (!NIH_Reporting_CategoriesErrors.Equals(string.Empty))
                  { 
                      returnString += "N I H Reporting Categories: " + NIH_Reporting_CategoriesErrors; 
                  } 
                  if (!Org_CityErrors.Equals(string.Empty))
                  { 
                      returnString += "Org City: " + Org_CityErrors; 
                  } 
                  if (!Org_CountryErrors.Equals(string.Empty))
                  { 
                      returnString += "Org Country: " + Org_CountryErrors; 
                  } 
                  if (!Org_DeptErrors.Equals(string.Empty))
                  { 
                      returnString += "Org Dept: " + Org_DeptErrors; 
                  } 
                  if (!Org_DistrictErrors.Equals(string.Empty))
                  { 
                      returnString += "Org District: " + Org_DistrictErrors; 
                  } 
                  if (!Org_DUNSErrors.Equals(string.Empty))
                  { 
                      returnString += "Org D U N S: " + Org_DUNSErrors; 
                  } 
                  if (!Org_FIPSErrors.Equals(string.Empty))
                  { 
                      returnString += "Org F I P S: " + Org_FIPSErrors; 
                  } 
                  if (!Org_StateErrors.Equals(string.Empty))
                  { 
                      returnString += "Org State: " + Org_StateErrors; 
                  } 
                  if (!Org_ZipCodeErrors.Equals(string.Empty))
                  { 
                      returnString += "Org Zip Code: " + Org_ZipCodeErrors; 
                  } 
                  if (!OrganizationErrors.Equals(string.Empty))
                  { 
                      returnString += "Organization: " + OrganizationErrors; 
                  } 
                  if (!PI_NamesErrors.Equals(string.Empty))
                  { 
                      returnString += "P I Names: " + PI_NamesErrors; 
                  } 
                  if (!PI_PersonIdsErrors.Equals(string.Empty))
                  { 
                      returnString += "P I Person Ids: " + PI_PersonIdsErrors; 
                  } 
                  if (!Project_StartErrors.Equals(string.Empty))
                  { 
                      returnString += "Project Start: " + Project_StartErrors; 
                  } 
                  if (!Project_EndErrors.Equals(string.Empty))
                  { 
                      returnString += "Project End: " + Project_EndErrors; 
                  } 
                  if (!Project_NumErrors.Equals(string.Empty))
                  { 
                      returnString += "Project Num: " + Project_NumErrors; 
                  } 
                  if (!Project_TermsErrors.Equals(string.Empty))
                  { 
                      returnString += "Project Terms: " + Project_TermsErrors; 
                  } 
                  if (!Project_TitleErrors.Equals(string.Empty))
                  { 
                      returnString += "Project Title: " + Project_TitleErrors; 
                  } 
                  if (!RelevanceErrors.Equals(string.Empty))
                  { 
                      returnString += "Relevance: " + RelevanceErrors; 
                  } 
                  if (!Serial_NumberErrors.Equals(string.Empty))
                  { 
                      returnString += "Serial Number: " + Serial_NumberErrors; 
                  } 
                  if (!Study_SectionErrors.Equals(string.Empty))
                  { 
                      returnString += "Study Section: " + Study_SectionErrors; 
                  } 
                  if (!Study_Section_NameErrors.Equals(string.Empty))
                  { 
                      returnString += "Study Section Name: " + Study_Section_NameErrors; 
                  } 
                  if (!SuffixErrors.Equals(string.Empty))
                  { 
                      returnString += "Suffix: " + SuffixErrors; 
                  } 
                  if (!Support_YearErrors.Equals(string.Empty))
                  { 
                      returnString += "Support Year: " + Support_YearErrors; 
                  } 
                  if (!Total_CostErrors.Equals(string.Empty))
                  { 
                      returnString += "Total Cost: " + Total_CostErrors; 
                  } 
                  if (!Total_Cost_Sub_ProjectErrors.Equals(string.Empty))
                  { 
                      returnString += "Total Cost Sub Project: " + Total_Cost_Sub_ProjectErrors; 
                  } 
                  if (!ImportIDErrors.Equals(string.Empty))
                  { 
                      returnString += "ImportID: " + ImportIDErrors; 
                  } 
                  if (!Major_Component_NameErrors.Equals(string.Empty))
                  { 
                      returnString += "Major Component Name: " + Major_Component_NameErrors; 
                  } 
                  if (!Award_Notice_DateErrors.Equals(string.Empty))
                  { 
                      returnString += "Award Notice Date: " + Award_Notice_DateErrors; 
                  } 
                  if (!Core_Project_NumErrors.Equals(string.Empty))
                  { 
                      returnString += "Core Project Num: " + Core_Project_NumErrors; 
                  } 
                  if (!CFDA_CodeErrors.Equals(string.Empty))
                  { 
                      returnString += "C F D A Code: " + CFDA_CodeErrors; 
                  } 
                  if (!Ed_Inst_TypeErrors.Equals(string.Empty))
                  { 
                      returnString += "Ed Inst Type: " + Ed_Inst_TypeErrors; 
                  } 
                  if (!Program_Officer_NameErrors.Equals(string.Empty))
                  { 
                      returnString += "Program Officer Name: " + Program_Officer_NameErrors; 
                  } 
                  if (!PHRErrors.Equals(string.Empty))
                  { 
                      returnString += "P H R: " + PHRErrors; 
                  } 
                  if (!IsBUErrors.Equals(string.Empty))
                  { 
                      returnString += "Is B U: " + IsBUErrors; 
                  } 
                  if (!IsBUMCErrors.Equals(string.Empty))
                  { 
                      returnString += "Is B U M C: " + IsBUMCErrors; 
                  } 
                  if (!IsBMCErrors.Equals(string.Empty))
                  { 
                      returnString += "Is B M C: " + IsBMCErrors; 
                  } 
                  if (!PubCountErrors.Equals(string.Empty))
                  { 
                      returnString += "Pub Count: " + PubCountErrors; 
                  } 
                  return returnString; 
              } 
        } 
        public bool Equals(NIHAwards left, NIHAwards right)
        {
            if((object)left == null && (object)right == null)
            {
                return true;
            }
            if((object)left == null || (object)right == null)
            {
                return false;
            }
            return left.NIHAwardsID == right.NIHAwardsID;
        }
        public int GetHashCode(NIHAwards obj)
        {
            return (obj.NIHAwardsID).GetHashCode();
        }
        public bool Equals(NIHAwards other)
        {
            if (this.NIHAwardsID == other.NIHAwardsID )
                return true;

            return false;
        }
        public override int GetHashCode()
        {
            return NIHAwardsID.GetHashCode();
        }

        public BO.Interfaces.Profile.Import.INIHAwards DBFields { get { return this; } } 
     
        # endregion // Public Properties 
     
        # region Protected Methods 
     
        protected override void InitializePropertiesCG()
        {
            NIHAwardsIDIsNull = true; 
            NIHAwardsIDErrors = string.Empty; 
            Application_IdIsNull = true; 
            Application_IdErrors = string.Empty; 
            InternalUsernameIsNull = true; 
            InternalUsernameErrors = string.Empty; 
            ActivityIsNull = true; 
            ActivityErrors = string.Empty; 
            Administering_ICIsNull = true; 
            Administering_ICErrors = string.Empty; 
            Application_TypeIsNull = true; 
            Application_TypeErrors = string.Empty; 
            ARRAIsNull = true; 
            ARRAErrors = string.Empty; 
            Budget_StartIsNull = true; 
            Budget_StartErrors = string.Empty; 
            Budget_EndIsNull = true; 
            Budget_EndErrors = string.Empty; 
            FOA_NumberIsNull = true; 
            FOA_NumberErrors = string.Empty; 
            Full_Project_Num_DCIsNull = true; 
            Full_Project_Num_DCErrors = string.Empty; 
            SubProject_IdIsNull = true; 
            SubProject_IdErrors = string.Empty; 
            Funding_ICsIsNull = true; 
            Funding_ICsErrors = string.Empty; 
            FYIsNull = true; 
            FYErrors = string.Empty; 
            IC_NameIsNull = true; 
            IC_NameErrors = string.Empty; 
            NIH_Reporting_CategoriesIsNull = true; 
            NIH_Reporting_CategoriesErrors = string.Empty; 
            Org_CityIsNull = true; 
            Org_CityErrors = string.Empty; 
            Org_CountryIsNull = true; 
            Org_CountryErrors = string.Empty; 
            Org_DeptIsNull = true; 
            Org_DeptErrors = string.Empty; 
            Org_DistrictIsNull = true; 
            Org_DistrictErrors = string.Empty; 
            Org_DUNSIsNull = true; 
            Org_DUNSErrors = string.Empty; 
            Org_FIPSIsNull = true; 
            Org_FIPSErrors = string.Empty; 
            Org_StateIsNull = true; 
            Org_StateErrors = string.Empty; 
            Org_ZipCodeIsNull = true; 
            Org_ZipCodeErrors = string.Empty; 
            OrganizationIsNull = true; 
            OrganizationErrors = string.Empty; 
            PI_NamesIsNull = true; 
            PI_NamesErrors = string.Empty; 
            PI_PersonIdsIsNull = true; 
            PI_PersonIdsErrors = string.Empty; 
            Project_StartIsNull = true; 
            Project_StartErrors = string.Empty; 
            Project_EndIsNull = true; 
            Project_EndErrors = string.Empty; 
            Project_NumIsNull = true; 
            Project_NumErrors = string.Empty; 
            Project_TermsIsNull = true; 
            Project_TermsErrors = string.Empty; 
            Project_TitleIsNull = true; 
            Project_TitleErrors = string.Empty; 
            RelevanceIsNull = true; 
            RelevanceErrors = string.Empty; 
            Serial_NumberIsNull = true; 
            Serial_NumberErrors = string.Empty; 
            Study_SectionIsNull = true; 
            Study_SectionErrors = string.Empty; 
            Study_Section_NameIsNull = true; 
            Study_Section_NameErrors = string.Empty; 
            SuffixIsNull = true; 
            SuffixErrors = string.Empty; 
            Support_YearIsNull = true; 
            Support_YearErrors = string.Empty; 
            Total_CostIsNull = true; 
            Total_CostErrors = string.Empty; 
            Total_Cost_Sub_ProjectIsNull = true; 
            Total_Cost_Sub_ProjectErrors = string.Empty; 
            ImportIDIsNull = true; 
            ImportIDErrors = string.Empty; 
            Major_Component_NameIsNull = true; 
            Major_Component_NameErrors = string.Empty; 
            Award_Notice_DateIsNull = true; 
            Award_Notice_DateErrors = string.Empty; 
            Core_Project_NumIsNull = true; 
            Core_Project_NumErrors = string.Empty; 
            CFDA_CodeIsNull = true; 
            CFDA_CodeErrors = string.Empty; 
            Ed_Inst_TypeIsNull = true; 
            Ed_Inst_TypeErrors = string.Empty; 
            Program_Officer_NameIsNull = true; 
            Program_Officer_NameErrors = string.Empty; 
            PHRIsNull = true; 
            PHRErrors = string.Empty; 
            IsBUIsNull = true; 
            IsBUErrors = string.Empty; 
            IsBUMCIsNull = true; 
            IsBUMCErrors = string.Empty; 
            IsBMCIsNull = true; 
            IsBMCErrors = string.Empty; 
            PubCountIsNull = true; 
            PubCountErrors = string.Empty; 
            InitializeProperties(); 
        }
     
        # endregion // Protected Methods 
 
        # region Enums 
 
 
        # endregion // Enums 
    } 
 
} 
