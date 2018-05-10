using System;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.ORCID
{
    public partial class PersonWork : ProfilesRNSDLL.DAL.ORCID.PersonWork
    {
    
        # region Constructors 
    
        public PersonWork() : base() { } 
    
        # endregion // Constructors
    
        # region Public Methods 
 
        public override void DBRulesCG(ProfilesRNSDLL.BO.ORCID.PersonWork bo) 
        { 
            /*! Check for missing values */ 
			if (bo.PersonIDIsNull) { 
				bo.PersonIDErrors += "Required." + Environment.NewLine; 
				bo.HasError = true; 
			} else { 
			}  
			if (bo.DecisionIDIsNull) { 
				bo.DecisionIDErrors += "Required." + Environment.NewLine; 
				bo.HasError = true; 
			} else { 
			}  
			if (bo.WorkTitleIsNull) { 
				bo.WorkTitleErrors += "Required." + Environment.NewLine; 
				bo.HasError = true; 
			} else { 
			}  
			if (bo.PubIDIsNull) { 
				bo.PubIDErrors += "Required." + Environment.NewLine; 
				bo.HasError = true; 
			} else { 
			}  
            /*! Check for out of Range values */ 
            if (!bo.WorkTypeIsNull) 
            { 
                if (bo.WorkType.Length > 500) 
                { 
                     bo.WorkTypeErrors += "This field has more characters than the maximum that can be stored, i.e. 500 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.URLIsNull) 
            { 
                if (bo.URL.Length > 1000) 
                { 
                     bo.URLErrors += "This field has more characters than the maximum that can be stored, i.e. 1000 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.WorkCitationTypeIsNull) 
            { 
                if (bo.WorkCitationType.Length > 500) 
                { 
                     bo.WorkCitationTypeErrors += "This field has more characters than the maximum that can be stored, i.e. 500 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.PublicationMediaTypeIsNull) 
            { 
                if (bo.PublicationMediaType.Length > 500) 
                { 
                     bo.PublicationMediaTypeErrors += "This field has more characters than the maximum that can be stored, i.e. 500 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.PubIDIsNull) 
            { 
                if (bo.PubID.Length > 50) 
                { 
                     bo.PubIDErrors += "This field has more characters than the maximum that can be stored, i.e. 50 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
        } 
    
    
        # endregion // Public Methods 
    
    }
    
} 
