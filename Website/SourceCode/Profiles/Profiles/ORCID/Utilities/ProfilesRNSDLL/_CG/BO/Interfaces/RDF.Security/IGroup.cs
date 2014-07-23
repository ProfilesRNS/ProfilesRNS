namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.Interfaces.RDF.Security
{ 
    public partial interface IGroup
    { 
        long SecurityGroupID { get; set; } 
        bool SecurityGroupIDIsNull { get; set; }
        string Label { get; set; } 
        bool LabelIsNull { get; set; }
        bool HasSpecialViewAccess { get; set; } 
        bool HasSpecialViewAccessIsNull { get; set; }
        bool HasSpecialEditAccess { get; set; } 
        bool HasSpecialEditAccessIsNull { get; set; }
        string Description { get; set; } 
        bool DescriptionIsNull { get; set; }
        int DefaultORCIDDecisionID { get; set; } 
        bool DefaultORCIDDecisionIDIsNull { get; set; }
    } 
} 
