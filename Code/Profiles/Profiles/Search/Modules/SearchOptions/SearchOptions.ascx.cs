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

namespace Profiles.Search.Modules.SearchOptions
{
    public partial class SearchOptions : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            BuildLinks();
        }

         public SearchOptions() { }
         public SearchOptions(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
        {
            this.SearchData = pagedata;
        }
         private void BuildLinks()
         {             
             litModifySearch.Text = "<a href='" + Root.Domain + "/search/people/modify/" + Request.QueryString["queryid"] + "'>" + "Modify Search" + "</a>";


             string searchfor = Request.QueryString["searchfor"];
             litSearchOtherInstitutions.Text = "<a href='" + Root.Domain + "/direct/default.aspx?keyword=" + Request.QueryString["searchfor"] + "'>" + "Search Other Institutions" + "</a>";             

         }

         private XmlDocument SearchData { get; set; }

    }
}