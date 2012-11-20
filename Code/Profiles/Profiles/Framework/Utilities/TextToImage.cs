using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Drawing;

namespace Profiles.Framework.Utilities
{
    public class TextToImage
    {

        public TextToImage() { }


        public Bitmap CreateBitmapImage(string sImageText)
        {
            Bitmap objBmpImage = new Bitmap(1, 1);
            
            int intWidth = 0;
            int intHeight = 0;

            // Create the Font object for the image text drawing.
    
            Font objFont = new Font("arial, sans-serif", 13, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Pixel);
            // Create a graphics object to measure the text's width and height.

            Graphics objGraphics = Graphics.FromImage(objBmpImage);

            // This is where the bitmap size is determined.

            intWidth = (int)objGraphics.MeasureString(sImageText, objFont).Width;

            intHeight = (int)objGraphics.MeasureString(sImageText, objFont).Height;
            // Create the bmpImage again with the correct size for the text and font.

            objBmpImage = new Bitmap(objBmpImage, new Size(intWidth, intHeight));
            
            // Add the colors to the new bitmap.

            objGraphics = Graphics.FromImage(objBmpImage);

            // Set Background color

            objGraphics.Clear(Color.White);

            objGraphics.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.AntiAlias;

            objGraphics.TextRenderingHint = System.Drawing.Text.TextRenderingHint.AntiAlias;

            objGraphics.DrawString(sImageText, objFont, new SolidBrush(Color.FromArgb(102, 102, 102)), 0, 0);

            objGraphics.Flush();



            return (objBmpImage);

        }





    }
}
