
namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID
{
    public partial class Person
    { 
        public override int TableId { get { return 3566;} }
        public enum FieldNames : int { PersonID = 43421, InternalUsername = 43422, PersonStatusTypeID = 43423, CreateUnlessOptOut = 43424, ORCID = 43425, ORCIDRecorded = 43426, FirstName = 43427, LastName = 43428, PublishedName = 43429, EmailDecisionID = 43430, EmailAddress = 43431, AlternateEmailDecisionID = 43432, AgreementAcknowledged = 43433, Biography = 43434, BiographyDecisionID = 43435 }
        public override string TableSchemaName { get { return "ORCID."; } }
    } 
} 
