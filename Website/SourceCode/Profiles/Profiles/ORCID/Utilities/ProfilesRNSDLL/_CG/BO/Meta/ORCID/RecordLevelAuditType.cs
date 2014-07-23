using System; 
using System.Collections.Generic; 
using System.Text; 
using System.Runtime.Serialization; 
using System.ComponentModel; 
 
namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID
{ 
    public partial class RecordLevelAuditType
    { 
        public override int TableId { get { return 3629;} }
        public enum FieldNames : int { RecordLevelAuditTypeID = 43789, AuditType = 43790 }
        public override string TableSchemaName { get { return "ORCID."; } }
    } 
} 
