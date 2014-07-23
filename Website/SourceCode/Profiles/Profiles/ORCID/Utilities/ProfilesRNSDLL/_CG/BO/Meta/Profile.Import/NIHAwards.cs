using System; 
using System.Collections.Generic; 
using System.Text; 
using System.Runtime.Serialization; 
using System.ComponentModel; 
 
namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.Profile.Import
{ 
    public partial class NIHAwards
    { 
        public override int TableId { get { return 4442;} }
        public enum FieldNames : int { NIHAwardsID = 52586, Application_Id = 52587, InternalUsername = 52588, Activity = 52589, Administering_IC = 52590, Application_Type = 52591, ARRA = 52592, Budget_Start = 52593, Budget_End = 52594, FOA_Number = 52595, Full_Project_Num_DC = 52596, SubProject_Id = 52597, Funding_ICs = 52598, FY = 52599, IC_Name = 52600, NIH_Reporting_Categories = 52601, Org_City = 52602, Org_Country = 52603, Org_Dept = 52604, Org_District = 52605, Org_DUNS = 52606, Org_FIPS = 52607, Org_State = 52608, Org_ZipCode = 52609, Organization = 52610, PI_Names = 52611, PI_PersonIds = 52612, Project_Start = 52613, Project_End = 52614, Project_Num = 52615, Project_Terms = 52616, Project_Title = 52617, Relevance = 52618, Serial_Number = 52619, Study_Section = 52620, Study_Section_Name = 52621, Suffix = 52622, Support_Year = 52623, Total_Cost = 52624, Total_Cost_Sub_Project = 52625, ImportID = 52626, Major_Component_Name = 52627, Award_Notice_Date = 52628, Core_Project_Num = 52629, CFDA_Code = 52630, Ed_Inst_Type = 52631, Program_Officer_Name = 52632, PHR = 52633, IsBU = 52634, IsBUMC = 52635, IsBMC = 52636, PubCount = 52637 }
        public override string TableSchemaName { get { return "Profile.Import"; } }
    } 
} 
