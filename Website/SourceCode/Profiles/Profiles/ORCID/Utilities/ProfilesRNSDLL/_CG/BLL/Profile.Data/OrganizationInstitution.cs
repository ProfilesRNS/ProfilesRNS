using System; 
using System.Collections.Generic; 
using System.Text; 
 
namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.Profile.Data
{
    public partial class OrganizationInstitution : ProfilesRNSDLL.DAL.Profile.Data.OrganizationInstitution
    {
    
        # region Constructors 
    
        public OrganizationInstitution() : base() { } 
    
        # endregion // Constructors
    
        # region Public Methods 
 
        public override void DBRulesCG(ProfilesRNSDLL.BO.Profile.Data.OrganizationInstitution bo) 
        { 
            /*! Check for missing values */ 
            /*! Check for out of Range values */ 
            if (!bo.InstitutionNameIsNull) 
            { 
                if (bo.InstitutionName.Length > 500) 
                { 
                     bo.InstitutionNameErrors += "This field has more characters than the maximum that can be stored, i.e. 500 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.InstitutionAbbreviationIsNull) 
            { 
                if (bo.InstitutionAbbreviation.Length > 50) 
                { 
                     bo.InstitutionAbbreviationErrors += "This field has more characters than the maximum that can be stored, i.e. 50 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
 /*           if (!bo.CityIsNull) 
            { 
                if (bo.City.Length > 500) 
                { 
                     bo.CityErrors += "This field has more characters than the maximum that can be stored, i.e. 500 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.StateIsNull) 
            { 
                if (bo.State.Length > 2) 
                { 
                     bo.StateErrors += "This field has more characters than the maximum that can be stored, i.e. 2 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.CountryIsNull) 
            { 
                if (bo.Country.Length > 2) 
                { 
                     bo.CountryErrors += "This field has more characters than the maximum that can be stored, i.e. 2 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.RingGoldIDIsNull) 
            { 
                if (bo.RingGoldID.Length > 100) 
                { 
                     bo.RingGoldIDErrors += "This field has more characters than the maximum that can be stored, i.e. 100 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
   */     } 
    
    
        # endregion // Public Methods 
    
    }
    
} 
