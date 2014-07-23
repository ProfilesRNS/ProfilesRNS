using System; 
using System.Collections.Generic; 
using System.Text; 
using System.Runtime.Serialization; 
using System.ComponentModel; 
 
namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.RDF
{ 
    public partial class Node
    { 
        public override int TableId { get { return 3690;} }
        public enum FieldNames : int { NodeID = 44210, ValueHash = 44211, Language = 44212, DataType = 44213, Value = 44214, InternalNodeMapID = 44215, ObjectType = 44216, ViewSecurityGroup = 44217, EditSecurityGroup = 44218 }
        public override string TableSchemaName { get { return "RDF."; } }
    } 
} 
