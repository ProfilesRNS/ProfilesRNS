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
using System.Configuration;

namespace Profiles.Framework.Utilities
{   /// <summary>
    /// Used to global set the RESTful URL structure.
    /// </summary>
    static public class Root
    {
        //***************************************************************************************************************************************
        /// <summary>
        /// Static property thats used to return the base of the RESTful url to include if SSL is used or if Profiles is installed as a subweb.
        /// </summary>
        static public string Domain
        {
            get
            {
		
                DataIO data = new DataIO();

                string restdomain = data.GetRESTBasePath();

                if (HttpContext.Current.Request.IsSecureConnection)
                {
                    restdomain = restdomain.Replace("http:", "https:");
                }
              
               return restdomain;
            }
        }


        //***************************************************************************************************************************************
        /// <summary>
        ///     AbsolutePath is used to parse out the tab names for building what tab is displayed from the PresentationXML based on the RESTful URL
        ///     
        ///     Example:
        ///         http://domain.com/profile/person/32213/concepts/details
        ///             The end of the URL will contain the tab name "Details" and cause the tabs to be built and the correct module to be rendered for Details.
        /// 
        /// 
        /// </summary>
        static public string AbsolutePath
        {
            get
            {
                String url = HttpContext.Current.Request.Url.ToString().ToLower().Replace(Root.Domain.ToLower(), "").Replace("/default.aspx", "");

                //string url = HttpContext.Current.Request.Url.AbsolutePath.ToLower();

                DebugLogging.Log("!!!!!!!!!!!!!!!!!!!!!!!!" + url);
                //dont use the default physical page, we want to use the clean RESTful path.
                //IIS can display its idea of a default URL by placing the page in the URL if it exists.
                return url;
            }
        }

    }
}
