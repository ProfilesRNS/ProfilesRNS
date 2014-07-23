namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.Interfaces.ORCID
{ 
    public partial interface IRecordLevelAuditTrail
    { 
        long RecordLevelAuditTrailID { get; set; } 
        bool RecordLevelAuditTrailIDIsNull { get; set; }
        int MetaTableID { get; set; } 
        bool MetaTableIDIsNull { get; set; }
        long RowIdentifier { get; set; } 
        bool RowIdentifierIsNull { get; set; }
        int RecordLevelAuditTypeID { get; set; } 
        bool RecordLevelAuditTypeIDIsNull { get; set; }
        System.DateTime CreatedDate { get; set; } 
        bool CreatedDateIsNull { get; set; }
        string CreatedBy { get; set; } 
        bool CreatedByIsNull { get; set; }
    } 
} 
