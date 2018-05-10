using System;
using System.Collections.Generic;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID
{
    public partial class RecordLevelAuditType : ProfilesRNSBaseClassBO, BO.Interfaces.ORCID.IRecordLevelAuditType, IEqualityComparer<RecordLevelAuditType>, IEquatable<RecordLevelAuditType> 
    { 
        # region Private variables 
          /*! RecordLevelAuditTypeID state (Record Level Audit TypeID) */ 
          private int _RecordLevelAuditTypeID;
          /*! AuditType state (Audit Type) */ 
          private string _AuditType;
        # endregion //Private variables 
     
        # region Public Properties 
     
        
        public int RecordLevelAuditTypeID 
        { 
              get { return _RecordLevelAuditTypeID; } 
              set { _RecordLevelAuditTypeID = value; RecordLevelAuditTypeIDIsNull = false; } 
        } 
        public bool RecordLevelAuditTypeIDIsNull { get; set; }
        public string RecordLevelAuditTypeIDErrors { get; set; }
        public string RecordLevelAuditTypeIDText { get { if (RecordLevelAuditTypeIDIsNull){ return string.Empty; } return RecordLevelAuditTypeID.ToString(); } } 
        public override string IdentityValue { get { if (RecordLevelAuditTypeIDIsNull){ return string.Empty; } return RecordLevelAuditTypeID.ToString(); } } 
        public override bool IdentityIsNull { get { return RecordLevelAuditTypeIDIsNull; } } 
        
        public string AuditType 
        { 
              get { return _AuditType; } 
              set { _AuditType = value; AuditTypeIsNull = false; } 
        } 
        public bool AuditTypeIsNull { get; set; }
        public string AuditTypeErrors { get; set; }
        public string AllErrors 
        { 
              get 
              { 
                  string returnString = string.Empty;
                  if (!RecordLevelAuditTypeIDErrors.Equals(string.Empty))
                  { 
                      returnString += "Record Level Audit TypeID: " + RecordLevelAuditTypeIDErrors; 
                  } 
                  if (!AuditTypeErrors.Equals(string.Empty))
                  { 
                      returnString += "Audit Type: " + AuditTypeErrors; 
                  } 
                  return returnString; 
              } 
        } 
        public bool Equals(RecordLevelAuditType left, RecordLevelAuditType right)
        {
            if((object)left == null && (object)right == null)
            {
                return true;
            }
            if((object)left == null || (object)right == null)
            {
                return false;
            }
            return left.RecordLevelAuditTypeID == right.RecordLevelAuditTypeID;
        }
        public int GetHashCode(RecordLevelAuditType obj)
        {
            return (obj.RecordLevelAuditTypeID).GetHashCode();
        }
        public bool Equals(RecordLevelAuditType other)
        {
            if (this.RecordLevelAuditTypeID == other.RecordLevelAuditTypeID )
                return true;

            return false;
        }
        public override int GetHashCode()
        {
            return RecordLevelAuditTypeID.GetHashCode();
        }

        public BO.Interfaces.ORCID.IRecordLevelAuditType DBFields { get { return this; } } 
     
        # endregion // Public Properties 
     
        # region Protected Methods 
     
        protected override void InitializePropertiesCG()
        {
            RecordLevelAuditTypeIDIsNull = true; 
            RecordLevelAuditTypeIDErrors = string.Empty; 
            AuditTypeIsNull = true; 
            AuditTypeErrors = string.Empty; 
            InitializeProperties(); 
        }
     
        # endregion // Protected Methods 
 
        # region Enums 
 
 
        # endregion // Enums 
    } 
 
} 
