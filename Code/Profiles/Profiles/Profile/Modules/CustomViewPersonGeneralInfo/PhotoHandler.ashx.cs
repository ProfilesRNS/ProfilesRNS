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

namespace Profiles.Profile.Modules.ProfileImage
{
    public class PhotoHandler : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            // Set up the response settings
            context.Response.ContentType = "image/jpeg";
            context.Response.Cache.SetCacheability(HttpCacheability.Public);
            context.Response.BufferOutput = false;

            if (!string.IsNullOrEmpty(context.Request.QueryString["NodeID"]))
            {
                Utilities.DataIO data = new Profiles.Profile.Utilities.DataIO();

                // get the id for the image
                Int64 nodeid = Convert.ToInt32(context.Request.QueryString["NodeID"]);

                //Set up the response settings
                context.Response.ContentType = "image/jpeg";
                context.Response.Cache.SetCacheability(HttpCacheability.Public);
                context.Response.BufferOutput = false;                
                
                Stream stream = data.GetUserPhotoList(nodeid);

                const int buffersize = 1024 * 16;
                byte[] buffer2 = new byte[buffersize];
                int count = stream.Read(buffer2, 0, buffersize);
                while (count > 0)
                {
                    context.Response.OutputStream.Write(buffer2, 0, count);
                    count = stream.Read(buffer2, 0, buffersize);
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
