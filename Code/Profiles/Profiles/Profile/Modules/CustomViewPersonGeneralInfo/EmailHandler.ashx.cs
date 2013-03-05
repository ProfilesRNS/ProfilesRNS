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

namespace Profiles.Profile.Modules.DisplayEmail
{
    public class EmailHandler : IHttpHandler
    {

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

namespace EmailImg
{
    /// <summary>
    /// Summary description for CaptchaImage.
    /// </summary>
    public class TextImage
    {

        // Public properties (all read-only).
        public string Text
        {
            get { return this.text; }
        }
        public Bitmap Image
        {
            get { return this.image; }
        }
        public int Width
        {
            get { return this.width; }
        }
        public int Height
        {
            get { return this.height; }
        }

        // Internal properties.
        private string text;
        private int width;
        private int height;
        private string familyName;
        private Bitmap image;

        // For generating random numbers.
        private Random random = new Random();

        // ====================================================================
        // Initializes a new instance of the CaptchaImage class using the
        // specified text, width and height.
        // ====================================================================
        public TextImage(string s, int width, int height)
        {
            this.text = s;
            this.SetDimensions(width, height);
            this.GenerateImage();
        }

        // ====================================================================
        // Initializes a new instance of the CaptchaImage class using the
        // specified text, width, height and font family.
        // ====================================================================
        public TextImage(string s, int width, int height, string familyName)
        {
            this.text = s;
            this.SetDimensions(width, height);
            this.SetFamilyName(familyName);
            this.GenerateImage();
        }

        // ====================================================================
        // This member overrides Object.Finalize.
        // ====================================================================
        ~TextImage()
        {
            Dispose(false);
        }

        // ====================================================================
        // Releases all resources used by this object.
        // ====================================================================
        public void Dispose()
        {
            GC.SuppressFinalize(this);
            this.Dispose(true);
        }

        // ====================================================================
        // Custom Dispose method to clean up unmanaged resources.
        // ====================================================================
        protected virtual void Dispose(bool disposing)
        {
            if (disposing)
                // Dispose of the bitmap.
                this.image.Dispose();
        }

        // ====================================================================
        // Sets the image width and height.
        // ====================================================================
        private void SetDimensions(int width, int height)
        {
            // Check the width and height.
            if (width <= 0)
                throw new ArgumentOutOfRangeException("width", width, "Argument out of range, must be greater than zero.");
            if (height <= 0)
                throw new ArgumentOutOfRangeException("height", height, "Argument out of range, must be greater than zero.");
            this.width = width;
            this.height = height;
        }

        // ====================================================================
        // Sets the font used for the image text.
        // ====================================================================
        private void SetFamilyName(string familyName)
        {
            // If the named font is not installed, default to a system font.
            try
            {
                Font font = new Font(this.familyName, 12F);
                this.familyName = familyName;
                font.Dispose();
            }
            catch (Exception ex)
            {
                string err = ex.Message;
                this.familyName = System.Drawing.FontFamily.GenericSerif.Name;
            }
        }

        // ====================================================================
        // Creates the bitmap image.
        // ====================================================================
        private void GenerateImage()
        {

            // Set up the text font.
            //SizeF size;

            float fontSize = 13;
            Font font;

            font = new Font(this.familyName, fontSize, FontStyle.Regular);

            // Declare a proposed size with dimensions set to the maximum integer value.
            Size proposedSize = new Size(int.MaxValue, int.MaxValue);

            Bitmap bitmap2 = new Bitmap(width, height, PixelFormat.Format32bppArgb);
            Graphics g2 = Graphics.FromImage(bitmap2);
            g2.SmoothingMode = SmoothingMode.AntiAlias;

            Rectangle rect = new Rectangle(0, 0, width + 1, (int)height + 1);

            // Fill in the background.
            g2.FillRectangle(Brushes.White, rect);

            // Set up the text format.
            StringFormat format = new StringFormat();
            format.Alignment = StringAlignment.Near;
            format.LineAlignment = StringAlignment.Near;

            // Create a path using the text and warp it randomly.
            GraphicsPath path = new GraphicsPath();
            path.AddString(this.text, font.FontFamily, (int)font.Style, font.Size, rect, format);

            g2.FillPath(Brushes.Black, path);

            // Clean up.
            font.Dispose();
            g2.Dispose();
            // Set the image.
            this.image = bitmap2;
        }
    }
}
