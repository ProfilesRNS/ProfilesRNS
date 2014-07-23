using System; 
using System.Collections.Generic; 
using System.Text; 
 
namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.ORCID
{
    public partial class PersonWorkIdentifier : ProfilesRNSDLL.DAL.ORCID.PersonWorkIdentifier
    {
    
        # region Constructors 
    
        public PersonWorkIdentifier() : base() { } 
    
        # endregion // Constructors
    
        # region Public Methods 
 
        public override void DBRulesCG(ProfilesRNSDLL.BO.ORCID.PersonWorkIdentifier bo) 
        { 
            /*! Check for missing values */ 
			if (bo.PersonWorkIDIsNull) { 
				bo.PersonWorkIDErrors += "Required." + Environment.NewLine; 
				bo.HasError = true; 
			} else { 
			}  
			if (bo.WorkExternalTypeIDIsNull) { 
				bo.WorkExternalTypeIDErrors += "Required." + Environment.NewLine; 
				bo.HasError = true; 
			} else { 
			}  
			if (bo.IdentifierIsNull) { 
				bo.IdentifierErrors += "Required." + Environment.NewLine; 
				bo.HasError = true; 
			} else { 
			}  
            /*! Check for out of Range values */ 
            if (!bo.IdentifierIsNull) 
            { 
                if (bo.Identifier.Length > 250) 
                { 
                     bo.IdentifierErrors += "This field has more characters than the maximum that can be stored, i.e. 250 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
        } 
    
    
        # endregion // Public Methods 
    
    }
    
} 
