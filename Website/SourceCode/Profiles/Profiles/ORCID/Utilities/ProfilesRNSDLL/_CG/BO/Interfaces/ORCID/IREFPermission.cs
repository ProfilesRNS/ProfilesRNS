namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.Interfaces.ORCID
{ 
    public partial interface IREFPermission
    { 
        int PermissionID { get; set; } 
        bool PermissionIDIsNull { get; set; }
        string PermissionScope { get; set; } 
        bool PermissionScopeIsNull { get; set; }
        string PermissionDescription { get; set; } 
        bool PermissionDescriptionIsNull { get; set; }
        string MethodAndRequest { get; set; } 
        bool MethodAndRequestIsNull { get; set; }
        string SuccessMessage { get; set; } 
        bool SuccessMessageIsNull { get; set; }
        string FailedMessage { get; set; } 
        bool FailedMessageIsNull { get; set; }
    } 
} 
