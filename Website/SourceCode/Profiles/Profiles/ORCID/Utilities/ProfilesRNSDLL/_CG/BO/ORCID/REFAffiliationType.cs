using System;
using System.ComponentModel;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID
{
    public partial class REFAffiliationType : ProfilesRNSBaseClassBO, BO.Interfaces.ORCID.IREFAffiliationType
    { 
        # region Private variables 
          /*! AffiliationTypeID state (Affiliation TypeID) */ 
          private int _AffiliationTypeID;
          /*! AffiliationType state (Affiliation Type) */ 
          private string _AffiliationType;
        # endregion //Private variables 
     
        # region Public Properties 
     
        
        public int AffiliationTypeID 
        { 
              get { return _AffiliationTypeID; } 
              set { _AffiliationTypeID = value; AffiliationTypeIDIsNull = false; } 
        } 
        public bool AffiliationTypeIDIsNull { get; set; }
        public string AffiliationTypeIDErrors { get; set; }
        
        public string AffiliationType 
        { 
              get { return _AffiliationType; } 
              set { _AffiliationType = value; AffiliationTypeIsNull = false; } 
        } 
        public bool AffiliationTypeIsNull { get; set; }
        public string AffiliationTypeErrors { get; set; }
        public override string IdentityValue { get { throw new Exception("This table does not have an identity."); } } 
        public override bool IdentityIsNull { get { throw new Exception("This table does not have an identity."); } } 
        public string AllErrors 
        { 
              get 
              { 
                  string returnString = string.Empty;
                  if (!AffiliationTypeIDErrors.Equals(string.Empty))
                  { 
                      returnString += "Affiliation TypeID: " + AffiliationTypeIDErrors; 
                  } 
                  if (!AffiliationTypeErrors.Equals(string.Empty))
                  { 
                      returnString += "Affiliation Type: " + AffiliationTypeErrors; 
                  } 
                  return returnString; 
              } 
        } 
        public BO.Interfaces.ORCID.IREFAffiliationType DBFields { get { return this; } } 
     
        # endregion // Public Properties 
     
        # region Protected Methods 
     
        protected override void InitializePropertiesCG()
        {
            AffiliationTypeIDIsNull = true; 
            AffiliationTypeIDErrors = string.Empty; 
            AffiliationTypeIsNull = true; 
            AffiliationTypeErrors = string.Empty; 
            InitializeProperties(); 
        }
     
        # endregion // Protected Methods 
 
        # region Enums 
 
        public enum REFAffiliationTypes{
			[DescriptionAttribute("education")]
			education=1
			,[DescriptionAttribute("employment")]
			employment=2
        }
 
        # endregion // Enums 
    } 
 
} 
