using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;

using Profiles.Framework.Utilities;

namespace Profiles.ORNG.Utilities
{
    public class GadgetSpec
    {

        static readonly string REGISTERED_APPS_CACHE_PREFIX = "ORNG.REGISTERED_APPS_";

        private int appId = 0;
        private string name;
        private string openSocialGadgetURL;
        private bool enabled;
        private string unavailableMessage;
        private bool sandboxOnly = false;
        private Dictionary<string, GadgetViewRequirements> viewRequirements = new Dictionary<string, GadgetViewRequirements>();

        public GadgetSpec(int appId, string name, string openSocialGadgetURL, string unavailableMessage, bool enabled, bool sandboxOnly)
        {
            this.appId = appId;
            this.name = name;
            this.openSocialGadgetURL = openSocialGadgetURL;
            this.enabled = enabled;
            this.sandboxOnly = sandboxOnly;
            this.unavailableMessage = String.IsNullOrEmpty(unavailableMessage) ? null : unavailableMessage;

            // if it's sandboxOnly, you will not find view requirements in the DB
            if (!sandboxOnly)
            {
                Profiles.ORNG.Utilities.DataIO data = new Profiles.ORNG.Utilities.DataIO();
                using (SqlDataReader dr = data.GetGadgetViewRequirements(appId))
                {
                    while (dr.Read())
                    {
                        viewRequirements.Add(dr[0].ToString().ToLower(), new GadgetViewRequirements(dr[0].ToString().ToLower(),
                                dr[1].ToString(), dr[2].ToString(), dr[3].ToString(),
                                dr.IsDBNull(4) ? Int32.MaxValue : dr.GetInt32(4), dr[5].ToString()));
                    }
                }
            }
        }

        public int GetAppId()
        {
            return appId;
        }

        public String GetName()
        {
            return name;
        }

        public String GetGadgetURL()
        {
            return openSocialGadgetURL;
        }

        public GadgetViewRequirements GetGadgetViewRequirements(String page)
        {
            page = page.ToLower();
            if (viewRequirements.ContainsKey(page))
            {
                return viewRequirements[page];
            }
            return null;
        }

        // based on security and securityGroup settings, do we show this?
        public bool Show(string viewerUri, string ownerUri, String page)
        {
            page = page.ToLower();
            bool show = false;

            if (viewRequirements.ContainsKey(page))
            {
                GadgetViewRequirements req = GetGadgetViewRequirements(page);
                string visibility = req.GetVisiblity();
                if (OpenSocialManager.PUBLIC.Equals(visibility))
                {
                    show = true;
                }
                else if (OpenSocialManager.USERS.Equals(visibility) && viewerUri != null)
                {
                    show = true;
                }
                else if (OpenSocialManager.PRIVATE.Equals(visibility) && (viewerUri != null) && (viewerUri == ownerUri)) 
                {
                    show = true;
                }
                else if (OpenSocialManager.IS_REGISTERED.Equals(visibility) && IsRegistered(ownerUri) ) 
                {
                    show = true;
                }
            }
            return show;
        }

        // OK to cache as long as dependency is working!
        // think about this, as this is now only set manually via DB
        public bool IsRegistered(string ownerUri)
        {
            if (ownerUri == null || ownerUri.Trim().Length == 0)
            {
                return false;
            }

            HashSet<int> registeredApps = (HashSet<int>)Framework.Utilities.Cache.FetchObject(REGISTERED_APPS_CACHE_PREFIX + ownerUri);
            if (registeredApps == null)
            {
                registeredApps = new HashSet<int>();
                Profiles.ORNG.Utilities.DataIO data = new Profiles.ORNG.Utilities.DataIO();

                using (SqlDataReader dr = data.GetRegisteredApps(ownerUri))
                {
                    while (dr.Read())
                    {
                        registeredApps.Add(dr.GetInt32(0));
                    }
                }

                Framework.Utilities.Cache.Set(REGISTERED_APPS_CACHE_PREFIX + ownerUri, registeredApps, OpenSocialManager.GetNodeID(ownerUri), null);
            }

            return registeredApps.Contains(GetAppId());
        }

        public string GetUnavailableMessage()
        {
            return unavailableMessage;
        }

        public bool RequiresRegitration()
        {
            return unavailableMessage != null;
        }

        public bool FromSandbox()
        {
            return sandboxOnly;
        }

        public bool IsEnabled()
        {
            return enabled;
        }

    }
}