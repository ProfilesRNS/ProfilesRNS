using System; 
using System.Collections.Generic; 
using System.Text; 
using System.Runtime.Serialization; 
using System.ComponentModel; 
 
namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID
{ 
    public partial class PersonToken : ProfilesRNSBaseClassBO, BO.Interfaces.ORCID.IPersonToken, IEqualityComparer<PersonToken>, IEquatable<PersonToken> 
    { 
        # region Private variables 
          /*! PersonTokenID state (Person TokenID) */ 
          private int _PersonTokenID;
          /*! PersonID state (PersonID) */ 
          private int _PersonID;
          /*! PermissionID state (PermissionID) */ 
          private int _PermissionID;
          /*! AccessToken state (Access Token) */ 
          private string _AccessToken;
          /*! TokenExpiration state (Token Expiration) */ 
          private System.DateTime _TokenExpiration;
          /*! RefreshToken state (Refresh Token) */ 
          private string _RefreshToken;
        # endregion //Private variables 
     
        # region Public Properties 
     
        
        public int PersonTokenID 
        { 
              get { return _PersonTokenID; } 
              set { _PersonTokenID = value; PersonTokenIDIsNull = false; } 
        } 
        public bool PersonTokenIDIsNull { get; set; }
        public string PersonTokenIDErrors { get; set; }
        public string PersonTokenIDText { get { if (PersonTokenIDIsNull){ return string.Empty; } return PersonTokenID.ToString(); } } 
        public override string IdentityValue { get { if (PersonTokenIDIsNull){ return string.Empty; } return PersonTokenID.ToString(); } } 
        public override bool IdentityIsNull { get { return PersonTokenIDIsNull; } } 
        
        public int PersonID 
        { 
              get { return _PersonID; } 
              set { _PersonID = value; PersonIDIsNull = false; } 
        } 
        public bool PersonIDIsNull { get; set; }
        public string PersonIDErrors { get; set; }
        
        public int PermissionID 
        { 
              get { return _PermissionID; } 
              set { _PermissionID = value; PermissionIDIsNull = false; } 
        } 
        public bool PermissionIDIsNull { get; set; }
        public string PermissionIDErrors { get; set; }
        
        public string AccessToken 
        { 
              get { return _AccessToken; } 
              set { _AccessToken = value; AccessTokenIsNull = false; } 
        } 
        public bool AccessTokenIsNull { get; set; }
        public string AccessTokenErrors { get; set; }
        
        public System.DateTime TokenExpiration 
        { 
              get { return _TokenExpiration; } 
              set { _TokenExpiration = value; TokenExpirationIsNull = false; } 
        } 
        public bool TokenExpirationIsNull { get; set; }
        public string TokenExpirationErrors { get; set; }
        public string TokenExpirationDesc { get { if (TokenExpirationIsNull){ return string.Empty; } return TokenExpiration.ToShortDateString(); } } 
        public string TokenExpirationTime { get { if (TokenExpirationIsNull){ return string.Empty; } return TokenExpiration.ToShortTimeString(); } } 
        
        public string RefreshToken 
        { 
              get { return _RefreshToken; } 
              set { _RefreshToken = value; RefreshTokenIsNull = false; } 
        } 
        public bool RefreshTokenIsNull { get; set; }
        public string RefreshTokenErrors { get; set; }
        public string AllErrors 
        { 
              get 
              { 
                  string returnString = string.Empty;
                  if (!PersonTokenIDErrors.Equals(string.Empty))
                  { 
                      returnString += "Person TokenID: " + PersonTokenIDErrors; 
                  } 
                  if (!PersonIDErrors.Equals(string.Empty))
                  { 
                      returnString += "PersonID: " + PersonIDErrors; 
                  } 
                  if (!PermissionIDErrors.Equals(string.Empty))
                  { 
                      returnString += "PermissionID: " + PermissionIDErrors; 
                  } 
                  if (!AccessTokenErrors.Equals(string.Empty))
                  { 
                      returnString += "Access Token: " + AccessTokenErrors; 
                  } 
                  if (!TokenExpirationErrors.Equals(string.Empty))
                  { 
                      returnString += "Token Expiration: " + TokenExpirationErrors; 
                  } 
                  if (!RefreshTokenErrors.Equals(string.Empty))
                  { 
                      returnString += "Refresh Token: " + RefreshTokenErrors; 
                  } 
                  return returnString; 
              } 
        } 
        public string Permission {
            get {
                if (Enum.IsDefined(typeof(BO.ORCID.REFPermission.REFPermissions), this.PermissionID)) {
                    return DevelopmentBase.Common.EnumDescription((BO.ORCID.REFPermission.REFPermissions)this.PermissionID);
                } else {
                    return "";
                }
            }
            set {
            }
        }
        public bool Equals(PersonToken left, PersonToken right)
        {
            if((object)left == null && (object)right == null)
            {
                return true;
            }
            if((object)left == null || (object)right == null)
            {
                return false;
            }
            return left.PersonTokenID == right.PersonTokenID;
        }
        public int GetHashCode(PersonToken obj)
        {
            return (obj.PersonTokenID).GetHashCode();
        }
        public bool Equals(PersonToken other)
        {
            if (this.PersonTokenID == other.PersonTokenID )
                return true;

            return false;
        }
        public override int GetHashCode()
        {
            return PersonTokenID.GetHashCode();
        }

        public BO.Interfaces.ORCID.IPersonToken DBFields { get { return this; } } 
     
        # endregion // Public Properties 
     
        # region Protected Methods 
     
        protected override void InitializePropertiesCG()
        {
            PersonTokenIDIsNull = true; 
            PersonTokenIDErrors = string.Empty; 
            PersonIDIsNull = true; 
            PersonIDErrors = string.Empty; 
            PermissionIDIsNull = true; 
            PermissionIDErrors = string.Empty; 
            AccessTokenIsNull = true; 
            AccessTokenErrors = string.Empty; 
            TokenExpirationIsNull = true; 
            TokenExpirationErrors = string.Empty; 
            RefreshTokenIsNull = true; 
            RefreshTokenErrors = string.Empty; 
            InitializeProperties(); 
        }
     
        # endregion // Protected Methods 
 
        # region Enums 
 
 
        # endregion // Enums 
    } 
 
} 
