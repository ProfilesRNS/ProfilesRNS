using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Net;
using System.Threading;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DevelopmentBase.Helpers
{
    public class WebPageContent
    {
        public static string Get(string strURL)
        {
            string strResponse = string.Empty;
            try
            {
                WebRequest myWebRequest = WebRequest.Create(strURL);
                WebResponse myWebResponse = myWebRequest.GetResponse();
                Stream ReceiveStream = myWebResponse.GetResponseStream();
                Encoding encode = System.Text.Encoding.GetEncoding("utf-8");
                StreamReader readStream = new StreamReader(ReceiveStream, encode);
                strResponse = readStream.ReadToEnd();
                readStream.Close();
                myWebResponse.Close();
            }
            catch //(Exception ex)
            { 

            }
            return strResponse;
        }

        public static void FireAndForget(string strURL)
        {
            try
            {
                HttpWebRequest myRequest = (HttpWebRequest)WebRequest.Create(strURL);
                ThreadPool.QueueUserWorkItem(o=>{ myRequest.GetResponse(); });
            }
            catch //(Exception ex)
            {

            }
        }
    }
}
