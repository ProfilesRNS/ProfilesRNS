using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Collections.Specialized;
using System.Net;
using System.IO;
using System.Web.Script.Serialization;
using System.IO.Compression;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.ORCID
{
    public class ORCIDCommon
    {
        internal static string GetWebResponse(string url, NameValueCollection parameters, string loggedInInternalUsername, string methodType, string contentType)
        {
            var httpWebRequest = (HttpWebRequest)WebRequest.Create(url);
            httpWebRequest.ContentType = contentType;
            httpWebRequest.Method = methodType;

            var sb = new StringBuilder();
            foreach (var key in parameters.AllKeys)
                sb.Append(key + "=" + parameters[key] + "&");

            sb.Length = sb.Length - 1;
            sb.ToString();

            byte[] requestBytes = Encoding.UTF8.GetBytes(sb.ToString());
            httpWebRequest.ContentLength = requestBytes.Length;

            using (var requestStream = httpWebRequest.GetRequestStream())
            {
                requestStream.Write(requestBytes, 0, requestBytes.Length);
            }

            try
            {
                using (System.IO.Stream response = httpWebRequest.GetResponse().GetResponseStream())
                {
                    StreamReader reader = new StreamReader(response);
                    return reader.ReadToEnd();
                }
            }
            catch (Exception en)
            {
                throw BLL.ORCID.ErrorLog.LogError(en, loggedInInternalUsername, "An error occurred while getting the response.");
            }
        }        
    }
}
