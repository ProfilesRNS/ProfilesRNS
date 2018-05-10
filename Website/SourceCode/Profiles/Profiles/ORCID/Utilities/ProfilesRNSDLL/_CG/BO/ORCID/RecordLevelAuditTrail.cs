using System;
using System.Collections.Generic;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID
{
    public partial class RecordLevelAuditTrail : ProfilesRNSBaseClassBO, BO.Interfaces.ORCID.IRecordLevelAuditTrail, IEqualityComparer<RecordLevelAuditTrail>, IEquatable<RecordLevelAuditTrail> 
    { 
        # region Private variables 
          /*! RecordLevelAuditTrailID state (Record Level Audit TrailID) */ 
          private long _RecordLevelAuditTrailID;
          /*! MetaTableID state (Meta TableID) */ 
          private int _MetaTableID;
          /*! RowIdentifier state (Row Identifier) */ 
          private long _RowIdentifier;
          /*! RecordLevelAuditTypeID state (Record Level Audit TypeID) */ 
          private int _RecordLevelAuditTypeID;
          /*! CreatedDate state (Created Date) */ 
          private System.DateTime _CreatedDate;
          /*! CreatedBy state (Created By) */ 
          private string _CreatedBy;
        # endregion //Private variables 
     
        # region Public Properties 
     
        
        public long RecordLevelAuditTrailID 
        { 
              get { return _RecordLevelAuditTrailID; } 
              set { _RecordLevelAuditTrailID = value; RecordLevelAuditTrailIDIsNull = false; } 
        } 
        public bool RecordLevelAuditTrailIDIsNull { get; set; }
        public string RecordLevelAuditTrailIDErrors { get; set; }
        public string RecordLevelAuditTrailIDText { get { if (RecordLevelAuditTrailIDIsNull){ return string.Empty; } return RecordLevelAuditTrailID.ToString(); } } 
        public override string IdentityValue { get { if (RecordLevelAuditTrailIDIsNull){ return string.Empty; } return RecordLevelAuditTrailID.ToString(); } } 
        public override bool IdentityIsNull { get { return RecordLevelAuditTrailIDIsNull; } } 
        
        public int MetaTableID 
        { 
              get { return _MetaTableID; } 
              set { _MetaTableID = value; MetaTableIDIsNull = false; } 
        } 
        public bool MetaTableIDIsNull { get; set; }
        public string MetaTableIDErrors { get; set; }
        
        public long RowIdentifier 
        { 
              get { return _RowIdentifier; } 
              set { _RowIdentifier = value; RowIdentifierIsNull = false; } 
        } 
        public bool RowIdentifierIsNull { get; set; }
        public string RowIdentifierErrors { get; set; }
        
        public int RecordLevelAuditTypeID 
        { 
              get { return _RecordLevelAuditTypeID; } 
              set { _RecordLevelAuditTypeID = value; RecordLevelAuditTypeIDIsNull = false; } 
        } 
        public bool RecordLevelAuditTypeIDIsNull { get; set; }
        public string RecordLevelAuditTypeIDErrors { get; set; }
        
        public System.DateTime CreatedDate 
        { 
              get { return _CreatedDate; } 
              set { _CreatedDate = value; CreatedDateIsNull = false; } 
        } 
        public bool CreatedDateIsNull { get; set; }
        public string CreatedDateErrors { get; set; }
        public string CreatedDateDesc { get { if (CreatedDateIsNull){ return string.Empty; } return CreatedDate.ToShortDateString(); } } 
        public string CreatedDateTime { get { if (CreatedDateIsNull){ return string.Empty; } return CreatedDate.ToShortTimeString(); } } 
        
        public string CreatedBy 
        { 
              get { return _CreatedBy; } 
              set { _CreatedBy = value; CreatedByIsNull = false; } 
        } 
        public bool CreatedByIsNull { get; set; }
        public string CreatedByErrors { get; set; }
        public string AllErrors 
        { 
              get 
              { 
                  string returnString = string.Empty;
                  if (!RecordLevelAuditTrailIDErrors.Equals(string.Empty))
                  { 
                      returnString += "Record Level Audit TrailID: " + RecordLevelAuditTrailIDErrors; 
                  } 
                  if (!MetaTableIDErrors.Equals(string.Empty))
                  { 
                      returnString += "Meta TableID: " + MetaTableIDErrors; 
                  } 
                  if (!RowIdentifierErrors.Equals(string.Empty))
                  { 
                      returnString += "Row Identifier: " + RowIdentifierErrors; 
                  } 
                  if (!RecordLevelAuditTypeIDErrors.Equals(string.Empty))
                  { 
                      returnString += "Record Level Audit TypeID: " + RecordLevelAuditTypeIDErrors; 
                  } 
                  if (!CreatedDateErrors.Equals(string.Empty))
                  { 
                      returnString += "Created Date: " + CreatedDateErrors; 
                  } 
                  if (!CreatedByErrors.Equals(string.Empty))
                  { 
                      returnString += "Created By: " + CreatedByErrors; 
                  } 
                  return returnString; 
              } 
        } 
        public bool Equals(RecordLevelAuditTrail left, RecordLevelAuditTrail right)
        {
            if((object)left == null && (object)right == null)
            {
                return true;
            }
            if((object)left == null || (object)right == null)
            {
                return false;
            }
            return left.RecordLevelAuditTrailID == right.RecordLevelAuditTrailID;
        }
        public int GetHashCode(RecordLevelAuditTrail obj)
        {
            return (obj.RecordLevelAuditTrailID).GetHashCode();
        }
        public bool Equals(RecordLevelAuditTrail other)
        {
            if (this.RecordLevelAuditTrailID == other.RecordLevelAuditTrailID )
                return true;

            return false;
        }
        public override int GetHashCode()
        {
            return RecordLevelAuditTrailID.GetHashCode();
        }

        public BO.Interfaces.ORCID.IRecordLevelAuditTrail DBFields { get { return this; } } 
     
        # endregion // Public Properties 
     
        # region Protected Methods 
     
        protected override void InitializePropertiesCG()
        {
            RecordLevelAuditTrailIDIsNull = true; 
            RecordLevelAuditTrailIDErrors = string.Empty; 
            MetaTableIDIsNull = true; 
            MetaTableIDErrors = string.Empty; 
            RowIdentifierIsNull = true; 
            RowIdentifierErrors = string.Empty; 
            RecordLevelAuditTypeIDIsNull = true; 
            RecordLevelAuditTypeIDErrors = string.Empty; 
            CreatedDateIsNull = true; 
            CreatedDateErrors = string.Empty; 
            CreatedByIsNull = true; 
            CreatedByErrors = string.Empty; 
            InitializeProperties(); 
        }
     
        # endregion // Protected Methods 
 
        # region Enums 
 
 
        # endregion // Enums 
    } 
 
} 
