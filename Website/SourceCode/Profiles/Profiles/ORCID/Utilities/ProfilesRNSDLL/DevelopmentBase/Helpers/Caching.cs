using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DevelopmentBase.Helpers
{
    public class Caching
    {
        public static Object CacheObjectGet(string key)
        {
            return System.Web.HttpContext.Current.Cache[key];
        }
        public static void CacheObjectRemove(string key)
        {
            System.Web.HttpContext.Current.Cache.Remove(key);
        }
        public static void CacheObjectInsert(string key, Object obj, System.Web.Caching.CacheDependency dep, DateTime dt, TimeSpan tspan)
        {
            System.Web.HttpContext.Current.Cache.Insert(key, obj, dep, dt, tspan);
        }
        public static void CacheObjectInsert(string key, Object obj, System.Web.Caching.CacheDependency dep)
        {
            System.Web.HttpContext.Current.Cache.Insert(key, obj, dep);
        }
    }
}
