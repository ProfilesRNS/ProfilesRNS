using System;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.Profile.Data
{
    public partial class OrganizationDivision : ProfilesRNSDLL.DAL.Profile.Data.OrganizationDivision
    {
    
        # region Constructors 
    
        public OrganizationDivision() : base() { } 
    
        # endregion // Constructors
    
        # region Public Methods 
 
        public override void DBRulesCG(ProfilesRNSDLL.BO.Profile.Data.OrganizationDivision bo) 
        { 
            /*! Check for missing values */ 
            /*! Check for out of Range values */ 
            if (!bo.DivisionNameIsNull) 
            { 
                if (bo.DivisionName.Length > 500) 
                { 
                     bo.DivisionNameErrors += "This field has more characters than the maximum that can be stored, i.e. 500 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
        } 
    
    
        # endregion // Public Methods 
    
    }
    
} 
