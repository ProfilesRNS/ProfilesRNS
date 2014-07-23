namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.Interfaces.ORCID
{ 
    public partial interface IErrorLog
    { 
        int ErrorLogID { get; set; } 
        bool ErrorLogIDIsNull { get; set; }
        string InternalUsername { get; set; } 
        bool InternalUsernameIsNull { get; set; }
        string Exception { get; set; } 
        bool ExceptionIsNull { get; set; }
        System.DateTime OccurredOn { get; set; } 
        bool OccurredOnIsNull { get; set; }
        bool Processed { get; set; } 
        bool ProcessedIsNull { get; set; }
    } 
} 
