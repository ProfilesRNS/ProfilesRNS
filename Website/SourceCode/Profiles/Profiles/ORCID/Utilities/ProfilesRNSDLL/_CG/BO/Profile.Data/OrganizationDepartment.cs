using System;
using System.Collections.Generic;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.Profile.Data
{
    public partial class OrganizationDepartment : ProfilesRNSBaseClassBO, BO.Interfaces.Profile.Data.IOrganizationDepartment, IEqualityComparer<OrganizationDepartment>, IEquatable<OrganizationDepartment> 
    { 
        # region Private variables 
          /*! DepartmentID state (DepartmentID) */ 
          private int _DepartmentID;
          /*! DepartmentName state (Department Name) */ 
          private string _DepartmentName;
          /*! Visible state (Visible) */ 
          private bool _Visible;
        # endregion //Private variables 
     
        # region Public Properties 
     
        
        public int DepartmentID 
        { 
              get { return _DepartmentID; } 
              set { _DepartmentID = value; DepartmentIDIsNull = false; } 
        } 
        public bool DepartmentIDIsNull { get; set; }
        public string DepartmentIDErrors { get; set; }
        public string DepartmentIDText { get { if (DepartmentIDIsNull){ return string.Empty; } return DepartmentID.ToString(); } } 
        public override string IdentityValue { get { if (DepartmentIDIsNull){ return string.Empty; } return DepartmentID.ToString(); } } 
        public override bool IdentityIsNull { get { return DepartmentIDIsNull; } } 
        
        public string DepartmentName 
        { 
              get { return _DepartmentName; } 
              set { _DepartmentName = value; DepartmentNameIsNull = false; } 
        } 
        public bool DepartmentNameIsNull { get; set; }
        public string DepartmentNameErrors { get; set; }
        
        public bool Visible 
        { 
              get { return _Visible; } 
              set { _Visible = value; VisibleIsNull = false; } 
        } 
        public bool VisibleIsNull { get; set; }
        public string VisibleErrors { get; set; }
        public string VisibleDesc { get { if (VisibleIsNull){ return string.Empty; } else if (Visible){ return "Yes"; } else { return "No"; } } } 
        public string AllErrors 
        { 
              get 
              { 
                  string returnString = string.Empty;
                  if (!DepartmentIDErrors.Equals(string.Empty))
                  { 
                      returnString += "DepartmentID: " + DepartmentIDErrors; 
                  } 
                  if (!DepartmentNameErrors.Equals(string.Empty))
                  { 
                      returnString += "Department Name: " + DepartmentNameErrors; 
                  } 
                  if (!VisibleErrors.Equals(string.Empty))
                  { 
                      returnString += "Visible: " + VisibleErrors; 
                  } 
                  return returnString; 
              } 
        } 
        public bool Equals(OrganizationDepartment left, OrganizationDepartment right)
        {
            if((object)left == null && (object)right == null)
            {
                return true;
            }
            if((object)left == null || (object)right == null)
            {
                return false;
            }
            return left.DepartmentID == right.DepartmentID;
        }
        public int GetHashCode(OrganizationDepartment obj)
        {
            return (obj.DepartmentID).GetHashCode();
        }
        public bool Equals(OrganizationDepartment other)
        {
            if (this.DepartmentID == other.DepartmentID )
                return true;

            return false;
        }
        public override int GetHashCode()
        {
            return DepartmentID.GetHashCode();
        }

        public BO.Interfaces.Profile.Data.IOrganizationDepartment DBFields { get { return this; } } 
     
        # endregion // Public Properties 
     
        # region Protected Methods 
     
        protected override void InitializePropertiesCG()
        {
            DepartmentIDIsNull = true; 
            DepartmentIDErrors = string.Empty; 
            DepartmentNameIsNull = true; 
            DepartmentNameErrors = string.Empty; 
            VisibleIsNull = true; 
            VisibleErrors = string.Empty; 
            InitializeProperties(); 
        }
     
        # endregion // Protected Methods 
 
        # region Enums 
 
 
        # endregion // Enums 
    } 
 
} 
