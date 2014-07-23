using System; 
using System.Collections.Generic; 
using System.Text; 
using System.Runtime.Serialization; 
using System.ComponentModel; 
 
namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.Profile.Data
{ 
    public partial class OrganizationDepartment
    { 
        public override int TableId { get { return 3684;} }
        public enum FieldNames : int { DepartmentID = 44184, DepartmentName = 44185, Visible = 44186 }
        public override string TableSchemaName { get { return "ORCID."; } }
    } 
} 
