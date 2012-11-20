/*  
 
    Copyright (c) 2008-2012 by the President and Fellows of Harvard College. All rights reserved.  
    Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
    and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
    National Center for Research Resources and Harvard University.


    Code licensed under a BSD License. 
    For details, see: LICENSE.txt 
  
*/
using System;
using System.Web;
using System.Xml;
using System.Web.Caching;

namespace Profiles.Search.Utilities
{
    public class CacheWrapper
    {
        public static void CacheItem(string Key, object Object)
        {
            if (HttpRuntime.Cache[Key] != null)
            {
                HttpRuntime.Cache.Remove(Key);

            }
            HttpRuntime.Cache.Insert(Key, Object, null, DateTime.Now.AddHours(24), Cache.NoSlidingExpiration);
        }

  
        public static object GetCacheItem(string Key)
        {
            object xdoc = null;

            if (HttpRuntime.Cache[Key] != null)
            {
                xdoc = HttpRuntime.Cache[Key];
            }


            return xdoc;

        }
    }
}
