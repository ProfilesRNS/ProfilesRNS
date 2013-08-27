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
namespace Profiles.ActiveNetwork.Modules.MyNetwork
{
    public partial class MyNetwork : System.Web.UI.UserControl
    {

        SessionManagement sm;
        protected void Page_Load(object sender, EventArgs e)
        {
            sm = new SessionManagement();

            if (sm.Session().UserID == 0)
                Response.Redirect(Root.Domain + "/search");

            
            DrawProfilesModule();

        }

        public MyNetwork() { }
        public MyNetwork(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
        {

        }




        private void DrawProfilesModule()
        {
            SqlDataReader reader;
            Framework.Utilities.DataIO data = new Profiles.Framework.Utilities.DataIO();
            List<NetworkItem> ni = new List<NetworkItem>();
            List<NetworkItem> nibinder;

            reader = data.GetActiveNetwork(0, true);


            while (reader.Read())
            {
                ni.Add(new NetworkItem(reader["URI"].ToString(),
                    reader["Name"].ToString(),
                    Convert.ToInt64(reader["NodeID"]),
                    reader["RelationshipType"].ToString(),
                    reader["RelationshipName"].ToString()));
            }




            nibinder = this.GetItems("Collaborator", ni);
            litCollaborators.Text = "<b>Collaborators</b> (" + nibinder.Count.ToString() + ")";
            gvCollaborators.DataSource = nibinder;
            gvCollaborators.DataBind();

            nibinder = this.GetItems("CurrentAdvisor", ni);
            litAdvisorsCurrent.Text = "<b>Advisor (Current)</b> (" + nibinder.Count.ToString() + ")";
            gvAdvisorsCurrent.DataSource = nibinder;
            gvAdvisorsCurrent.DataBind();
            nibinder = new List<NetworkItem>();

            nibinder = this.GetItems("CurrentAdvisee", ni);
            litAdviseesCurrent.Text = "<b>Advisee (Current)</b> (" + nibinder.Count.ToString() + ")";
            gvAdviseesCurrent.DataSource = nibinder;
            gvAdviseesCurrent.DataBind();
            nibinder = new List<NetworkItem>();

            nibinder = this.GetItems("PastAdvisor", ni);
            litAdvisorsPast.Text = "<b>Advisor (Past)</b> (" + nibinder.Count.ToString() + ")";
            gvAdvisorsPast.DataSource = nibinder;
            gvAdvisorsPast.DataBind();
            nibinder = new List<NetworkItem>();

            nibinder = this.GetItems("PastAdvisee", ni);
            litAdviseesPast.Text = "<b>Advisee (Past)</b> (" + nibinder.Count.ToString() + ")";
            gvAdviseesPast.DataSource = nibinder;
            gvAdviseesPast.DataBind();


        }



        private List<NetworkItem> GetItems(string RelationshipType, List<NetworkItem> nibinder)
        {
            List<NetworkItem> rtnni = new List<NetworkItem>();

            foreach (NetworkItem ni in nibinder)
            {
                if (ni.RelationshipType.ToLower() == RelationshipType.ToLower())
                    rtnni.Add(new NetworkItem(ni.URI, ni.Name, ni.NodeID, ni.RelationshipType, ni.RelationshipName));
            }

            return rtnni;
        }


        protected void gvActiveNetwork_OnRowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                NetworkItem networkitem = (NetworkItem)e.Row.DataItem;
                Literal lbPerson = (Literal)e.Row.FindControl("lbPerson");
                ImageButton ibRemove = (ImageButton)e.Row.FindControl("ibRemove");
                ibRemove.CommandArgument = networkitem.NodeID.ToString();
                ibRemove.CommandName = networkitem.RelationshipType;
                lbPerson.Text = "<a href='" + networkitem.URI + "'>" + networkitem.Name + "</a>";
            }

        }



        protected void ibRemove_OnClick(object sender, EventArgs e)
        {
            ImageButton remove = (ImageButton)sender;

            Framework.Utilities.DataIO data = new Profiles.Framework.Utilities.DataIO();

            data.SetActiveNetwork(Convert.ToInt64(remove.CommandArgument), remove.CommandName, false);

            this.DrawProfilesModule();
        }

        private Int64 Subject { get; set; }


        private class NetworkItem
        {
            public NetworkItem(string uri, string name, Int64 nodeid, string relationshiptype, string relationshipname)
            {
                this.URI = uri;
                this.Name = name;
                this.NodeID = nodeid;
                this.RelationshipName = relationshipname;
                this.RelationshipType = relationshiptype;

            }

            public string URI { get; set; }
            public string Name { get; set; }
            public Int64 NodeID { get; set; }
            public string RelationshipType { get; set; }
            public string RelationshipName { get; set; }

        }

    }
}