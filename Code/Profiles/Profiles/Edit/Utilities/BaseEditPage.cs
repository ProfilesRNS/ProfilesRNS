using System;
using System.IO;
using System.Web.UI;
using System.Text;

namespace Profiles.Edit.Utilities
{
    public class BasePage : Page
    {

        private static string[] aspNetFormElements = new string[] 
              { 
                "__EVENTTARGET",
                "__EVENTARGUMENT",
                "__VIEWSTATE",
                "__EVENTVALIDATION",
                "__VIEWSTATEENCRYPTED",
              };



        protected override void Render(HtmlTextWriter writer)
        {

            StringWriter stringWriter = new StringWriter();

            HtmlTextWriter htmlWriter = new HtmlTextWriter(stringWriter);

            base.Render(htmlWriter);

            string html = stringWriter.ToString();

            int formStart = html.IndexOf("<form");

            int endForm = -1;

            if (formStart >= 0)

                endForm = html.IndexOf(">", formStart);



            if (endForm >= 0)
            {

                StringBuilder viewStateBuilder = new StringBuilder();

                foreach (string element in aspNetFormElements)
                {

                    int startPoint = html.IndexOf("<input type=\"hidden\" name=\"" + element + "\"");

                    if (startPoint >= 0 && startPoint > endForm)
                    {

                        int endPoint = html.IndexOf("/>", startPoint);

                        if (endPoint >= 0)
                        {

                            endPoint += 2;

                            string viewStateInput = html.Substring(startPoint, endPoint - startPoint);

                            html = html.Remove(startPoint, endPoint - startPoint);

                            viewStateBuilder.Append(viewStateInput).Append("\r\n");

                        }

                    }

                }



                if (viewStateBuilder.Length > 0)
                {

                    viewStateBuilder.Insert(0, "\r\n");

                    html = html.Insert(endForm + 1, viewStateBuilder.ToString());

                }

            }



            writer.Write(html);

        }

    }
}

