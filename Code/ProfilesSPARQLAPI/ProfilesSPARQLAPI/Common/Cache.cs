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


namespace Search.Common
{
    static public class Cache
    {
        static double timeout;
        /// <summary>
        /// 
        /// </summary>
        /// <param name="key"></param>
        /// <param name="data"></param>

        static public void Set(string request, Object data)
        {

            //CACHE_EXPIRE is in minutes for SPARQLAPI
            timeout = Convert.ToDouble(ConfigurationSettings.AppSettings["CACHE_EXPIRE"]);
            
            DebugCacheSetting();
            
            string hashkey = string.Empty;
            hashkey = Cache.HashForKey(request);
            try
            {
                if (HttpRuntime.Cache[hashkey] != null)
                {
                    HttpRuntime.Cache[hashkey] = null;
                }
                
                HttpRuntime.Cache.Insert(hashkey, data, null, DateTime.Now.AddMinutes(timeout), System.Web.Caching.Cache.NoSlidingExpiration);
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        static public object Fetch(string request)
        {
            object xmlrtn = null;
            string hashkey = string.Empty;
            hashkey = Cache.HashForKey(request);
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

        [Conditional("DEBUG")]
        static void DebugCacheSetting() { timeout = 0; }


    }

    //    <Cache>
    //    <RequestDate>2010061108001234</RequestDate>
    //    <CacheTimeout>3600</CacheTimeout>
    //    <UserRoleList>
    //        <UserRole FilterMatch="true" InstitutionID="123456" DepartmentID="" DivisionID="">Admin</UserRole>
    //        <UserRole FilterMatch="true">User</UserRole>
    //        <UserRole FilterMatch="false">Public</UserRole>
    //    </UserRoleList>
    //</Cache>



}
