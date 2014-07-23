using System; 
using System.Collections.Generic; 
using System.Text; 
using System.Runtime.Serialization; 
using System.ComponentModel; 
 
namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID
{ 
    public partial class REFRecordStatus
    { 
        public override int TableId { get { return 3727;} }
        public enum FieldNames : int { RecordStatusID = 44535, StatusDescription = 44536 }
        public override string TableSchemaName { get { return "ORCID."; } }
    } 
} 
