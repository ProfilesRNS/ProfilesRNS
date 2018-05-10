using System;
using System.Collections.Generic;
using System.ComponentModel;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID
{
    public partial class REFDecision : ProfilesRNSBaseClassBO, BO.Interfaces.ORCID.IREFDecision, IEqualityComparer<REFDecision>, IEquatable<REFDecision> 
    { 
        # region Private variables 
          /*! DecisionID state (DecisionID) */ 
          private int _DecisionID;
          /*! DecisionDescription state (Decision Description) */ 
          private string _DecisionDescription;
          /*! DecisionDescriptionLong state (Decision Description Long) */ 
          private string _DecisionDescriptionLong;
        # endregion //Private variables 
     
        # region Public Properties 
     
        
        public int DecisionID 
        { 
              get { return _DecisionID; } 
              set { _DecisionID = value; DecisionIDIsNull = false; } 
        } 
        public bool DecisionIDIsNull { get; set; }
        public string DecisionIDErrors { get; set; }
        public string DecisionIDText { get { if (DecisionIDIsNull){ return string.Empty; } return DecisionID.ToString(); } } 
        public override string IdentityValue { get { if (DecisionIDIsNull){ return string.Empty; } return DecisionID.ToString(); } } 
        public override bool IdentityIsNull { get { return DecisionIDIsNull; } } 
        
        public string DecisionDescription 
        { 
              get { return _DecisionDescription; } 
              set { _DecisionDescription = value; DecisionDescriptionIsNull = false; } 
        } 
        public bool DecisionDescriptionIsNull { get; set; }
        public string DecisionDescriptionErrors { get; set; }
        
        public string DecisionDescriptionLong 
        { 
              get { return _DecisionDescriptionLong; } 
              set { _DecisionDescriptionLong = value; DecisionDescriptionLongIsNull = false; } 
        } 
        public bool DecisionDescriptionLongIsNull { get; set; }
        public string DecisionDescriptionLongErrors { get; set; }
        public string AllErrors 
        { 
              get 
              { 
                  string returnString = string.Empty;
                  if (!DecisionIDErrors.Equals(string.Empty))
                  { 
                      returnString += "DecisionID: " + DecisionIDErrors; 
                  } 
                  if (!DecisionDescriptionErrors.Equals(string.Empty))
                  { 
                      returnString += "Decision Description: " + DecisionDescriptionErrors; 
                  } 
                  if (!DecisionDescriptionLongErrors.Equals(string.Empty))
                  { 
                      returnString += "Decision Description Long: " + DecisionDescriptionLongErrors; 
                  } 
                  return returnString; 
              } 
        } 
        public bool Equals(REFDecision left, REFDecision right)
        {
            if((object)left == null && (object)right == null)
            {
                return true;
            }
            if((object)left == null || (object)right == null)
            {
                return false;
            }
            return left.DecisionID == right.DecisionID;
        }
        public int GetHashCode(REFDecision obj)
        {
            return (obj.DecisionID).GetHashCode();
        }
        public bool Equals(REFDecision other)
        {
            if (this.DecisionID == other.DecisionID )
                return true;

            return false;
        }
        public override int GetHashCode()
        {
            return DecisionID.GetHashCode();
        }

        public BO.Interfaces.ORCID.IREFDecision DBFields { get { return this; } } 
     
        # endregion // Public Properties 
     
        # region Protected Methods 
     
        protected override void InitializePropertiesCG()
        {
            DecisionIDIsNull = true; 
            DecisionIDErrors = string.Empty; 
            DecisionDescriptionIsNull = true; 
            DecisionDescriptionErrors = string.Empty; 
            DecisionDescriptionLongIsNull = true; 
            DecisionDescriptionLongErrors = string.Empty; 
            InitializeProperties(); 
        }
     
        # endregion // Protected Methods 
 
        # region Enums 
 
        public enum REFDecisions{
			[DescriptionAttribute("Public")]
			Public=1
			,[DescriptionAttribute("Limited")]
			Limited=2
			,[DescriptionAttribute("Private")]
			Private=3
			,[DescriptionAttribute("Exclude")]
			Exclude=4
			,[DescriptionAttribute("Include")]
			Include=5
			,[DescriptionAttribute("Unable To Push")]
			Unable_To_Push=6
        }
 
        # endregion // Enums 
    } 
 
} 
