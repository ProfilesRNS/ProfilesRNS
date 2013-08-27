/*
 
    Copyright (c) 2008-2012 by the President and Fellows of Harvard College. All rights reserved.  
    Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
    and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
    National Center for Research Resources and Harvard University.


    Code licensed under a BSD License. 
    For details, see: LICENSE.txt 
  
*/

using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.IO;
using System.Web;
using System.Xml;

namespace Profiles.Profile.Modules.ProfileImage
{
    public class PhotoHandler : IHttpHandler, System.Web.SessionState.IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            // Set up the response settings
            context.Response.ContentType = "image/jpeg";
            context.Response.Cache.SetCacheability(HttpCacheability.Public);
            context.Response.BufferOutput = false;

            if (!string.IsNullOrEmpty(context.Request.QueryString["NodeID"]))
            {
                
                // get the id for the image
                Int64 nodeid = Convert.ToInt32(context.Request.QueryString["NodeID"]);
                bool harvarddefault = false;

                if (context.Request.QueryString["HarvardDefault"] != null)
                {
                    harvarddefault = true;
                }

                Utilities.DataIO data = new Profiles.Profile.Utilities.DataIO();

                Framework.Utilities.RDFTriple request = new Profiles.Framework.Utilities.RDFTriple(nodeid);

                request.Expand = true;
                Framework.Utilities.Namespace xmlnamespace = new Profiles.Framework.Utilities.Namespace();
                XmlDocument person ;

                person = data.GetRDFData(request);
                XmlNamespaceManager namespaces =  xmlnamespace.LoadNamespaces(person);

                if (person.SelectSingleNode("rdf:RDF/rdf:Description[1]/prns:mainImage/@rdf:resource", namespaces) != null)
                {

                    //Set up the response settings
                    context.Response.ContentType = "image/jpeg";
                    context.Response.Cache.SetCacheability(HttpCacheability.Public);
                    context.Response.BufferOutput = false;

                    Stream stream = data.GetUserPhotoList(nodeid,harvarddefault);

                    const int buffersize = 1024 * 16;
                    byte[] buffer2 = new byte[buffersize];
                    int count = stream.Read(buffer2, 0, buffersize);
                    while (count > 0)
                    {
                        context.Response.OutputStream.Write(buffer2, 0, count);
                        count = stream.Read(buffer2, 0, buffersize);
                    }

                }
                else
                {

                    context.Response.Write("No Image Found");
                }
            }
        }

        //this is required for using the IHttpHandler interface. 
        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
       
    }
}
