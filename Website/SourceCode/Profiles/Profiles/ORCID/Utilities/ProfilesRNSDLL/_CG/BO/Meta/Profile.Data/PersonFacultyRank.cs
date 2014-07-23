using System; 
using System.Collections.Generic; 
using System.Text; 
using System.Runtime.Serialization; 
using System.ComponentModel; 
 
namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.Profile.Data
{ 
    public partial class PersonFacultyRank
    { 
        public override int TableId { get { return 3572;} }
        public enum FieldNames : int { FacultyRankID = 43458, FacultyRank = 43459, FacultyRankSort = 43460, Visible = 43461 }
        public override string TableSchemaName { get { return "ORCID."; } }
    } 
} 
