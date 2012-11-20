/*  
 
    Copyright (c) 2008-2010 by the President and Fellows of Harvard College. All rights reserved.  
    Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
    and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
    National Center for Research Resources and Harvard University.


    Code licensed under a BSD License. 
    For details, see: LICENSE.txt 
  
*/
using System;
using System.Collections.Generic;
using System.Text;
using System.Net;
using System.IO;
using System.Xml;
using System.Linq;



namespace Connects.Profiles.Utility
{
    public class CommonUtil
    {
        public string HttpPost(string myUri, string myXml, string contentType)
        {
            Uri uri = new Uri(myUri);
            WebRequest myRequest = WebRequest.Create(uri);
            myRequest.ContentType = contentType;
            //myRequest.ContentType = "application/x-www-form-urlencoded";
            myRequest.Method = "POST";

            byte[] bytes = Encoding.ASCII.GetBytes(myXml);
            Stream os = null;

            string err = null;
            try
            { // send the Post
                myRequest.ContentLength = bytes.Length;   //Count bytes to send
                os = myRequest.GetRequestStream();
                os.Write(bytes, 0, bytes.Length);         //Send it
            }
            catch (WebException ex)
            {
                err = "Input=" + ex.Message;
            }
            finally
            {
                if (os != null)
                { os.Close(); }
            }

            try
            { // get the response
                WebResponse myResponse = myRequest.GetResponse();
                if (myResponse == null)
                { return null; }
                StreamReader sr = new StreamReader(myResponse.GetResponseStream());
                return sr.ReadToEnd().Trim();
            }
            catch (WebException ex)
            {
                err = "Output=" + ex.Message;
            }
            return err;
        } // end HttpPost 
    }
    public class GenericListItem
    {
        public GenericListItem(string value)
        {
            this.Value = value;
        }
        public GenericListItem(string text, string value)
        {
            this.Value = value;
            this.Text = text;
        }
        public string Value { get; set; }
        public string Text { get; set; }

    }
    public class Namespace
    {
        XmlNamespaceManager _nsmrequest;
        XmlAttributeCollection ac;

        public Namespace()
        {

        }

        public XmlNamespaceManager LoadNamespaces(XmlDocument data)
        {
            _nsmrequest = new XmlNamespaceManager(data.NameTable);
            ac = data.DocumentElement.Attributes;
            foreach (XmlAttribute a in ac)
            {
                if (a.Name.Split(':').Count() > 1)
                    _nsmrequest.AddNamespace(a.Name.Split(':')[1], a.Value);
            }

            return _nsmrequest;
        }


    }
}
