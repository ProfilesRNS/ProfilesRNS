using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID
{
    public class Config
    {
/*        public static string PathToProfiles 
        {
            get
            {
                return ProfilesRNSDLL.DevelopmentBase.Common.GetConfig("ORCID.PathToProfiles");
            }
        }*/
        public static string ClientID 
        {
            get
            {
                return ProfilesRNSDLL.DevelopmentBase.Common.GetConfig("ORCID.ClientID");
            }
        }
        public static string ClientSecret 
        {
            get
            {
                return ProfilesRNSDLL.DevelopmentBase.Common.GetConfig("ORCID.ClientSecret");
            }
        }
        public static string ORCID_API_URL
        {
            get
            {
                return ProfilesRNSDLL.DevelopmentBase.Common.GetConfig("ORCID.ORCID_API_URL");
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
                return ProfilesRNSDLL.DevelopmentBase.Common.GetConfig("ORCID.ORCID_URL");
            }
        }
        public static string WebAppURL
        {
            get
            {
                return ProfilesRNSDLL.DevelopmentBase.Common.GetConfig("ORCID.WebAppURL");
            }
        }
        public static string OrganizationName
        {
            get
            {
                return ProfilesRNSDLL.DevelopmentBase.Common.GetConfig("ORCID.OrganizationName");
            }
        }
        public static string OrganizationNameShort
        {
            get
            {
                return ProfilesRNSDLL.DevelopmentBase.Common.GetConfig("ORCID.OrganizationNameShort");
            }
        }
        public static string OrganizationNameAorAN
        {
            get
            {
                return ProfilesRNSDLL.DevelopmentBase.Common.GetConfig("ORCID.OrganizationNameAorAN");
            }
        }
        public static string OrganizationNameEmailSuffix
        {
            get
            {
                return ProfilesRNSDLL.DevelopmentBase.Common.GetConfig("ORCID.OrganizationNameEmailSuffix");
            }
        }
        public static string ProductionURL
        {
            get
            {
                return ProfilesRNSDLL.DevelopmentBase.Common.GetConfig("ORCID.ProductionURL");
            }
        }
        public static string InfoSite
        {
            get
            {
                return ProfilesRNSDLL.DevelopmentBase.Common.GetConfig("ORCID.InfoSite");
            }
        }
        public static string MessageVersion
        {
            get
            {
                return ProfilesRNSDLL.DevelopmentBase.Common.GetConfig("ORCID.MessageVersion");
            }
        }
        public static int BatchCreateSize
        {
            get
            {
                return ProfilesRNSDLL.DevelopmentBase.Common.GetConfigInt("ORCID.BatchCreateSize");
            }
        }
        public static bool UseMailinatorEmailAddressForTestingOnStagingEnvironment
        {
            get
            {
                return ProfilesRNSDLL.DevelopmentBase.Common.GetConfigInt("ORCID.UseMailinatorEmailAddressForTestingOnStagingEnvironment").Equals(1);
            }
        }        
        public static bool RequireAcknowledgement
        {
            get
            {
                return ProfilesRNSDLL.DevelopmentBase.Common.GetConfigInt("ORCID.RequireAcknowledgement").Equals(1);
            }
        }
    }
}
