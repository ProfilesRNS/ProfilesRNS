namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.Interfaces.Profile.Import
{ 
    public partial interface IFreetextKeywords
    { 
        int PersonKeywordID { get; set; } 
        bool PersonKeywordIDIsNull { get; set; }
        string InternalUsername { get; set; } 
        bool InternalUsernameIsNull { get; set; }
        string Keyword { get; set; } 
        bool KeywordIsNull { get; set; }
        int DisplaySecurityGroupID { get; set; } 
        bool DisplaySecurityGroupIDIsNull { get; set; }
    } 
} 
