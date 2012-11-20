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
using System.Xml.Xsl;
using System.Web.UI.HtmlControls;


using Profiles.Framework.Utilities;
using Profiles.Search.Utilities;

namespace Profiles.Search.Modules.KeywordConnection
{
    public partial class KeywordConnection : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            DrawProfilesModule();
        }
        public KeywordConnection() { }
        public KeywordConnection(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)            
        {
            this.SearchData = pagedata;
        }

        public XmlDocument SearchData { get; set; }


        private void DrawProfilesModule()
        {

            XsltArgumentList args = new XsltArgumentList();

            args.AddParam("root", "", Root.Domain);

            Search.Utilities.APISearchRequest apisearch = new APISearchRequest();
            Search.Utilities.DataIO data = new Profiles.Search.Utilities.DataIO();

            string queryid = string.Empty;
            string keyword = string.Empty;
            string personid = string.Empty;
            string nodeid = string.Empty;

            //I dont know what the root of /people should return so for now I require the queryid
            if (Request.QueryString["queryid"] != null)
            {
                queryid = Request.QueryString["queryid"].ToString().Trim();
                
            }

            if (Request.QueryString["nodeid"] != null)
            {
                nodeid = Request.QueryString["nodeid"].ToString().Trim();

            }

            keyword = data.KeyKeyword(queryid);
            personid = data.PersonID(queryid, nodeid);


            this.SearchData = apisearch.Execute(queryid, keyword, personid);
            

            litKeywordConnection.Text = XslHelper.TransformInMemory(Server.MapPath("~/Search/Modules/KeywordConnection/KeywordConnection.xslt"), args, this.SearchData.OuterXml);
}
    }
}