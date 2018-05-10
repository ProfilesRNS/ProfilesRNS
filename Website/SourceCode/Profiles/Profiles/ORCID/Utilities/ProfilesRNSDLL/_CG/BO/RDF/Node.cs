using System;
using System.Collections.Generic;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.RDF
{
    public partial class Node : ProfilesRNSBaseClassBO, BO.Interfaces.RDF.INode, IEqualityComparer<Node>, IEquatable<Node> 
    { 
        # region Private variables 
          /*! NodeID state (NodeID) */ 
          private long _NodeID;
          /*! ValueHash state (Value Hash) */ 
          private System.Byte[] _ValueHash;
          /*! Language state (Language) */ 
          private string _Language;
          /*! DataType state (Data Type) */ 
          private string _DataType;
          /*! Value state (Value) */ 
          private string _Value;
          /*! InternalNodeMapID state (Internal Node MapID) */ 
          private int _InternalNodeMapID;
          /*! ObjectType state (Object Type) */ 
          private bool _ObjectType;
          /*! ViewSecurityGroup state (View Security Group) */ 
          private long _ViewSecurityGroup;
          /*! EditSecurityGroup state (Edit Security Group) */ 
          private long _EditSecurityGroup;
        # endregion //Private variables 
     
        # region Public Properties 
     
        
        public long NodeID 
        { 
              get { return _NodeID; } 
              set { _NodeID = value; NodeIDIsNull = false; } 
        } 
        public bool NodeIDIsNull { get; set; }
        public string NodeIDErrors { get; set; }
        public string NodeIDText { get { if (NodeIDIsNull){ return string.Empty; } return NodeID.ToString(); } } 
        public override string IdentityValue { get { if (NodeIDIsNull){ return string.Empty; } return NodeID.ToString(); } } 
        public override bool IdentityIsNull { get { return NodeIDIsNull; } } 
        
        public System.Byte[] ValueHash 
        { 
              get { return _ValueHash; } 
              set { _ValueHash = value; ValueHashIsNull = false; } 
        } 
        public bool ValueHashIsNull { get; set; }
        public string ValueHashErrors { get; set; }
        
        public string Language 
        { 
              get { return _Language; } 
              set { _Language = value; LanguageIsNull = false; } 
        } 
        public bool LanguageIsNull { get; set; }
        public string LanguageErrors { get; set; }
        
        public string DataType 
        { 
              get { return _DataType; } 
              set { _DataType = value; DataTypeIsNull = false; } 
        } 
        public bool DataTypeIsNull { get; set; }
        public string DataTypeErrors { get; set; }
        
        public string Value 
        { 
              get { return _Value; } 
              set { _Value = value; ValueIsNull = false; } 
        } 
        public bool ValueIsNull { get; set; }
        public string ValueErrors { get; set; }
        
        public int InternalNodeMapID 
        { 
              get { return _InternalNodeMapID; } 
              set { _InternalNodeMapID = value; InternalNodeMapIDIsNull = false; } 
        } 
        public bool InternalNodeMapIDIsNull { get; set; }
        public string InternalNodeMapIDErrors { get; set; }
        
        public bool ObjectType 
        { 
              get { return _ObjectType; } 
              set { _ObjectType = value; ObjectTypeIsNull = false; } 
        } 
        public bool ObjectTypeIsNull { get; set; }
        public string ObjectTypeErrors { get; set; }
        public string ObjectTypeDesc { get { if (ObjectTypeIsNull){ return string.Empty; } else if (ObjectType){ return "Yes"; } else { return "No"; } } } 
        
        public long ViewSecurityGroup 
        { 
              get { return _ViewSecurityGroup; } 
              set { _ViewSecurityGroup = value; ViewSecurityGroupIsNull = false; } 
        } 
        public bool ViewSecurityGroupIsNull { get; set; }
        public string ViewSecurityGroupErrors { get; set; }
        
        public long EditSecurityGroup 
        { 
              get { return _EditSecurityGroup; } 
              set { _EditSecurityGroup = value; EditSecurityGroupIsNull = false; } 
        } 
        public bool EditSecurityGroupIsNull { get; set; }
        public string EditSecurityGroupErrors { get; set; }
        public string AllErrors 
        { 
              get 
              { 
                  string returnString = string.Empty;
                  if (!NodeIDErrors.Equals(string.Empty))
                  { 
                      returnString += "NodeID: " + NodeIDErrors; 
                  } 
                  if (!ValueHashErrors.Equals(string.Empty))
                  { 
                      returnString += "Value Hash: " + ValueHashErrors; 
                  } 
                  if (!LanguageErrors.Equals(string.Empty))
                  { 
                      returnString += "Language: " + LanguageErrors; 
                  } 
                  if (!DataTypeErrors.Equals(string.Empty))
                  { 
                      returnString += "Data Type: " + DataTypeErrors; 
                  } 
                  if (!ValueErrors.Equals(string.Empty))
                  { 
                      returnString += "Value: " + ValueErrors; 
                  } 
                  if (!InternalNodeMapIDErrors.Equals(string.Empty))
                  { 
                      returnString += "Internal Node MapID: " + InternalNodeMapIDErrors; 
                  } 
                  if (!ObjectTypeErrors.Equals(string.Empty))
                  { 
                      returnString += "Object Type: " + ObjectTypeErrors; 
                  } 
                  if (!ViewSecurityGroupErrors.Equals(string.Empty))
                  { 
                      returnString += "View Security Group: " + ViewSecurityGroupErrors; 
                  } 
                  if (!EditSecurityGroupErrors.Equals(string.Empty))
                  { 
                      returnString += "Edit Security Group: " + EditSecurityGroupErrors; 
                  } 
                  return returnString; 
              } 
        } 
        public bool Equals(Node left, Node right)
        {
            if((object)left == null && (object)right == null)
            {
                return true;
            }
            if((object)left == null || (object)right == null)
            {
                return false;
            }
            return left.NodeID == right.NodeID;
        }
        public int GetHashCode(Node obj)
        {
            return (obj.NodeID).GetHashCode();
        }
        public bool Equals(Node other)
        {
            if (this.NodeID == other.NodeID )
                return true;

            return false;
        }
        public override int GetHashCode()
        {
            return NodeID.GetHashCode();
        }

        public BO.Interfaces.RDF.INode DBFields { get { return this; } } 
     
        # endregion // Public Properties 
     
        # region Protected Methods 
     
        protected override void InitializePropertiesCG()
        {
            NodeIDIsNull = true; 
            NodeIDErrors = string.Empty; 
            ValueHashIsNull = true; 
            ValueHashErrors = string.Empty; 
            LanguageIsNull = true; 
            LanguageErrors = string.Empty; 
            DataTypeIsNull = true; 
            DataTypeErrors = string.Empty; 
            ValueIsNull = true; 
            ValueErrors = string.Empty; 
            InternalNodeMapIDIsNull = true; 
            InternalNodeMapIDErrors = string.Empty; 
            ObjectTypeIsNull = true; 
            ObjectTypeErrors = string.Empty; 
            ViewSecurityGroupIsNull = true; 
            ViewSecurityGroupErrors = string.Empty; 
            EditSecurityGroupIsNull = true; 
            EditSecurityGroupErrors = string.Empty; 
            InitializeProperties(); 
        }
     
        # endregion // Protected Methods 
 
        # region Enums 
 
 
        # endregion // Enums 
    } 
 
} 
