using System;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.RDF
{
    public partial class Triple : ProfilesRNSDLL.DAL.RDF.Triple
    {
    
        # region Constructors 
    
        public Triple() : base() { } 
    
        # endregion // Constructors
    
        # region Public Methods 
 
        public override void DBRulesCG(ProfilesRNSDLL.BO.RDF.Triple bo) 
        { 
            /*! Check for missing values */ 
			if (bo.SubjectIsNull) { 
				bo.SubjectErrors += "Required." + Environment.NewLine; 
				bo.HasError = true; 
			} else { 
			}  
			if (bo.PredicateIsNull) { 
				bo.PredicateErrors += "Required." + Environment.NewLine; 
				bo.HasError = true; 
			} else { 
			}  
			if (bo.ObjectIsNull) { 
				bo.ObjectErrors += "Required." + Environment.NewLine; 
				bo.HasError = true; 
			} else { 
			}  
			if (bo.TripleHashIsNull) { 
				bo.TripleHashErrors += "Required." + Environment.NewLine; 
				bo.HasError = true; 
			} else { 
			}  
			if (bo.WeightIsNull) { 
				bo.WeightErrors += "Required." + Environment.NewLine; 
				bo.HasError = true; 
			} else { 
			}  
            /*! Check for out of Range values */ 
        } 
    
    
        # endregion // Public Methods 
    
    }
    
} 
