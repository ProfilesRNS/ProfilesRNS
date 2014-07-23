using System; 
using System.Collections.Generic; 
using System.Text; 
 
namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.ORCID
{
    public partial class PersonAffiliation : ProfilesRNSDLL.DAL.ORCID.PersonAffiliation
    {
    
        # region Constructors 
    
        public PersonAffiliation() : base() { } 
    
        # endregion // Constructors
    
        # region Public Methods 
 
        public override void DBRulesCG(ProfilesRNSDLL.BO.ORCID.PersonAffiliation bo) 
        { 
            /*! Check for missing values */ 
			if (bo.ProfilesIDIsNull) { 
				bo.ProfilesIDErrors += "Required." + Environment.NewLine; 
				bo.HasError = true; 
			} else { 
			}  
			if (bo.AffiliationTypeIDIsNull) { 
				bo.AffiliationTypeIDErrors += "Required." + Environment.NewLine; 
				bo.HasError = true; 
			} else { 
			}  
			if (bo.PersonIDIsNull) { 
				bo.PersonIDErrors += "Required." + Environment.NewLine; 
				bo.HasError = true; 
			} else { 
			}  
			if (bo.DecisionIDIsNull) { 
				bo.DecisionIDErrors += "Required." + Environment.NewLine; 
				bo.HasError = true; 
			} else { 
			}  
			if (bo.OrganizationNameIsNull) { 
				bo.OrganizationNameErrors += "Required." + Environment.NewLine; 
				bo.HasError = true; 
			} else { 
			}  
            /*! Check for out of Range values */ 
            if (!bo.DepartmentNameIsNull) 
            { 
                if (bo.DepartmentName.Length > 4000) 
                { 
                     bo.DepartmentNameErrors += "This field has more characters than the maximum that can be stored, i.e. 4000 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.RoleTitleIsNull) 
            { 
                if (bo.RoleTitle.Length > 200) 
                { 
                     bo.RoleTitleErrors += "This field has more characters than the maximum that can be stored, i.e. 200 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.OrganizationNameIsNull) 
            { 
                if (bo.OrganizationName.Length > 4000) 
                { 
                     bo.OrganizationNameErrors += "This field has more characters than the maximum that can be stored, i.e. 4000 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.OrganizationCityIsNull) 
            { 
                if (bo.OrganizationCity.Length > 4000) 
                { 
                     bo.OrganizationCityErrors += "This field has more characters than the maximum that can be stored, i.e. 4000 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.OrganizationRegionIsNull) 
            { 
                if (bo.OrganizationRegion.Length > 2) 
                { 
                     bo.OrganizationRegionErrors += "This field has more characters than the maximum that can be stored, i.e. 2 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.OrganizationCountryIsNull) 
            { 
                if (bo.OrganizationCountry.Length > 2) 
                { 
                     bo.OrganizationCountryErrors += "This field has more characters than the maximum that can be stored, i.e. 2 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.DisambiguationIDIsNull) 
            { 
                if (bo.DisambiguationID.Length > 500) 
                { 
                     bo.DisambiguationIDErrors += "This field has more characters than the maximum that can be stored, i.e. 500 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.DisambiguationSourceIsNull) 
            { 
                if (bo.DisambiguationSource.Length > 500) 
                { 
                     bo.DisambiguationSourceErrors += "This field has more characters than the maximum that can be stored, i.e. 500 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
        } 
    
    
        # endregion // Public Methods 
    
    }
    
} 
