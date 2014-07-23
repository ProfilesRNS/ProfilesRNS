namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.Interfaces.Profile.Data
{ 
    public partial interface IPersonFacultyRank
    { 
        int FacultyRankID { get; set; } 
        bool FacultyRankIDIsNull { get; set; }
        string FacultyRank { get; set; } 
        bool FacultyRankIsNull { get; set; }
        int FacultyRankSort { get; set; } 
        bool FacultyRankSortIsNull { get; set; }
        bool Visible { get; set; } 
        bool VisibleIsNull { get; set; }
    } 
} 
