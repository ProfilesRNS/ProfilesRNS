using System; 
using System.Collections.Generic; 
using System.Text; 
using System.Runtime.Serialization; 
using System.ComponentModel; 
 
namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID
{ 
    public partial class REFPersonStatusType
    { 
        public override int TableId { get { return 3724;} }
        public enum FieldNames : int { PersonStatusTypeID = 44507, StatusDescription = 44508 }
        public override string TableSchemaName { get { return "ORCID."; } }
    } 
} 
