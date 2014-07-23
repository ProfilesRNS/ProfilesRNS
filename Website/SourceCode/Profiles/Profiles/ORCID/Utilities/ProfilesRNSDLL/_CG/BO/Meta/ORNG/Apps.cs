using System; 
using System.Collections.Generic; 
using System.Text; 
using System.Runtime.Serialization; 
using System.ComponentModel; 
 
namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORNG
{ 
    public partial class Apps
    { 
        public override int TableId { get { return 3694;} }
        public enum FieldNames : int { appId = 44227, name = 44228, url = 44229, PersonFilterID = 44230, enabled = 44231 }
        public override string TableSchemaName { get { return "ORNG"; } }
    } 
} 
