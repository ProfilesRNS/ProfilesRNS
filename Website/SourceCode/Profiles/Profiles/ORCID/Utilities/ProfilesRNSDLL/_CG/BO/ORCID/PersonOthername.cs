using System; 
using System.Collections.Generic; 
using System.Text; 
using System.Runtime.Serialization; 
using System.ComponentModel; 
 
namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID
{ 
    public partial class PersonOthername : ProfilesRNSBaseClassBO, BO.Interfaces.ORCID.IPersonOthername, IEqualityComparer<PersonOthername>, IEquatable<PersonOthername> 
    { 
        # region Private variables 
          /*! PersonOthernameID state (Person OthernameID) */ 
          private int _PersonOthernameID;
          /*! PersonID state (PersonID) */ 
          private int _PersonID;
          /*! OtherName state (Other Name) */ 
          private string _OtherName;
          /*! PersonMessageID state (Person MessageID) */ 
          private int _PersonMessageID;
        # endregion //Private variables 
     
        # region Public Properties 
     
        
        public int PersonOthernameID 
        { 
              get { return _PersonOthernameID; } 
              set { _PersonOthernameID = value; PersonOthernameIDIsNull = false; } 
        } 
        public bool PersonOthernameIDIsNull { get; set; }
        public string PersonOthernameIDErrors { get; set; }
        public string PersonOthernameIDText { get { if (PersonOthernameIDIsNull){ return string.Empty; } return PersonOthernameID.ToString(); } } 
        public override string IdentityValue { get { if (PersonOthernameIDIsNull){ return string.Empty; } return PersonOthernameID.ToString(); } } 
        public override bool IdentityIsNull { get { return PersonOthernameIDIsNull; } } 
        
        public int PersonID 
        { 
              get { return _PersonID; } 
              set { _PersonID = value; PersonIDIsNull = false; } 
        } 
        public bool PersonIDIsNull { get; set; }
        public string PersonIDErrors { get; set; }
        
        public string OtherName 
        { 
              get { return _OtherName; } 
              set { _OtherName = value; OtherNameIsNull = false; } 
        } 
        public bool OtherNameIsNull { get; set; }
        public string OtherNameErrors { get; set; }
        
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
                  if (!PersonOthernameIDErrors.Equals(string.Empty))
                  { 
                      returnString += "Person OthernameID: " + PersonOthernameIDErrors; 
                  } 
                  if (!PersonIDErrors.Equals(string.Empty))
                  { 
                      returnString += "PersonID: " + PersonIDErrors; 
                  } 
                  if (!OtherNameErrors.Equals(string.Empty))
                  { 
                      returnString += "Other Name: " + OtherNameErrors; 
                  } 
                  if (!PersonMessageIDErrors.Equals(string.Empty))
                  { 
                      returnString += "Person MessageID: " + PersonMessageIDErrors; 
                  } 
                  return returnString; 
              } 
        } 
        public bool Equals(PersonOthername left, PersonOthername right)
        {
            if((object)left == null && (object)right == null)
            {
                return true;
            }
            if((object)left == null || (object)right == null)
            {
                return false;
            }
            return left.PersonOthernameID == right.PersonOthernameID;
        }
        public int GetHashCode(PersonOthername obj)
        {
            return (obj.PersonOthernameID).GetHashCode();
        }
        public bool Equals(PersonOthername other)
        {
            if (this.PersonOthernameID == other.PersonOthernameID )
                return true;

            return false;
        }
        public override int GetHashCode()
        {
            return PersonOthernameID.GetHashCode();
        }

        public BO.Interfaces.ORCID.IPersonOthername DBFields { get { return this; } } 
     
        # endregion // Public Properties 
     
        # region Protected Methods 
     
        protected override void InitializePropertiesCG()
        {
            PersonOthernameIDIsNull = true; 
            PersonOthernameIDErrors = string.Empty; 
            PersonIDIsNull = true; 
            PersonIDErrors = string.Empty; 
            OtherNameIsNull = true; 
            OtherNameErrors = string.Empty; 
            PersonMessageIDIsNull = true; 
            PersonMessageIDErrors = string.Empty; 
            InitializeProperties(); 
        }
     
        # endregion // Protected Methods 
 
        # region Enums 
 
 
        # endregion // Enums 
    } 
 
} 
