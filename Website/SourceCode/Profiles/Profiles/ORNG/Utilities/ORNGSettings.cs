using System.Configuration;

namespace Profiles.ORNG.Utilities
{
    public class ORNGSettings : ConfigurationSection
    {
        public static readonly string ORNG_CONFIG_SECTION = "ORNG";

        public static ORNGSettings getSettings()
        {
            return (ORNGSettings)ConfigurationManager.GetSection(ORNG_CONFIG_SECTION);
        }

        /// <summary>
        /// if true, ORNG is enabled
        /// </summary>
        [ConfigurationProperty("Enabled", DefaultValue = "false", IsRequired = false)]
        public bool Enabled
        {
            get
            {
                return (bool)this["Enabled"];
            }
            set
            {
                this["Enabled"] = value;
            }
        }

        [ConfigurationProperty("ShindigURL", DefaultValue = "http://localhost/shindigorng", IsRequired = false)]
        [StringValidator(MinLength = 4)]
        public string ShindigURL
        {
            get
            {
                return (string)this["ShindigURL"];
            }
            set
            {
                this["ShindigURL"] = value;
            }
        }

        [ConfigurationProperty("Features", DefaultValue = "container:open-views:rpc:pubsub-2", IsRequired = false)]
        [StringValidator(MinLength = 4)]
        public string Features
        {
            get
            {
                return (string)this["Features"];
            }
            set
            {
                this["Features"] = value;
            }
        }

        [ConfigurationProperty("TokenService", DefaultValue = "localhost:8777", IsRequired = false)]
        [StringValidator(MinLength = 3)]
        public string TokenService
        {
            get
            {
                return (string)this["TokenService"];
            }
            set
            {
                this["TokenService"] = value;
            }
        }

        [ConfigurationProperty("SocketPoolMin", DefaultValue = "3", IsRequired = false)]
        [IntegerValidator(MinValue = 1, MaxValue = 255)]
        public int SocketPoolMin
        {
            get
            {
                return (int)this["SocketPoolMin"];
            }
            set
            {
                this["SocketPoolMin"] = value;
            }
        }

        [ConfigurationProperty("SocketPoolMax", DefaultValue = "10", IsRequired = false)]
        [IntegerValidator(MinValue = 1, MaxValue = 255)]
        public int SocketPoolMax
        {
            get
            {
                return (int)this["SocketPoolMax"];
            }
            set
            {
                this["SocketPoolMax"] = value;
            }
        }

        [ConfigurationProperty("SocketPoolExpire", DefaultValue = "1000", IsRequired = false)]
        [IntegerValidator(MinValue = 0)]
        public int SocketPoolExpire
        {
            get
            {
                return (int)this["SocketPoolExpire"];
            }
            set
            {
                this["SocketPoolExpire"] = value;
            }
        }

        [ConfigurationProperty("SocketReceiveTimeout", DefaultValue = "5000", IsRequired = false)]
        [IntegerValidator(MinValue = 0)]
        public int SocketReceiveTimeout
        {
            get
            {
                return (int)this["SocketReceiveTimeout"];
            }
            set
            {
                this["SocketReceiveTimeout"] = value;
            }
        }

        [ConfigurationProperty("SearchLimit", DefaultValue = "1000", IsRequired = false)]
        [IntegerValidator(MinValue = 1)]
        public int SearchLimit
        {
            get
            {
                return (int)this["SearchLimit"];
            }
            set
            {
                this["SearchLimit"] = value;
            }
        }

        [ConfigurationProperty("SandboxPassword", DefaultValue = "", IsRequired = false)]
        public string SandboxPassword
        {
            get
            {
                return (string)this["SandboxPassword"];
            }
            set
            {
                this["SandboxPassword"] = value;
            }
        }

    }
}