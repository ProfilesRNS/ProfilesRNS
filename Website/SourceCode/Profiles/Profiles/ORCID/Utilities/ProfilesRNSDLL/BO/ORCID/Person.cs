using System;
using System.Collections.Generic;
using System.Linq;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID
{
    public partial class Person
    {
        public List<BO.ORCID.PersonAlternateEmail> AlternateEmails { get; set; }
        public List<BO.ORCID.PersonWork> Works { get; set; }
        public List<BO.ORCID.PersonURL> URLs { get; set; }
        public List<BO.ORCID.PersonAffiliation> Affiliations { get; set; }
        public List<BO.ORCID.PersonOthername> Othernames { get; set; }
        public BO.ORCID.PersonMessage PersonMessage { get; set; }
        public string EmailDecision
        {
            get
            {
                if (Enum.IsDefined(typeof(BO.ORCID.REFDecision.REFDecisions), this.EmailDecisionID))
                {
                    return DevelopmentBase.Common.EnumDescription((BO.ORCID.REFDecision.REFDecisions)this.EmailDecisionID);
                }
                else
                {
                    return "";
                }
            }            
        }
        public string AlternateEmailDecision
        {
            get
            {
                if (Enum.IsDefined(typeof(BO.ORCID.REFDecision.REFDecisions), this.AlternateEmailDecisionID))
                {
                    return DevelopmentBase.Common.EnumDescription((BO.ORCID.REFDecision.REFDecisions)this.AlternateEmailDecisionID);
                }
                else
                {
                    return "";
                }
            }
        }
        public string BiographyDecision
        {
            get
            {
                if (Enum.IsDefined(typeof(BO.ORCID.REFDecision.REFDecisions), this.BiographyDecisionID))
                {
                    return DevelopmentBase.Common.EnumDescription((BO.ORCID.REFDecision.REFDecisions)this.BiographyDecisionID);
                }
                else
                {
                    return "";
                }
            }
        }
        public bool HasValidORCID
        {
            get
            {
                if (ORCID != null && ORCID.Length.Equals(19) && ORCID.Contains("-"))
                {
                    return true;
                }
                else
                {                    
                    return false;
                }
            }
        }
        public string ORCIDUrl
        {
            get
            { 
                if (HasValidORCID)
                {
                    return DevelopmentBase.Common.GetConfig("ORCID.ORCID_URL") + "/" + this.ORCID;
                }
                else
                {
                    return string.Empty;
                }
            }
        }
        public string DisplayName
        {
            get
            {
                if (!this.LastNameIsNull && !this.FirstNameIsNull)
                {
                    return LastName + ", " + FirstName;
                }
                else if (!this.LastNameIsNull)
                {
                    return LastName;
                }
                else if (!this.FirstNameIsNull)
                {
                    return FirstName;
                }
                else
                {
                    return "";
                }
            }
        }
        public string FullName
        {
            get
            {
                if (!this.LastNameIsNull && !this.FirstNameIsNull)
                {
                    return FirstName + " " + LastName;
                }
                else if (!this.LastNameIsNull)
                {
                    return LastName;
                }
                else if (!this.FirstNameIsNull)
                {
                    return FirstName;
                }
                else
                {
                    return "";
                }
            }
        }
        public bool PushBiographyToORCID { get; set; }
        public List<BO.ORCID.PersonWork> WorksToPush
        {
            get
            {
                if (Works != null)
                {
                    return (from a in Works where a.DecisionID != (int)BO.ORCID.REFDecision.REFDecisions.Exclude select a).ToList();
                }
                else
                {
                    return new List<PersonWork>();
                }
            }
        }
        public bool HasWorksToPush
        {
            get
            {
                return WorksToPush.Count > 0;
            }
        }
        public List<BO.ORCID.PersonAffiliation> AffiliationsToPush
        {
            get
            {
                if (Works != null)
                {
                    return (from a in Affiliations where a.DecisionID != (int)BO.ORCID.REFDecision.REFDecisions.Exclude 
                                && a.RoleTitleIsNull != true 
                                && a.OrganizationCityIsNull != true 
                                && a.OrganizationRegionIsNull != true 
                                && a.OrganizationCountryIsNull != true
                                select a).ToList();
                }
                else
                {
                    return new List<PersonAffiliation>();
                }
            }
        }
        public bool HasAffiliationsToPush
        {
            get
            {
                return AffiliationsToPush.Count > 0;
            }
        }
        public List<BO.ORCID.PersonURL> URLsToPush
        {
            get
            {
                if (URLs != null)
                {
                    return (from a in URLs where a.DecisionID != (int)BO.ORCID.REFDecision.REFDecisions.Exclude select a).ToList();
                }
                else
                {
                    return new List<PersonURL>();
                }
            }
        }
        public bool HasURLsToPush
        {
            get
            {
                return URLsToPush.Count > 0;
            }
        }

        protected override void InitializeProperties()
        {
            AlternateEmails = new List<BO.ORCID.PersonAlternateEmail>();
            Works = new List<BO.ORCID.PersonWork>();
            URLs = new List<BO.ORCID.PersonURL>();
            Affiliations = new List<PersonAffiliation>();
            Othernames = new List<PersonOthername>();
            this.PersonMessage = new BO.ORCID.PersonMessage();
        }
    }
}
