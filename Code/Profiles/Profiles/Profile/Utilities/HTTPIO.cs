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
using System.Xml;
using System.Web;
using System.Net;
using System.IO;
using System.Text;
using System.Runtime.Serialization;
using System.Configuration;

using Profiles.Framework.Utilities;

namespace Profiles.Profile.Utilities
{
    public class HTTPIO
    {

        string _xml;

        public HTTPIO()
        {

        }

        public XmlDocument QueryHTTPIO(RDFTriple datarequest)
        {
            string result = string.Empty;
            XmlDocument rawdata = new XmlDocument();

            try
            {
                HttpWebRequest request = null;
                request = (HttpWebRequest)WebRequest.Create(datarequest.URI);
                request.Method = "POST";
                request.ContentType = "application/rdf+xml";
                request.ContentLength = datarequest.URI.Length;

                if (request.Headers["SessionID"] == null)
                    request.Headers.Add("SessionID", datarequest.Session.SessionID);

                if (datarequest.Offset != null)
                    if (datarequest.Offset != string.Empty)
                        request.Headers.Add("Offset", datarequest.Offset.ToString());

                if (datarequest.Limit != null)
                    if (datarequest.Limit != string.Empty)
                        request.Headers.Add("Limit", datarequest.Limit.ToString());


                request.Headers.Add("ShowDetails", datarequest.ShowDetails.ToString());
                request.Headers.Add("Expand", datarequest.Expand.ToString());

                if (datarequest.ExpandRDFList != null)
                    request.Headers.Add("ExpandRDFList", datarequest.ExpandRDFList.ToString());

                using (Stream writeStream = request.GetRequestStream())
                {
                    UTF8Encoding encoding = new UTF8Encoding();
                    byte[] bytes = encoding.GetBytes(datarequest.URI);
                    writeStream.Write(bytes, 0, bytes.Length);
                }

                using (HttpWebResponse response = (HttpWebResponse)request.GetResponse())
                {
                    using (Stream responseStream = response.GetResponseStream())
                    {
                        using (StreamReader readStream = new StreamReader(responseStream, Encoding.UTF8))
                        {
                            result = readStream.ReadToEnd();
                        }
                    }
                }

                rawdata.LoadXml(result);

            }
            catch (Exception ex)
            {
                Framework.Utilities.DebugLogging.Log(ex.Message + " ++ " + ex.StackTrace);
            }

            return rawdata;
        }


    }

}
