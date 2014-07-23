using System; 
using System.Collections.Generic; 
using System.Text; 
using System.Runtime.Serialization; 
using System.ComponentModel; 
 
namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID
{ 
    public partial class PersonMessage : ProfilesRNSBaseClassBO, BO.Interfaces.ORCID.IPersonMessage, IEqualityComparer<PersonMessage>, IEquatable<PersonMessage> 
    { 
        # region Private variables 
          /*! PersonMessageID state (Person MessageID) */ 
          private int _PersonMessageID;
          /*! PersonID state (PersonID) */ 
          private int _PersonID;
          /*! XML_Sent state (XML Sent) */ 
          private string _XML_Sent;
          /*! XML_Response state (XML Response) */ 
          private string _XML_Response;
          /*! ErrorMessage state (Error Message) */ 
          private string _ErrorMessage;
          /*! HttpResponseCode state (Http Response Code) */ 
          private string _HttpResponseCode;
          /*! MessagePostSuccess state (Message Post Success) */ 
          private bool _MessagePostSuccess;
          /*! RecordStatusID state (Record StatusID) */ 
          private int _RecordStatusID;
          /*! PermissionID state (PermissionID) */ 
          private int _PermissionID;
          /*! RequestURL state (Request URL) */ 
          private string _RequestURL;
          /*! HeaderPost state (Header Post) */ 
          private string _HeaderPost;
          /*! UserMessage state (User Message) */ 
          private string _UserMessage;
          /*! PostDate state (Post Date) */ 
          private System.DateTime _PostDate;
        # endregion //Private variables 
     
        # region Public Properties 
     
        
        public int PersonMessageID 
        { 
              get { return _PersonMessageID; } 
              set { _PersonMessageID = value; PersonMessageIDIsNull = false; } 
        } 
        public bool PersonMessageIDIsNull { get; set; }
        public string PersonMessageIDErrors { get; set; }
        public string PersonMessageIDText { get { if (PersonMessageIDIsNull){ return string.Empty; } return PersonMessageID.ToString(); } } 
        public override string IdentityValue { get { if (PersonMessageIDIsNull){ return string.Empty; } return PersonMessageID.ToString(); } } 
        public override bool IdentityIsNull { get { return PersonMessageIDIsNull; } } 
        
        public int PersonID 
        { 
              get { return _PersonID; } 
              set { _PersonID = value; PersonIDIsNull = false; } 
        } 
        public bool PersonIDIsNull { get; set; }
        public string PersonIDErrors { get; set; }
        
        public string XML_Sent 
        { 
              get { return _XML_Sent; } 
              set { _XML_Sent = value; XML_SentIsNull = false; } 
        } 
        public bool XML_SentIsNull { get; set; }
        public string XML_SentErrors { get; set; }
        
        public string XML_Response 
        { 
              get { return _XML_Response; } 
              set { _XML_Response = value; XML_ResponseIsNull = false; } 
        } 
        public bool XML_ResponseIsNull { get; set; }
        public string XML_ResponseErrors { get; set; }
        
        public string ErrorMessage 
        { 
              get { return _ErrorMessage; } 
              set { _ErrorMessage = value; ErrorMessageIsNull = false; } 
        } 
        public bool ErrorMessageIsNull { get; set; }
        public string ErrorMessageErrors { get; set; }
        
        public string HttpResponseCode 
        { 
              get { return _HttpResponseCode; } 
              set { _HttpResponseCode = value; HttpResponseCodeIsNull = false; } 
        } 
        public bool HttpResponseCodeIsNull { get; set; }
        public string HttpResponseCodeErrors { get; set; }
        
        public bool MessagePostSuccess 
        { 
              get { return _MessagePostSuccess; } 
              set { _MessagePostSuccess = value; MessagePostSuccessIsNull = false; } 
        } 
        public bool MessagePostSuccessIsNull { get; set; }
        public string MessagePostSuccessErrors { get; set; }
        public string MessagePostSuccessDesc { get { if (MessagePostSuccessIsNull){ return string.Empty; } else if (MessagePostSuccess){ return "Yes"; } else { return "No"; } } } 
        
        public int RecordStatusID 
        { 
              get { return _RecordStatusID; } 
              set { _RecordStatusID = value; RecordStatusIDIsNull = false; } 
        } 
        public bool RecordStatusIDIsNull { get; set; }
        public string RecordStatusIDErrors { get; set; }
        
        public int PermissionID 
        { 
              get { return _PermissionID; } 
              set { _PermissionID = value; PermissionIDIsNull = false; } 
        } 
        public bool PermissionIDIsNull { get; set; }
        public string PermissionIDErrors { get; set; }
        
        public string RequestURL 
        { 
              get { return _RequestURL; } 
              set { _RequestURL = value; RequestURLIsNull = false; } 
        } 
        public bool RequestURLIsNull { get; set; }
        public string RequestURLErrors { get; set; }
        
        public string HeaderPost 
        { 
              get { return _HeaderPost; } 
              set { _HeaderPost = value; HeaderPostIsNull = false; } 
        } 
        public bool HeaderPostIsNull { get; set; }
        public string HeaderPostErrors { get; set; }
        
        public string UserMessage 
        { 
              get { return _UserMessage; } 
              set { _UserMessage = value; UserMessageIsNull = false; } 
        } 
        public bool UserMessageIsNull { get; set; }
        public string UserMessageErrors { get; set; }
        
        public System.DateTime PostDate 
        { 
              get { return _PostDate; } 
              set { _PostDate = value; PostDateIsNull = false; } 
        } 
        public bool PostDateIsNull { get; set; }
        public string PostDateErrors { get; set; }
        public string PostDateDesc { get { if (PostDateIsNull){ return string.Empty; } return PostDate.ToShortDateString(); } } 
        public string PostDateTime { get { if (PostDateIsNull){ return string.Empty; } return PostDate.ToShortTimeString(); } } 
        public string AllErrors 
        { 
              get 
              { 
                  string returnString = string.Empty;
                  if (!PersonMessageIDErrors.Equals(string.Empty))
                  { 
                      returnString += "Person MessageID: " + PersonMessageIDErrors; 
                  } 
                  if (!PersonIDErrors.Equals(string.Empty))
                  { 
                      returnString += "PersonID: " + PersonIDErrors; 
                  } 
                  if (!XML_SentErrors.Equals(string.Empty))
                  { 
                      returnString += "XML Sent: " + XML_SentErrors; 
                  } 
                  if (!XML_ResponseErrors.Equals(string.Empty))
                  { 
                      returnString += "XML Response: " + XML_ResponseErrors; 
                  } 
                  if (!ErrorMessageErrors.Equals(string.Empty))
                  { 
                      returnString += "Error Message: " + ErrorMessageErrors; 
                  } 
                  if (!HttpResponseCodeErrors.Equals(string.Empty))
                  { 
                      returnString += "Http Response Code: " + HttpResponseCodeErrors; 
                  } 
                  if (!MessagePostSuccessErrors.Equals(string.Empty))
                  { 
                      returnString += "Message Post Success: " + MessagePostSuccessErrors; 
                  } 
                  if (!RecordStatusIDErrors.Equals(string.Empty))
                  { 
                      returnString += "Record StatusID: " + RecordStatusIDErrors; 
                  } 
                  if (!PermissionIDErrors.Equals(string.Empty))
                  { 
                      returnString += "PermissionID: " + PermissionIDErrors; 
                  } 
                  if (!RequestURLErrors.Equals(string.Empty))
                  { 
                      returnString += "Request URL: " + RequestURLErrors; 
                  } 
                  if (!HeaderPostErrors.Equals(string.Empty))
                  { 
                      returnString += "Header Post: " + HeaderPostErrors; 
                  } 
                  if (!UserMessageErrors.Equals(string.Empty))
                  { 
                      returnString += "User Message: " + UserMessageErrors; 
                  } 
                  if (!PostDateErrors.Equals(string.Empty))
                  { 
                      returnString += "Post Date: " + PostDateErrors; 
                  } 
                  return returnString; 
              } 
        } 
        public string RecordStatus {
            get {
                if (Enum.IsDefined(typeof(BO.ORCID.REFRecordStatus.REFRecordStatuss), this.RecordStatusID)) {
                    return DevelopmentBase.Common.EnumDescription((BO.ORCID.REFRecordStatus.REFRecordStatuss)this.RecordStatusID);
                } else {
                    return "";
                }
            }
            set {
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
        public bool Equals(PersonMessage left, PersonMessage right)
        {
            if((object)left == null && (object)right == null)
            {
                return true;
            }
            if((object)left == null || (object)right == null)
            {
                return false;
            }
            return left.PersonMessageID == right.PersonMessageID;
        }
        public int GetHashCode(PersonMessage obj)
        {
            return (obj.PersonMessageID).GetHashCode();
        }
        public bool Equals(PersonMessage other)
        {
            if (this.PersonMessageID == other.PersonMessageID )
                return true;

            return false;
        }
        public override int GetHashCode()
        {
            return PersonMessageID.GetHashCode();
        }

        public BO.Interfaces.ORCID.IPersonMessage DBFields { get { return this; } } 
     
        # endregion // Public Properties 
     
        # region Protected Methods 
     
        protected override void InitializePropertiesCG()
        {
            PersonMessageIDIsNull = true; 
            PersonMessageIDErrors = string.Empty; 
            PersonIDIsNull = true; 
            PersonIDErrors = string.Empty; 
            XML_SentIsNull = true; 
            XML_SentErrors = string.Empty; 
            XML_ResponseIsNull = true; 
            XML_ResponseErrors = string.Empty; 
            ErrorMessageIsNull = true; 
            ErrorMessageErrors = string.Empty; 
            HttpResponseCodeIsNull = true; 
            HttpResponseCodeErrors = string.Empty; 
            MessagePostSuccessIsNull = true; 
            MessagePostSuccessErrors = string.Empty; 
            RecordStatusIDIsNull = true; 
            RecordStatusIDErrors = string.Empty; 
            PermissionIDIsNull = true; 
            PermissionIDErrors = string.Empty; 
            RequestURLIsNull = true; 
            RequestURLErrors = string.Empty; 
            HeaderPostIsNull = true; 
            HeaderPostErrors = string.Empty; 
            UserMessageIsNull = true; 
            UserMessageErrors = string.Empty; 
            PostDateIsNull = true; 
            PostDateErrors = string.Empty; 
            InitializeProperties(); 
        }
     
        # endregion // Protected Methods 
 
        # region Enums 
 
 
        # endregion // Enums 
    } 
 
} 
