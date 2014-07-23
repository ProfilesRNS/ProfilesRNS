using System; 
using System.Collections.Generic; 
using System.Text; 
using System.Runtime.Serialization; 
using System.ComponentModel; 
 
namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.RDF.Security
{ 
    public partial class Group : ProfilesRNSBaseClassBO, BO.Interfaces.RDF.Security.IGroup
    { 
        # region Private variables 
          /*! SecurityGroupID state (Security GroupID) */ 
          private long _SecurityGroupID;
          /*! Label state (Label) */ 
          private string _Label;
          /*! HasSpecialViewAccess state (Has Special View Access) */ 
          private bool _HasSpecialViewAccess;
          /*! HasSpecialEditAccess state (Has Special Edit Access) */ 
          private bool _HasSpecialEditAccess;
          /*! Description state (Description) */ 
          private string _Description;
          /*! DefaultORCIDDecisionID state (Default O R CID DecisionID) */ 
          private int _DefaultORCIDDecisionID;
        # endregion //Private variables 
     
        # region Public Properties 
     
        
        public long SecurityGroupID 
        { 
              get { return _SecurityGroupID; } 
              set { _SecurityGroupID = value; SecurityGroupIDIsNull = false; } 
        } 
        public bool SecurityGroupIDIsNull { get; set; }
        public string SecurityGroupIDErrors { get; set; }
        
        public string Label 
        { 
              get { return _Label; } 
              set { _Label = value; LabelIsNull = false; } 
        } 
        public bool LabelIsNull { get; set; }
        public string LabelErrors { get; set; }
        
        public bool HasSpecialViewAccess 
        { 
              get { return _HasSpecialViewAccess; } 
              set { _HasSpecialViewAccess = value; HasSpecialViewAccessIsNull = false; } 
        } 
        public bool HasSpecialViewAccessIsNull { get; set; }
        public string HasSpecialViewAccessErrors { get; set; }
        public string HasSpecialViewAccessDesc { get { if (HasSpecialViewAccessIsNull){ return string.Empty; } else if (HasSpecialViewAccess){ return "Yes"; } else { return "No"; } } } 
        
        public bool HasSpecialEditAccess 
        { 
              get { return _HasSpecialEditAccess; } 
              set { _HasSpecialEditAccess = value; HasSpecialEditAccessIsNull = false; } 
        } 
        public bool HasSpecialEditAccessIsNull { get; set; }
        public string HasSpecialEditAccessErrors { get; set; }
        public string HasSpecialEditAccessDesc { get { if (HasSpecialEditAccessIsNull){ return string.Empty; } else if (HasSpecialEditAccess){ return "Yes"; } else { return "No"; } } } 
        
        public string Description 
        { 
              get { return _Description; } 
              set { _Description = value; DescriptionIsNull = false; } 
        } 
        public bool DescriptionIsNull { get; set; }
        public string DescriptionErrors { get; set; }
        
        public int DefaultORCIDDecisionID 
        { 
              get { return _DefaultORCIDDecisionID; } 
              set { _DefaultORCIDDecisionID = value; DefaultORCIDDecisionIDIsNull = false; } 
        } 
        public bool DefaultORCIDDecisionIDIsNull { get; set; }
        public string DefaultORCIDDecisionIDErrors { get; set; }
        public override string IdentityValue { get { throw new Exception("This table does not have an identity."); } } 
        public override bool IdentityIsNull { get { throw new Exception("This table does not have an identity."); } } 
        public string AllErrors 
        { 
              get 
              { 
                  string returnString = string.Empty;
                  if (!SecurityGroupIDErrors.Equals(string.Empty))
                  { 
                      returnString += "Security GroupID: " + SecurityGroupIDErrors; 
                  } 
                  if (!LabelErrors.Equals(string.Empty))
                  { 
                      returnString += "Label: " + LabelErrors; 
                  } 
                  if (!HasSpecialViewAccessErrors.Equals(string.Empty))
                  { 
                      returnString += "Has Special View Access: " + HasSpecialViewAccessErrors; 
                  } 
                  if (!HasSpecialEditAccessErrors.Equals(string.Empty))
                  { 
                      returnString += "Has Special Edit Access: " + HasSpecialEditAccessErrors; 
                  } 
                  if (!DescriptionErrors.Equals(string.Empty))
                  { 
                      returnString += "Description: " + DescriptionErrors; 
                  } 
                  if (!DefaultORCIDDecisionIDErrors.Equals(string.Empty))
                  { 
                      returnString += "Default O R CID DecisionID: " + DefaultORCIDDecisionIDErrors; 
                  } 
                  return returnString; 
              } 
        } 
        public BO.Interfaces.RDF.Security.IGroup DBFields { get { return this; } } 
     
        # endregion // Public Properties 
     
        # region Protected Methods 
     
        protected override void InitializePropertiesCG()
        {
            SecurityGroupIDIsNull = true; 
            SecurityGroupIDErrors = string.Empty; 
            LabelIsNull = true; 
            LabelErrors = string.Empty; 
            HasSpecialViewAccessIsNull = true; 
            HasSpecialViewAccessErrors = string.Empty; 
            HasSpecialEditAccessIsNull = true; 
            HasSpecialEditAccessErrors = string.Empty; 
            DescriptionIsNull = true; 
            DescriptionErrors = string.Empty; 
            DefaultORCIDDecisionIDIsNull = true; 
            DefaultORCIDDecisionIDErrors = string.Empty; 
            InitializeProperties(); 
        }
     
        # endregion // Protected Methods 
 
        # region Enums 
 
        public enum Groups{
			[DescriptionAttribute("Admins")]
			Admins=-50
			,[DescriptionAttribute("Curators")]
			Curators=-40
			,[DescriptionAttribute("Harvesters")]
			Harvesters=-30
			,[DescriptionAttribute("Users")]
			Users=-20
			,[DescriptionAttribute("No Search")]
			No_Search=-10
			,[DescriptionAttribute("Public")]
			Public=-1
			,[DescriptionAttribute("Undefined")]
			Undefined=0
        }
 
        # endregion // Enums 
    } 
 
} 
