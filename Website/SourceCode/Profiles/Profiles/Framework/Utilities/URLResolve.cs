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
using System.Linq;
using System.Web;

namespace Profiles.Framework.Utilities
{
    /// <summary>
    /// This class is used to store the state of the REST URL Resolve process called by the REST.aspx.cs file.
    /// </summary>
    public class URLResolve
    {
        public URLResolve(bool resolved, string errordescription, string responseurl,string contenttype,string statuscode,
            bool redirect,bool includepostdata)
        {
            this.Resolved = resolved;
            this.ErrorDescription = errordescription;
            this.ResponseURL = responseurl;
            this.ContentType = contenttype;
            this.StatusCode = statuscode;
            this.Redirect = redirect;
            this.IncludePostData = includepostdata;
        }

        public bool Resolved { get; set; }
        public string ErrorDescription{get;set;}
        public string ResponseURL { get; set; }
        public string ContentType { get; set; }
        public string StatusCode { get; set; }
        public bool Redirect { get; set; }
        public bool IncludePostData { get; set; }
    }
}
