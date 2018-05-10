using System;
using System.Collections.Generic;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID
{
    public partial class PersonWork : ProfilesRNSBaseClassBO, BO.Interfaces.ORCID.IPersonWork, IEqualityComparer<PersonWork>, IEquatable<PersonWork> 
    { 
        # region Private variables 
          /*! PersonWorkID state (Person WorkID) */ 
          private int _PersonWorkID;
          /*! PersonID state (PersonID) */ 
          private int _PersonID;
          /*! PersonMessageID state (Person MessageID) */ 
          private int _PersonMessageID;
          /*! DecisionID state (DecisionID) */ 
          private int _DecisionID;
          /*! WorkTitle state (Work Title) */ 
          private string _WorkTitle;
          /*! ShortDescription state (Short Description) */ 
          private string _ShortDescription;
          /*! WorkCitation state (Work Citation) */ 
          private string _WorkCitation;
          /*! WorkType state (Work Type) */ 
          private string _WorkType;
          /*! URL state (URL) */ 
          private string _URL;
          /*! SubTitle state (Sub Title) */ 
          private string _SubTitle;
          /*! WorkCitationType state (Work Citation Type) */ 
          private string _WorkCitationType;
          /*! PubDate state (Pub Date) */ 
          private System.DateTime _PubDate;
          /*! PublicationMediaType state (Publication Media Type) */ 
          private string _PublicationMediaType;
          /*! PubID state (PubID) */ 
          private string _PubID;
        # endregion //Private variables 
     
        # region Public Properties 
     
        
        public int PersonWorkID 
        { 
              get { return _PersonWorkID; } 
              set { _PersonWorkID = value; PersonWorkIDIsNull = false; } 
        } 
        public bool PersonWorkIDIsNull { get; set; }
        public string PersonWorkIDErrors { get; set; }
        public string PersonWorkIDText { get { if (PersonWorkIDIsNull){ return string.Empty; } return PersonWorkID.ToString(); } } 
        public override string IdentityValue { get { if (PersonWorkIDIsNull){ return string.Empty; } return PersonWorkID.ToString(); } } 
        public override bool IdentityIsNull { get { return PersonWorkIDIsNull; } } 
        
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
        
        public string WorkTitle 
        { 
              get { return _WorkTitle; } 
              set { _WorkTitle = value; WorkTitleIsNull = false; } 
        } 
        public bool WorkTitleIsNull { get; set; }
        public string WorkTitleErrors { get; set; }
        
        public string ShortDescription 
        { 
              get { return _ShortDescription; } 
              set { _ShortDescription = value; ShortDescriptionIsNull = false; } 
        } 
        public bool ShortDescriptionIsNull { get; set; }
        public string ShortDescriptionErrors { get; set; }
        
        public string WorkCitation 
        { 
              get { return _WorkCitation; } 
              set { _WorkCitation = value; WorkCitationIsNull = false; } 
        } 
        public bool WorkCitationIsNull { get; set; }
        public string WorkCitationErrors { get; set; }
        
        public string WorkType 
        { 
              get { return _WorkType; } 
              set { _WorkType = value; WorkTypeIsNull = false; } 
        } 
        public bool WorkTypeIsNull { get; set; }
        public string WorkTypeErrors { get; set; }
        
        public string URL 
        { 
              get { return _URL; } 
              set { _URL = value; URLIsNull = false; } 
        } 
        public bool URLIsNull { get; set; }
        public string URLErrors { get; set; }
        
        public string SubTitle 
        { 
              get { return _SubTitle; } 
              set { _SubTitle = value; SubTitleIsNull = false; } 
        } 
        public bool SubTitleIsNull { get; set; }
        public string SubTitleErrors { get; set; }
        
        public string WorkCitationType 
        { 
              get { return _WorkCitationType; } 
              set { _WorkCitationType = value; WorkCitationTypeIsNull = false; } 
        } 
        public bool WorkCitationTypeIsNull { get; set; }
        public string WorkCitationTypeErrors { get; set; }
        
        public System.DateTime PubDate 
        { 
              get { return _PubDate; } 
              set { _PubDate = value; PubDateIsNull = false; } 
        } 
        public bool PubDateIsNull { get; set; }
        public string PubDateErrors { get; set; }
        public string PubDateDesc { get { if (PubDateIsNull){ return string.Empty; } return PubDate.ToShortDateString(); } } 
        public string PubDateTime { get { if (PubDateIsNull){ return string.Empty; } return PubDate.ToShortTimeString(); } } 
        
        public string PublicationMediaType 
        { 
              get { return _PublicationMediaType; } 
              set { _PublicationMediaType = value; PublicationMediaTypeIsNull = false; } 
        } 
        public bool PublicationMediaTypeIsNull { get; set; }
        public string PublicationMediaTypeErrors { get; set; }
        
        public string PubID 
        { 
              get { return _PubID; } 
              set { _PubID = value; PubIDIsNull = false; } 
        } 
        public bool PubIDIsNull { get; set; }
        public string PubIDErrors { get; set; }
        public string AllErrors 
        { 
              get 
              { 
                  string returnString = string.Empty;
                  if (!PersonWorkIDErrors.Equals(string.Empty))
                  { 
                      returnString += "Person WorkID: " + PersonWorkIDErrors; 
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
                  if (!WorkTitleErrors.Equals(string.Empty))
                  { 
                      returnString += "Work Title: " + WorkTitleErrors; 
                  } 
                  if (!ShortDescriptionErrors.Equals(string.Empty))
                  { 
                      returnString += "Short Description: " + ShortDescriptionErrors; 
                  } 
                  if (!WorkCitationErrors.Equals(string.Empty))
                  { 
                      returnString += "Work Citation: " + WorkCitationErrors; 
                  } 
                  if (!WorkTypeErrors.Equals(string.Empty))
                  { 
                      returnString += "Work Type: " + WorkTypeErrors; 
                  } 
                  if (!URLErrors.Equals(string.Empty))
                  { 
                      returnString += "URL: " + URLErrors; 
                  } 
                  if (!SubTitleErrors.Equals(string.Empty))
                  { 
                      returnString += "Sub Title: " + SubTitleErrors; 
                  } 
                  if (!WorkCitationTypeErrors.Equals(string.Empty))
                  { 
                      returnString += "Work Citation Type: " + WorkCitationTypeErrors; 
                  } 
                  if (!PubDateErrors.Equals(string.Empty))
                  { 
                      returnString += "Pub Date: " + PubDateErrors; 
                  } 
                  if (!PublicationMediaTypeErrors.Equals(string.Empty))
                  { 
                      returnString += "Publication Media Type: " + PublicationMediaTypeErrors; 
                  } 
                  if (!PubIDErrors.Equals(string.Empty))
                  { 
                      returnString += "PubID: " + PubIDErrors; 
                  } 
                  return returnString; 
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
        public bool Equals(PersonWork left, PersonWork right)
        {
            if((object)left == null && (object)right == null)
            {
                return true;
            }
            if((object)left == null || (object)right == null)
            {
                return false;
            }
            return left.PersonWorkID == right.PersonWorkID;
        }
        public int GetHashCode(PersonWork obj)
        {
            return (obj.PersonWorkID).GetHashCode();
        }
        public bool Equals(PersonWork other)
        {
            if (this.PersonWorkID == other.PersonWorkID )
                return true;

            return false;
        }
        public override int GetHashCode()
        {
            return PersonWorkID.GetHashCode();
        }

        public BO.Interfaces.ORCID.IPersonWork DBFields { get { return this; } } 
     
        # endregion // Public Properties 
     
        # region Protected Methods 
     
        protected override void InitializePropertiesCG()
        {
            PersonWorkIDIsNull = true; 
            PersonWorkIDErrors = string.Empty; 
            PersonIDIsNull = true; 
            PersonIDErrors = string.Empty; 
            PersonMessageIDIsNull = true; 
            PersonMessageIDErrors = string.Empty; 
            DecisionIDIsNull = true; 
            DecisionIDErrors = string.Empty; 
            WorkTitleIsNull = true; 
            WorkTitleErrors = string.Empty; 
            ShortDescriptionIsNull = true; 
            ShortDescriptionErrors = string.Empty; 
            WorkCitationIsNull = true; 
            WorkCitationErrors = string.Empty; 
            WorkTypeIsNull = true; 
            WorkTypeErrors = string.Empty; 
            URLIsNull = true; 
            URLErrors = string.Empty; 
            SubTitleIsNull = true; 
            SubTitleErrors = string.Empty; 
            WorkCitationTypeIsNull = true; 
            WorkCitationTypeErrors = string.Empty; 
            PubDateIsNull = true; 
            PubDateErrors = string.Empty; 
            PublicationMediaTypeIsNull = true; 
            PublicationMediaTypeErrors = string.Empty; 
            PubIDIsNull = true; 
            PubIDErrors = string.Empty; 
            InitializeProperties(); 
        }
     
        # endregion // Protected Methods 
 
        # region Enums 
 
 
        # endregion // Enums 
    } 
 
} 
