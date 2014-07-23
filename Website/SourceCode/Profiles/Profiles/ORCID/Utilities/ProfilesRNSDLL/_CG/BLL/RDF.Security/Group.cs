using System; 
using System.Collections.Generic; 
using System.Text; 
 
namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.RDF.Security
{
    public partial class Group : ProfilesRNSDLL.DAL.RDF.Security.Group
    {
    
        # region Constructors 
    
        public Group() : base() { } 
    
        # endregion // Constructors
    
        # region Public Methods 
 
        public override void DBRulesCG(ProfilesRNSDLL.BO.RDF.Security.Group bo) 
        { 
            /*! Check for missing values */ 
			if (bo.SecurityGroupIDIsNull) { 
				bo.SecurityGroupIDErrors += "Required." + Environment.NewLine; 
				bo.HasError = true; 
			} else { 
			}  
			if (bo.LabelIsNull) { 
				bo.LabelErrors += "Required." + Environment.NewLine; 
				bo.HasError = true; 
			} else { 
			}  
            /*! Check for out of Range values */ 
            if (!bo.LabelIsNull) 
            { 
                if (bo.Label.Length > 255) 
                { 
                     bo.LabelErrors += "This field has more characters than the maximum that can be stored, i.e. 255 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
        } 
    
    
        # endregion // Public Methods 
    
    }
    
} 
