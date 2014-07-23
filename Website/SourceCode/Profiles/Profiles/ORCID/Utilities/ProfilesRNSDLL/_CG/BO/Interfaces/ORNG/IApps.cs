namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.Interfaces.ORNG
{ 
    public partial interface IApps
    { 
        int appId { get; set; } 
        bool appIdIsNull { get; set; }
        string name { get; set; } 
        bool nameIsNull { get; set; }
        string url { get; set; } 
        bool urlIsNull { get; set; }
        int PersonFilterID { get; set; } 
        bool PersonFilterIDIsNull { get; set; }
        bool enabled { get; set; } 
        bool enabledIsNull { get; set; }
    } 
} 
