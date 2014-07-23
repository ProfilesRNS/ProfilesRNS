namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.Interfaces.RDF
{ 
    public partial interface INode
    { 
        long NodeID { get; set; } 
        bool NodeIDIsNull { get; set; }
        System.Byte[] ValueHash { get; set; } 
        bool ValueHashIsNull { get; set; }
        string Language { get; set; } 
        bool LanguageIsNull { get; set; }
        string DataType { get; set; } 
        bool DataTypeIsNull { get; set; }
        string Value { get; set; } 
        bool ValueIsNull { get; set; }
        int InternalNodeMapID { get; set; } 
        bool InternalNodeMapIDIsNull { get; set; }
        bool ObjectType { get; set; } 
        bool ObjectTypeIsNull { get; set; }
        long ViewSecurityGroup { get; set; } 
        bool ViewSecurityGroupIsNull { get; set; }
        long EditSecurityGroup { get; set; } 
        bool EditSecurityGroupIsNull { get; set; }
    } 
} 
