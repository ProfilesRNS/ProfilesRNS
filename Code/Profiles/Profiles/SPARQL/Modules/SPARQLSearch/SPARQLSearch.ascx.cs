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
using System.Web.UI;
using System.Web.UI.WebControls;

using Profiles.Framework.Utilities;

namespace Profiles.Search.Modules.SPARQLSearch
{
    public partial class SPARQLSearch : System.Web.UI.UserControl
    { 
        
        public SPARQLSearch() { }
        public SPARQLSearch(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)            
        {     
          
        }
        

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                txtQuery.Text = "PREFIX core: <http://vivoweb.org/ontology/core#>" +
                "PREFIX foaf: <http://xmlns.com/foaf/0.1/>" +
                "SELECT DISTINCT ?p ?o " +
                "WHERE { " +
                "   ?s foaf:firstName \"Griffin\" . " +
                "   ?s foaf:lastName \"Weber\" . " +
                "   ?s ?p ?o" +
                "}";
            }
        }

        protected void cmdRun_Click(object sender, EventArgs e)
        {
            txtResults.Text = this.QueryAPI(txtQuery.Text.Trim());
        }

        public string QueryAPI(string request)
        {

            Framework.Utilities.DebugLogging.Log(request);

            string result = string.Empty;
            string _xml = string.Empty;
            XmlDocument resultdata = new XmlDocument();

            request = "<query-request><query>" + Server.HtmlEncode(request) + "</query></query-request>";

            try
            {
                _xml = request.Trim();
                Framework.Utilities.DebugLogging.Log("LOADING " + _xml);
                HttpWebRequest _request = null;
                string s = ConfigurationManager.AppSettings["SPARQLEndPoint"].ToString().Trim();
                Framework.Utilities.DebugLogging.Log("URI " + s);
                _request = (HttpWebRequest)WebRequest.Create(s);

                _request.Method = "POST";
                _request.ContentType = "text/xml";
                _request.ContentLength = _xml.Length;
                using (Stream writeStream = _request.GetRequestStream())
                {
                    UTF8Encoding encoding = new UTF8Encoding();
                    byte[] bytes = encoding.GetBytes(_xml);
                    writeStream.Write(bytes, 0, bytes.Length);
                }

                using (HttpWebResponse response = (HttpWebResponse)_request.GetResponse())
                {
                    using (Stream responseStream = response.GetResponseStream())
                    {
                        using (StreamReader readStream = new StreamReader(responseStream, Encoding.UTF8))
                        {
                            result = readStream.ReadToEnd();
                        }
                    }
                }

                Framework.Utilities.DebugLogging.Log(result);

            }
            catch (Exception ex)
            {
                
                result = ex.Message;
                Framework.Utilities.DebugLogging.Log(result);
               Framework.Utilities.DebugLogging.Log(ex.Message + " ++ " + ex.StackTrace);
            }

            if (result == string.Empty)
            {
                result = "Check the query syntax " + result;
            }
            else
            {
                try
                {
                    resultdata.LoadXml(result);

                    result = resultdata.InnerXml;
                }
                catch (Exception ex) { Framework.Utilities.DebugLogging.Log(ex.Message); }
            }



            return result;

        }

    }
}