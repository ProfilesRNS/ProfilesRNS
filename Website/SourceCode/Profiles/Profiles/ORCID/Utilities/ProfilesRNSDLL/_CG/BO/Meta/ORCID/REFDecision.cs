using System; 
using System.Collections.Generic; 
using System.Text; 
using System.Runtime.Serialization; 
using System.ComponentModel; 
 
namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID
{ 
    public partial class REFDecision
    { 
        public override int TableId { get { return 3730;} }
        public enum FieldNames : int { DecisionID = 44567, DecisionDescription = 44568, DecisionDescriptionLong = 44569 }
        public override string TableSchemaName { get { return "ORCID."; } }
    } 
} 
