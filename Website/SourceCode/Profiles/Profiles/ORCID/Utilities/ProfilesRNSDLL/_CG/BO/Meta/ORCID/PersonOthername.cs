using System; 
using System.Collections.Generic; 
using System.Text; 
using System.Runtime.Serialization; 
using System.ComponentModel; 
 
namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID
{ 
    public partial class PersonOthername
    { 
        public override int TableId { get { return 3733;} }
        public enum FieldNames : int { PersonOthernameID = 44582, PersonID = 44583, OtherName = 44584, PersonMessageID = 44585 }
        public override string TableSchemaName { get { return "ORCID."; } }
    } 
} 
