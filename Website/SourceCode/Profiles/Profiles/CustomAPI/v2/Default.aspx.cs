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
using System.Web.UI.WebControls;
using System.Xml;
using System.Net;
using System.IO;
using System.Text;
using System.Runtime.Serialization;
using System.Configuration;
using Profiles.Framework.Utilities;

using Profiles.Profile.Utilities;

namespace Profiles.CustomAPI
{
    public partial class Default : System.Web.UI.Page
    {
        // add smart caching of all of these ID lookups!
        protected void Page_Load(object sender, EventArgs e)
        {
            string PersonId = Request["Person"];
            string EmployeeID = Request["EmployeeID"];
            string FNO = Request["FNO"];
            string Subject = Request["Subject"];
            string PrettyURL = Request["PrettyURL"];
            string Expand = Request["Expand"];
            string ShowDetails = Request["ShowDetails"];
            string callback = Request["callback"];

            Int64 nodeid = -1;
            if (Subject != null)
            {
                nodeid = Convert.ToInt64(Subject);
            }
            else if (PrettyURL != null)
            {
                nodeid = Framework.Utilities.UCSFIDSet.ByPrettyURL[PrettyURL.ToLower()].NodeId;
            }
            else 
            {
                Profiles.CustomAPI.Utilities.DataIO data = new Profiles.CustomAPI.Utilities.DataIO();
                int personid = -1;
                if (PersonId != null)
                {
                    personid = Convert.ToInt32(PersonId);
                }
                else if (FNO != null)
                {
                    personid = (int)Profiles.Framework.Utilities.UCSFIDSet.ByFNO[FNO.ToLower()].PersonId;
                }
                else if (EmployeeID != null)
                {
                    personid = (int)Profiles.Framework.Utilities.UCSFIDSet.ByEmployeeID[EmployeeID].PersonId;
                }
                nodeid = Framework.Utilities.UCSFIDSet.ByPersonId[personid].NodeId;
            }
            RDFTriple request = new RDFTriple(nodeid);


            //The system default is True and True for showdetails and expand, but if its an external page call to this page, 
            //then its set to false for expand.           
            if (Expand != null)
            {
                request.Expand = Convert.ToBoolean(Expand);
            }
            else
            {
                request.Expand = false;
            }


            if (ShowDetails != null)
            {
                request.ShowDetails = Convert.ToBoolean(ShowDetails);
            }
            else
            {
                request.ShowDetails = false;
            }

            Response.Clear();
            Response.Charset = "charset=UTF-8";
            Response.StatusCode = Convert.ToInt16("200");

            if ("JSON-LD".Equals(Request["Format"]))
            {
                string URL = ConfigurationManager.AppSettings["OpenSocial.ShindigURL"] + "/rest/rdf?userId=" +
                    HttpUtility.UrlEncode(Root.Domain + "/CustomAPI/v2/Default.aspx?Subject=" + nodeid + "&Expand=" + request.Expand + "&ShowDetails=" + request.ShowDetails);
                WebClient client = new WebClient();
                String jsonProfiles = client.DownloadString(URL);
                if (callback != null && callback.Length > 0)
                {
                    Response.ContentType = "application/javascript";
                    Response.Write(callback + "(" + jsonProfiles + ");");
                }
                else
                {
                    Response.ContentType = "application/json";
                    Response.Write(jsonProfiles);
                }
            }
            else
            {
                Response.ContentType = "text/xml";//"application/rdf+xml";
                Response.Write(new Profiles.Profile.Utilities.DataIO().GetRDFData(request).InnerXml);
            }
        }
    }
}
