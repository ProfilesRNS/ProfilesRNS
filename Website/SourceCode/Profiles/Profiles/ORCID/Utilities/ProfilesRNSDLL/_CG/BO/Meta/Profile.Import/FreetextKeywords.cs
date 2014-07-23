using System; 
using System.Collections.Generic; 
using System.Text; 
using System.Runtime.Serialization; 
using System.ComponentModel; 
 
namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.Profile.Import
{ 
    public partial class FreetextKeywords
    { 
        public override int TableId { get { return 4441;} }
        public enum FieldNames : int { PersonKeywordID = 52582, InternalUsername = 52583, Keyword = 52584, DisplaySecurityGroupID = 52585 }
        public override string TableSchemaName { get { return "Profile.Import"; } }
    } 
} 
