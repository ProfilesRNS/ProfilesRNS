using System;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.ORCID
{
    public partial class PersonAlternateEmail : ProfilesRNSDLL.DAL.ORCID.PersonAlternateEmail
    {
    
        # region Constructors 
    
        public PersonAlternateEmail() : base() { } 
    
        # endregion // Constructors
    
        # region Public Methods 
 
        public override void DBRulesCG(ProfilesRNSDLL.BO.ORCID.PersonAlternateEmail bo) 
        { 
            /*! Check for missing values */ 
			if (bo.PersonIDIsNull) { 
				bo.PersonIDErrors += "Required." + Environment.NewLine; 
				bo.HasError = true; 
			} else { 
			}  
			if (bo.EmailAddressIsNull) { 
				bo.EmailAddressErrors += "Required." + Environment.NewLine; 
				bo.HasError = true; 
			} else { 
			}  
            /*! Check for out of Range values */ 
            if (!bo.EmailAddressIsNull) 
            { 
                if (bo.EmailAddress.Length > 200) 
                { 
                     bo.EmailAddressErrors += "This field has more characters than the maximum that can be stored, i.e. 200 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
        } 
    
    
        # endregion // Public Methods 
    
    }
    
} 
