namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.Interfaces.ORCID
{ 
    public partial interface IPersonURL
    { 
        int PersonURLID { get; set; } 
        bool PersonURLIDIsNull { get; set; }
        int PersonID { get; set; } 
        bool PersonIDIsNull { get; set; }
        int PersonMessageID { get; set; } 
        bool PersonMessageIDIsNull { get; set; }
        string URLName { get; set; } 
        bool URLNameIsNull { get; set; }
        string URL { get; set; } 
        bool URLIsNull { get; set; }
        int DecisionID { get; set; } 
        bool DecisionIDIsNull { get; set; }
    } 
} 
