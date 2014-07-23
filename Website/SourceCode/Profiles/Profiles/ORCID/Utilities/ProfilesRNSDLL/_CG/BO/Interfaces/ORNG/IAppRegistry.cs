namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.Interfaces.ORNG
{ 
    public partial interface IAppRegistry
    { 
        long nodeid { get; set; } 
        bool nodeidIsNull { get; set; }
        int appId { get; set; } 
        bool appIdIsNull { get; set; }
        string visibility { get; set; } 
        bool visibilityIsNull { get; set; }
        System.DateTime createdDT { get; set; } 
        bool createdDTIsNull { get; set; }
    } 
} 
