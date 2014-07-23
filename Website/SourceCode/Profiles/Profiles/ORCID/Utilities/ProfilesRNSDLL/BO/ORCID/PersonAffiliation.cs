using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID
{
    public partial class PersonAffiliation
    {
        public string DescriptionHTML
        {
            get
            {
                return Description.Replace(Environment.NewLine, "<br />");
            }
        }
        public string Address
        {
            get
            {
                string address = string.Empty;
                if (!OrganizationCityIsNull && !string.IsNullOrEmpty(OrganizationCity))
                {
                    address = this.OrganizationCity;
                }
                if (!OrganizationRegionIsNull && !string.IsNullOrEmpty(OrganizationRegion))
                {
                    DevelopmentBase.Helpers.StringMethods.AddString(ref address, this.OrganizationRegion, ", ");
                }
                if (!OrganizationCountryIsNull && !string.IsNullOrEmpty(OrganizationCountry))
                {
                    DevelopmentBase.Helpers.StringMethods.AddString(ref address, this.OrganizationCountry, ", ");
                }
                return address;
            }
        }

        public string AffiliationTypeCapitalized
        {
            get
            {
                return AffiliationType.Substring(0, 1).ToUpper() + AffiliationType.Substring(1, AffiliationType.Length-1).ToLower();
            }
        }

        private string Description
        {
            get {
                string affiliationDescription = this.RoleTitle + Environment.NewLine;
                if (!string.IsNullOrEmpty(Period))
                {
                    affiliationDescription += this.Period + Environment.NewLine;
                }
                affiliationDescription += this.OrganizationName + Environment.NewLine;
                if (!DepartmentNameIsNull && !string.IsNullOrEmpty(DepartmentName))
                {
                    affiliationDescription += this.DepartmentName + Environment.NewLine;
                }
                if (!string.IsNullOrEmpty(Address))
                {
                    affiliationDescription += Address;
                }
                return affiliationDescription;
            }
        }
        
        private string Period
        {
            get
            {
                if (!this.StartDateIsNull && !this.EndDateIsNull)
                {
                    return StartDate.ToString("M/yyyy") + " - " + EndDate.ToString("M/yyyy");
                }
                else if (!this.StartDateIsNull)
                {
                    return StartDate.ToString("M/yyyy");
                }
                else if (!this.EndDateIsNull)
                {
                    return EndDate.ToString("M/yyyy");
                }
                else
                {
                    return string.Empty;
                }
            }
        }
    }
}
