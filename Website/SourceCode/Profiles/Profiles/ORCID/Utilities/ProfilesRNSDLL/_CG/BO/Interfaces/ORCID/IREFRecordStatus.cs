namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.Interfaces.ORCID
{ 
    public partial interface IREFRecordStatus
    { 
        int RecordStatusID { get; set; } 
        bool RecordStatusIDIsNull { get; set; }
        string StatusDescription { get; set; } 
        bool StatusDescriptionIsNull { get; set; }
    } 
} 
