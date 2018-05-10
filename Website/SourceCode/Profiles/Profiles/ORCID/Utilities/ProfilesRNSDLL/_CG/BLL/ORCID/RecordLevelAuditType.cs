using System;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.ORCID
{
    public partial class RecordLevelAuditType : ProfilesRNSDLL.DAL.ORCID.RecordLevelAuditType
    {
    
        # region Constructors 
    
        public RecordLevelAuditType() : base() { } 
    
        # endregion // Constructors
    
        # region Public Methods 
 
        public override void DBRulesCG(ProfilesRNSDLL.BO.ORCID.RecordLevelAuditType bo) 
        { 
            /*! Check for missing values */ 
			if (bo.AuditTypeIsNull) { 
				bo.AuditTypeErrors += "Required." + Environment.NewLine; 
				bo.HasError = true; 
			} else { 
			}  
            /*! Check for out of Range values */ 
            if (!bo.AuditTypeIsNull) 
            { 
                if (bo.AuditType.Length > 50) 
                { 
                     bo.AuditTypeErrors += "This field has more characters than the maximum that can be stored, i.e. 50 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
        } 
    
    
        # endregion // Public Methods 
    
    }
    
} 
