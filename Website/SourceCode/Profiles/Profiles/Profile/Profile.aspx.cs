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
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.Net;
using System.IO;
using System.Text;
using System.Runtime.Serialization;
using System.Configuration;


using Profiles.Profile.Utilities;

namespace Profiles.Profile
{
    public partial class Profile : ProfileData
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            Framework.Utilities.RDFTriple request = base.RDFTriple;

            //The system default is True and True for showdetails and expand, but if its an external page call to this page, 
            //then its set to false for expand.           
            if (HttpContext.Current.Request.Headers["Expand"] != null)
            {
                request.Expand = Convert.ToBoolean(HttpContext.Current.Request.Headers["Expand"].ToString());
            }
            else
            {
                request.Expand = false;
            }


            if (HttpContext.Current.Request.Headers["ShowDetails"] != null)
            {
                request.ShowDetails = Convert.ToBoolean(HttpContext.Current.Request.Headers["ShowDetails"].ToString());
            }
            else
            {
                request.ShowDetails = true;
            }            

            base.LoadRDFData();

            Response.Clear();
            Response.ContentType = "application/rdf+xml";
            Response.Charset = "charset=UTF-8";
            Response.StatusCode = Convert.ToInt16("200");

            Response.Write(base.RDFData.InnerXml);
        }
    }
}
