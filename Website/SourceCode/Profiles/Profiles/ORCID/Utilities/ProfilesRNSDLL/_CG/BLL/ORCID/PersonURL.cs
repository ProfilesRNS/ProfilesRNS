using System;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.ORCID
{
    public partial class PersonURL : ProfilesRNSDLL.DAL.ORCID.PersonURL
    {
    
        # region Constructors 
    
        public PersonURL() : base() { } 
    
        # endregion // Constructors
    
        # region Public Methods 
 
        public override void DBRulesCG(ProfilesRNSDLL.BO.ORCID.PersonURL bo) 
        { 
            /*! Check for missing values */ 
			if (bo.PersonIDIsNull) { 
				bo.PersonIDErrors += "Required." + Environment.NewLine; 
				bo.HasError = true; 
			} else { 
			}  
			if (bo.URLIsNull) { 
				bo.URLErrors += "Required." + Environment.NewLine; 
				bo.HasError = true; 
			} else { 
			}  
			if (bo.DecisionIDIsNull) { 
				bo.DecisionIDErrors += "Required." + Environment.NewLine; 
				bo.HasError = true; 
			} else { 
			}  
            /*! Check for out of Range values */ 
            if (!bo.URLNameIsNull) 
            { 
                if (bo.URLName.Length > 500) 
                { 
                     bo.URLNameErrors += "This field has more characters than the maximum that can be stored, i.e. 500 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.URLIsNull) 
            { 
                if (bo.URL.Length > 2000) 
                { 
                     bo.URLErrors += "This field has more characters than the maximum that can be stored, i.e. 2000 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
        } 
    
    
        # endregion // Public Methods 
    
    }
    
} 
