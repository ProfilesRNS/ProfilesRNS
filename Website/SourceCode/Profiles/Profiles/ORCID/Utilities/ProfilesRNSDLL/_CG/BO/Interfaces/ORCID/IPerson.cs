namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.Interfaces.ORCID
{ 
    public partial interface IPerson
    { 
        int PersonID { get; set; } 
        bool PersonIDIsNull { get; set; }
        string InternalUsername { get; set; } 
        bool InternalUsernameIsNull { get; set; }
        int PersonStatusTypeID { get; set; } 
        bool PersonStatusTypeIDIsNull { get; set; }
        bool CreateUnlessOptOut { get; set; } 
        bool CreateUnlessOptOutIsNull { get; set; }
        string ORCID { get; set; } 
        bool ORCIDIsNull { get; set; }
        System.DateTime ORCIDRecorded { get; set; } 
        bool ORCIDRecordedIsNull { get; set; }
        string FirstName { get; set; } 
        bool FirstNameIsNull { get; set; }
        string LastName { get; set; } 
        bool LastNameIsNull { get; set; }
        string PublishedName { get; set; } 
        bool PublishedNameIsNull { get; set; }
        int EmailDecisionID { get; set; } 
        bool EmailDecisionIDIsNull { get; set; }
        string EmailAddress { get; set; } 
        bool EmailAddressIsNull { get; set; }
        int AlternateEmailDecisionID { get; set; } 
        bool AlternateEmailDecisionIDIsNull { get; set; }
        bool AgreementAcknowledged { get; set; } 
        bool AgreementAcknowledgedIsNull { get; set; }
        string Biography { get; set; } 
        bool BiographyIsNull { get; set; }
        int BiographyDecisionID { get; set; } 
        bool BiographyDecisionIDIsNull { get; set; }
    } 
} 
