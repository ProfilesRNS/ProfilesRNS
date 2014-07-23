using System; 
using System.Collections.Generic; 
using System.Text; 
using System.Runtime.Serialization; 
using System.ComponentModel; 
 
namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID
{ 
    public partial class FieldLevelAuditTrail : ProfilesRNSBaseClassBO, BO.Interfaces.ORCID.IFieldLevelAuditTrail, IEqualityComparer<FieldLevelAuditTrail>, IEquatable<FieldLevelAuditTrail> 
    { 
        # region Private variables 
          /*! FieldLevelAuditTrailID state (Field Level Audit TrailID) */ 
          private long _FieldLevelAuditTrailID;
          /*! RecordLevelAuditTrailID state (Record Level Audit TrailID) */ 
          private long _RecordLevelAuditTrailID;
          /*! MetaFieldID state (Meta FieldID) */ 
          private int _MetaFieldID;
          /*! ValueBefore state (Value Before) */ 
          private string _ValueBefore;
          /*! ValueAfter state (Value After) */ 
          private string _ValueAfter;
        # endregion //Private variables 
     
        # region Public Properties 
     
        
        public long FieldLevelAuditTrailID 
        { 
              get { return _FieldLevelAuditTrailID; } 
              set { _FieldLevelAuditTrailID = value; FieldLevelAuditTrailIDIsNull = false; } 
        } 
        public bool FieldLevelAuditTrailIDIsNull { get; set; }
        public string FieldLevelAuditTrailIDErrors { get; set; }
        public string FieldLevelAuditTrailIDText { get { if (FieldLevelAuditTrailIDIsNull){ return string.Empty; } return FieldLevelAuditTrailID.ToString(); } } 
        public override string IdentityValue { get { if (FieldLevelAuditTrailIDIsNull){ return string.Empty; } return FieldLevelAuditTrailID.ToString(); } } 
        public override bool IdentityIsNull { get { return FieldLevelAuditTrailIDIsNull; } } 
        
        public long RecordLevelAuditTrailID 
        { 
              get { return _RecordLevelAuditTrailID; } 
              set { _RecordLevelAuditTrailID = value; RecordLevelAuditTrailIDIsNull = false; } 
        } 
        public bool RecordLevelAuditTrailIDIsNull { get; set; }
        public string RecordLevelAuditTrailIDErrors { get; set; }
        
        public int MetaFieldID 
        { 
              get { return _MetaFieldID; } 
              set { _MetaFieldID = value; MetaFieldIDIsNull = false; } 
        } 
        public bool MetaFieldIDIsNull { get; set; }
        public string MetaFieldIDErrors { get; set; }
        
        public string ValueBefore 
        { 
              get { return _ValueBefore; } 
              set { _ValueBefore = value; ValueBeforeIsNull = false; } 
        } 
        public bool ValueBeforeIsNull { get; set; }
        public string ValueBeforeErrors { get; set; }
        
        public string ValueAfter 
        { 
              get { return _ValueAfter; } 
              set { _ValueAfter = value; ValueAfterIsNull = false; } 
        } 
        public bool ValueAfterIsNull { get; set; }
        public string ValueAfterErrors { get; set; }
        public string AllErrors 
        { 
              get 
              { 
                  string returnString = string.Empty;
                  if (!FieldLevelAuditTrailIDErrors.Equals(string.Empty))
                  { 
                      returnString += "Field Level Audit TrailID: " + FieldLevelAuditTrailIDErrors; 
                  } 
                  if (!RecordLevelAuditTrailIDErrors.Equals(string.Empty))
                  { 
                      returnString += "Record Level Audit TrailID: " + RecordLevelAuditTrailIDErrors; 
                  } 
                  if (!MetaFieldIDErrors.Equals(string.Empty))
                  { 
                      returnString += "Meta FieldID: " + MetaFieldIDErrors; 
                  } 
                  if (!ValueBeforeErrors.Equals(string.Empty))
                  { 
                      returnString += "Value Before: " + ValueBeforeErrors; 
                  } 
                  if (!ValueAfterErrors.Equals(string.Empty))
                  { 
                      returnString += "Value After: " + ValueAfterErrors; 
                  } 
                  return returnString; 
              } 
        } 
        public bool Equals(FieldLevelAuditTrail left, FieldLevelAuditTrail right)
        {
            if((object)left == null && (object)right == null)
            {
                return true;
            }
            if((object)left == null || (object)right == null)
            {
                return false;
            }
            return left.FieldLevelAuditTrailID == right.FieldLevelAuditTrailID;
        }
        public int GetHashCode(FieldLevelAuditTrail obj)
        {
            return (obj.FieldLevelAuditTrailID).GetHashCode();
        }
        public bool Equals(FieldLevelAuditTrail other)
        {
            if (this.FieldLevelAuditTrailID == other.FieldLevelAuditTrailID )
                return true;

            return false;
        }
        public override int GetHashCode()
        {
            return FieldLevelAuditTrailID.GetHashCode();
        }

        public BO.Interfaces.ORCID.IFieldLevelAuditTrail DBFields { get { return this; } } 
     
        # endregion // Public Properties 
     
        # region Protected Methods 
     
        protected override void InitializePropertiesCG()
        {
            FieldLevelAuditTrailIDIsNull = true; 
            FieldLevelAuditTrailIDErrors = string.Empty; 
            RecordLevelAuditTrailIDIsNull = true; 
            RecordLevelAuditTrailIDErrors = string.Empty; 
            MetaFieldIDIsNull = true; 
            MetaFieldIDErrors = string.Empty; 
            ValueBeforeIsNull = true; 
            ValueBeforeErrors = string.Empty; 
            ValueAfterIsNull = true; 
            ValueAfterErrors = string.Empty; 
            InitializeProperties(); 
        }
     
        # endregion // Protected Methods 
 
        # region Enums 
 
 
        # endregion // Enums 
    } 
 
} 
