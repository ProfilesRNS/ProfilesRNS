using System; 
using System.Collections.Generic; 
using System.Text; 
 
namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.ORCID
{
    public partial class PersonToken : ProfilesRNSDLL.DAL.ORCID.PersonToken
    {
    
        # region Constructors 
    
        public PersonToken() : base() { } 
    
        # endregion // Constructors
    
        # region Public Methods 
 
        public override void DBRulesCG(ProfilesRNSDLL.BO.ORCID.PersonToken bo) 
        { 
            /*! Check for missing values */ 
			if (bo.PersonIDIsNull) { 
				bo.PersonIDErrors += "Required." + Environment.NewLine; 
				bo.HasError = true; 
			} else { 
			}  
			if (bo.PermissionIDIsNull) { 
				bo.PermissionIDErrors += "Required." + Environment.NewLine; 
				bo.HasError = true; 
			} else { 
			}  
			if (bo.AccessTokenIsNull) { 
				bo.AccessTokenErrors += "Required." + Environment.NewLine; 
				bo.HasError = true; 
			} else { 
			}  
			if (bo.TokenExpirationIsNull) { 
				bo.TokenExpirationErrors += "Required." + Environment.NewLine; 
				bo.HasError = true; 
			} else { 
			}  
            /*! Check for out of Range values */ 
            if (!bo.AccessTokenIsNull) 
            { 
                if (bo.AccessToken.Length > 50) 
                { 
                     bo.AccessTokenErrors += "This field has more characters than the maximum that can be stored, i.e. 50 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.RefreshTokenIsNull) 
            { 
                if (bo.RefreshToken.Length > 50) 
                { 
                     bo.RefreshTokenErrors += "This field has more characters than the maximum that can be stored, i.e. 50 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
        } 
    
    
        # endregion // Public Methods 
    
    }
    
} 
