
namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.Profile.Data
{
    public partial class OrganizationInstitution
    { 
        public override int TableId { get { return 3635;} }
        public enum FieldNames : int { InstitutionID = 43813, InstitutionName = 43814, InstitutionAbbreviation = 43815/*, City = 52928, State = 52929, Country = 52930, RingGoldID = 52931*/ }
        public override string TableSchemaName { get { return "ORCID."; } }
    } 
} 
