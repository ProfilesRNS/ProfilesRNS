using System; 
using System.Collections.Generic; 
using System.Text; 
using System.Runtime.Serialization; 
using System.ComponentModel; 
 
namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.RDF
{ 
    public partial class Triple : ProfilesRNSBaseClassBO, BO.Interfaces.RDF.ITriple, IEqualityComparer<Triple>, IEquatable<Triple> 
    { 
        # region Private variables 
          /*! TripleID state (TripleID) */ 
          private long _TripleID;
          /*! Subject state (Subject) */ 
          private long _Subject;
          /*! Predicate state (Predicate) */ 
          private long _Predicate;
          /*! Object state (Object) */ 
          private long _Object;
          /*! TripleHash state (Triple Hash) */ 
          private System.Byte[] _TripleHash;
          /*! Weight state (Weight) */ 
          private double _Weight;
          /*! Reitification state (Reitification) */ 
          private long _Reitification;
          /*! ObjectType state (Object Type) */ 
          private bool _ObjectType;
          /*! SortOrder state (Sort Order) */ 
          private int _SortOrder;
          /*! ViewSecurityGroup state (View Security Group) */ 
          private long _ViewSecurityGroup;
          /*! Graph state (Graph) */ 
          private long _Graph;
        # endregion //Private variables 
     
        # region Public Properties 
     
        
        public long TripleID 
        { 
              get { return _TripleID; } 
              set { _TripleID = value; TripleIDIsNull = false; } 
        } 
        public bool TripleIDIsNull { get; set; }
        public string TripleIDErrors { get; set; }
        public string TripleIDText { get { if (TripleIDIsNull){ return string.Empty; } return TripleID.ToString(); } } 
        public override string IdentityValue { get { if (TripleIDIsNull){ return string.Empty; } return TripleID.ToString(); } } 
        public override bool IdentityIsNull { get { return TripleIDIsNull; } } 
        
        public long Subject 
        { 
              get { return _Subject; } 
              set { _Subject = value; SubjectIsNull = false; } 
        } 
        public bool SubjectIsNull { get; set; }
        public string SubjectErrors { get; set; }
        
        public long Predicate 
        { 
              get { return _Predicate; } 
              set { _Predicate = value; PredicateIsNull = false; } 
        } 
        public bool PredicateIsNull { get; set; }
        public string PredicateErrors { get; set; }
        
        public long Object 
        { 
              get { return _Object; } 
              set { _Object = value; ObjectIsNull = false; } 
        } 
        public bool ObjectIsNull { get; set; }
        public string ObjectErrors { get; set; }
        
        public System.Byte[] TripleHash 
        { 
              get { return _TripleHash; } 
              set { _TripleHash = value; TripleHashIsNull = false; } 
        } 
        public bool TripleHashIsNull { get; set; }
        public string TripleHashErrors { get; set; }
        
        public double Weight 
        { 
              get { return _Weight; } 
              set { _Weight = value; WeightIsNull = false; } 
        } 
        public bool WeightIsNull { get; set; }
        public string WeightErrors { get; set; }
        
        public long Reitification 
        { 
              get { return _Reitification; } 
              set { _Reitification = value; ReitificationIsNull = false; } 
        } 
        public bool ReitificationIsNull { get; set; }
        public string ReitificationErrors { get; set; }
        
        public bool ObjectType 
        { 
              get { return _ObjectType; } 
              set { _ObjectType = value; ObjectTypeIsNull = false; } 
        } 
        public bool ObjectTypeIsNull { get; set; }
        public string ObjectTypeErrors { get; set; }
        public string ObjectTypeDesc { get { if (ObjectTypeIsNull){ return string.Empty; } else if (ObjectType){ return "Yes"; } else { return "No"; } } } 
        
        public int SortOrder 
        { 
              get { return _SortOrder; } 
              set { _SortOrder = value; SortOrderIsNull = false; } 
        } 
        public bool SortOrderIsNull { get; set; }
        public string SortOrderErrors { get; set; }
        
        public long ViewSecurityGroup 
        { 
              get { return _ViewSecurityGroup; } 
              set { _ViewSecurityGroup = value; ViewSecurityGroupIsNull = false; } 
        } 
        public bool ViewSecurityGroupIsNull { get; set; }
        public string ViewSecurityGroupErrors { get; set; }
        
        public long Graph 
        { 
              get { return _Graph; } 
              set { _Graph = value; GraphIsNull = false; } 
        } 
        public bool GraphIsNull { get; set; }
        public string GraphErrors { get; set; }
        public string AllErrors 
        { 
              get 
              { 
                  string returnString = string.Empty;
                  if (!TripleIDErrors.Equals(string.Empty))
                  { 
                      returnString += "TripleID: " + TripleIDErrors; 
                  } 
                  if (!SubjectErrors.Equals(string.Empty))
                  { 
                      returnString += "Subject: " + SubjectErrors; 
                  } 
                  if (!PredicateErrors.Equals(string.Empty))
                  { 
                      returnString += "Predicate: " + PredicateErrors; 
                  } 
                  if (!ObjectErrors.Equals(string.Empty))
                  { 
                      returnString += "Object: " + ObjectErrors; 
                  } 
                  if (!TripleHashErrors.Equals(string.Empty))
                  { 
                      returnString += "Triple Hash: " + TripleHashErrors; 
                  } 
                  if (!WeightErrors.Equals(string.Empty))
                  { 
                      returnString += "Weight: " + WeightErrors; 
                  } 
                  if (!ReitificationErrors.Equals(string.Empty))
                  { 
                      returnString += "Reitification: " + ReitificationErrors; 
                  } 
                  if (!ObjectTypeErrors.Equals(string.Empty))
                  { 
                      returnString += "Object Type: " + ObjectTypeErrors; 
                  } 
                  if (!SortOrderErrors.Equals(string.Empty))
                  { 
                      returnString += "Sort Order: " + SortOrderErrors; 
                  } 
                  if (!ViewSecurityGroupErrors.Equals(string.Empty))
                  { 
                      returnString += "View Security Group: " + ViewSecurityGroupErrors; 
                  } 
                  if (!GraphErrors.Equals(string.Empty))
                  { 
                      returnString += "Graph: " + GraphErrors; 
                  } 
                  return returnString; 
              } 
        } 
        public bool Equals(Triple left, Triple right)
        {
            if((object)left == null && (object)right == null)
            {
                return true;
            }
            if((object)left == null || (object)right == null)
            {
                return false;
            }
            return left.TripleID == right.TripleID;
        }
        public int GetHashCode(Triple obj)
        {
            return (obj.TripleID).GetHashCode();
        }
        public bool Equals(Triple other)
        {
            if (this.TripleID == other.TripleID )
                return true;

            return false;
        }
        public override int GetHashCode()
        {
            return TripleID.GetHashCode();
        }

        public BO.Interfaces.RDF.ITriple DBFields { get { return this; } } 
     
        # endregion // Public Properties 
     
        # region Protected Methods 
     
        protected override void InitializePropertiesCG()
        {
            TripleIDIsNull = true; 
            TripleIDErrors = string.Empty; 
            SubjectIsNull = true; 
            SubjectErrors = string.Empty; 
            PredicateIsNull = true; 
            PredicateErrors = string.Empty; 
            ObjectIsNull = true; 
            ObjectErrors = string.Empty; 
            TripleHashIsNull = true; 
            TripleHashErrors = string.Empty; 
            WeightIsNull = true; 
            WeightErrors = string.Empty; 
            ReitificationIsNull = true; 
            ReitificationErrors = string.Empty; 
            ObjectTypeIsNull = true; 
            ObjectTypeErrors = string.Empty; 
            SortOrderIsNull = true; 
            SortOrderErrors = string.Empty; 
            ViewSecurityGroupIsNull = true; 
            ViewSecurityGroupErrors = string.Empty; 
            GraphIsNull = true; 
            GraphErrors = string.Empty; 
            InitializeProperties(); 
        }
     
        # endregion // Protected Methods 
 
        # region Enums 
 
 
        # endregion // Enums 
    } 
 
} 
