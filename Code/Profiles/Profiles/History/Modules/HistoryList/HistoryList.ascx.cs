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
using System.Data.SqlClient;


using Profiles.Profile.Utilities;
using Profiles.Framework.Utilities;
namespace Profiles.History.Modules.HistoryList
{
    public partial class HistoryList : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            DrawProfilesModule();
        }
        public HistoryList() { }
        public HistoryList(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
        {


        }
        private void DrawProfilesModule()
        {
            UserHistory uh = new UserHistory();
            List<HistoryItem> hi = uh.GetItems();

            if (hi==null)
                Response.Redirect(Root.Domain + "/search", true);
                        
            rptHistory.DataSource = hi;
            rptHistory.DataBind();

        }

        protected void rptHistory_OnItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            Literal litHistory = (Literal)e.Item.FindControl("litHistory");
            HistoryItem hi = (HistoryItem)e.Item.DataItem;


            if (hi != null || litHistory != null)
            {

                litHistory.Text = "<a href='" + hi.URI + "'>" + hi.ItemLabel + "</a>";

            }
                




        }


    }





}