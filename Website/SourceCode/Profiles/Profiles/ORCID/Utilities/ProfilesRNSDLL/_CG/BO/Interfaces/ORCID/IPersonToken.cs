namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.Interfaces.ORCID
{ 
    public partial interface IPersonToken
    { 
        int PersonTokenID { get; set; } 
        bool PersonTokenIDIsNull { get; set; }
        int PersonID { get; set; } 
        bool PersonIDIsNull { get; set; }
        int PermissionID { get; set; } 
        bool PermissionIDIsNull { get; set; }
        string AccessToken { get; set; } 
        bool AccessTokenIsNull { get; set; }
        System.DateTime TokenExpiration { get; set; } 
        bool TokenExpirationIsNull { get; set; }
        string RefreshToken { get; set; } 
        bool RefreshTokenIsNull { get; set; }
    } 
} 
