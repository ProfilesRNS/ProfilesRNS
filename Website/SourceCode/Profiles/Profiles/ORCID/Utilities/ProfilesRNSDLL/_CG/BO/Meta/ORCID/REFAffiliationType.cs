using System; 
using System.Collections.Generic; 
using System.Text; 
using System.Runtime.Serialization; 
using System.ComponentModel; 
 
namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID
{ 
    public partial class REFAffiliationType
    { 
        public override int TableId { get { return 4469;} }
        public enum FieldNames : int { AffiliationTypeID = 52856, AffiliationType = 52857 }
        public override string TableSchemaName { get { return "ORCID."; } }
    } 
} 
