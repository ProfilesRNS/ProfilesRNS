using System;
using System.IO;
using System.Web;
using System.Configuration;
using System.Diagnostics;

namespace HttpBL
{
    // notice: add a reference to System.Configuration
    class Settings : ConfigurationSection
    {
        #region "IISobj"
        private HttpContext         _context = null;
        #endregion

        #region "properties"
        /// <summary>
        /// if true, Http:BL filtering is enabled
        /// </summary>
        [ConfigurationProperty("Enabled", DefaultValue = "true", IsRequired = false)]
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

        /// <summary>
        /// your own access key from http://www.projecthoneypot.org
        /// </summary>
        [ConfigurationProperty("AccessKey", DefaultValue = "abcdefghijkl", IsRequired = true)]
        [StringValidator(MinLength = 10, MaxLength = 64)]
        public string AccessKey
        {
            get
            {
                return (string)this["AccessKey"];
            }
            set
            {
                this["AccessKey"] = value;
            }
        }

        /// <summary>
        /// file containing ALWAYS blacklisted IPs (one on each row)
        /// </summary>
        [ConfigurationProperty("AlwaysDeny", DefaultValue = "", IsRequired = false)]
        public string AlwaysDeny
        {
            get
            {
                return NormalizePath((string)this["AlwaysDeny"]);
            }
            set
            {
                this["AlwaysDeny"] = value;
            }
        }

        /// <summary>
        /// file containing ALWAYS whitelisted IPs (one on each row)
        /// </summary>
        [ConfigurationProperty("AlwaysAllow", DefaultValue = "", IsRequired = false)]
        public string AlwaysAllow
        {
            get
            {
                return NormalizePath((string)this["AlwaysAllow"]);
            }
            set
            {
                this["AlwaysAllow"] = value;
            }
        }

        /// <summary>
        /// query domain (default = dnsbl.httpbl.org)
        /// </summary>
        [ConfigurationProperty("QueryDomain", DefaultValue = "dnsbl.httpbl.org", IsRequired = false)]
        [StringValidator(MinLength = 3)]
        public string QueryDomain
        {
            get
            {
                return (string)this["QueryDomain"];
            }
            set
            {
                this["QueryDomain"] = value;
            }
        }

        /// <summary>
        /// max age for a listed entry, entries below this value will be ignored
        /// </summary>
        [ConfigurationProperty("MaxAge", DefaultValue = "30", IsRequired = false)]
        [IntegerValidator(MinValue = 1, MaxValue = 255)]
        public int MaxAge
        {
            get
            {
                return (int)this["MaxAge"];
            }
            set
            {
                this["MaxAge"] = value;
            }
        }

        /// <summary>
        /// max score for a listed entry, entries below this value will be ignored
        /// </summary>
        [ConfigurationProperty("MaxScore", DefaultValue = "40", IsRequired = false)]
        [IntegerValidator(MinValue = 1, MaxValue = 255)]
        public int MaxScore
        {
            get
            {
                return (int)this["MaxScore"];
            }
            set
            {
                this["MaxScore"] = value;
            }
        }

        /// <summary>
        /// TTL used for a cached entry; the response from the DNS query for a given
        /// IP will be cached for this amount of time; notice that the TTL is dynamic
        /// so, the TTL will expire "n" seconds after the last time a given cached
        /// element is accessed; a value of 0 disables the caching (not recommended)
        /// </summary>
        [ConfigurationProperty("CacheTTL", DefaultValue = "3600", IsRequired = false)]
        [LongValidator(MinValue=0)]
        public long CacheTTL
        {
            get
            {
                return (long)this["CacheTTL"];
            }
            set
            {
                this["CacheTTL"] = value;
            }
        }

        /// <summary>
        /// if true, we'll also cache whitelisted (not listed) IPs, this greatly
        /// helps reducing the DNS queries; it's recommended to keep this param
        /// active to avoid overloading the ProjectHoneypot DNS servers with
        /// unneeded queries
        /// </summary>
        [ConfigurationProperty("CacheWhite", DefaultValue = "true", IsRequired = false)]
        public bool CacheWhite
        {
            get
            {
                return (bool)this["CacheWhite"];
            }
            set
            {
                this["CacheWhite"] = value;
            }
        }

