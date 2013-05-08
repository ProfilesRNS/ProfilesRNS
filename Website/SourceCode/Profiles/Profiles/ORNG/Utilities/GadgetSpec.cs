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
        private bool sandboxOnly = false;
        private Dictionary<string, GadgetViewRequirements> viewRequirements = new Dictionary<string, GadgetViewRequirements>();

        public GadgetSpec(int appId, string name, string openSocialGadgetURL, bool enabled, bool sandboxOnly)
        {
            this.appId = appId;
            this.name = name;
            this.openSocialGadgetURL = openSocialGadgetURL;
            this.enabled = enabled;
            this.sandboxOnly = sandboxOnly;

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

        public bool HasRegisteredVisibility()
        {
            foreach (GadgetViewRequirements req in viewRequirements.Values)
            {
                if (OpenSocialManager.REGISTRY_DEFINED.Equals(req.GetVisiblity()))
                {
                    return true;
                }
            }
            return false;
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
        public bool Show(string viewerId, string ownerId, String page)
        {
            page = page.ToLower();
            bool show = true;
            // if there are no view requirements, go ahead and show it.  We are likely testing out a new gadget
            // if there are some, turn it off unless this page says its OK to turn it on
            if (viewRequirements.Count > 0)
            {
                show = false;
            }

            if (viewRequirements.ContainsKey(page))
            {
                GadgetViewRequirements req = GetGadgetViewRequirements(page);
                string visibility = (req.GetVisiblity() == OpenSocialManager.REGISTRY_DEFINED ? GetRegistryDefinedVisiblity(ownerId) : req.GetVisiblity());
                if (OpenSocialManager.PUBLIC.Equals(visibility))
                {
                    show = true;
                }
                else if (OpenSocialManager.USERS.Equals(visibility) && viewerId != null)
                {
                    show = true;
                }
                else if (OpenSocialManager.PRIVATE.Equals(visibility) && (viewerId != null) && (viewerId == ownerId)) 
                {
                    show = true;
                }
                else if (OpenSocialManager.IS_REGISTERED.Equals(visibility) && GetRegistryDefinedVisiblity(ownerId) != null) 
                {
                    show = true;
                }
            }
            return show;
        }

        // OK to cache as long as dependency is working!
        public string GetRegistryDefinedVisiblity(string personId)
        {
            if (personId == null || personId.Trim().Length == 0)
            {
                return null;
            }

            Dictionary<int, string> registeredApps = (Dictionary<int, string>)Framework.Utilities.Cache.FetchObject(REGISTERED_APPS_CACHE_PREFIX + personId);
            if (registeredApps == null)
            {
                registeredApps = new Dictionary<int, string>();
                Profiles.ORNG.Utilities.DataIO data = new Profiles.ORNG.Utilities.DataIO();

                using (SqlDataReader dr = data.GetRegisteredApps(personId))
                {
                    while (dr.Read())
                    {
                        registeredApps[dr.GetInt32(0)] = dr.GetString(1);
                    }
                }

                Framework.Utilities.Cache.Set(REGISTERED_APPS_CACHE_PREFIX + personId, registeredApps, OpenSocialManager.GetNodeID(personId));
            }

            return registeredApps.ContainsKey(GetAppId()) ? registeredApps[GetAppId()] : null;
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