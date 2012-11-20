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

namespace Profiles.Search
{
    public partial class data : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            XmlDocument request = new XmlDocument();
            
            string rawrequest = string.Empty;

            //Process the request
            System.IO.StreamReader requeststream = new System.IO.StreamReader(Request.InputStream, System.Text.Encoding.UTF8, false);

            rawrequest = requeststream.ReadToEnd().ToString();

            request.LoadXml(rawrequest);

            Response.Clear();
            Response.ContentType = "application/rdf+xml";
            Response.Charset = "charset=UTF-8";
            Response.StatusCode = Convert.ToInt16("200");
                        

            Response.Write(this.Query(request).InnerXml);
        }


        private XmlDocument Query(XmlDocument request)
        {

            Search.Utilities.DataIO data = new Profiles.Search.Utilities.DataIO();

            return data.Search(request,false);

        }

    }
}
