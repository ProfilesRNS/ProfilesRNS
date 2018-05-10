using System;
using System.Collections.Generic;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID
{
    public partial class PersonWorkIdentifier : ProfilesRNSBaseClassBO, BO.Interfaces.ORCID.IPersonWorkIdentifier, IEqualityComparer<PersonWorkIdentifier>, IEquatable<PersonWorkIdentifier> 
    { 
        # region Private variables 
          /*! PersonWorkIdentifierID state (Person Work IdentifierID) */ 
          private int _PersonWorkIdentifierID;
          /*! PersonWorkID state (Person WorkID) */ 
          private int _PersonWorkID;
          /*! WorkExternalTypeID state (Work External TypeID) */ 
          private int _WorkExternalTypeID;
          /*! Identifier state (Identifier) */ 
          private string _Identifier;
        # endregion //Private variables 
     
        # region Public Properties 
     
        
        public int PersonWorkIdentifierID 
        { 
              get { return _PersonWorkIdentifierID; } 
              set { _PersonWorkIdentifierID = value; PersonWorkIdentifierIDIsNull = false; } 
        } 
        public bool PersonWorkIdentifierIDIsNull { get; set; }
        public string PersonWorkIdentifierIDErrors { get; set; }
        public string PersonWorkIdentifierIDText { get { if (PersonWorkIdentifierIDIsNull){ return string.Empty; } return PersonWorkIdentifierID.ToString(); } } 
        public override string IdentityValue { get { if (PersonWorkIdentifierIDIsNull){ return string.Empty; } return PersonWorkIdentifierID.ToString(); } } 
        public override bool IdentityIsNull { get { return PersonWorkIdentifierIDIsNull; } } 
        
        public int PersonWorkID 
        { 
              get { return _PersonWorkID; } 
              set { _PersonWorkID = value; PersonWorkIDIsNull = false; } 
        } 
        public bool PersonWorkIDIsNull { get; set; }
        public string PersonWorkIDErrors { get; set; }
        
        public int WorkExternalTypeID 
        { 
              get { return _WorkExternalTypeID; } 
              set { _WorkExternalTypeID = value; WorkExternalTypeIDIsNull = false; } 
        } 
        public bool WorkExternalTypeIDIsNull { get; set; }
        public string WorkExternalTypeIDErrors { get; set; }
        
        public string Identifier 
        { 
              get { return _Identifier; } 
              set { _Identifier = value; IdentifierIsNull = false; } 
        } 
        public bool IdentifierIsNull { get; set; }
        public string IdentifierErrors { get; set; }
        public string AllErrors 
        { 
              get 
              { 
                  string returnString = string.Empty;
                  if (!PersonWorkIdentifierIDErrors.Equals(string.Empty))
                  { 
                      returnString += "Person Work IdentifierID: " + PersonWorkIdentifierIDErrors; 
                  } 
                  if (!PersonWorkIDErrors.Equals(string.Empty))
                  { 
                      returnString += "Person WorkID: " + PersonWorkIDErrors; 
                  } 
                  if (!WorkExternalTypeIDErrors.Equals(string.Empty))
                  { 
                      returnString += "Work External TypeID: " + WorkExternalTypeIDErrors; 
                  } 
                  if (!IdentifierErrors.Equals(string.Empty))
                  { 
                      returnString += "Identifier: " + IdentifierErrors; 
                  } 
                  return returnString; 
              } 
        } 
        public string WorkExternalType {
            get {
                if (Enum.IsDefined(typeof(BO.ORCID.REFWorkExternalType.REFWorkExternalTypes), this.WorkExternalTypeID)) {
                    return DevelopmentBase.Common.EnumDescription((BO.ORCID.REFWorkExternalType.REFWorkExternalTypes)this.WorkExternalTypeID);
                } else {
                    return "";
                }
            }
            set {
            }
        }
        public bool Equals(PersonWorkIdentifier left, PersonWorkIdentifier right)
        {
            if((object)left == null && (object)right == null)
            {
                return true;
            }
            if((object)left == null || (object)right == null)
            {
                return false;
            }
            return left.PersonWorkIdentifierID == right.PersonWorkIdentifierID;
        }
        public int GetHashCode(PersonWorkIdentifier obj)
        {
            return (obj.PersonWorkIdentifierID).GetHashCode();
        }
        public bool Equals(PersonWorkIdentifier other)
        {
            if (this.PersonWorkIdentifierID == other.PersonWorkIdentifierID )
                return true;

            return false;
        }
        public override int GetHashCode()
        {
            return PersonWorkIdentifierID.GetHashCode();
        }

        public BO.Interfaces.ORCID.IPersonWorkIdentifier DBFields { get { return this; } } 
     
        # endregion // Public Properties 
     
        # region Protected Methods 
     
        protected override void InitializePropertiesCG()
        {
            PersonWorkIdentifierIDIsNull = true; 
            PersonWorkIdentifierIDErrors = string.Empty; 
            PersonWorkIDIsNull = true; 
            PersonWorkIDErrors = string.Empty; 
            WorkExternalTypeIDIsNull = true; 
            WorkExternalTypeIDErrors = string.Empty; 
            IdentifierIsNull = true; 
            IdentifierErrors = string.Empty; 
            InitializeProperties(); 
        }
     
        # endregion // Protected Methods 
 
        # region Enums 
 
 
        # endregion // Enums 
    } 
 
} 
