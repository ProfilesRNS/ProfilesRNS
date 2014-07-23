namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.Interfaces.RDF
{ 
    public partial interface ITriple
    { 
        long TripleID { get; set; } 
        bool TripleIDIsNull { get; set; }
        long Subject { get; set; } 
        bool SubjectIsNull { get; set; }
        long Predicate { get; set; } 
        bool PredicateIsNull { get; set; }
        long Object { get; set; } 
        bool ObjectIsNull { get; set; }
        System.Byte[] TripleHash { get; set; } 
        bool TripleHashIsNull { get; set; }
        double Weight { get; set; } 
        bool WeightIsNull { get; set; }
        long Reitification { get; set; } 
        bool ReitificationIsNull { get; set; }
        bool ObjectType { get; set; } 
        bool ObjectTypeIsNull { get; set; }
        int SortOrder { get; set; } 
        bool SortOrderIsNull { get; set; }
        long ViewSecurityGroup { get; set; } 
        bool ViewSecurityGroupIsNull { get; set; }
        long Graph { get; set; } 
        bool GraphIsNull { get; set; }
    } 
} 
