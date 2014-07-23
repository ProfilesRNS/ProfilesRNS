namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.Interfaces.ORCID
{ 
    public partial interface IREFDecision
    { 
        int DecisionID { get; set; } 
        bool DecisionIDIsNull { get; set; }
        string DecisionDescription { get; set; } 
        bool DecisionDescriptionIsNull { get; set; }
        string DecisionDescriptionLong { get; set; } 
        bool DecisionDescriptionLongIsNull { get; set; }
    } 
} 
