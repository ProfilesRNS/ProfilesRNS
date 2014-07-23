namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.Interfaces.Profile.Data
{ 
    public partial interface IPerson
    { 
        int PersonID { get; set; } 
        bool PersonIDIsNull { get; set; }
        int UserID { get; set; } 
        bool UserIDIsNull { get; set; }
        string FirstName { get; set; } 
        bool FirstNameIsNull { get; set; }
        string LastName { get; set; } 
        bool LastNameIsNull { get; set; }
        string MiddleName { get; set; } 
        bool MiddleNameIsNull { get; set; }
        string DisplayName { get; set; } 
        bool DisplayNameIsNull { get; set; }
        string Suffix { get; set; } 
        bool SuffixIsNull { get; set; }
        bool IsActive { get; set; } 
        bool IsActiveIsNull { get; set; }
        string EmailAddr { get; set; } 
        bool EmailAddrIsNull { get; set; }
        string Phone { get; set; } 
        bool PhoneIsNull { get; set; }
        string Fax { get; set; } 
        bool FaxIsNull { get; set; }
        string AddressLine1 { get; set; } 
        bool AddressLine1IsNull { get; set; }
        string AddressLine2 { get; set; } 
        bool AddressLine2IsNull { get; set; }
        string AddressLine3 { get; set; } 
        bool AddressLine3IsNull { get; set; }
        string AddressLine4 { get; set; } 
        bool AddressLine4IsNull { get; set; }
        string City { get; set; } 
        bool CityIsNull { get; set; }
        string State { get; set; } 
        bool StateIsNull { get; set; }
        string Zip { get; set; } 
        bool ZipIsNull { get; set; }
        string Building { get; set; } 
        bool BuildingIsNull { get; set; }
        int Floor { get; set; } 
        bool FloorIsNull { get; set; }
        string Room { get; set; } 
        bool RoomIsNull { get; set; }
        string AddressString { get; set; } 
        bool AddressStringIsNull { get; set; }
        double Latitude { get; set; } 
        bool LatitudeIsNull { get; set; }
        double Longitude { get; set; } 
        bool LongitudeIsNull { get; set; }
        int GeoScore { get; set; } 
        bool GeoScoreIsNull { get; set; }
        int FacultyRankID { get; set; } 
        bool FacultyRankIDIsNull { get; set; }
        string InternalUsername { get; set; } 
        bool InternalUsernameIsNull { get; set; }
        bool Visible { get; set; } 
        bool VisibleIsNull { get; set; }
    } 
} 
