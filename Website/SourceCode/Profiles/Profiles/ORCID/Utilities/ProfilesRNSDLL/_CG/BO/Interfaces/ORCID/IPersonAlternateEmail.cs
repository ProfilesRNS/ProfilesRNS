namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.Interfaces.ORCID
{ 
    public partial interface IPersonAlternateEmail
    { 
        int PersonAlternateEmailID { get; set; } 
        bool PersonAlternateEmailIDIsNull { get; set; }
        int PersonID { get; set; } 
        bool PersonIDIsNull { get; set; }
        string EmailAddress { get; set; } 
        bool EmailAddressIsNull { get; set; }
        int PersonMessageID { get; set; } 
        bool PersonMessageIDIsNull { get; set; }
    } 
} 
