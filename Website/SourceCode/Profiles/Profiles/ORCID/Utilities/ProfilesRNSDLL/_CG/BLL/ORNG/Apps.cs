using System;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.ORNG
{
    public partial class Apps : ProfilesRNSDLL.DAL.ORNG.Apps
    {
    
        # region Constructors 
    
        public Apps() : base() { } 
    
        # endregion // Constructors
    
        # region Public Methods 
 
        public override void DBRulesCG(ProfilesRNSDLL.BO.ORNG.Apps bo) 
        { 
            /*! Check for missing values */ 
			if (bo.appIdIsNull) { 
				bo.appIdErrors += "Required." + Environment.NewLine; 
				bo.HasError = true; 
			} else { 
			}  
			if (bo.nameIsNull) { 
				bo.nameErrors += "Required." + Environment.NewLine; 
				bo.HasError = true; 
			} else { 
			}  
			if (bo.enabledIsNull) { 
				bo.enabledErrors += "Required." + Environment.NewLine; 
				bo.HasError = true; 
			} else { 
			}  
            /*! Check for out of Range values */ 
            if (!bo.nameIsNull) 
            { 
                if (bo.name.Length > 255) 
                { 
                     bo.nameErrors += "This field has more characters than the maximum that can be stored, i.e. 255 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.urlIsNull) 
            { 
                if (bo.url.Length > 255) 
                { 
                     bo.urlErrors += "This field has more characters than the maximum that can be stored, i.e. 255 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
        } 
    
    
        # endregion // Public Methods 
    
    }
    
} 
