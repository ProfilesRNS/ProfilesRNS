using System;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.ORCID
{
    public partial class REFPermission : ProfilesRNSDLL.DAL.ORCID.REFPermission
    {
    
        # region Constructors 
    
        public REFPermission() : base() { } 
    
        # endregion // Constructors
    
        # region Public Methods 
 
        public override void DBRulesCG(ProfilesRNSDLL.BO.ORCID.REFPermission bo) 
        { 
            /*! Check for missing values */ 
			if (bo.PermissionScopeIsNull) { 
				bo.PermissionScopeErrors += "Required." + Environment.NewLine; 
				bo.HasError = true; 
			} else { 
			}  
			if (bo.PermissionDescriptionIsNull) { 
				bo.PermissionDescriptionErrors += "Required." + Environment.NewLine; 
				bo.HasError = true; 
			} else { 
			}  
            /*! Check for out of Range values */ 
            if (!bo.PermissionScopeIsNull) 
            { 
                if (bo.PermissionScope.Length > 100) 
                { 
                     bo.PermissionScopeErrors += "This field has more characters than the maximum that can be stored, i.e. 100 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.PermissionDescriptionIsNull) 
            { 
                if (bo.PermissionDescription.Length > 500) 
                { 
                     bo.PermissionDescriptionErrors += "This field has more characters than the maximum that can be stored, i.e. 500 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.MethodAndRequestIsNull) 
            { 
                if (bo.MethodAndRequest.Length > 100) 
                { 
                     bo.MethodAndRequestErrors += "This field has more characters than the maximum that can be stored, i.e. 100 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.SuccessMessageIsNull) 
            { 
                if (bo.SuccessMessage.Length > 1000) 
                { 
                     bo.SuccessMessageErrors += "This field has more characters than the maximum that can be stored, i.e. 1000 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.FailedMessageIsNull) 
            { 
                if (bo.FailedMessage.Length > 1000) 
                { 
                     bo.FailedMessageErrors += "This field has more characters than the maximum that can be stored, i.e. 1000 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
        } 
    
    
        # endregion // Public Methods 
    
    }
    
} 
