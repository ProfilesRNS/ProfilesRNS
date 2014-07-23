using System; 
using System.Collections.Generic; 
using System.Text; 
 
namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.ORCID
{
    public partial class ErrorLog : ProfilesRNSDLL.DAL.ORCID.ErrorLog
    {
    
        # region Constructors 
    
        public ErrorLog() : base() { } 
    
        # endregion // Constructors
    
        # region Public Methods 
 
        public override void DBRulesCG(ProfilesRNSDLL.BO.ORCID.ErrorLog bo) 
        { 
            /*! Check for missing values */ 
			if (bo.ExceptionIsNull) { 
				bo.ExceptionErrors += "Required." + Environment.NewLine; 
				bo.HasError = true; 
			} else { 
			}  
			if (bo.OccurredOnIsNull) { 
				bo.OccurredOnErrors += "Required." + Environment.NewLine; 
				bo.HasError = true; 
			} else { 
			}  
			if (bo.ProcessedIsNull) { 
				bo.ProcessedErrors += "Required." + Environment.NewLine; 
				bo.HasError = true; 
			} else { 
			}  
            /*! Check for out of Range values */ 
            if (!bo.InternalUsernameIsNull) 
            { 
                if (bo.InternalUsername.Length > 11) 
                { 
                     bo.InternalUsernameErrors += "This field has more characters than the maximum that can be stored, i.e. 11 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
        } 
    
    
        # endregion // Public Methods 
    
    }
    
} 
