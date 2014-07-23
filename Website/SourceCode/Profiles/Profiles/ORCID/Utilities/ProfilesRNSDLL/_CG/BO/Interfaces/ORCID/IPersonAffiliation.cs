namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.Interfaces.ORCID
{ 
    public partial interface IPersonAffiliation
    { 
        int PersonAffiliationID { get; set; } 
        bool PersonAffiliationIDIsNull { get; set; }
        int ProfilesID { get; set; } 
        bool ProfilesIDIsNull { get; set; }
        int AffiliationTypeID { get; set; } 
        bool AffiliationTypeIDIsNull { get; set; }
        int PersonID { get; set; } 
        bool PersonIDIsNull { get; set; }
        int PersonMessageID { get; set; } 
        bool PersonMessageIDIsNull { get; set; }
        int DecisionID { get; set; } 
        bool DecisionIDIsNull { get; set; }
        string DepartmentName { get; set; } 
        bool DepartmentNameIsNull { get; set; }
        string RoleTitle { get; set; } 
        bool RoleTitleIsNull { get; set; }
        System.DateTime StartDate { get; set; } 
        bool StartDateIsNull { get; set; }
        System.DateTime EndDate { get; set; } 
        bool EndDateIsNull { get; set; }
        string OrganizationName { get; set; } 
        bool OrganizationNameIsNull { get; set; }
        string OrganizationCity { get; set; } 
        bool OrganizationCityIsNull { get; set; }
        string OrganizationRegion { get; set; } 
        bool OrganizationRegionIsNull { get; set; }
        string OrganizationCountry { get; set; } 
        bool OrganizationCountryIsNull { get; set; }
        string DisambiguationID { get; set; } 
        bool DisambiguationIDIsNull { get; set; }
        string DisambiguationSource { get; set; } 
        bool DisambiguationSourceIsNull { get; set; }
    } 
} 
