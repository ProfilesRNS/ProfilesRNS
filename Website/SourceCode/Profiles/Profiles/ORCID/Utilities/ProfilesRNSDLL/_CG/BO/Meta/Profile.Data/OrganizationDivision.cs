using System; 
using System.Collections.Generic; 
using System.Text; 
using System.Runtime.Serialization; 
using System.ComponentModel; 
 
namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.Profile.Data
{ 
    public partial class OrganizationDivision
    { 
        public override int TableId { get { return 3683;} }
        public enum FieldNames : int { DivisionID = 44182, DivisionName = 44183 }
        public override string TableSchemaName { get { return "ORCID."; } }
    } 
} 
