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
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Xml;
using System.Web.UI.WebControls;
using System.IO;
using System.Web.UI.HtmlControls;

using Profiles.ORNG.Utilities;
using System.Configuration;
using System.Net;

namespace Profiles.ORNG
{
    public partial class JsonAPI : System.Web.UI.Page
    {

        private static string jsonld;

        static JsonAPI()
        {
            jsonld = File.ReadAllText(AppDomain.CurrentDomain.BaseDirectory + "/ORNG/JavaScript/jsonld-helper.js");
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            string subject = Request["subject"];
            string predicate = Request["predicate"];
            string obj = Request["object"];
            string person = Request["person"];
            string expand = Request["expand"];
            string showDetails = Request["showdetails"];
            string callback = Request["callback"];

            Int64 nodeid = -1;
            if (subject != null)
            {
                nodeid = Convert.ToInt64(subject);
            }
            else if (person != null)
            {
                nodeid = new DataIO().GetNodeId(Convert.ToInt32(person));
            }

            Response.Clear();
            Response.Charset = "charset=UTF-8";
            Response.StatusCode = Convert.ToInt16("200");

            string URL = Profiles.Framework.Utilities.Root.Domain + "/Profile/Profile.aspx?Subject=" + nodeid;
            if (predicate != null) 
                URL += "&Predicate=" + predicate;
            if (obj != null) 
                URL += "&Object=" + obj;
            if (expand != null) 
                URL += "&Expand=" + expand;
            if (showDetails != null) 
                URL += "&ShowDetails=" + showDetails;
            URL = ConfigurationManager.AppSettings["ORNG.ShindigURL"] + "/rest/rdf?userId=" + HttpUtility.UrlEncode(URL);

            WebClient client = new WebClient();
            String jsonProfiles = client.DownloadString(URL);
            if (callback != null && callback.Length > 0)
            {
                Response.ContentType = "application/javascript";
                Response.Write(jsonld + Environment.NewLine + callback + "(orng.rdf.deserialize('" + Profiles.Framework.Utilities.Root.Domain + "/profile/" + nodeid + "'," + jsonProfiles + "));");
            }
            else
            {
                Response.ContentType = "application/ld+json";
                Response.Write(jsonProfiles);
            }
        }
    }

}
