namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.Interfaces.ORCID
{ 
    public partial interface IPersonWork
    { 
        int PersonWorkID { get; set; } 
        bool PersonWorkIDIsNull { get; set; }
        int PersonID { get; set; } 
        bool PersonIDIsNull { get; set; }
        int PersonMessageID { get; set; } 
        bool PersonMessageIDIsNull { get; set; }
        int DecisionID { get; set; } 
        bool DecisionIDIsNull { get; set; }
        string WorkTitle { get; set; } 
        bool WorkTitleIsNull { get; set; }
        string ShortDescription { get; set; } 
        bool ShortDescriptionIsNull { get; set; }
        string WorkCitation { get; set; } 
        bool WorkCitationIsNull { get; set; }
        string WorkType { get; set; } 
        bool WorkTypeIsNull { get; set; }
        string URL { get; set; } 
        bool URLIsNull { get; set; }
        string SubTitle { get; set; } 
        bool SubTitleIsNull { get; set; }
        string WorkCitationType { get; set; } 
        bool WorkCitationTypeIsNull { get; set; }
        System.DateTime PubDate { get; set; } 
        bool PubDateIsNull { get; set; }
        string PublicationMediaType { get; set; } 
        bool PublicationMediaTypeIsNull { get; set; }
        string PubID { get; set; } 
        bool PubIDIsNull { get; set; }
    } 
} 
