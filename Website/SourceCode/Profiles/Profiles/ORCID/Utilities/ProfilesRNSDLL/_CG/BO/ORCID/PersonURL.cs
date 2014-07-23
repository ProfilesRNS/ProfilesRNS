using System; 
using System.Collections.Generic; 
using System.Text; 
using System.Runtime.Serialization; 
using System.ComponentModel; 
 
namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID
{ 
    public partial class PersonURL : ProfilesRNSBaseClassBO, BO.Interfaces.ORCID.IPersonURL, IEqualityComparer<PersonURL>, IEquatable<PersonURL> 
    { 
        # region Private variables 
          /*! PersonURLID state (Person URLID) */ 
          private int _PersonURLID;
          /*! PersonID state (PersonID) */ 
          private int _PersonID;
          /*! PersonMessageID state (Person MessageID) */ 
          private int _PersonMessageID;
          /*! URLName state (URL Name) */ 
          private string _URLName;
          /*! URL state (URL) */ 
          private string _URL;
          /*! DecisionID state (DecisionID) */ 
          private int _DecisionID;
        # endregion //Private variables 
     
        # region Public Properties 
     
        
        public int PersonURLID 
        { 
              get { return _PersonURLID; } 
              set { _PersonURLID = value; PersonURLIDIsNull = false; } 
        } 
        public bool PersonURLIDIsNull { get; set; }
        public string PersonURLIDErrors { get; set; }
        public string PersonURLIDText { get { if (PersonURLIDIsNull){ return string.Empty; } return PersonURLID.ToString(); } } 
        public override string IdentityValue { get { if (PersonURLIDIsNull){ return string.Empty; } return PersonURLID.ToString(); } } 
        public override bool IdentityIsNull { get { return PersonURLIDIsNull; } } 
        
        public int PersonID 
        { 
              get { return _PersonID; } 
              set { _PersonID = value; PersonIDIsNull = false; } 
        } 
        public bool PersonIDIsNull { get; set; }
        public string PersonIDErrors { get; set; }
        
        public int PersonMessageID 
        { 
              get { return _PersonMessageID; } 
              set { _PersonMessageID = value; PersonMessageIDIsNull = false; } 
        } 
        public bool PersonMessageIDIsNull { get; set; }
        public string PersonMessageIDErrors { get; set; }
        
        public string URLName 
        { 
              get { return _URLName; } 
              set { _URLName = value; URLNameIsNull = false; } 
        } 
        public bool URLNameIsNull { get; set; }
        public string URLNameErrors { get; set; }
        
        public string URL 
        { 
              get { return _URL; } 
              set { _URL = value; URLIsNull = false; } 
        } 
        public bool URLIsNull { get; set; }
        public string URLErrors { get; set; }
        
        public int DecisionID 
        { 
              get { return _DecisionID; } 
              set { _DecisionID = value; DecisionIDIsNull = false; } 
        } 
        public bool DecisionIDIsNull { get; set; }
        public string DecisionIDErrors { get; set; }
        public string AllErrors 
        { 
              get 
              { 
                  string returnString = string.Empty;
                  if (!PersonURLIDErrors.Equals(string.Empty))
                  { 
                      returnString += "Person URLID: " + PersonURLIDErrors; 
                  } 
                  if (!PersonIDErrors.Equals(string.Empty))
                  { 
                      returnString += "PersonID: " + PersonIDErrors; 
                  } 
                  if (!PersonMessageIDErrors.Equals(string.Empty))
                  { 
                      returnString += "Person MessageID: " + PersonMessageIDErrors; 
                  } 
                  if (!URLNameErrors.Equals(string.Empty))
                  { 
                      returnString += "URL Name: " + URLNameErrors; 
                  } 
                  if (!URLErrors.Equals(string.Empty))
                  { 
                      returnString += "URL: " + URLErrors; 
                  } 
                  if (!DecisionIDErrors.Equals(string.Empty))
                  { 
                      returnString += "DecisionID: " + DecisionIDErrors; 
                  } 
                  return returnString; 
              } 
        } 
        public string Decision {
            get {
                if (Enum.IsDefined(typeof(BO.ORCID.REFDecision.REFDecisions), this.DecisionID)) {
                    return DevelopmentBase.Common.EnumDescription((BO.ORCID.REFDecision.REFDecisions)this.DecisionID);
                } else {
                    return "";
                }
            }
            set {
            }
        }
        public bool Equals(PersonURL left, PersonURL right)
        {
            if((object)left == null && (object)right == null)
            {
                return true;
            }
            if((object)left == null || (object)right == null)
            {
                return false;
            }
            return left.PersonURLID == right.PersonURLID;
        }
        public int GetHashCode(PersonURL obj)
        {
            return (obj.PersonURLID).GetHashCode();
        }
        public bool Equals(PersonURL other)
        {
            if (this.PersonURLID == other.PersonURLID )
                return true;

            return false;
        }
        public override int GetHashCode()
        {
            return PersonURLID.GetHashCode();
        }

        public BO.Interfaces.ORCID.IPersonURL DBFields { get { return this; } } 
     
        # endregion // Public Properties 
     
        # region Protected Methods 
     
        protected override void InitializePropertiesCG()
        {
            PersonURLIDIsNull = true; 
            PersonURLIDErrors = string.Empty; 
            PersonIDIsNull = true; 
            PersonIDErrors = string.Empty; 
            PersonMessageIDIsNull = true; 
            PersonMessageIDErrors = string.Empty; 
            URLNameIsNull = true; 
            URLNameErrors = string.Empty; 
            URLIsNull = true; 
            URLErrors = string.Empty; 
            DecisionIDIsNull = true; 
            DecisionIDErrors = string.Empty; 
            InitializeProperties(); 
        }
     
        # endregion // Protected Methods 
 
        # region Enums 
 
 
        # endregion // Enums 
    } 
 
} 
