namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.Interfaces.ORCID
{ 
    public partial interface IPersonOthername
    { 
        int PersonOthernameID { get; set; } 
        bool PersonOthernameIDIsNull { get; set; }
        int PersonID { get; set; } 
        bool PersonIDIsNull { get; set; }
        string OtherName { get; set; } 
        bool OtherNameIsNull { get; set; }
        int PersonMessageID { get; set; } 
        bool PersonMessageIDIsNull { get; set; }
    } 
} 
