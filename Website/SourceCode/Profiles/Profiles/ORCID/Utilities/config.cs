using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Configuration;

namespace Profiles.ORCID.Utilities
{
    public class config
    {
        public static string PathToProfiles
        {
            get
            {
                return ConfigurationManager.AppSettings["ORCID.PathToProfiles"];
            }
        }
        public static string ClientID
        {
            get
            {
                return ConfigurationManager.AppSettings["ORCID.ClientID"];
            }
        }
        public static string ClientSecret
        {
            get
            {
                return ConfigurationManager.AppSettings["ORCID.ClientSecret"];
            }
        }
        public static string ORCID_API_URL
        {
            get
            {
                return ConfigurationManager.AppSettings["ORCID.ORCID_API_URL"];
            }
        }
        internal static string ORCID_API_URL_WITH_VERSION
        {
            get
            {
                return ORCID_API_URL + "/v" + MessageVersion;
            }
        }
        public static string ORCID_URL
        {
            get
            {
                return ConfigurationManager.AppSettings["ORCID.ORCID_URL"];
            }
        }
        public static string WebAppURL
        {
            get
            {
                return ConfigurationManager.AppSettings["ORCID.WebAppURL"];
            }
        }
        public static string OrganizationName
        {
            get
            {
                return ConfigurationManager.AppSettings["ORCID.OrganizationName"];
            }
        }
        public static string OrganizationNameShort
        {
            get
            {
                return ConfigurationManager.AppSettings["ORCID.OrganizationNameShort"];
            }
        }
        public static string OrganizationNameAorAN
        {
            get
            {
                return ConfigurationManager.AppSettings["ORCID.OrganizationNameAorAN"];
            }
        }
        public static string OrganizationNameEmailSuffix
        {
            get
            {
                return ConfigurationManager.AppSettings["ORCID.OrganizationNameEmailSuffix"];
            }
        }
        public static string ProductionURL
        {
            get
            {
                return ConfigurationManager.AppSettings["ORCID.ProductionURL"];
            }
        }
        public static string InfoSite
        {
            get
            {
                return ConfigurationManager.AppSettings["ORCID.InfoSite"];
            }
        }
        public static string MessageVersion
        {
            get
            {
                return ConfigurationManager.AppSettings["ORCID.MessageVersion"];
            }
        }
        public static int BatchCreateSize
        {
            get
            {
                return Convert.ToInt32(ConfigurationManager.AppSettings["ORCID.BatchCreateSize"]);
            }
        }
        public static bool UseMailinatorEmailAddressForTestingOnStagingEnvironment
        {
            get
            {
                return ConfigurationManager.AppSettings["ORCID.UseMailinatorEmailAddressForTestingOnStagingEnvironment"].Equals(1);
            }
        }
        public static bool RequireAcknowledgement
        {
            get
            {
                return ConfigurationManager.AppSettings["ORCID.RequireAcknowledgement"].Equals(1);
            }
        }
        public static string AcknowledgementInfoSiteText
        {
            get
            {
                return ConfigurationManager.AppSettings["ORCID.AcknowledgementInfoSiteText"];
            }
        }
        public static bool Enabled
        {
            get
            {
                return Convert.ToInt32(ConfigurationManager.AppSettings["ORCID.Enabled"]).Equals(1);
            }
        }
        public static bool ShowNoORCIDMessage
        {
            get
            {
                return Convert.ToInt32(ConfigurationManager.AppSettings["ORCID.ShowNoORCIDMessage"]).Equals(1);
            }
        }

    }
}