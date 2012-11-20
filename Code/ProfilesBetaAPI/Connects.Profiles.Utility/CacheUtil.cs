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

namespace Connects.Profiles.Utility
{
    static public class CacheUtil
    {
        private static double timeout;
        /// <summary>
        /// Used to Set objects in cache for a set timout lenght of time.
        /// </summary>
        /// <param name="key"></param>
        /// <param name="data"></param>        

        static public void Set(string key, Object data, double cachetimeout)
        {
            timeout = cachetimeout;

            string hashkey = string.Empty;
            hashkey = HashForKey(key);
            try
            {
                if (HttpRuntime.Cache[hashkey] != null)
                {
                    HttpRuntime.Cache.Remove(hashkey);
                }

                HttpRuntime.Cache.Insert(hashkey, data, null, DateTime.Now.AddSeconds(timeout), System.Web.Caching.Cache.NoSlidingExpiration);
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
        static public void Set(string key, Object data)
        {
            timeout = Convert.ToDouble(10000);
            Set(key, data, timeout);
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


            hashkey = HashForKey(key);
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


            hashkey = HashForKey(key);
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




        /// <summary>
        /// Takes a string of plain text and then returns a MD5 hash value
        /// </summary>
        /// <param name="plainText"></param>
        /// <returns></returns>
        static public string HashForKey(string plainText)
        {
            plainText = plainText.ToLower();

            // Use input string to calculate MD5 hash
            MD5 md5 = System.Security.Cryptography.MD5.Create();
            byte[] inputBytes = System.Text.Encoding.ASCII.GetBytes(plainText);
            byte[] hashBytes = md5.ComputeHash(inputBytes);

            // Convert the byte array to hexadecimal string
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < hashBytes.Length; i++)
            {
                sb.Append(hashBytes[i].ToString("X2"));
                // To force the hex string to lower-case letters instead of
                // upper-case, use he following line instead:
                // sb.Append(hashBytes[i].ToString("x2")); 
            }
            return sb.ToString();

        }



    }

}
