namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.Interfaces.Profile.Data
{ 
    public partial interface IOrganizationInstitution
    { 
        int InstitutionID { get; set; } 
        bool InstitutionIDIsNull { get; set; }
        string InstitutionName { get; set; } 
        bool InstitutionNameIsNull { get; set; }
        string InstitutionAbbreviation { get; set; } 
        bool InstitutionAbbreviationIsNull { get; set; }
 /*       string City { get; set; } 
        bool CityIsNull { get; set; }
        string State { get; set; } 
        bool StateIsNull { get; set; }
        string Country { get; set; } 
        bool CountryIsNull { get; set; }
        string RingGoldID { get; set; } 
        bool RingGoldIDIsNull { get; set; }
 */   } 
} 
