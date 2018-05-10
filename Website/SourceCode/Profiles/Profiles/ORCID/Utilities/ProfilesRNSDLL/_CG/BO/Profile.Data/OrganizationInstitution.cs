using System;
using System.Collections.Generic;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.Profile.Data
{
    public partial class OrganizationInstitution : ProfilesRNSBaseClassBO, BO.Interfaces.Profile.Data.IOrganizationInstitution, IEqualityComparer<OrganizationInstitution>, IEquatable<OrganizationInstitution> 
    { 
        # region Private variables 
          /*! InstitutionID state (InstitutionID) */ 
          private int _InstitutionID;
          /*! InstitutionName state (Institution Name) */ 
          private string _InstitutionName;
          /*! InstitutionAbbreviation state (Institution Abbreviation) */ 
          private string _InstitutionAbbreviation;
          /*! City state (City) */ 
  //        private string _City;
          /*! State state (State) */ 
  //        private string _State;
          /*! Country state (Country) */ 
  //        private string _Country;
          /*! RingGoldID state (Ring GoldID) */ 
  //        private string _RingGoldID;
        # endregion //Private variables 
     
        # region Public Properties 
     
        
        public int InstitutionID 
        { 
              get { return _InstitutionID; } 
              set { _InstitutionID = value; InstitutionIDIsNull = false; } 
        } 
        public bool InstitutionIDIsNull { get; set; }
        public string InstitutionIDErrors { get; set; }
        public string InstitutionIDText { get { if (InstitutionIDIsNull){ return string.Empty; } return InstitutionID.ToString(); } } 
        public override string IdentityValue { get { if (InstitutionIDIsNull){ return string.Empty; } return InstitutionID.ToString(); } } 
        public override bool IdentityIsNull { get { return InstitutionIDIsNull; } } 
        
        public string InstitutionName 
        { 
              get { return _InstitutionName; } 
              set { _InstitutionName = value; InstitutionNameIsNull = false; } 
        } 
        public bool InstitutionNameIsNull { get; set; }
        public string InstitutionNameErrors { get; set; }
        
        public string InstitutionAbbreviation 
        { 
              get { return _InstitutionAbbreviation; } 
              set { _InstitutionAbbreviation = value; InstitutionAbbreviationIsNull = false; } 
        } 
        public bool InstitutionAbbreviationIsNull { get; set; }
        public string InstitutionAbbreviationErrors { get; set; }
 /*       
        public string City 
        { 
              get { return _City; } 
              set { _City = value; CityIsNull = false; } 
        } 
        public bool CityIsNull { get; set; }
        public string CityErrors { get; set; }
        
        public string State 
        { 
              get { return _State; } 
              set { _State = value; StateIsNull = false; } 
        } 
        public bool StateIsNull { get; set; }
        public string StateErrors { get; set; }
        
        public string Country 
        { 
              get { return _Country; } 
              set { _Country = value; CountryIsNull = false; } 
        } 
        public bool CountryIsNull { get; set; }
        public string CountryErrors { get; set; }
        
        public string RingGoldID 
        { 
              get { return _RingGoldID; } 
              set { _RingGoldID = value; RingGoldIDIsNull = false; } 
        } 
        public bool RingGoldIDIsNull { get; set; }
        public string RingGoldIDErrors { get; set; }
   */     public string AllErrors 
        { 
              get 
              { 
                  string returnString = string.Empty;
                  if (!InstitutionIDErrors.Equals(string.Empty))
                  { 
                      returnString += "InstitutionID: " + InstitutionIDErrors; 
                  } 
                  if (!InstitutionNameErrors.Equals(string.Empty))
                  { 
                      returnString += "Institution Name: " + InstitutionNameErrors; 
                  } 
                  if (!InstitutionAbbreviationErrors.Equals(string.Empty))
                  { 
                      returnString += "Institution Abbreviation: " + InstitutionAbbreviationErrors; 
                  } 
  /*                if (!CityErrors.Equals(string.Empty))
                  { 
                      returnString += "City: " + CityErrors; 
                  } 
                  if (!StateErrors.Equals(string.Empty))
                  { 
                      returnString += "State: " + StateErrors; 
                  } 
                  if (!CountryErrors.Equals(string.Empty))
                  { 
                      returnString += "Country: " + CountryErrors; 
                  } 
                  if (!RingGoldIDErrors.Equals(string.Empty))
                  { 
                      returnString += "Ring GoldID: " + RingGoldIDErrors; 
                  } 
    */              return returnString; 
              } 
        } 
        public bool Equals(OrganizationInstitution left, OrganizationInstitution right)
        {
            if((object)left == null && (object)right == null)
            {
                return true;
            }
            if((object)left == null || (object)right == null)
            {
                return false;
            }
            return left.InstitutionID == right.InstitutionID;
        }
        public int GetHashCode(OrganizationInstitution obj)
        {
            return (obj.InstitutionID).GetHashCode();
        }
        public bool Equals(OrganizationInstitution other)
        {
            if (this.InstitutionID == other.InstitutionID )
                return true;

            return false;
        }
        public override int GetHashCode()
        {
            return InstitutionID.GetHashCode();
        }

        public BO.Interfaces.Profile.Data.IOrganizationInstitution DBFields { get { return this; } } 
     
        # endregion // Public Properties 
     
        # region Protected Methods 
     
        protected override void InitializePropertiesCG()
        {
            InstitutionIDIsNull = true; 
            InstitutionIDErrors = string.Empty; 
            InstitutionNameIsNull = true; 
            InstitutionNameErrors = string.Empty; 
            InstitutionAbbreviationIsNull = true; 
            InstitutionAbbreviationErrors = string.Empty; 
/*            CityIsNull = true; 
            CityErrors = string.Empty; 
            StateIsNull = true; 
            StateErrors = string.Empty; 
            CountryIsNull = true; 
            CountryErrors = string.Empty; 
            RingGoldIDIsNull = true; 
            RingGoldIDErrors = string.Empty; 
  */          InitializeProperties(); 
        }
     
        # endregion // Protected Methods 
 
        # region Enums 
 
 
        # endregion // Enums 
    } 
 
} 
