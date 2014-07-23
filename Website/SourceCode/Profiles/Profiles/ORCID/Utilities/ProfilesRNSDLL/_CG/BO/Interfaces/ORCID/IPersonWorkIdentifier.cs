namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.Interfaces.ORCID
{ 
    public partial interface IPersonWorkIdentifier
    { 
        int PersonWorkIdentifierID { get; set; } 
        bool PersonWorkIdentifierIDIsNull { get; set; }
        int PersonWorkID { get; set; } 
        bool PersonWorkIDIsNull { get; set; }
        int WorkExternalTypeID { get; set; } 
        bool WorkExternalTypeIDIsNull { get; set; }
        string Identifier { get; set; } 
        bool IdentifierIsNull { get; set; }
    } 
} 