        /// <summary>
        /// true = redirect a listed IP to "RedirectURL"; false, issue a straight reject
        /// </summary>
        [ConfigurationProperty("RedirectOnHit", DefaultValue = "false", IsRequired = false)]
        public bool RedirectOnHit
        {
            get
            {
                return (bool)this["RedirectOnHit"];
            }
            set
            {
                this["RedirectOnHit"] = value;
            }
        }
        
        /// <summary>
        /// if RedirectOnHit is true, then this will be the URL where a request
        /// will be redirected to in case the requesting IP is listed; notice that
        /// it's possible to add parameters to the URL (see the example config file)
        /// </summary>
        [ConfigurationProperty("RedirectURL", DefaultValue = "/denied.aspx?ip=$IP&result=$RESULT", IsRequired = false)]
        [StringValidator(MinLength = 4)]
        public string RedirectURL
        {
            get
            {
                return (string)this["RedirectURL"];
            }
            set
            {
                this["RedirectURL"] = value;
            }
        }

        /// <summary>
        /// true = enables logging to file
        /// </summary>
        [ConfigurationProperty("Logging", DefaultValue = "false", IsRequired = false)]
        public bool Logging
        {
            get
            {
                return (bool)this["Logging"];
            }
            set
            {
                this["Logging"] = value;
            }
        }

        /// <summary>
        /// path for the log files, can be relative or even virtual
        /// </summary>
        [ConfigurationProperty("LogPath", DefaultValue = ".", IsRequired = false)]
        [StringValidator(MinLength = 1)]
        public string LogPath
        {
            get
            {
                return NormalizePath((string)this["LogPath"]);
            }
            set
            {
                this["LogPath"] = value;
            }
        }

        /// <summary>
        /// true = log blacklisted IPs to logfile
        /// </summary>
        [ConfigurationProperty("LogHits", DefaultValue = "true", IsRequired = false)]
        public bool LogHits
        {
            get
            {
                return (bool)this["LogHits"];
            }
            set
            {
                this["LogHits"] = value;
            }
        }

        /// <summary>
        /// IIS request context for this instance
        /// </summary>
        public HttpContext iisContext
        {
            get { return this._context; }
            set { this._context = value; }
        }
        #endregion

        #region "utilities"
        /// <summary>
        /// normalizes a pathname by expanding whatever environment
        /// variables contained in the given path and then retrieving
        /// the fully qualified pathname; if the class has a valid
        /// HTTP (IIS) context, the path can also be mapped from a
        /// virtual path
        /// </summary>
        /// <param name="pathName">
        /// pathname to be "normalized"
        /// </param>
        /// <returns>
        /// normalized pathname
        /// </returns>
        private string NormalizePath(string pathName)
        {
            if (string.IsNullOrEmpty(pathName)) return pathName;
            string fullPath = null;
            try
            {
                fullPath = Environment.ExpandEnvironmentVariables(pathName);
                if (null != this._context)
                    fullPath = MapVirtPath(fullPath);
                fullPath = Path.GetFullPath(fullPath);
            }
            catch (Exception ex)
            {
                traceMsg("NormalizePath({0}) error {1}", pathName, ex.Message);
                fullPath = pathName;
            }
            return fullPath;
        }

        /// <summary>
        /// maps an IIS virtual path to a phys path
        /// </summary>
        /// <param name="pathName">
        /// the virtual path to be mapped
        /// </param>
        /// <returns>
        /// the mapped path
        /// </returns>
        private string MapVirtPath(string pathName)
        {
            if (null == this._context) return pathName;
            if (string.IsNullOrEmpty(pathName)) return pathName;
            string mappedPath = null;
            try
            {
                mappedPath = this._context.Server.MapPath(pathName);
            }
            catch (Exception ex)
            {
                traceMsg("MapVirtPath({0}) error {1}", pathName, ex.Message);
                mappedPath = pathName;
            }
            return mappedPath;
        }

        /// <summary>
        /// trace/debug messages
        /// </summary>
        /// <param name="format">format string</param>
        /// <param name="args">message args</param>
        private void traceMsg(string format, params object[] args)
        {
            string message = string.Format(format, args);
            Trace.WriteLine(message);
        }
        #endregion
    }
}
