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
namespace Profiles.History.Modules.HistoryByType
{
    public partial class HistoryByType : System.Web.UI.UserControl
    {

        List<HistoryItem> hi;
        protected void Page_Load(object sender, EventArgs e)
        {
            DrawProfilesModule();
        }
        public HistoryByType() { }
        public HistoryByType(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
        {


        }

        private void DrawProfilesModule()
        {
            UserHistory uh = new UserHistory();
            List<string> types;
            types = new List<string>();
            hi = uh.GetItems();

            if (hi == null)
                Response.Redirect(Root.Domain + "/search",true);


            foreach (HistoryItem item in hi)
            {
                string hiremove;

                foreach (string s in item.Types)
                {
                    hiremove = types.Find(delegate(string hiremoveitem) { return hiremoveitem == s; });
                    if (hiremove.IsNullOrEmpty())
                        types.Add(s);

                }
            }


            rptHistory.DataSource = types;
            rptHistory.DataBind();

        }

        protected void rptHistoryTypes_OnItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            Literal litHistoryItem = (Literal)e.Item.FindControl("litHistoryItem");
            HistoryItem hi = (HistoryItem)e.Item.DataItem;

            if (hi != null || litHistoryItem != null)
            {
                litHistoryItem.Text = "<a href='" + hi.URI + "'>" + hi.ItemLabel + "</a>";
            }

        }



        protected void rptHistory_OnItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            Repeater rptHistoryTypes = (Repeater)e.Item.FindControl("rptHistoryTypes");
            Literal litType = (Literal)e.Item.FindControl("litType");
            string type = (string)e.Item.DataItem;
            List<HistoryItem> itemsbytype = new List<HistoryItem>();

            if (!type.IsNullOrEmpty())
            {
                foreach (HistoryItem historyitem in this.hi)
                {
                    if (historyitem.Types.Contains(type))
                        itemsbytype.Add(historyitem);
                }



                if (hi != null || rptHistoryTypes != null)
                {
                    litType.Text = "<b>" + type + "</b>";
                    rptHistoryTypes.DataSource = itemsbytype;
                    rptHistoryTypes.DataBind();

                }
            }
        }






    }
}