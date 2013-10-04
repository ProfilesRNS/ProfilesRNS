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
        static byte[] silhouetteImage = null;
        static readonly string IMAGE_CACHE_PREFIX = "UCSF.Image_";

        static PhotoHandler()
        {
            // this method is limited to 2^32 byte files (4.2 GB)
            using (FileStream fs = File.OpenRead(AppDomain.CurrentDomain.BaseDirectory + "/Profile/Images/default_img.png"))
            {
                silhouetteImage = new byte[fs.Length];
                fs.Read(silhouetteImage, 0, Convert.ToInt32(fs.Length));
            }
        }

        public void ProcessRequest(HttpContext context)
        {
            Utilities.DataIO data = new Profiles.Profile.Utilities.DataIO();

            Int64 nodeid = -1;
            if (!string.IsNullOrEmpty(context.Request.QueryString["NodeID"]))
            {
                // get the id for the image
                nodeid = Convert.ToInt32(context.Request.QueryString["NodeID"]);
            }
            else if (!string.IsNullOrEmpty(context.Request.QueryString["person"]))
            {
                // UCSF.  Allow old id to work
                nodeid = Framework.Utilities.UCSFIDSet.ByPersonId[Convert.ToInt64(context.Request.QueryString["person"])].NodeId;
            }

            if (nodeid > 0)
            {
                // UCSF items
                bool thumbnail = false;
                int width = 150;
                int height = 300;
                if (context.Request.QueryString["Thumbnail"] != null)
                {
                    thumbnail = true;
                }
                if (context.Request.QueryString["Width"] != null)
                {
                    width = Convert.ToInt32(context.Request.QueryString["Width"]);
                    height = 2 * width;
                }
                if (context.Request.QueryString["Height"] != null)
                {
                    height = Convert.ToInt32(context.Request.QueryString["Height"]);
                }

                // we know that it is OK to cache this
                byte[] rawimage = (byte[])Framework.Utilities.Cache.FetchObject(IMAGE_CACHE_PREFIX + nodeid);

                if (rawimage == null)
                {
                    // stuff below this and if statement is what makes it slow
                    Framework.Utilities.RDFTriple request = new Profiles.Framework.Utilities.RDFTriple(nodeid);

                    request.Expand = true;
                    Framework.Utilities.Namespace xmlnamespace = new Profiles.Framework.Utilities.Namespace();
                    XmlDocument person;

                    person = data.GetRDFData(request);
                    XmlNamespaceManager namespaces = xmlnamespace.LoadNamespaces(person);

                    if (person.SelectSingleNode("rdf:RDF/rdf:Description[1]/prns:mainImage/@rdf:resource", namespaces) != null)
                    {
                        rawimage = data.GetUserPhotoList(nodeid);
                        if (rawimage != null)
                        {
                            Framework.Utilities.Cache.Set(IMAGE_CACHE_PREFIX + nodeid, rawimage, nodeid, request.Session.SessionID);
                        }
                    }
                    else if (thumbnail)
                    {
                        rawimage = silhouetteImage;
                    }
                }

                if (rawimage != null)
                {
                    Edit.Utilities.DataIO resize = new Profiles.Edit.Utilities.DataIO();
                    byte[] image = resize.ResizeImageFile(rawimage, width, height);
                    Stream stream = new System.IO.MemoryStream(image);

                    // Set up the response settings
                    context.Response.ContentType = "image/jpeg";
                    context.Response.Cache.SetCacheability(HttpCacheability.Public);
                    context.Response.BufferOutput = false;
                    context.Response.AddHeader("Content-Length", stream.Length.ToString());

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
