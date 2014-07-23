namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.Interfaces.Profile.Data
{ 
    public partial interface IOrganizationDepartment
    { 
        int DepartmentID { get; set; } 
        bool DepartmentIDIsNull { get; set; }
        string DepartmentName { get; set; } 
        bool DepartmentNameIsNull { get; set; }
        bool Visible { get; set; } 
        bool VisibleIsNull { get; set; }
    } 
} 
