using System; 
using System.Collections.Generic; 
using System.Text; 
using System.Runtime.Serialization; 
using System.ComponentModel; 
 
namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.RDF
{ 
    public partial class Triple
    { 
        public override int TableId { get { return 3676;} }
        public enum FieldNames : int { TripleID = 44131, Subject = 44132, Predicate = 44133, Object = 44134, TripleHash = 44135, Weight = 44136, Reitification = 44137, ObjectType = 44138, SortOrder = 44139, ViewSecurityGroup = 44140, Graph = 44141 }
        public override string TableSchemaName { get { return "RDF."; } }
    } 
} 
