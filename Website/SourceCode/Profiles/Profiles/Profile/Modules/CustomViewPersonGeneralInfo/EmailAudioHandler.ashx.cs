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
using System.Data.SqlClient;
using System.Threading;
using System.Speech.Synthesis;

namespace Profiles.Profile.Modules.DisplayEmail
{
    public class EmailAudioHandler : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            if (!string.IsNullOrEmpty(context.Request.QueryString["msg"]))
            {
                Utilities.DataIO data = new Profiles.Profile.Utilities.DataIO();
                SqlDataReader reader;
                string email = context.Request.QueryString["msg"];

                SqlCommand cmd = new SqlCommand("SELECT [Utility.Application].[fnDecryptBase64RC4] ( '" + email + "',   (Select [value] from [Framework.].parameter with(nolock) where ParameterID = 'RC4EncryptionKey'))");
                reader = data.GetSQLDataReader(cmd);
                reader.Read();

                string EmailText = reader[0].ToString();
                char[] s1 = EmailText.ToCharArray();
                char[] s2 = new char[s1.Length * 2];
                for (int i = 0; i < s1.Length; i++)
                {
                    s2[2 * i] = s1[i];
                    s2[2 * i + 1] = ' ';
                }
                EmailText = new String(s2);
                EmailText = EmailText.Replace(".", "dot");
                context.Response.ContentType = "audio/wav";
                //MemoryStream mstream = GetAudio(EmailText);
                MemoryStream mstream = GetAudio(EmailText);
                mstream.Position = 0;
                mstream.WriteTo(context.Response.OutputStream);
                context.Response.End();
            }
        }


        public static MemoryStream GetAudio(string input)
        {
            MemoryStream mem = new MemoryStream();

            Thread t = new Thread(new ThreadStart(() =>
            {
                SpeechSynthesizer synth = new SpeechSynthesizer();

                synth.Rate = -5;
                synth.SetOutputToWaveStream(mem);
                synth.Speak(input);

            }));

            t.Start();
            t.Join();

            return mem;
        }

/*
        public void ProcessRequest(HttpContext context)
        {
            // Set up the response settings
            context.Response.ContentType = "image/bmp";
            context.Response.Cache.SetCacheability(HttpCacheability.Public);
            context.Response.BufferOutput = false;

            if (!string.IsNullOrEmpty(context.Request.QueryString["msg"]))
            {
                Utilities.DataIO data = new Profiles.Profile.Utilities.DataIO();
                SqlDataReader reader;
                string email = context.Request.QueryString["msg"];

                SqlCommand cmd = new SqlCommand("SELECT [Utility.Application].[fnDecryptBase64RC4] ( '" + email + "',   (Select [value] from [Framework.].parameter with(nolock) where ParameterID = 'RC4EncryptionKey'))");
                reader = data.GetSQLDataReader(cmd);
                reader.Read();

                string EmailText = reader[0].ToString();

                int MyLen;

                SizeF size;
                float fontSize = 11;
                Font font;

                font = new Font("Arial", fontSize, FontStyle.Regular);


                MyLen = EmailText.Length;


                // Create a new 32-bit bitmap image.
                Bitmap bitmap = new Bitmap(MyLen, 25, PixelFormat.Format32bppArgb);

                // Create a graphics object for drawing.
                Graphics g = Graphics.FromImage(bitmap);
                g.SmoothingMode = SmoothingMode.AntiAlias;

                size = g.MeasureString(EmailText, font);

                // Create a CAPTCHA image using the text stored in the Session object.
                EmailImg.TextImage ci = new EmailImg.TextImage(EmailText, (int)size.Width, (int)size.Height, "Arial");

                // Change the response headers to output a JPEG image.
                HttpContext.Current.Response.Clear();
                HttpContext.Current.Response.ContentType = "image/jpeg";

                // Code to stop image from being cached
                HttpContext.Current.Response.CacheControl = "no-cache";
                HttpContext.Current.Response.AddHeader("Pragma", "no-cache");
                HttpContext.Current.Response.Expires = -1;
                HttpContext.Current.Response.AddHeader("Last-Modified", DateTime.Now.ToString());

                // Write the image to the response stream in JPEG format.
                ci.Image.Save(HttpContext.Current.Response.OutputStream, ImageFormat.Jpeg);

                // Dispose of the CAPTCHA image object.
                ci.Dispose();

                font.Dispose();
                g.Dispose();






            }
        }
        */
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
