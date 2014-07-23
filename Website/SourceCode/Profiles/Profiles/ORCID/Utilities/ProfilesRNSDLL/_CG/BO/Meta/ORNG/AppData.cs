using System; 
using System.Collections.Generic; 
using System.Text; 
using System.Runtime.Serialization; 
using System.ComponentModel; 
 
namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORNG
{ 
    public partial class AppData
    { 
        public override int TableId { get { return 3705;} }
        public enum FieldNames : int { nodeId = 44268, appId = 44269, keyname = 44270, value = 44271, createdDT = 44272, updatedDT = 44273 }
        public override string TableSchemaName { get { return "ORNG"; } }
    } 
} 
