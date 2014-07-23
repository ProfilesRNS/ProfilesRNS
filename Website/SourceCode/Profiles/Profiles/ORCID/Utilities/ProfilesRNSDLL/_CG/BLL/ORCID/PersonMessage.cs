using System; 
using System.Collections.Generic; 
using System.Text; 
 
namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.ORCID
{
    public partial class PersonMessage : ProfilesRNSDLL.DAL.ORCID.PersonMessage
    {
    
        # region Constructors 
    
        public PersonMessage() : base() { } 
    
        # endregion // Constructors
    
        # region Public Methods 
 
        public override void DBRulesCG(ProfilesRNSDLL.BO.ORCID.PersonMessage bo) 
        { 
            /*! Check for missing values */ 
			if (bo.PersonIDIsNull) { 
				bo.PersonIDErrors += "Required." + Environment.NewLine; 
				bo.HasError = true; 
			} else { 
			}  
            /*! Check for out of Range values */ 
            if (!bo.ErrorMessageIsNull) 
            { 
                if (bo.ErrorMessage.Length > 1000) 
                { 
                     bo.ErrorMessageErrors += "This field has more characters than the maximum that can be stored, i.e. 1000 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.HttpResponseCodeIsNull) 
            { 
                if (bo.HttpResponseCode.Length > 50) 
                { 
                     bo.HttpResponseCodeErrors += "This field has more characters than the maximum that can be stored, i.e. 50 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.RequestURLIsNull) 
            { 
                if (bo.RequestURL.Length > 1000) 
                { 
                     bo.RequestURLErrors += "This field has more characters than the maximum that can be stored, i.e. 1000 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.HeaderPostIsNull) 
            { 
                if (bo.HeaderPost.Length > 1000) 
                { 
                     bo.HeaderPostErrors += "This field has more characters than the maximum that can be stored, i.e. 1000 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.UserMessageIsNull) 
            { 
                if (bo.UserMessage.Length > 2000) 
                { 
                     bo.UserMessageErrors += "This field has more characters than the maximum that can be stored, i.e. 2000 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
        } 
    
    
        # endregion // Public Methods 
    
    }
    
} 
