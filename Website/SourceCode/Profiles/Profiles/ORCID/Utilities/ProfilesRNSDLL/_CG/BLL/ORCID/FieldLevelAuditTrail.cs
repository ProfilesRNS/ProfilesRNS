using System;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.ORCID
{
    public partial class FieldLevelAuditTrail : ProfilesRNSDLL.DAL.ORCID.FieldLevelAuditTrail
    {
    
        # region Constructors 
    
        public FieldLevelAuditTrail() : base() { } 
    
        # endregion // Constructors
    
        # region Public Methods 
 
        public override void DBRulesCG(ProfilesRNSDLL.BO.ORCID.FieldLevelAuditTrail bo) 
        { 
            /*! Check for missing values */ 
			if (bo.RecordLevelAuditTrailIDIsNull) { 
				bo.RecordLevelAuditTrailIDErrors += "Required." + Environment.NewLine; 
				bo.HasError = true; 
			} else { 
			}  
			if (bo.MetaFieldIDIsNull) { 
				bo.MetaFieldIDErrors += "Required." + Environment.NewLine; 
				bo.HasError = true; 
			} else { 
			}  
            /*! Check for out of Range values */ 
            if (!bo.ValueBeforeIsNull) 
            { 
                if (bo.ValueBefore.Length > 50) 
                { 
                     bo.ValueBeforeErrors += "This field has more characters than the maximum that can be stored, i.e. 50 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.ValueAfterIsNull) 
            { 
                if (bo.ValueAfter.Length > 50) 
                { 
                     bo.ValueAfterErrors += "This field has more characters than the maximum that can be stored, i.e. 50 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
        } 
    
    
        # endregion // Public Methods 
    
    }
    
} 
