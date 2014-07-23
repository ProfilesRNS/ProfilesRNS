using System; 
using System.Collections.Generic; 
using System.Text; 
using System.Runtime.Serialization; 
using System.ComponentModel; 
 
namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID
{ 
    public partial class ErrorLog : ProfilesRNSBaseClassBO, BO.Interfaces.ORCID.IErrorLog, IEqualityComparer<ErrorLog>, IEquatable<ErrorLog> 
    { 
        # region Private variables 
          /*! ErrorLogID state (Error LogID) */ 
          private int _ErrorLogID;
          /*! InternalUsername state (Internal Username) */ 
          private string _InternalUsername;
          /*! Exception state (Exception) */ 
          private string _Exception;
          /*! OccurredOn state (Occurred On) */ 
          private System.DateTime _OccurredOn;
          /*! Processed state (Processed) */ 
          private bool _Processed;
        # endregion //Private variables 
     
        # region Public Properties 
     
        
        public int ErrorLogID 
        { 
              get { return _ErrorLogID; } 
              set { _ErrorLogID = value; ErrorLogIDIsNull = false; } 
        } 
        public bool ErrorLogIDIsNull { get; set; }
        public string ErrorLogIDErrors { get; set; }
        public string ErrorLogIDText { get { if (ErrorLogIDIsNull){ return string.Empty; } return ErrorLogID.ToString(); } } 
        public override string IdentityValue { get { if (ErrorLogIDIsNull){ return string.Empty; } return ErrorLogID.ToString(); } } 
        public override bool IdentityIsNull { get { return ErrorLogIDIsNull; } } 
        
        public string InternalUsername 
        { 
              get { return _InternalUsername; } 
              set { _InternalUsername = value; InternalUsernameIsNull = false; } 
        } 
        public bool InternalUsernameIsNull { get; set; }
        public string InternalUsernameErrors { get; set; }
        
        public string Exception 
        { 
              get { return _Exception; } 
              set { _Exception = value; ExceptionIsNull = false; } 
        } 
        public bool ExceptionIsNull { get; set; }
        public string ExceptionErrors { get; set; }
        
        public System.DateTime OccurredOn 
        { 
              get { return _OccurredOn; } 
              set { _OccurredOn = value; OccurredOnIsNull = false; } 
        } 
        public bool OccurredOnIsNull { get; set; }
        public string OccurredOnErrors { get; set; }
        public string OccurredOnDesc { get { if (OccurredOnIsNull){ return string.Empty; } return OccurredOn.ToShortDateString(); } } 
        public string OccurredOnTime { get { if (OccurredOnIsNull){ return string.Empty; } return OccurredOn.ToShortTimeString(); } } 
        
        public bool Processed 
        { 
              get { return _Processed; } 
              set { _Processed = value; ProcessedIsNull = false; } 
        } 
        public bool ProcessedIsNull { get; set; }
        public string ProcessedErrors { get; set; }
        public string ProcessedDesc { get { if (ProcessedIsNull){ return string.Empty; } else if (Processed){ return "Yes"; } else { return "No"; } } } 
        public string AllErrors 
        { 
              get 
              { 
                  string returnString = string.Empty;
                  if (!ErrorLogIDErrors.Equals(string.Empty))
                  { 
                      returnString += "Error LogID: " + ErrorLogIDErrors; 
                  } 
                  if (!InternalUsernameErrors.Equals(string.Empty))
                  { 
                      returnString += "Internal Username: " + InternalUsernameErrors; 
                  } 
                  if (!ExceptionErrors.Equals(string.Empty))
                  { 
                      returnString += "Exception: " + ExceptionErrors; 
                  } 
                  if (!OccurredOnErrors.Equals(string.Empty))
                  { 
                      returnString += "Occurred On: " + OccurredOnErrors; 
                  } 
                  if (!ProcessedErrors.Equals(string.Empty))
                  { 
                      returnString += "Processed: " + ProcessedErrors; 
                  } 
                  return returnString; 
              } 
        } 
        public bool Equals(ErrorLog left, ErrorLog right)
        {
            if((object)left == null && (object)right == null)
            {
                return true;
            }
            if((object)left == null || (object)right == null)
            {
                return false;
            }
            return left.ErrorLogID == right.ErrorLogID;
        }
        public int GetHashCode(ErrorLog obj)
        {
            return (obj.ErrorLogID).GetHashCode();
        }
        public bool Equals(ErrorLog other)
        {
            if (this.ErrorLogID == other.ErrorLogID )
                return true;

            return false;
        }
        public override int GetHashCode()
        {
            return ErrorLogID.GetHashCode();
        }

        public BO.Interfaces.ORCID.IErrorLog DBFields { get { return this; } } 
     
        # endregion // Public Properties 
     
        # region Protected Methods 
     
        protected override void InitializePropertiesCG()
        {
            ErrorLogIDIsNull = true; 
            ErrorLogIDErrors = string.Empty; 
            InternalUsernameIsNull = true; 
            InternalUsernameErrors = string.Empty; 
            ExceptionIsNull = true; 
            ExceptionErrors = string.Empty; 
            OccurredOnIsNull = true; 
            OccurredOnErrors = string.Empty; 
            ProcessedIsNull = true; 
            ProcessedErrors = string.Empty; 
            InitializeProperties(); 
        }
     
        # endregion // Protected Methods 
 
        # region Enums 
 
 
        # endregion // Enums 
    } 
 
} 
