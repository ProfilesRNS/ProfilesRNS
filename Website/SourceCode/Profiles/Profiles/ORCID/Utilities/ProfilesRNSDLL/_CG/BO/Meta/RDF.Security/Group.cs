using System; 
using System.Collections.Generic; 
using System.Text; 
using System.Runtime.Serialization; 
using System.ComponentModel; 
 
namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.RDF.Security
{ 
    public partial class Group
    { 
        public override int TableId { get { return 3657;} }
        public enum FieldNames : int { SecurityGroupID = 43983, Label = 43984, HasSpecialViewAccess = 43985, HasSpecialEditAccess = 43986, Description = 43987, DefaultORCIDDecisionID = 44571 }
        public override string TableSchemaName { get { return "ORCID."; } }
    } 
} 
