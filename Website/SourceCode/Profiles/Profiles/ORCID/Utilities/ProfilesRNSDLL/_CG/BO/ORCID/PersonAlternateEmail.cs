using System; 
using System.Collections.Generic; 
using System.Text; 
using System.Runtime.Serialization; 
using System.ComponentModel; 
 
namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID
{ 
    public partial class PersonAlternateEmail : ProfilesRNSBaseClassBO, BO.Interfaces.ORCID.IPersonAlternateEmail, IEqualityComparer<PersonAlternateEmail>, IEquatable<PersonAlternateEmail> 
    { 
        # region Private variables 
          /*! PersonAlternateEmailID state (Person Alternate EmailID) */ 
          private int _PersonAlternateEmailID;
          /*! PersonID state (PersonID) */ 
          private int _PersonID;
          /*! EmailAddress state (Email Address) */ 
          private string _EmailAddress;
          /*! PersonMessageID state (Person MessageID) */ 
          private int _PersonMessageID;
        # endregion //Private variables 
     
        # region Public Properties 
     
        
        public int PersonAlternateEmailID 
        { 
              get { return _PersonAlternateEmailID; } 
              set { _PersonAlternateEmailID = value; PersonAlternateEmailIDIsNull = false; } 
        } 
        public bool PersonAlternateEmailIDIsNull { get; set; }
        public string PersonAlternateEmailIDErrors { get; set; }
        public string PersonAlternateEmailIDText { get { if (PersonAlternateEmailIDIsNull){ return string.Empty; } return PersonAlternateEmailID.ToString(); } } 
        public override string IdentityValue { get { if (PersonAlternateEmailIDIsNull){ return string.Empty; } return PersonAlternateEmailID.ToString(); } } 
        public override bool IdentityIsNull { get { return PersonAlternateEmailIDIsNull; } } 
        
        public int PersonID 
        { 
              get { return _PersonID; } 
              set { _PersonID = value; PersonIDIsNull = false; } 
        } 
        public bool PersonIDIsNull { get; set; }
        public string PersonIDErrors { get; set; }
        
        public string EmailAddress 
        { 
              get { return _EmailAddress; } 
              set { _EmailAddress = value; EmailAddressIsNull = false; } 
        } 
        public bool EmailAddressIsNull { get; set; }
        public string EmailAddressErrors { get; set; }
        
        public int PersonMessageID 
        { 
              get { return _PersonMessageID; } 
              set { _PersonMessageID = value; PersonMessageIDIsNull = false; } 
        } 
        public bool PersonMessageIDIsNull { get; set; }
        public string PersonMessageIDErrors { get; set; }
        public string AllErrors 
        { 
              get 
              { 
                  string returnString = string.Empty;
                  if (!PersonAlternateEmailIDErrors.Equals(string.Empty))
                  { 
                      returnString += "Person Alternate EmailID: " + PersonAlternateEmailIDErrors; 
                  } 
                  if (!PersonIDErrors.Equals(string.Empty))
                  { 
                      returnString += "PersonID: " + PersonIDErrors; 
                  } 
                  if (!EmailAddressErrors.Equals(string.Empty))
                  { 
                      returnString += "Email Address: " + EmailAddressErrors; 
                  } 
                  if (!PersonMessageIDErrors.Equals(string.Empty))
                  { 
                      returnString += "Person MessageID: " + PersonMessageIDErrors; 
                  } 
                  return returnString; 
              } 
        } 
        public bool Equals(PersonAlternateEmail left, PersonAlternateEmail right)
        {
            if((object)left == null && (object)right == null)
            {
                return true;
            }
            if((object)left == null || (object)right == null)
            {
                return false;
            }
            return left.PersonAlternateEmailID == right.PersonAlternateEmailID;
        }
        public int GetHashCode(PersonAlternateEmail obj)
        {
            return (obj.PersonAlternateEmailID).GetHashCode();
        }
        public bool Equals(PersonAlternateEmail other)
        {
            if (this.PersonAlternateEmailID == other.PersonAlternateEmailID )
                return true;

            return false;
        }
        public override int GetHashCode()
        {
            return PersonAlternateEmailID.GetHashCode();
        }

        public BO.Interfaces.ORCID.IPersonAlternateEmail DBFields { get { return this; } } 
     
        # endregion // Public Properties 
     
        # region Protected Methods 
     
        protected override void InitializePropertiesCG()
        {
            PersonAlternateEmailIDIsNull = true; 
            PersonAlternateEmailIDErrors = string.Empty; 
            PersonIDIsNull = true; 
            PersonIDErrors = string.Empty; 
            EmailAddressIsNull = true; 
            EmailAddressErrors = string.Empty; 
            PersonMessageIDIsNull = true; 
            PersonMessageIDErrors = string.Empty; 
            InitializeProperties(); 
        }
     
        # endregion // Protected Methods 
 
        # region Enums 
 
 
        # endregion // Enums 
    } 
 
} 
