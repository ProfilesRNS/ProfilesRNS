using System; 
using System.Collections.Generic; 
using System.Text; 
 
namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.RDF
{
    public partial class Node : ProfilesRNSDLL.DAL.RDF.Node
    {
    
        # region Constructors 
    
        public Node() : base() { } 
    
        # endregion // Constructors
    
        # region Public Methods 
 
        public override void DBRulesCG(ProfilesRNSDLL.BO.RDF.Node bo) 
        { 
            /*! Check for missing values */ 
			if (bo.ValueHashIsNull) { 
				bo.ValueHashErrors += "Required." + Environment.NewLine; 
				bo.HasError = true; 
			} else { 
			}  
			if (bo.ValueIsNull) { 
				bo.ValueErrors += "Required." + Environment.NewLine; 
				bo.HasError = true; 
			} else { 
			}  
            /*! Check for out of Range values */ 
            if (!bo.LanguageIsNull) 
            { 
                if (bo.Language.Length > 255) 
                { 
                     bo.LanguageErrors += "This field has more characters than the maximum that can be stored, i.e. 255 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
            if (!bo.DataTypeIsNull) 
            { 
                if (bo.DataType.Length > 255) 
                { 
                     bo.DataTypeErrors += "This field has more characters than the maximum that can be stored, i.e. 255 characters." + Environment.NewLine; 
                     bo.HasError = true;
                } 
            }
        } 
    
    
        # endregion // Public Methods 
    
    }
    
} 
