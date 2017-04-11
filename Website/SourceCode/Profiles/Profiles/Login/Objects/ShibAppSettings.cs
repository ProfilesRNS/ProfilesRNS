using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;

namespace Profiles.Login.Objects
{
    public class ShibAppSettings
    {
        /* App Settings Constants */
        private const string APP_SETTING_SHIB_IDENTITY_PROVIDER = "Shibboleth.ShibIdentityProvider";
        private const string APP_SETTING_SHIB_USERNAME_HEADER = "Shibboleth.UserNameHeader";
        private const string APP_SETTING_SHIB_SESSION_ID = "Shibboleth.SessionID";
        private const string APP_SETTING_SHIB_LOGIN_URL = "Shibboleth.LoginURL";
        private const string APP_SETTINB_SHIB_LOGOUT_URL = "Shibboleth.LogoutURL";

        /* App Settings Values */
        private string shibIdentityProviderAppSettingValue;
        private string shibUsernameHeaderAppSettingValue;
        private string shibSessionIdAppSettingValue;
        private string shibLoginUrlAppSettingValue;
        private string shibLogoutUrlAppSettingValue;

        /* Public accessable methods */
        public string ShibIdentityProviderAppSettingValue
        {
            get
            {
                return shibIdentityProviderAppSettingValue;
            }
        }

        public string ShibUsernameHeaderAppSettingValue
        {
            get
            {
                return shibUsernameHeaderAppSettingValue;
            }
        }

        public string ShibSessionIdAppSettingValue
        {
            get
            {
                return shibSessionIdAppSettingValue;
            }
        }

        public string ShibLoginUrlAppSettingValue
        {
            get
            {
                return shibLoginUrlAppSettingValue;
            }
        }

        public string ShibLogoutUrlAppSettingValue
        {
            get
            {
                return shibLogoutUrlAppSettingValue;
            }
        }

        /// <summary>
        /// Initialize application settings.  If any settings are invalid or empty that are set an error on the page and return false.
        /// </summary>
        /// <returns>True if valid, False if not</returns>
        public bool InitializeAppSettings()
        {
            /* Get App Settings Values, if required configuration settings are not present, error and stop. */
            shibIdentityProviderAppSettingValue = ConfigurationManager.AppSettings[APP_SETTING_SHIB_IDENTITY_PROVIDER];
            shibUsernameHeaderAppSettingValue = ConfigurationManager.AppSettings[APP_SETTING_SHIB_USERNAME_HEADER];
            shibSessionIdAppSettingValue = ConfigurationManager.AppSettings[APP_SETTING_SHIB_SESSION_ID];
            shibLoginUrlAppSettingValue = ConfigurationManager.AppSettings[APP_SETTING_SHIB_LOGIN_URL];
            shibLogoutUrlAppSettingValue = ConfigurationManager.AppSettings[APP_SETTINB_SHIB_LOGOUT_URL];
            if (ShibLoginUrlAppSettingValue != null) { shibLoginUrlAppSettingValue = ShibLoginUrlAppSettingValue.Trim(); }
            if (ShibLogoutUrlAppSettingValue != null) { shibLogoutUrlAppSettingValue = ShibLogoutUrlAppSettingValue.Trim(); }
            if (string.IsNullOrEmpty(ShibIdentityProviderAppSettingValue) || string.IsNullOrEmpty(ShibUsernameHeaderAppSettingValue) || string.IsNullOrEmpty(ShibSessionIdAppSettingValue) ||
                 string.IsNullOrEmpty(ShibLoginUrlAppSettingValue))
            {
                return false;
            }

            return true;
        }

        /// <summary>
        /// Return a string for error reporting to the user of the settings that are required. 
        /// </summary>
        public string RequiredSettingsString
        {
            get
            {
                return APP_SETTING_SHIB_IDENTITY_PROVIDER + ", " + APP_SETTING_SHIB_USERNAME_HEADER + ", " + APP_SETTING_SHIB_SESSION_ID + ", " + APP_SETTING_SHIB_LOGIN_URL;
            }
        }
    }
}