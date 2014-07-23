using System; 
using System.Collections.Generic; 
using System.Text; 
 
namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.Profile.Import
{
    public partial class NIHAwards : ProfilesRNSDLL.DAL.Profile.Import.NIHAwards
    {
    
        # region Constructors 
    
        public NIHAwards() : base() { } 
    
        # endregion // Constructors
    
        # region Public Methods 
 
        public override void DBRulesCG(ProfilesRNSDLL.BO.Profile.Import.NIHAwards bo) 
        { 
            /*! Check for missing values */ 
			if (bo.Application_IdIsNull) { 
				bo.Application_IdErrors += "Required." + Environment.NewLine; 
				bo.HasError = true; 
			} else { 
			}  
			if (bo.InternalUsernameIsNull) { 
				bo.InternalUsernameErrors += "Required." + Environment.NewLine; 
				bo.HasError = true; 
			} else { 
			}  
			if (bo.ImportIDIsNull) { 
				bo.ImportIDErrors += "Required." + Environment.NewLine; 
				bo.HasError = true; 
			} else { 
			}  
            /*! Check for out of Range values */ 
            if (!bo.InternalUsernameIsNull) 
            { 
                if (bo.InternalUsername.Length > 50) 
                { 
                     bo.InternalUsernameErrors += "This field has more characters than the maximum that can be stored, i.e. 50 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.ActivityIsNull) 
            { 
                if (bo.Activity.Length > 3) 
                { 
                     bo.ActivityErrors += "This field has more characters than the maximum that can be stored, i.e. 3 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.Administering_ICIsNull) 
            { 
                if (bo.Administering_IC.Length > 2) 
                { 
                     bo.Administering_ICErrors += "This field has more characters than the maximum that can be stored, i.e. 2 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.ARRAIsNull) 
            { 
                if (bo.ARRA.Length > 1) 
                { 
                     bo.ARRAErrors += "This field has more characters than the maximum that can be stored, i.e. 1 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.FOA_NumberIsNull) 
            { 
                if (bo.FOA_Number.Length > 17) 
                { 
                     bo.FOA_NumberErrors += "This field has more characters than the maximum that can be stored, i.e. 17 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.Full_Project_Num_DCIsNull) 
            { 
                if (bo.Full_Project_Num_DC.Length > 100) 
                { 
                     bo.Full_Project_Num_DCErrors += "This field has more characters than the maximum that can be stored, i.e. 100 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.Funding_ICsIsNull) 
            { 
                if (bo.Funding_ICs.Length > 300) 
                { 
                     bo.Funding_ICsErrors += "This field has more characters than the maximum that can be stored, i.e. 300 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.IC_NameIsNull) 
            { 
                if (bo.IC_Name.Length > 255) 
                { 
                     bo.IC_NameErrors += "This field has more characters than the maximum that can be stored, i.e. 255 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.NIH_Reporting_CategoriesIsNull) 
            { 
                if (bo.NIH_Reporting_Categories.Length > 900) 
                { 
                     bo.NIH_Reporting_CategoriesErrors += "This field has more characters than the maximum that can be stored, i.e. 900 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.Org_CityIsNull) 
            { 
                if (bo.Org_City.Length > 255) 
                { 
                     bo.Org_CityErrors += "This field has more characters than the maximum that can be stored, i.e. 255 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.Org_CountryIsNull) 
            { 
                if (bo.Org_Country.Length > 50) 
                { 
                     bo.Org_CountryErrors += "This field has more characters than the maximum that can be stored, i.e. 50 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.Org_DeptIsNull) 
            { 
                if (bo.Org_Dept.Length > 255) 
                { 
                     bo.Org_DeptErrors += "This field has more characters than the maximum that can be stored, i.e. 255 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.Org_DUNSIsNull) 
            { 
                if (bo.Org_DUNS.Length > 255) 
                { 
                     bo.Org_DUNSErrors += "This field has more characters than the maximum that can be stored, i.e. 255 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.Org_FIPSIsNull) 
            { 
                if (bo.Org_FIPS.Length > 255) 
                { 
                     bo.Org_FIPSErrors += "This field has more characters than the maximum that can be stored, i.e. 255 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.Org_StateIsNull) 
            { 
                if (bo.Org_State.Length > 50) 
                { 
                     bo.Org_StateErrors += "This field has more characters than the maximum that can be stored, i.e. 50 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.Org_ZipCodeIsNull) 
            { 
                if (bo.Org_ZipCode.Length > 50) 
                { 
                     bo.Org_ZipCodeErrors += "This field has more characters than the maximum that can be stored, i.e. 50 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.OrganizationIsNull) 
            { 
                if (bo.Organization.Length > 255) 
                { 
                     bo.OrganizationErrors += "This field has more characters than the maximum that can be stored, i.e. 255 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.PI_NamesIsNull) 
            { 
                if (bo.PI_Names.Length > 500) 
                { 
                     bo.PI_NamesErrors += "This field has more characters than the maximum that can be stored, i.e. 500 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.PI_PersonIdsIsNull) 
            { 
                if (bo.PI_PersonIds.Length > 500) 
                { 
                     bo.PI_PersonIdsErrors += "This field has more characters than the maximum that can be stored, i.e. 500 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.Project_NumIsNull) 
            { 
                if (bo.Project_Num.Length > 30) 
                { 
                     bo.Project_NumErrors += "This field has more characters than the maximum that can be stored, i.e. 30 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.Project_TermsIsNull) 
            { 
                if (bo.Project_Terms.Length > 4000) 
                { 
                     bo.Project_TermsErrors += "This field has more characters than the maximum that can be stored, i.e. 4000 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.Project_TitleIsNull) 
            { 
                if (bo.Project_Title.Length > 255) 
                { 
                     bo.Project_TitleErrors += "This field has more characters than the maximum that can be stored, i.e. 255 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.RelevanceIsNull) 
            { 
                if (bo.Relevance.Length > 4000) 
                { 
                     bo.RelevanceErrors += "This field has more characters than the maximum that can be stored, i.e. 4000 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.Study_SectionIsNull) 
            { 
                if (bo.Study_Section.Length > 4) 
                { 
                     bo.Study_SectionErrors += "This field has more characters than the maximum that can be stored, i.e. 4 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.Study_Section_NameIsNull) 
            { 
                if (bo.Study_Section_Name.Length > 255) 
                { 
                     bo.Study_Section_NameErrors += "This field has more characters than the maximum that can be stored, i.e. 255 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.SuffixIsNull) 
            { 
                if (bo.Suffix.Length > 6) 
                { 
                     bo.SuffixErrors += "This field has more characters than the maximum that can be stored, i.e. 6 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.Major_Component_NameIsNull) 
            { 
                if (bo.Major_Component_Name.Length > 255) 
                { 
                     bo.Major_Component_NameErrors += "This field has more characters than the maximum that can be stored, i.e. 255 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.Core_Project_NumIsNull) 
            { 
                if (bo.Core_Project_Num.Length > 50) 
                { 
                     bo.Core_Project_NumErrors += "This field has more characters than the maximum that can be stored, i.e. 50 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.CFDA_CodeIsNull) 
            { 
                if (bo.CFDA_Code.Length > 50) 
                { 
                     bo.CFDA_CodeErrors += "This field has more characters than the maximum that can be stored, i.e. 50 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.Ed_Inst_TypeIsNull) 
            { 
                if (bo.Ed_Inst_Type.Length > 100) 
                { 
                     bo.Ed_Inst_TypeErrors += "This field has more characters than the maximum that can be stored, i.e. 100 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.Program_Officer_NameIsNull) 
            { 
                if (bo.Program_Officer_Name.Length > 255) 
                { 
                     bo.Program_Officer_NameErrors += "This field has more characters than the maximum that can be stored, i.e. 255 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
        } 
    
    
        # endregion // Public Methods 
    
    }
    
} 
