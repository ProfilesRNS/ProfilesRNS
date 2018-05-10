
namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID
{
    public partial class PersonToken
    { 
        public override int TableId { get { return 3595;} }
        public enum FieldNames : int { PersonTokenID = 43591, PersonID = 43592, PermissionID = 43593, AccessToken = 43594, TokenExpiration = 43595, RefreshToken = 43596 }
        public override string TableSchemaName { get { return "ORCID."; } }
    } 
} 
