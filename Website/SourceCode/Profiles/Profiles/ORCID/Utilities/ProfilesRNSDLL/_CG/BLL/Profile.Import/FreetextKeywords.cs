using System; 
using System.Collections.Generic; 
using System.Text; 
 
namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.Profile.Import
{
    public partial class FreetextKeywords : ProfilesRNSDLL.DAL.Profile.Import.FreetextKeywords
    {
    
        # region Constructors 
    
        public FreetextKeywords() : base() { } 
    
        # endregion // Constructors
    
        # region Public Methods 
 
        public override void DBRulesCG(ProfilesRNSDLL.BO.Profile.Import.FreetextKeywords bo) 
        { 
            /*! Check for missing values */ 
			if (bo.InternalUsernameIsNull) { 
				bo.InternalUsernameErrors += "Required." + Environment.NewLine; 
				bo.HasError = true; 
			} else { 
			}  
			if (bo.KeywordIsNull) { 
				bo.KeywordErrors += "Required." + Environment.NewLine; 
				bo.HasError = true; 
			} else { 
			}  
			if (bo.DisplaySecurityGroupIDIsNull) { 
				bo.DisplaySecurityGroupIDErrors += "Required." + Environment.NewLine; 
				bo.HasError = true; 
			} else { 
			}  
            /*! Check for out of Range values */ 
            if (!bo.InternalUsernameIsNull) 
            { 
                if (bo.InternalUsername.Length > 50) 
                { 
                     bo.InternalUsernameErrors += "This field has more characters than the maximum that can be stored, i.e. 50 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.KeywordIsNull) 
            { 
                if (bo.Keyword.Length > 250) 
                { 
                     bo.KeywordErrors += "This field has more characters than the maximum that can be stored, i.e. 250 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
        } 
    
    
        # endregion // Public Methods 
    
    }
    
} 
