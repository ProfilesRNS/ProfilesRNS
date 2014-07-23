using System; 
using System.Collections.Generic; 
using System.Text; 
 
namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.ORNG
{
    public partial class AppData : ProfilesRNSDLL.DAL.ORNG.AppData
    {
    
        # region Constructors 
    
        public AppData() : base() { } 
    
        # endregion // Constructors
    
        # region Public Methods 
 
        public override void DBRulesCG(ProfilesRNSDLL.BO.ORNG.AppData bo) 
        { 
            /*! Check for missing values */ 
			if (bo.nodeIdIsNull) { 
				bo.nodeIdErrors += "Required." + Environment.NewLine; 
				bo.HasError = true; 
			} else { 
			}  
			if (bo.appIdIsNull) { 
				bo.appIdErrors += "Required." + Environment.NewLine; 
				bo.HasError = true; 
			} else { 
			}  
			if (bo.keynameIsNull) { 
				bo.keynameErrors += "Required." + Environment.NewLine; 
				bo.HasError = true; 
			} else { 
			}  
            /*! Check for out of Range values */ 
            if (!bo.keynameIsNull) 
            { 
                if (bo.keyname.Length > 255) 
                { 
                     bo.keynameErrors += "This field has more characters than the maximum that can be stored, i.e. 255 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.valueIsNull) 
            { 
                if (bo.value.Length > 4000) 
                { 
                     bo.valueErrors += "This field has more characters than the maximum that can be stored, i.e. 4000 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
        } 
    
    
        # endregion // Public Methods 
    
    }
    
} 
