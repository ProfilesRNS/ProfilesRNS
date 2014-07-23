using System; 
using System.Collections.Generic; 
using System.Text; 
using System.Runtime.Serialization; 
using System.ComponentModel; 
 
namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID
{ 
    public partial class Person : ProfilesRNSBaseClassBO, BO.Interfaces.ORCID.IPerson, IEqualityComparer<Person>, IEquatable<Person> 
    { 
        # region Private variables 
          /*! PersonID state (PersonID) */ 
          private int _PersonID;
          /*! InternalUsername state (Internal Username) */ 
          private string _InternalUsername;
          /*! PersonStatusTypeID state (Person Status TypeID) */ 
          private int _PersonStatusTypeID;
          /*! CreateUnlessOptOut state (Create Unless Opt Out) */ 
          private bool _CreateUnlessOptOut;
          /*! ORCID state (O R CID) */ 
          private string _ORCID;
          /*! ORCIDRecorded state (O R CID Recorded) */ 
          private System.DateTime _ORCIDRecorded;
          /*! FirstName state (First Name) */ 
          private string _FirstName;
          /*! LastName state (Last Name) */ 
          private string _LastName;
          /*! PublishedName state (Published Name) */ 
          private string _PublishedName;
          /*! EmailDecisionID state (Email DecisionID) */ 
          private int _EmailDecisionID;
          /*! EmailAddress state (Email Address) */ 
          private string _EmailAddress;
          /*! AlternateEmailDecisionID state (Alternate Email DecisionID) */ 
          private int _AlternateEmailDecisionID;
          /*! AgreementAcknowledged state (Agreement Acknowledged) */ 
          private bool _AgreementAcknowledged;
          /*! Biography state (Biography) */ 
          private string _Biography;
          /*! BiographyDecisionID state (Biography DecisionID) */ 
          private int _BiographyDecisionID;
        # endregion //Private variables 
     
        # region Public Properties 
     
        
        public int PersonID 
        { 
              get { return _PersonID; } 
              set { _PersonID = value; PersonIDIsNull = false; } 
        } 
        public bool PersonIDIsNull { get; set; }
        public string PersonIDErrors { get; set; }
        public string PersonIDText { get { if (PersonIDIsNull){ return string.Empty; } return PersonID.ToString(); } } 
        public override string IdentityValue { get { if (PersonIDIsNull){ return string.Empty; } return PersonID.ToString(); } } 
        public override bool IdentityIsNull { get { return PersonIDIsNull; } } 
        
        public string InternalUsername 
        { 
              get { return _InternalUsername; } 
              set { _InternalUsername = value; InternalUsernameIsNull = false; } 
        } 
        public bool InternalUsernameIsNull { get; set; }
        public string InternalUsernameErrors { get; set; }
        
        public int PersonStatusTypeID 
        { 
              get { return _PersonStatusTypeID; } 
              set { _PersonStatusTypeID = value; PersonStatusTypeIDIsNull = false; } 
        } 
        public bool PersonStatusTypeIDIsNull { get; set; }
        public string PersonStatusTypeIDErrors { get; set; }
        
        public bool CreateUnlessOptOut 
        { 
              get { return _CreateUnlessOptOut; } 
              set { _CreateUnlessOptOut = value; CreateUnlessOptOutIsNull = false; } 
        } 
        public bool CreateUnlessOptOutIsNull { get; set; }
        public string CreateUnlessOptOutErrors { get; set; }
        public string CreateUnlessOptOutDesc { get { if (CreateUnlessOptOutIsNull){ return string.Empty; } else if (CreateUnlessOptOut){ return "Yes"; } else { return "No"; } } } 
        
        public string ORCID 
        { 
              get { return _ORCID; } 
              set { _ORCID = value; ORCIDIsNull = false; } 
        } 
        public bool ORCIDIsNull { get; set; }
        public string ORCIDErrors { get; set; }
        
        public System.DateTime ORCIDRecorded 
        { 
              get { return _ORCIDRecorded; } 
              set { _ORCIDRecorded = value; ORCIDRecordedIsNull = false; } 
        } 
        public bool ORCIDRecordedIsNull { get; set; }
        public string ORCIDRecordedErrors { get; set; }
        public string ORCIDRecordedDesc { get { if (ORCIDRecordedIsNull){ return string.Empty; } return ORCIDRecorded.ToShortDateString(); } } 
        public string ORCIDRecordedTime { get { if (ORCIDRecordedIsNull){ return string.Empty; } return ORCIDRecorded.ToShortTimeString(); } } 
        
        public string FirstName 
        { 
              get { return _FirstName; } 
              set { _FirstName = value; FirstNameIsNull = false; } 
        } 
        public bool FirstNameIsNull { get; set; }
        public string FirstNameErrors { get; set; }
        
        public string LastName 
        { 
              get { return _LastName; } 
              set { _LastName = value; LastNameIsNull = false; } 
        } 
        public bool LastNameIsNull { get; set; }
        public string LastNameErrors { get; set; }
        
        public string PublishedName 
        { 
              get { return _PublishedName; } 
              set { _PublishedName = value; PublishedNameIsNull = false; } 
        } 
        public bool PublishedNameIsNull { get; set; }
        public string PublishedNameErrors { get; set; }
        
        public int EmailDecisionID 
        { 
              get { return _EmailDecisionID; } 
              set { _EmailDecisionID = value; EmailDecisionIDIsNull = false; } 
        } 
        public bool EmailDecisionIDIsNull { get; set; }
        public string EmailDecisionIDErrors { get; set; }
        
        public string EmailAddress 
        { 
              get { return _EmailAddress; } 
              set { _EmailAddress = value; EmailAddressIsNull = false; } 
        } 
        public bool EmailAddressIsNull { get; set; }
        public string EmailAddressErrors { get; set; }
        
        public int AlternateEmailDecisionID 
        { 
              get { return _AlternateEmailDecisionID; } 
              set { _AlternateEmailDecisionID = value; AlternateEmailDecisionIDIsNull = false; } 
        } 
        public bool AlternateEmailDecisionIDIsNull { get; set; }
        public string AlternateEmailDecisionIDErrors { get; set; }
        
        public bool AgreementAcknowledged 
        { 
              get { return _AgreementAcknowledged; } 
              set { _AgreementAcknowledged = value; AgreementAcknowledgedIsNull = false; } 
        } 
        public bool AgreementAcknowledgedIsNull { get; set; }
        public string AgreementAcknowledgedErrors { get; set; }
        public string AgreementAcknowledgedDesc { get { if (AgreementAcknowledgedIsNull){ return string.Empty; } else if (AgreementAcknowledged){ return "Yes"; } else { return "No"; } } } 
        
        public string Biography 
        { 
              get { return _Biography; } 
              set { _Biography = value; BiographyIsNull = false; } 
        } 
        public bool BiographyIsNull { get; set; }
        public string BiographyErrors { get; set; }
        
        public int BiographyDecisionID 
        { 
              get { return _BiographyDecisionID; } 
              set { _BiographyDecisionID = value; BiographyDecisionIDIsNull = false; } 
        } 
        public bool BiographyDecisionIDIsNull { get; set; }
        public string BiographyDecisionIDErrors { get; set; }
        public string AllErrors 
        { 
              get 
              { 
                  string returnString = string.Empty;
                  if (!PersonIDErrors.Equals(string.Empty))
                  { 
                      returnString += "PersonID: " + PersonIDErrors; 
                  } 
                  if (!InternalUsernameErrors.Equals(string.Empty))
                  { 
                      returnString += "Internal Username: " + InternalUsernameErrors; 
                  } 
                  if (!PersonStatusTypeIDErrors.Equals(string.Empty))
                  { 
                      returnString += "Person Status TypeID: " + PersonStatusTypeIDErrors; 
                  } 
                  if (!CreateUnlessOptOutErrors.Equals(string.Empty))
                  { 
                      returnString += "Create Unless Opt Out: " + CreateUnlessOptOutErrors; 
                  } 
                  if (!ORCIDErrors.Equals(string.Empty))
                  { 
                      returnString += "O R CID: " + ORCIDErrors; 
                  } 
                  if (!ORCIDRecordedErrors.Equals(string.Empty))
                  { 
                      returnString += "O R CID Recorded: " + ORCIDRecordedErrors; 
                  } 
                  if (!FirstNameErrors.Equals(string.Empty))
                  { 
                      returnString += "First Name: " + FirstNameErrors; 
                  } 
                  if (!LastNameErrors.Equals(string.Empty))
                  { 
                      returnString += "Last Name: " + LastNameErrors; 
                  } 
                  if (!PublishedNameErrors.Equals(string.Empty))
                  { 
                      returnString += "Published Name: " + PublishedNameErrors; 
                  } 
                  if (!EmailDecisionIDErrors.Equals(string.Empty))
                  { 
                      returnString += "Email DecisionID: " + EmailDecisionIDErrors; 
                  } 
                  if (!EmailAddressErrors.Equals(string.Empty))
                  { 
                      returnString += "Email Address: " + EmailAddressErrors; 
                  } 
                  if (!AlternateEmailDecisionIDErrors.Equals(string.Empty))
                  { 
                      returnString += "Alternate Email DecisionID: " + AlternateEmailDecisionIDErrors; 
                  } 
                  if (!AgreementAcknowledgedErrors.Equals(string.Empty))
                  { 
                      returnString += "Agreement Acknowledged: " + AgreementAcknowledgedErrors; 
                  } 
                  if (!BiographyErrors.Equals(string.Empty))
                  { 
                      returnString += "Biography: " + BiographyErrors; 
                  } 
                  if (!BiographyDecisionIDErrors.Equals(string.Empty))
                  { 
                      returnString += "Biography DecisionID: " + BiographyDecisionIDErrors; 
                  } 
                  return returnString; 
              } 
        } 
        public string PersonStatusType {
            get {
                if (Enum.IsDefined(typeof(BO.ORCID.REFPersonStatusType.REFPersonStatusTypes), this.PersonStatusTypeID)) {
                    return DevelopmentBase.Common.EnumDescription((BO.ORCID.REFPersonStatusType.REFPersonStatusTypes)this.PersonStatusTypeID);
                } else {
                    return "";
                }
            }
            set {
            }
        }
        public bool Equals(Person left, Person right)
        {
            if((object)left == null && (object)right == null)
            {
                return true;
            }
            if((object)left == null || (object)right == null)
            {
                return false;
            }
            return left.PersonID == right.PersonID;
        }
        public int GetHashCode(Person obj)
        {
            return (obj.PersonID).GetHashCode();
        }
        public bool Equals(Person other)
        {
            if (this.PersonID == other.PersonID )
                return true;

            return false;
        }
        public override int GetHashCode()
        {
            return PersonID.GetHashCode();
        }

        public BO.Interfaces.ORCID.IPerson DBFields { get { return this; } } 
     
        # endregion // Public Properties 
     
        # region Protected Methods 
     
        protected override void InitializePropertiesCG()
        {
            PersonIDIsNull = true; 
            PersonIDErrors = string.Empty; 
            InternalUsernameIsNull = true; 
            InternalUsernameErrors = string.Empty; 
            PersonStatusTypeIDIsNull = true; 
            PersonStatusTypeIDErrors = string.Empty; 
            CreateUnlessOptOutIsNull = true; 
            CreateUnlessOptOutErrors = string.Empty; 
            ORCIDIsNull = true; 
            ORCIDErrors = string.Empty; 
            ORCIDRecordedIsNull = true; 
            ORCIDRecordedErrors = string.Empty; 
            FirstNameIsNull = true; 
            FirstNameErrors = string.Empty; 
            LastNameIsNull = true; 
            LastNameErrors = string.Empty; 
            PublishedNameIsNull = true; 
            PublishedNameErrors = string.Empty; 
            EmailDecisionIDIsNull = true; 
            EmailDecisionIDErrors = string.Empty; 
            EmailAddressIsNull = true; 
            EmailAddressErrors = string.Empty; 
            AlternateEmailDecisionIDIsNull = true; 
            AlternateEmailDecisionIDErrors = string.Empty; 
            AgreementAcknowledgedIsNull = true; 
            AgreementAcknowledgedErrors = string.Empty; 
            BiographyIsNull = true; 
            BiographyErrors = string.Empty; 
            BiographyDecisionIDIsNull = true; 
            BiographyDecisionIDErrors = string.Empty; 
            InitializeProperties(); 
        }
     
        # endregion // Protected Methods 
 
        # region Enums 
 
 
        # endregion // Enums 
    } 
 
} 
