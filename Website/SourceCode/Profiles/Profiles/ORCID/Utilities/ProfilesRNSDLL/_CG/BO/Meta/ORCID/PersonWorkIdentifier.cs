using System; 
using System.Collections.Generic; 
using System.Text; 
using System.Runtime.Serialization; 
using System.ComponentModel; 
 
namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID
{ 
    public partial class PersonWorkIdentifier
    { 
        public override int TableId { get { return 3615;} }
        public enum FieldNames : int { PersonWorkIdentifierID = 43710, PersonWorkID = 43711, WorkExternalTypeID = 43712, Identifier = 43713 }
        public override string TableSchemaName { get { return "ORCID."; } }
    } 
} 
