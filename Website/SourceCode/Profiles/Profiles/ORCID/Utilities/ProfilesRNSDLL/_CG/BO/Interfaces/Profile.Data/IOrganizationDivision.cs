namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.Interfaces.Profile.Data
{ 
    public partial interface IOrganizationDivision
    { 
        int DivisionID { get; set; } 
        bool DivisionIDIsNull { get; set; }
        string DivisionName { get; set; } 
        bool DivisionNameIsNull { get; set; }
    } 
} 
