using System;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.ORCID
{
    public partial class RecordLevelAuditTrail : ProfilesRNSDLL.DAL.ORCID.RecordLevelAuditTrail
    {
    
        # region Constructors 
    
        public RecordLevelAuditTrail() : base() { } 
    
        # endregion // Constructors
    
        # region Public Methods 
 
        public override void DBRulesCG(ProfilesRNSDLL.BO.ORCID.RecordLevelAuditTrail bo) 
        { 
            /*! Check for missing values */ 
			if (bo.MetaTableIDIsNull) { 
				bo.MetaTableIDErrors += "Required." + Environment.NewLine; 
				bo.HasError = true; 
			} else { 
			}  
			if (bo.RowIdentifierIsNull) { 
				bo.RowIdentifierErrors += "Required." + Environment.NewLine; 
				bo.HasError = true; 
			} else { 
			}  
			if (bo.RecordLevelAuditTypeIDIsNull) { 
				bo.RecordLevelAuditTypeIDErrors += "Required." + Environment.NewLine; 
				bo.HasError = true; 
			} else { 
			}  
			if (bo.CreatedDateIsNull) { 
				bo.CreatedDateErrors += "Required." + Environment.NewLine; 
				bo.HasError = true; 
			} else { 
			}  
			if (bo.CreatedByIsNull) { 
				bo.CreatedByErrors += "Required." + Environment.NewLine; 
				bo.HasError = true; 
			} else { 
			}  
            /*! Check for out of Range values */ 
            if (!bo.CreatedByIsNull) 
            { 
                if (bo.CreatedBy.Length > 10) 
                { 
                     bo.CreatedByErrors += "This field has more characters than the maximum that can be stored, i.e. 10 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
        } 
    
    
        # endregion // Public Methods 
    
    }
    
} 
