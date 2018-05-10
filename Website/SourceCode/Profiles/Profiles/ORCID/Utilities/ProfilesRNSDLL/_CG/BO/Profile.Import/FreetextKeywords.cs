using System;
using System.Collections.Generic;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.Profile.Import
{
    public partial class FreetextKeywords : ProfilesRNSBaseClassBO, BO.Interfaces.Profile.Import.IFreetextKeywords, IEqualityComparer<FreetextKeywords>, IEquatable<FreetextKeywords> 
    { 
        # region Private variables 
          /*! PersonKeywordID state (Person KeywordID) */ 
          private int _PersonKeywordID;
          /*! InternalUsername state (Internal Username) */ 
          private string _InternalUsername;
          /*! Keyword state (Keyword) */ 
          private string _Keyword;
          /*! DisplaySecurityGroupID state (Display Security GroupID) */ 
          private int _DisplaySecurityGroupID;
        # endregion //Private variables 
     
        # region Public Properties 
     
        
        public int PersonKeywordID 
        { 
              get { return _PersonKeywordID; } 
              set { _PersonKeywordID = value; PersonKeywordIDIsNull = false; } 
        } 
        public bool PersonKeywordIDIsNull { get; set; }
        public string PersonKeywordIDErrors { get; set; }
        public string PersonKeywordIDText { get { if (PersonKeywordIDIsNull){ return string.Empty; } return PersonKeywordID.ToString(); } } 
        public override string IdentityValue { get { if (PersonKeywordIDIsNull){ return string.Empty; } return PersonKeywordID.ToString(); } } 
        public override bool IdentityIsNull { get { return PersonKeywordIDIsNull; } } 
        
        public string InternalUsername 
        { 
              get { return _InternalUsername; } 
              set { _InternalUsername = value; InternalUsernameIsNull = false; } 
        } 
        public bool InternalUsernameIsNull { get; set; }
        public string InternalUsernameErrors { get; set; }
        
        public string Keyword 
        { 
              get { return _Keyword; } 
              set { _Keyword = value; KeywordIsNull = false; } 
        } 
        public bool KeywordIsNull { get; set; }
        public string KeywordErrors { get; set; }
        
        public int DisplaySecurityGroupID 
        { 
              get { return _DisplaySecurityGroupID; } 
              set { _DisplaySecurityGroupID = value; DisplaySecurityGroupIDIsNull = false; } 
        } 
        public bool DisplaySecurityGroupIDIsNull { get; set; }
        public string DisplaySecurityGroupIDErrors { get; set; }
        public string AllErrors 
        { 
              get 
              { 
                  string returnString = string.Empty;
                  if (!PersonKeywordIDErrors.Equals(string.Empty))
                  { 
                      returnString += "Person KeywordID: " + PersonKeywordIDErrors; 
                  } 
                  if (!InternalUsernameErrors.Equals(string.Empty))
                  { 
                      returnString += "Internal Username: " + InternalUsernameErrors; 
                  } 
                  if (!KeywordErrors.Equals(string.Empty))
                  { 
                      returnString += "Keyword: " + KeywordErrors; 
                  } 
                  if (!DisplaySecurityGroupIDErrors.Equals(string.Empty))
                  { 
                      returnString += "Display Security GroupID: " + DisplaySecurityGroupIDErrors; 
                  } 
                  return returnString; 
              } 
        } 
        public bool Equals(FreetextKeywords left, FreetextKeywords right)
        {
            if((object)left == null && (object)right == null)
            {
                return true;
            }
            if((object)left == null || (object)right == null)
            {
                return false;
            }
            return left.PersonKeywordID == right.PersonKeywordID;
        }
        public int GetHashCode(FreetextKeywords obj)
        {
            return (obj.PersonKeywordID).GetHashCode();
        }
        public bool Equals(FreetextKeywords other)
        {
            if (this.PersonKeywordID == other.PersonKeywordID )
                return true;

            return false;
        }
        public override int GetHashCode()
        {
            return PersonKeywordID.GetHashCode();
        }

        public BO.Interfaces.Profile.Import.IFreetextKeywords DBFields { get { return this; } } 
     
        # endregion // Public Properties 
     
        # region Protected Methods 
     
        protected override void InitializePropertiesCG()
        {
            PersonKeywordIDIsNull = true; 
            PersonKeywordIDErrors = string.Empty; 
            InternalUsernameIsNull = true; 
            InternalUsernameErrors = string.Empty; 
            KeywordIsNull = true; 
            KeywordErrors = string.Empty; 
            DisplaySecurityGroupIDIsNull = true; 
            DisplaySecurityGroupIDErrors = string.Empty; 
            InitializeProperties(); 
        }
     
        # endregion // Protected Methods 
 
        # region Enums 
 
 
        # endregion // Enums 
    } 
 
} 
