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
        static readonly string DEPENDENCY_PREFIX = "Dependency ";
        private static double defaultTimeout = Convert.ToInt32(ConfigurationSettings.AppSettings["CACHE_EXPIRE"]);
        /// <summary>
        /// Used to Set objects in cache for a set timout lenght of time.
        /// </summary>
        /// <param name="key"></param>
        /// <param name="data"></param>        


        static public void Set(string key, Object data, double cachetimeout, CacheDependency dependency)
        {
            string hashkey = string.Empty;
            hashkey = Cache.HashForKey(key);

            try
            {

                if (HttpRuntime.Cache[hashkey] != null)
                {
                    HttpRuntime.Cache.Remove(hashkey);
                }

                if (cachetimeout < 0 && dependency == null)
                {
                    HttpRuntime.Cache.Insert(hashkey, data);
                }
                else
                {
                    HttpRuntime.Cache.Insert(hashkey, data, dependency, DateTime.Now.AddSeconds(defaultTimeout), System.Web.Caching.Cache.NoSlidingExpiration);
                }
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }

        }

        static public void SetWithTimeout(string key, Object data, double cachetimeout)
        {
            Set(key, data, cachetimeout, null);
        }

        static public void Set(string key, Object data)
        {
            Set(key, data, defaultTimeout, null);
        }


        /// <summary>
        /// Uses the web.config value for CACHE_EXPIRE to set the lenght of time for an object to be stored in RAM on web server.
        /// </summary>
        /// <param name="key">Unique key value to Set and Fetch item from cache</param>
        /// <param name="data">Data value to be Set in cache</param>
        static public void Set(string key, Object data, Int64 nodeId, String sessionID)
        {
            String[] dependencyKey = new String[sessionID == null ? 1 : 2];
            dependencyKey[0] = DEPENDENCY_PREFIX + nodeId.ToString();

            if (HttpRuntime.Cache[dependencyKey[0]] == null)
                AlterDependency(nodeId.ToString());

            if (sessionID != null)
            {
                dependencyKey[1] = DEPENDENCY_PREFIX + sessionID;
                if (HttpRuntime.Cache[dependencyKey[1]] == null)
                    AlterDependency(sessionID);
            }
            Set(key, data, defaultTimeout, new CacheDependency(null, dependencyKey));
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

        static public void Remove(string key)
        {

            if (HttpRuntime.Cache[key] != null)
            {
                HttpRuntime.Cache.Remove(key);
            }

        }


        static public void AlterDependency(string key)
        {
            HttpRuntime.Cache.Insert(DEPENDENCY_PREFIX + key, Guid.NewGuid().ToString());
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
