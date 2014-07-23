using System; 
using System.Collections.Generic; 
using System.Text; 
using System.Runtime.Serialization; 
using System.ComponentModel; 
 
namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID
{ 
    public partial class REFPermission
    { 
        public override int TableId { get { return 3722;} }
        public enum FieldNames : int { PermissionID = 44499, PermissionScope = 44500, PermissionDescription = 44501, MethodAndRequest = 44502, SuccessMessage = 44503, FailedMessage = 44504 }
        public override string TableSchemaName { get { return "ORCID."; } }
    } 
} 
