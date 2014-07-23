using System; 
using System.Collections.Generic; 
using System.Text; 
using System.Runtime.Serialization; 
using System.ComponentModel; 
 
namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID
{ 
    public partial class REFPermission : ProfilesRNSBaseClassBO, BO.Interfaces.ORCID.IREFPermission, IEqualityComparer<REFPermission>, IEquatable<REFPermission> 
    { 
        # region Private variables 
          /*! PermissionID state (PermissionID) */ 
          private int _PermissionID;
          /*! PermissionScope state (Permission Scope) */ 
          private string _PermissionScope;
          /*! PermissionDescription state (Permission Description) */ 
          private string _PermissionDescription;
          /*! MethodAndRequest state (Method And Request) */ 
          private string _MethodAndRequest;
          /*! SuccessMessage state (Success Message) */ 
          private string _SuccessMessage;
          /*! FailedMessage state (Failed Message) */ 
          private string _FailedMessage;
        # endregion //Private variables 
     
        # region Public Properties 
     
        
        public int PermissionID 
        { 
              get { return _PermissionID; } 
              set { _PermissionID = value; PermissionIDIsNull = false; } 
        } 
        public bool PermissionIDIsNull { get; set; }
        public string PermissionIDErrors { get; set; }
        public string PermissionIDText { get { if (PermissionIDIsNull){ return string.Empty; } return PermissionID.ToString(); } } 
        public override string IdentityValue { get { if (PermissionIDIsNull){ return string.Empty; } return PermissionID.ToString(); } } 
        public override bool IdentityIsNull { get { return PermissionIDIsNull; } } 
        
        public string PermissionScope 
        { 
              get { return _PermissionScope; } 
              set { _PermissionScope = value; PermissionScopeIsNull = false; } 
        } 
        public bool PermissionScopeIsNull { get; set; }
        public string PermissionScopeErrors { get; set; }
        
        public string PermissionDescription 
        { 
              get { return _PermissionDescription; } 
              set { _PermissionDescription = value; PermissionDescriptionIsNull = false; } 
        } 
        public bool PermissionDescriptionIsNull { get; set; }
        public string PermissionDescriptionErrors { get; set; }
        
        public string MethodAndRequest 
        { 
              get { return _MethodAndRequest; } 
              set { _MethodAndRequest = value; MethodAndRequestIsNull = false; } 
        } 
        public bool MethodAndRequestIsNull { get; set; }
        public string MethodAndRequestErrors { get; set; }
        
        public string SuccessMessage 
        { 
              get { return _SuccessMessage; } 
              set { _SuccessMessage = value; SuccessMessageIsNull = false; } 
        } 
        public bool SuccessMessageIsNull { get; set; }
        public string SuccessMessageErrors { get; set; }
        
        public string FailedMessage 
        { 
              get { return _FailedMessage; } 
              set { _FailedMessage = value; FailedMessageIsNull = false; } 
        } 
        public bool FailedMessageIsNull { get; set; }
        public string FailedMessageErrors { get; set; }
        public string AllErrors 
        { 
              get 
              { 
                  string returnString = string.Empty;
                  if (!PermissionIDErrors.Equals(string.Empty))
                  { 
                      returnString += "PermissionID: " + PermissionIDErrors; 
                  } 
                  if (!PermissionScopeErrors.Equals(string.Empty))
                  { 
                      returnString += "Permission Scope: " + PermissionScopeErrors; 
                  } 
                  if (!PermissionDescriptionErrors.Equals(string.Empty))
                  { 
                      returnString += "Permission Description: " + PermissionDescriptionErrors; 
                  } 
                  if (!MethodAndRequestErrors.Equals(string.Empty))
                  { 
                      returnString += "Method And Request: " + MethodAndRequestErrors; 
                  } 
                  if (!SuccessMessageErrors.Equals(string.Empty))
                  { 
                      returnString += "Success Message: " + SuccessMessageErrors; 
                  } 
                  if (!FailedMessageErrors.Equals(string.Empty))
                  { 
                      returnString += "Failed Message: " + FailedMessageErrors; 
                  } 
                  return returnString; 
              } 
        } 
        public bool Equals(REFPermission left, REFPermission right)
        {
            if((object)left == null && (object)right == null)
            {
                return true;
            }
            if((object)left == null || (object)right == null)
            {
                return false;
            }
            return left.PermissionID == right.PermissionID;
        }
        public int GetHashCode(REFPermission obj)
        {
            return (obj.PermissionID).GetHashCode();
        }
        public bool Equals(REFPermission other)
        {
            if (this.PermissionID == other.PermissionID )
                return true;

            return false;
        }
        public override int GetHashCode()
        {
            return PermissionID.GetHashCode();
        }

        public BO.Interfaces.ORCID.IREFPermission DBFields { get { return this; } } 
     
        # endregion // Public Properties 
     
        # region Protected Methods 
     
        protected override void InitializePropertiesCG()
        {
            PermissionIDIsNull = true; 
            PermissionIDErrors = string.Empty; 
            PermissionScopeIsNull = true; 
            PermissionScopeErrors = string.Empty; 
            PermissionDescriptionIsNull = true; 
            PermissionDescriptionErrors = string.Empty; 
            MethodAndRequestIsNull = true; 
            MethodAndRequestErrors = string.Empty; 
            SuccessMessageIsNull = true; 
            SuccessMessageErrors = string.Empty; 
            FailedMessageIsNull = true; 
            FailedMessageErrors = string.Empty; 
            InitializeProperties(); 
        }
     
        # endregion // Protected Methods 
 
        # region Enums 
 
        public enum REFPermissions{
			[DescriptionAttribute("/orcid-profile/create")]
			orcid_profile_create=1
			,[DescriptionAttribute("/orcid-bio/update")]
			orcid_bio_update=2
			,[DescriptionAttribute("/orcid-works/create")]
			orcid_works_create=3
			,[DescriptionAttribute("/orcid-profile/read-limited")]
			orcid_profile_read_limited=4
			,[DescriptionAttribute("/orcid-bio/read-limited")]
			orcid_bio_read_limited=5
			,[DescriptionAttribute("/orcid-works/read-limited")]
			orcid_works_read_limited=6
			,[DescriptionAttribute("/orcid-bio/external-identifiers/create")]
			orcid_bio_external_identifiers_create=7
			,[DescriptionAttribute("/authenticate")]
			authenticate=8
			,[DescriptionAttribute("/affiliations/create")]
			affiliations_create=9
			,[DescriptionAttribute("/affiliations/update")]
			affiliations_update=10
			,[DescriptionAttribute("/read-public")]
			read_public=11
        }
 
        # endregion // Enums 
    } 
 
} 
