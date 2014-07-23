using System; 
using System.Collections.Generic; 
using System.Text; 
using System.Runtime.Serialization; 
using System.ComponentModel; 
 
namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID
{ 
    public partial class REFWorkExternalType
    { 
        public override int TableId { get { return 3563;} }
        public enum FieldNames : int { WorkExternalTypeID = 43402, WorkExternalType = 43403, WorkExternalDescription = 43404 }
        public override string TableSchemaName { get { return "ORCID."; } }
    } 
} 
