namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.Interfaces.ORNG
{ 
    public partial interface IAppData
    { 
        long nodeId { get; set; } 
        bool nodeIdIsNull { get; set; }
        int appId { get; set; } 
        bool appIdIsNull { get; set; }
        string keyname { get; set; } 
        bool keynameIsNull { get; set; }
        string value { get; set; } 
        bool valueIsNull { get; set; }
        System.DateTime createdDT { get; set; } 
        bool createdDTIsNull { get; set; }
        System.DateTime updatedDT { get; set; } 
        bool updatedDTIsNull { get; set; }
    } 
} 
