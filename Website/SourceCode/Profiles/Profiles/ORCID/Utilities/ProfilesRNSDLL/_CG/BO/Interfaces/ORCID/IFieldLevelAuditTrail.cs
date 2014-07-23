namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.Interfaces.ORCID
{ 
    public partial interface IFieldLevelAuditTrail
    { 
        long FieldLevelAuditTrailID { get; set; } 
        bool FieldLevelAuditTrailIDIsNull { get; set; }
        long RecordLevelAuditTrailID { get; set; } 
        bool RecordLevelAuditTrailIDIsNull { get; set; }
        int MetaFieldID { get; set; } 
        bool MetaFieldIDIsNull { get; set; }
        string ValueBefore { get; set; } 
        bool ValueBeforeIsNull { get; set; }
        string ValueAfter { get; set; } 
        bool ValueAfterIsNull { get; set; }
    } 
} 
