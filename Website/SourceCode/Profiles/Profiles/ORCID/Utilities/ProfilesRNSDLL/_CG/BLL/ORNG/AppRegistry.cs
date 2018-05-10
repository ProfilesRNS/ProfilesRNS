using System;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.ORNG
{
    public partial class AppRegistry : ProfilesRNSDLL.DAL.ORNG.AppRegistry
    {
    
        # region Constructors 
    
        public AppRegistry() : base() { } 
    
        # endregion // Constructors
    
        # region Public Methods 
 
        public override void DBRulesCG(ProfilesRNSDLL.BO.ORNG.AppRegistry bo) 
        { 
            /*! Check for missing values */ 
			if (bo.nodeidIsNull) { 
				bo.nodeidErrors += "Required." + Environment.NewLine; 
				bo.HasError = true; 
			} else { 
			}  
			if (bo.appIdIsNull) { 
				bo.appIdErrors += "Required." + Environment.NewLine; 
				bo.HasError = true; 
			} else { 
			}  
            /*! Check for out of Range values */ 
            if (!bo.visibilityIsNull) 
            { 
                if (bo.visibility.Length > 50) 
                { 
                     bo.visibilityErrors += "This field has more characters than the maximum that can be stored, i.e. 50 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
        } 
    
    
        # endregion // Public Methods 
    
    }
    
} 
