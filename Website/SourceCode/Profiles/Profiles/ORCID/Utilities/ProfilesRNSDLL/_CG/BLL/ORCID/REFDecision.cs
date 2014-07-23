using System; 
using System.Collections.Generic; 
using System.Text; 
 
namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.ORCID
{
    public partial class REFDecision : ProfilesRNSDLL.DAL.ORCID.REFDecision
    {
    
        # region Constructors 
    
        public REFDecision() : base() { } 
    
        # endregion // Constructors
    
        # region Public Methods 
 
        public override void DBRulesCG(ProfilesRNSDLL.BO.ORCID.REFDecision bo) 
        { 
            /*! Check for missing values */ 
			if (bo.DecisionDescriptionIsNull) { 
				bo.DecisionDescriptionErrors += "Required." + Environment.NewLine; 
				bo.HasError = true; 
			} else { 
			}  
			if (bo.DecisionDescriptionLongIsNull) { 
				bo.DecisionDescriptionLongErrors += "Required." + Environment.NewLine; 
				bo.HasError = true; 
			} else { 
			}  
            /*! Check for out of Range values */ 
            if (!bo.DecisionDescriptionIsNull) 
            { 
                if (bo.DecisionDescription.Length > 150) 
                { 
                     bo.DecisionDescriptionErrors += "This field has more characters than the maximum that can be stored, i.e. 150 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.DecisionDescriptionLongIsNull) 
            { 
                if (bo.DecisionDescriptionLong.Length > 500) 
                { 
                     bo.DecisionDescriptionLongErrors += "This field has more characters than the maximum that can be stored, i.e. 500 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
        } 
    
    
        # endregion // Public Methods 
    
    }
    
} 
