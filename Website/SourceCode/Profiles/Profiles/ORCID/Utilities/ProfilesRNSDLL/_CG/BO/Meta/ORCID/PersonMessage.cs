
namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID
{
    public partial class PersonMessage
    { 
        public override int TableId { get { return 3575;} }
        public enum FieldNames : int { PersonMessageID = 43469, PersonID = 43470, XML_Sent = 43471, XML_Response = 43472, ErrorMessage = 43473, HttpResponseCode = 43474, MessagePostSuccess = 43475, RecordStatusID = 43476, PermissionID = 43477, RequestURL = 43478, HeaderPost = 43479, UserMessage = 43480, PostDate = 43481 }
        public override string TableSchemaName { get { return "ORCID."; } }
    } 
} 
