namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.Interfaces.ORCID
{ 
    public partial interface IRecordLevelAuditType
    { 
        int RecordLevelAuditTypeID { get; set; } 
        bool RecordLevelAuditTypeIDIsNull { get; set; }
        string AuditType { get; set; } 
        bool AuditTypeIsNull { get; set; }
    } 
} 
