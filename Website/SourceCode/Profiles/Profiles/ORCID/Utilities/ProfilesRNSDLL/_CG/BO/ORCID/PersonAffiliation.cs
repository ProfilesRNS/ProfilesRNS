using System;
using System.Collections.Generic;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID
{
    public partial class PersonAffiliation : ProfilesRNSBaseClassBO, BO.Interfaces.ORCID.IPersonAffiliation, IEqualityComparer<PersonAffiliation>, IEquatable<PersonAffiliation> 
    { 
        # region Private variables 
          /*! PersonAffiliationID state (Person AffiliationID) */ 
          private int _PersonAffiliationID;
          /*! ProfilesID state (ProfilesID) */ 
          private int _ProfilesID;
          /*! AffiliationTypeID state (Affiliation TypeID) */ 
          private int _AffiliationTypeID;
          /*! PersonID state (PersonID) */ 
          private int _PersonID;
          /*! PersonMessageID state (Person MessageID) */ 
          private int _PersonMessageID;
          /*! DecisionID state (DecisionID) */ 
          private int _DecisionID;
          /*! DepartmentName state (Department Name) */ 
          private string _DepartmentName;
          /*! RoleTitle state (Role Title) */ 
          private string _RoleTitle;
          /*! StartDate state (Start Date) */ 
          private System.DateTime _StartDate;
          /*! EndDate state (End Date) */ 
          private System.DateTime _EndDate;
          /*! OrganizationName state (Organization Name) */ 
          private string _OrganizationName;
          /*! OrganizationCity state (Organization City) */ 
          private string _OrganizationCity;
          /*! OrganizationRegion state (Organization Region) */ 
          private string _OrganizationRegion;
          /*! OrganizationCountry state (Organization Country) */ 
          private string _OrganizationCountry;
          /*! DisambiguationID state (DisambiguationID) */ 
          private string _DisambiguationID;
          /*! DisambiguationSource state (Disambiguation Source) */ 
          private string _DisambiguationSource;
        # endregion //Private variables 
     
        # region Public Properties 
     
        
        public int PersonAffiliationID 
        { 
              get { return _PersonAffiliationID; } 
              set { _PersonAffiliationID = value; PersonAffiliationIDIsNull = false; } 
        } 
        public bool PersonAffiliationIDIsNull { get; set; }
        public string PersonAffiliationIDErrors { get; set; }
        public string PersonAffiliationIDText { get { if (PersonAffiliationIDIsNull){ return string.Empty; } return PersonAffiliationID.ToString(); } } 
        public override string IdentityValue { get { if (PersonAffiliationIDIsNull){ return string.Empty; } return PersonAffiliationID.ToString(); } } 
        public override bool IdentityIsNull { get { return PersonAffiliationIDIsNull; } } 
        
        public int ProfilesID 
        { 
              get { return _ProfilesID; } 
              set { _ProfilesID = value; ProfilesIDIsNull = false; } 
        } 
        public bool ProfilesIDIsNull { get; set; }
        public string ProfilesIDErrors { get; set; }
        
        public int AffiliationTypeID 
        { 
              get { return _AffiliationTypeID; } 
              set { _AffiliationTypeID = value; AffiliationTypeIDIsNull = false; } 
        } 
        public bool AffiliationTypeIDIsNull { get; set; }
        public string AffiliationTypeIDErrors { get; set; }
        
        public int PersonID 
        { 
              get { return _PersonID; } 
              set { _PersonID = value; PersonIDIsNull = false; } 
        } 
        public bool PersonIDIsNull { get; set; }
        public string PersonIDErrors { get; set; }
        
        public int PersonMessageID 
        { 
              get { return _PersonMessageID; } 
              set { _PersonMessageID = value; PersonMessageIDIsNull = false; } 
        } 
        public bool PersonMessageIDIsNull { get; set; }
        public string PersonMessageIDErrors { get; set; }
        
        public int DecisionID 
        { 
              get { return _DecisionID; } 
              set { _DecisionID = value; DecisionIDIsNull = false; } 
        } 
        public bool DecisionIDIsNull { get; set; }
        public string DecisionIDErrors { get; set; }
        
        public string DepartmentName 
        { 
              get { return _DepartmentName; } 
              set { _DepartmentName = value; DepartmentNameIsNull = false; } 
        } 
        public bool DepartmentNameIsNull { get; set; }
        public string DepartmentNameErrors { get; set; }
        
        public string RoleTitle 
        { 
              get { return _RoleTitle; } 
              set { _RoleTitle = value; RoleTitleIsNull = false; } 
        } 
        public bool RoleTitleIsNull { get; set; }
        public string RoleTitleErrors { get; set; }
        
        public System.DateTime StartDate 
        { 
              get { return _StartDate; } 
              set { _StartDate = value; StartDateIsNull = false; } 
        } 
        public bool StartDateIsNull { get; set; }
        public string StartDateErrors { get; set; }
        public string StartDateDesc { get { if (StartDateIsNull){ return string.Empty; } return StartDate.ToShortDateString(); } } 
        public string StartDateTime { get { if (StartDateIsNull){ return string.Empty; } return StartDate.ToShortTimeString(); } } 
        
        public System.DateTime EndDate 
        { 
              get { return _EndDate; } 
              set { _EndDate = value; EndDateIsNull = false; } 
        } 
        public bool EndDateIsNull { get; set; }
        public string EndDateErrors { get; set; }
        public string EndDateDesc { get { if (EndDateIsNull){ return string.Empty; } return EndDate.ToShortDateString(); } } 
        public string EndDateTime { get { if (EndDateIsNull){ return string.Empty; } return EndDate.ToShortTimeString(); } } 
        
        public string OrganizationName 
        { 
              get { return _OrganizationName; } 
              set { _OrganizationName = value; OrganizationNameIsNull = false; } 
        } 
        public bool OrganizationNameIsNull { get; set; }
        public string OrganizationNameErrors { get; set; }
        
        public string OrganizationCity 
        { 
              get { return _OrganizationCity; } 
              set { _OrganizationCity = value; OrganizationCityIsNull = false; } 
        } 
        public bool OrganizationCityIsNull { get; set; }
        public string OrganizationCityErrors { get; set; }
        
        public string OrganizationRegion 
        { 
              get { return _OrganizationRegion; } 
              set { _OrganizationRegion = value; OrganizationRegionIsNull = false; } 
        } 
        public bool OrganizationRegionIsNull { get; set; }
        public string OrganizationRegionErrors { get; set; }
        
        public string OrganizationCountry 
        { 
              get { return _OrganizationCountry; } 
              set { _OrganizationCountry = value; OrganizationCountryIsNull = false; } 
        } 
        public bool OrganizationCountryIsNull { get; set; }
        public string OrganizationCountryErrors { get; set; }
        
        public string DisambiguationID 
        { 
              get { return _DisambiguationID; } 
              set { _DisambiguationID = value; DisambiguationIDIsNull = false; } 
        } 
        public bool DisambiguationIDIsNull { get; set; }
        public string DisambiguationIDErrors { get; set; }
        
        public string DisambiguationSource 
        { 
              get { return _DisambiguationSource; } 
              set { _DisambiguationSource = value; DisambiguationSourceIsNull = false; } 
        } 
        public bool DisambiguationSourceIsNull { get; set; }
        public string DisambiguationSourceErrors { get; set; }
        public string AllErrors 
        { 
              get 
              { 
                  string returnString = string.Empty;
                  if (!PersonAffiliationIDErrors.Equals(string.Empty))
                  { 
                      returnString += "Person AffiliationID: " + PersonAffiliationIDErrors; 
                  } 
                  if (!ProfilesIDErrors.Equals(string.Empty))
                  { 
                      returnString += "ProfilesID: " + ProfilesIDErrors; 
                  } 
                  if (!AffiliationTypeIDErrors.Equals(string.Empty))
                  { 
                      returnString += "Affiliation TypeID: " + AffiliationTypeIDErrors; 
                  } 
                  if (!PersonIDErrors.Equals(string.Empty))
                  { 
                      returnString += "PersonID: " + PersonIDErrors; 
                  } 
                  if (!PersonMessageIDErrors.Equals(string.Empty))
                  { 
                      returnString += "Person MessageID: " + PersonMessageIDErrors; 
                  } 
                  if (!DecisionIDErrors.Equals(string.Empty))
                  { 
                      returnString += "DecisionID: " + DecisionIDErrors; 
                  } 
                  if (!DepartmentNameErrors.Equals(string.Empty))
                  { 
                      returnString += "Department Name: " + DepartmentNameErrors; 
                  } 
                  if (!RoleTitleErrors.Equals(string.Empty))
                  { 
                      returnString += "Role Title: " + RoleTitleErrors; 
                  } 
                  if (!StartDateErrors.Equals(string.Empty))
                  { 
                      returnString += "Start Date: " + StartDateErrors; 
                  } 
                  if (!EndDateErrors.Equals(string.Empty))
                  { 
                      returnString += "End Date: " + EndDateErrors; 
                  } 
                  if (!OrganizationNameErrors.Equals(string.Empty))
                  { 
                      returnString += "Organization Name: " + OrganizationNameErrors; 
                  } 
                  if (!OrganizationCityErrors.Equals(string.Empty))
                  { 
                      returnString += "Organization City: " + OrganizationCityErrors; 
                  } 
                  if (!OrganizationRegionErrors.Equals(string.Empty))
                  { 
                      returnString += "Organization Region: " + OrganizationRegionErrors; 
                  } 
                  if (!OrganizationCountryErrors.Equals(string.Empty))
                  { 
                      returnString += "Organization Country: " + OrganizationCountryErrors; 
                  } 
                  if (!DisambiguationIDErrors.Equals(string.Empty))
                  { 
                      returnString += "DisambiguationID: " + DisambiguationIDErrors; 
                  } 
                  if (!DisambiguationSourceErrors.Equals(string.Empty))
                  { 
                      returnString += "Disambiguation Source: " + DisambiguationSourceErrors; 
                  } 
                  return returnString; 
              } 
        } 
        public string AffiliationType {
            get {
                if (Enum.IsDefined(typeof(BO.ORCID.REFAffiliationType.REFAffiliationTypes), this.AffiliationTypeID)) {
                    return DevelopmentBase.Common.EnumDescription((BO.ORCID.REFAffiliationType.REFAffiliationTypes)this.AffiliationTypeID);
                } else {
                    return "";
                }
            }
            set {
            }
        }
        public string Decision {
            get {
                if (Enum.IsDefined(typeof(BO.ORCID.REFDecision.REFDecisions), this.DecisionID)) {
                    return DevelopmentBase.Common.EnumDescription((BO.ORCID.REFDecision.REFDecisions)this.DecisionID);
                } else {
                    return "";
                }
            }
            set {
            }
        }
        public bool Equals(PersonAffiliation left, PersonAffiliation right)
        {
            if((object)left == null && (object)right == null)
            {
                return true;
            }
            if((object)left == null || (object)right == null)
            {
                return false;
            }
            return left.PersonAffiliationID == right.PersonAffiliationID;
        }
        public int GetHashCode(PersonAffiliation obj)
        {
            return (obj.PersonAffiliationID).GetHashCode();
        }
        public bool Equals(PersonAffiliation other)
        {
            if (this.PersonAffiliationID == other.PersonAffiliationID )
                return true;

            return false;
        }
        public override int GetHashCode()
        {
            return PersonAffiliationID.GetHashCode();
        }

        public BO.Interfaces.ORCID.IPersonAffiliation DBFields { get { return this; } } 
     
        # endregion // Public Properties 
     
        # region Protected Methods 
     
        protected override void InitializePropertiesCG()
        {
            PersonAffiliationIDIsNull = true; 
            PersonAffiliationIDErrors = string.Empty; 
            ProfilesIDIsNull = true; 
            ProfilesIDErrors = string.Empty; 
            AffiliationTypeIDIsNull = true; 
            AffiliationTypeIDErrors = string.Empty; 
            PersonIDIsNull = true; 
            PersonIDErrors = string.Empty; 
            PersonMessageIDIsNull = true; 
            PersonMessageIDErrors = string.Empty; 
            DecisionIDIsNull = true; 
            DecisionIDErrors = string.Empty; 
            DepartmentNameIsNull = true; 
            DepartmentNameErrors = string.Empty; 
            RoleTitleIsNull = true; 
            RoleTitleErrors = string.Empty; 
            StartDateIsNull = true; 
            StartDateErrors = string.Empty; 
            EndDateIsNull = true; 
            EndDateErrors = string.Empty; 
            OrganizationNameIsNull = true; 
            OrganizationNameErrors = string.Empty; 
            OrganizationCityIsNull = true; 
            OrganizationCityErrors = string.Empty; 
            OrganizationRegionIsNull = true; 
            OrganizationRegionErrors = string.Empty; 
            OrganizationCountryIsNull = true; 
            OrganizationCountryErrors = string.Empty; 
            DisambiguationIDIsNull = true; 
            DisambiguationIDErrors = string.Empty; 
            DisambiguationSourceIsNull = true; 
            DisambiguationSourceErrors = string.Empty; 
            InitializeProperties(); 
        }
     
        # endregion // Protected Methods 
 
        # region Enums 
 
 
        # endregion // Enums 
    } 
 
} 
