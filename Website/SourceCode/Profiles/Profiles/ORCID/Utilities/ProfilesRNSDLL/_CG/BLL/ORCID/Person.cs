using System;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.ORCID
{
    public partial class Person : ProfilesRNSDLL.DAL.ORCID.Person
    {
    
        # region Constructors 
    
        public Person() : base() { } 
    
        # endregion // Constructors
    
        # region Public Methods 
 
        public override void DBRulesCG(ProfilesRNSDLL.BO.ORCID.Person bo) 
        { 
            /*! Check for missing values */ 
			if (bo.InternalUsernameIsNull) { 
				bo.InternalUsernameErrors += "Required." + Environment.NewLine; 
				bo.HasError = true; 
			} else { 
			}  
			if (bo.PersonStatusTypeIDIsNull) { 
				bo.PersonStatusTypeIDErrors += "Required." + Environment.NewLine; 
				bo.HasError = true; 
			} else { 
			}  
			if (bo.CreateUnlessOptOutIsNull) { 
				bo.CreateUnlessOptOutErrors += "Required." + Environment.NewLine; 
				bo.HasError = true; 
			} else { 
			}  
            /*! Check for out of Range values */ 
            if (!bo.InternalUsernameIsNull) 
            { 
                if (bo.InternalUsername.Length > 100) 
                { 
                     bo.InternalUsernameErrors += "This field has more characters than the maximum that can be stored, i.e. 100 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.ORCIDIsNull) 
            { 
                if (bo.ORCID.Length > 50) 
                { 
                     bo.ORCIDErrors += "This field has more characters than the maximum that can be stored, i.e. 50 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.FirstNameIsNull) 
            { 
                if (bo.FirstName.Length > 150) 
                { 
                     bo.FirstNameErrors += "This field has more characters than the maximum that can be stored, i.e. 150 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.LastNameIsNull) 
            { 
                if (bo.LastName.Length > 150) 
                { 
                     bo.LastNameErrors += "This field has more characters than the maximum that can be stored, i.e. 150 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.PublishedNameIsNull) 
            { 
                if (bo.PublishedName.Length > 500) 
                { 
                     bo.PublishedNameErrors += "This field has more characters than the maximum that can be stored, i.e. 500 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.EmailAddressIsNull) 
            { 
                if (bo.EmailAddress.Length > 300) 
                { 
                     bo.EmailAddressErrors += "This field has more characters than the maximum that can be stored, i.e. 300 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.BiographyIsNull) 
            { 
                if (bo.Biography.Length > 5000) 
                { 
                     bo.BiographyErrors += "This field has more characters than the maximum that can be stored, i.e. 5000 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
        } 
    
    
        # endregion // Public Methods 
    
    }
    
} 
