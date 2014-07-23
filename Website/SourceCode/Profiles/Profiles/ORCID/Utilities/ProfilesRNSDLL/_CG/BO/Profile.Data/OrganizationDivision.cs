using System; 
using System.Collections.Generic; 
using System.Text; 
using System.Runtime.Serialization; 
using System.ComponentModel; 
 
namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.Profile.Data
{ 
    public partial class OrganizationDivision : ProfilesRNSBaseClassBO, BO.Interfaces.Profile.Data.IOrganizationDivision, IEqualityComparer<OrganizationDivision>, IEquatable<OrganizationDivision> 
    { 
        # region Private variables 
          /*! DivisionID state (DivisionID) */ 
          private int _DivisionID;
          /*! DivisionName state (Division Name) */ 
          private string _DivisionName;
        # endregion //Private variables 
     
        # region Public Properties 
     
        
        public int DivisionID 
        { 
              get { return _DivisionID; } 
              set { _DivisionID = value; DivisionIDIsNull = false; } 
        } 
        public bool DivisionIDIsNull { get; set; }
        public string DivisionIDErrors { get; set; }
        public string DivisionIDText { get { if (DivisionIDIsNull){ return string.Empty; } return DivisionID.ToString(); } } 
        public override string IdentityValue { get { if (DivisionIDIsNull){ return string.Empty; } return DivisionID.ToString(); } } 
        public override bool IdentityIsNull { get { return DivisionIDIsNull; } } 
        
        public string DivisionName 
        { 
              get { return _DivisionName; } 
              set { _DivisionName = value; DivisionNameIsNull = false; } 
        } 
        public bool DivisionNameIsNull { get; set; }
        public string DivisionNameErrors { get; set; }
        public string AllErrors 
        { 
              get 
              { 
                  string returnString = string.Empty;
                  if (!DivisionIDErrors.Equals(string.Empty))
                  { 
                      returnString += "DivisionID: " + DivisionIDErrors; 
                  } 
                  if (!DivisionNameErrors.Equals(string.Empty))
                  { 
                      returnString += "Division Name: " + DivisionNameErrors; 
                  } 
                  return returnString; 
              } 
        } 
        public bool Equals(OrganizationDivision left, OrganizationDivision right)
        {
            if((object)left == null && (object)right == null)
            {
                return true;
            }
            if((object)left == null || (object)right == null)
            {
                return false;
            }
            return left.DivisionID == right.DivisionID;
        }
        public int GetHashCode(OrganizationDivision obj)
        {
            return (obj.DivisionID).GetHashCode();
        }
        public bool Equals(OrganizationDivision other)
        {
            if (this.DivisionID == other.DivisionID )
                return true;

            return false;
        }
        public override int GetHashCode()
        {
            return DivisionID.GetHashCode();
        }

        public BO.Interfaces.Profile.Data.IOrganizationDivision DBFields { get { return this; } } 
     
        # endregion // Public Properties 
     
        # region Protected Methods 
     
        protected override void InitializePropertiesCG()
        {
            DivisionIDIsNull = true; 
            DivisionIDErrors = string.Empty; 
            DivisionNameIsNull = true; 
            DivisionNameErrors = string.Empty; 
            InitializeProperties(); 
        }
     
        # endregion // Protected Methods 
 
        # region Enums 
 
 
        # endregion // Enums 
    } 
 
} 
