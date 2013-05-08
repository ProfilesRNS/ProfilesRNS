/*  
 
    Copyright (c) 2008-2012 by the President and Fellows of Harvard College. All rights reserved.  
    Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
    and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
    National Center for Research Resources and Harvard University.


    Code licensed under a BSD License. 
    For details, see: LICENSE.txt 
  
*/
using System;
using System.Collections.Generic;
using System.Data;
using System.Xml;
using System.Configuration;
using System.Web;
using System.Web.Caching;
using System.Text;
using System.Security.Cryptography;
using System.Diagnostics;


namespace Profiles.Framework.Utilities
{
    static public class Cache
    {

        static readonly string DEPENDENCY_PREFIX = "Node Dependency ";
        static int defaultTimeout = Convert.ToInt32(ConfigurationSettings.AppSettings["CACHE_EXPIRE"]);
        /// <summary>
        /// Used to Set objects in cache for a set timout lenght of time.
        /// </summary>
        /// <param name="key"></param>
        /// <param name="data"></param>        
        static private void Set(string key, Object data, Int32 cachetimeout, Int64 dependencykey)
        {
            string hashkey = string.Empty;
            hashkey = Cache.HashForKey(key);

            try
            {
                if (HttpRuntime.Cache[hashkey] != null)
                {
                    HttpRuntime.Cache.Remove(hashkey);
                }
                if (cachetimeout < 0 && dependencykey == 0)
                {
                    HttpRuntime.Cache.Insert(hashkey, data);
                }
                else
                {
                    HttpRuntime.Cache.Insert(hashkey, data, CreateDependency(dependencykey.ToString()), DateTime.Now.AddSeconds(cachetimeout), System.Web.Caching.Cache.NoSlidingExpiration);
                }
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }

        }

        /// <summary>
        /// Uses the web.config value for CACHE_EXPIRE to set the lenght of time for an object to be stored in RAM on web server.
        /// </summary>
        /// <param name="key">Unique key value to Set and Fetch item from cache</param>
        /// <param name="data">Data value to be Set in cache</param>
        static public void Set(string key, Object data, Int64 dependencykey)
        {
            Set(key, data, defaultTimeout, dependencykey);
        }

        static public void SetNoDependency(string key, Object data, int cacheTimeout)
        {
            Set(key, data, cacheTimeout, 0);
        }
        /// <summary>
        /// Used to Fetch RDF data or Presentation data from cache.
        /// </summary>
        /// <param name="request"></param>
        /// <returns></returns>
        static public XmlDocument Fetch(string key)
        {


            XmlDocument xmlrtn = null;
            string hashkey = string.Empty;

            hashkey = Cache.HashForKey(key);

            try
            {
                if (HttpRuntime.Cache[hashkey] != null)
                {
                    xmlrtn = (XmlDocument)HttpRuntime.Cache[hashkey];
                }
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }

            return xmlrtn;
        }


        /// <summary>
        /// Used to Fetch RDF data or Presentation data from cache.
        /// </summary>
        /// <param name="request"></param>
        /// <returns></returns>
        static public Object FetchObject(string key)
        {
            Object xmlrtn = null;
            string hashkey = string.Empty;


            hashkey = Cache.HashForKey(key);
            try
            {
                if (HttpRuntime.Cache[hashkey] != null)
                {
                    xmlrtn = HttpRuntime.Cache[hashkey];
                }
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }

            return xmlrtn;
        }

        static public void ClearDependentItems(Int64 nodeId)
        {
            ClearDependentItems(nodeId.ToString());
        }

        // this one should be deprecated!
        static public void ClearDependentItems(string key)
        {
            Remove(DEPENDENCY_PREFIX + key);
            CreateDependency(key);
        }

        static private void Remove(string key)
        {

            if (HttpRuntime.Cache[key] != null)
            {
                HttpRuntime.Cache.Remove(key);
            }

        }

        static private CacheDependency CreateDependency(string key)
        {
            String[] dependencyKey = new String[1];
            dependencyKey[0] = DEPENDENCY_PREFIX + key;
            CacheDependency dependency = null;

            if (key != "0")
            {
                if (HttpRuntime.Cache[dependencyKey[0]] == null)
                {
                    HttpRuntime.Cache.Insert(dependencyKey[0], Guid.NewGuid().ToString());
                }
                dependency = new CacheDependency(null, dependencyKey);
            }

            return dependency;
        }


        /// <summary>
        /// Takes a string of plain text and then returns a MD5 hash value
        /// </summary>
        /// <param name="plainText"></param>
        /// <returns></returns>
        static public string HashForKey(string plainText)
        {


            SHA1CryptoServiceProvider SHA1 = new SHA1CryptoServiceProvider();
            byte[] byteV = System.Text.Encoding.UTF8.GetBytes(plainText);
            byte[] byteH = SHA1.ComputeHash(byteV);
            SHA1.Clear();
            return Convert.ToBase64String(byteH);

        }



    }



}
