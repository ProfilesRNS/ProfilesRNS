using System; 
using System.Collections.Generic; 
using System.Text; 
using System.Runtime.Serialization; 
 
/*! \namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DevelopmentBase
 * This namespace contains the common objects that will for OIT development projects.
 */
namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DevelopmentBase
{ 
     
    partial class BaseClassBO
    { 
     
        # region  Enums 
 
        public enum ProjectRoles
        {
			Administration_Project_User=57
			, AIMS_Administration=9
			, Aperture_Super_User=85
			, BUMC_IT_Support_Super_User=88
			, BUMC_ClinicalResearch_Admin=37
			, BUMC_ClinicalResearch_Administrative_Assistant=74
			, BUMC_ClinicalResearch_Clinical_Research_Associate=78
			, BUMC_ClinicalResearch_Co_Investigator=70
			, BUMC_ClinicalResearch_CRRO_Approver=44
			, BUMC_ClinicalResearch_Data_Manager=76
			, BUMC_ClinicalResearch_IRB_Approver=46
			, BUMC_ClinicalResearch_Other=80
			, BUMC_ClinicalResearch_Participating_Clinician=75
			, BUMC_ClinicalResearch_Principal_Investigator=43
			, BUMC_ClinicalResearch_Project_Manager=77
			, BUMC_ClinicalResearch_Public=47
			, BUMC_ClinicalResearch_Study_Contact=82
			, BUMC_ClinicalResearch_Study_Coordinator=69
			, BUMC_ClinicalResearch_Super_User=34
			, BUMC_ClinicalResearch_Technician=72
			, BUMC_Committees_Admin=38
			, BUMC_Committees_Faculty_Member=50
			, BUMC_Committees_Super_User=35
			, BUMC_Finance_Core_Billing_Admin=39
			, BUMC_Finance_Core_Director=51
			, BUMC_Finance_Core_Usage_Reporter=40
			, BUMC_Finance_DOMCR_SchedAdmin=52
			, BUMC_Finance_Evans_Report_Viewer=49
			, BUMC_Finance_Instrument_Manager=53
			, BUMC_Finance_Salary_Viewer=48
			, BUMC_Finance_Super_User=12
			, BUMC_FM_HerbalStudy_Admin=89
			, BUMC_GrantDocs_Super_User=86
			, BUMC_MYRA_Super_User=11
			, BUMC_ORCID_Scholar_Impersonate=97
			, BUMC_ORCID_Super_User=98
			, BUMC_Project_Admin=2
			, BUMC_Project_Admin_Alt=15
			, BUMC_Project_Annual_Evaluation_Reviewer=14
			, BUMC_Project_Audit_Trail_Viewer=26
			, BUMC_Project_Committee_Admin=27
			, BUMC_Project_CV_Admin=5
			, BUMC_Project_Faculty=6
			, BUMC_Project_Faculty_Eval_Admin=19
			, BUMC_Project_Faculty_Eval_User_SPH=23
			, BUMC_Project_Faculty_SPH=18
			, BUMC_Project_GSDM_View_Wish_To_Discuss_List=100
			, BUMC_Project_Impersonate_Other_User=20
			, BUMC_Project_Meeting_Requested_User=99
			, BUMC_Project_Project_Task_List_User=24
			, BUMC_Project_Skills_User=7
			, BUMC_Project_Super_User=1
			, BUMC_Project_Task_List_User=10
			, CancerCenterCommittee_Admin=28
			, CancerCenterCommittee_Committee_Member=30
			, CancerCenterCommittee_Executive_Committee_Member=31
			, CancerCenterCommittee_Super_User=29
			, CoreManagement_Admin=41
			, CoreManagement_Super_User=36
			, CoresCTSI_Admin=93
			, CoresCTSI_SuperUser=94
			, CorporateComm_Super_User=87
			, Development_Environment_SuperUser=95
			, Expertise_Resources_Anonymous_User=60
			, Expertise_Resources_BU_Faculty_AND_Staff_Group=65
			, Expertise_Resources_BUMC_OSP_Group=67
			, Expertise_Resources_Executive_Group=66
			, Expertise_Resources_Super_User=54
			, FACTSWeb_SuperUser=96
			, File_Maker_Super_User=91
			, GrantsGov_Super_User=92
			, Manual_Processing_Super_User=55
			, MED_IT_Database_Reporting_Super_User=33
			, OIT_DB_Devel_Some_new_role=3
			, OIT_Developers_OIT_Developer=13
			, People_Super_User=4
			, Prepopweb_Prepopweb=8
			, Profiles_Super_User=83
			, SFS_Admin=22
			, SFS_Super_User=21
			, SPH_Eval_Developer=56
			, SPH_Registrar_Statistics_Report_Reader=17
			, SPH_Registrar_Super_User=16
			, SPH_Registrar_View_Student_and_Credits_Report=32

        }
 
        # endregion // Enums 
    } 
 
} 
