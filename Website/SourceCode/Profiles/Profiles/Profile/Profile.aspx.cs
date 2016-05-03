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
using System.Web.UI.HtmlControls;

namespace Profiles.Profile
{
    public partial class Profile : ProfileData
    {
        static private Random random = new Random();

        protected void Page_Load(object sender, EventArgs e)
        {

            Framework.Utilities.RDFTriple request = base.RDFTriple;

                       //The system default is True and True for showdetails and expand, but if its an external page call to this page, 
            //then its set to false for expand.           
            if (HttpContext.Current.Request.Headers["Expand"] != null)
                this.RDFTriple.Expand = Convert.ToBoolean(HttpContext.Current.Request.Headers["Expand"].ToString());
            else
                this.RDFTriple.Expand = true;

            if (HttpContext.Current.Request.Headers["ShowDetails"] != null)
                this.RDFTriple.ShowDetails = Convert.ToBoolean(HttpContext.Current.Request.Headers["ShowDetails"].ToString());
            else
                this.RDFTriple.ShowDetails = true;

            if (HttpContext.Current.Request.Headers["Offset"] != null)
                this.RDFTriple.Offset = HttpContext.Current.Request.Headers["Offset"].ToString();

            if (HttpContext.Current.Request.Headers["Limit"] != null)
                this.RDFTriple.Limit = HttpContext.Current.Request.Headers["Limit"].ToString();

            if (HttpContext.Current.Request.Headers["ExpandRDFListXML"] != null)
                this.RDFTriple.ExpandRDFList = HttpContext.Current.Request.Headers["ExpandRDFListXML"].ToString();

            if (HttpContext.Current.Request.Headers["SessionID"] != null)
                this.RDFTriple.Session.SessionID = HttpContext.Current.Request.Headers["SessionID"].ToString();


            if (HttpContext.Current.Request.Headers["UserAgent"] != null)
                this.RDFTriple.Session.UserAgent = HttpContext.Current.Request.Headers["UserAgent"].ToString();


            base.LoadRDFData();


            Response.Clear();
            Response.ContentType = "application/rdf+xml";
            Response.Charset = "charset=UTF-8";
            Response.StatusCode = Convert.ToInt16("200");

            // Tell the bots that this is slow moving data, add an exires at some random date up to 30 days out
            DateTime expires = DateTime.Now.Add(TimeSpan.FromDays(random.NextDouble() * 29 + 1));
            Response.AddHeader("Expires", expires.ToUniversalTime().ToString("r"));

            Response.Write(base.RDFData.InnerXml);
        }
    }
}
