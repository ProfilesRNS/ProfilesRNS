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
        private static double timeout;
        /// <summary>
        /// Used to Set objects in cache for a set timout lenght of time.
        /// </summary>
        /// <param name="key"></param>
        /// <param name="data"></param>        
        static public void Set(string key, Object data, double cachetimeout, Int64 dependencykey)
        {
            timeout = cachetimeout;

            string hashkey = string.Empty;
            hashkey = Cache.HashForKey(key);

            try
            {

                if (HttpRuntime.Cache[hashkey] != null)
                {
                    HttpRuntime.Cache.Remove(hashkey);
                }

                HttpRuntime.Cache.Insert(hashkey, data, CreateDependency(dependencykey.ToString()), DateTime.Now.AddSeconds(timeout), System.Web.Caching.Cache.NoSlidingExpiration);
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
            timeout = Convert.ToDouble(ConfigurationSettings.AppSettings["CACHE_EXPIRE"]);
            Set(key, data, timeout, dependencykey);

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
        static public CacheDependency CreateDependency(string key)
        {
            String[] dependencyKey = new String[1];
            dependencyKey[0] = "Node Dependency " + key;
            CacheDependency dependency = null;

            if (key != "0")
            {
                dependency = new CacheDependency(null, dependencyKey);
                HttpRuntime.Cache.Insert(dependencyKey[0], Guid.NewGuid().ToString());
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
