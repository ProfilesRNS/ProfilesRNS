using System; 
using System.Collections.Generic; 
using System.Text; 
 
namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.Profile.Data
{
    public partial class OrganizationDepartment : ProfilesRNSDLL.DAL.Profile.Data.OrganizationDepartment
    {
    
        # region Constructors 
    
        public OrganizationDepartment() : base() { } 
    
        # endregion // Constructors
    
        # region Public Methods 
 
        public override void DBRulesCG(ProfilesRNSDLL.BO.Profile.Data.OrganizationDepartment bo) 
        { 
            /*! Check for missing values */ 
            /*! Check for out of Range values */ 
            if (!bo.DepartmentNameIsNull) 
            { 
                if (bo.DepartmentName.Length > 500) 
                { 
                     bo.DepartmentNameErrors += "This field has more characters than the maximum that can be stored, i.e. 500 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
        } 
    
    
        # endregion // Public Methods 
    
    }
    
} 
