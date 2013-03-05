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

namespace Profiles.Framework.Modules.MainMenu
{
    public partial class SetActiveNetworks : System.Web.UI.UserControl
    {
        SessionManagement sm;
        protected void Page_Init(object sender, EventArgs e)
        {
            sm = new SessionManagement();

            DrawProfilesModule();


        }

        private void DrawProfilesModule()
        {

            Utilities.DataIO data = new Profiles.Framework.Utilities.DataIO();
            SqlDataReader reader;

            List<NetworkItem> networkitem = new List<NetworkItem>();

            this.RelationshipTypes = new List<RelationshipType>();

            Int64 subject = 0;

            if (HttpContext.Current.Request.QueryString["subject"] != null)
            {
                subject = Convert.ToInt64(HttpContext.Current.Request.QueryString["subject"]);
            }

            if (sm.Session().UserID != 0)
            {
                if (subject != sm.Session().NodeID && subject != 0 && (!Root.AbsolutePath.Contains("/proxy") && !Root.AbsolutePath.Contains("/edit")))
                {
                    reader = data.GetActiveNetwork(subject, true);

                    while (reader.Read())
                    {
                        this.RelationshipTypes.Add(new RelationshipType(reader["RelationshipName"].ToString(), reader["RelationshipType"].ToString(), Convert.ToBoolean(reader["DoesExist"])));

                    }
                    if (RelationshipTypes.Count > 0)
                    {
                        rptRelationshipTypes.DataSource = this.RelationshipTypes;
                        rptRelationshipTypes.DataBind();
                        pnlSetActiveNetworks.Visible = true;
                    }
                    else
                    {
                        pnlSetActiveNetworks.Visible = false;
                    }
                }
                else
                {
                    pnlSetActiveNetworks.Visible = false;
                }
            }

            reader = data.GetActiveNetwork(0, false);

            while (reader.Read())
            {
                networkitem.Add(new NetworkItem(reader[1].ToString(), Convert.ToInt64(reader[2]), reader[3].ToString()));
            }

            if (!reader.IsClosed)
                reader.Close();

            if (networkitem.Count > 0)
            {
                gvActiveNetwork.DataSource = networkitem;
                gvActiveNetwork.DataBind();

                pnlMyNetwork.Visible = true;

                litActiveNetworkDetails.Text = "<a class='activeSectionDetails' href='" + Root.Domain + "/activenetwork/default.aspx'><font style='font-size:10px'>View Details</font></a>";
            }
            else
            {
                pnlMyNetwork.Visible = false;
            }


        }

        protected void gvActiveNetwork_OnRowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                NetworkItem networkitem = (NetworkItem)e.Row.DataItem;
                Literal lbPerson = (Literal)e.Row.FindControl("lbPerson");
                ImageButton ibRemove = (ImageButton)e.Row.FindControl("ibRemove");
                ibRemove.CommandArgument = networkitem.NodeID.ToString();
                ibRemove.ImageUrl = Root.Domain + "/Framework/Images/delete.png";
                lbPerson.Text = "<a href='" + networkitem.URI + "'>" + networkitem.Name + "</a>";
            }
        }

        protected void ibRemove_OnClick(object sender, EventArgs e)
        {
            ImageButton remove = (ImageButton)sender;

            Utilities.DataIO data = new Profiles.Framework.Utilities.DataIO();

            data.SetActiveNetwork(Convert.ToInt64(remove.CommandArgument), null, false);

            this.DrawProfilesModule();
            // upUpdate.Update();
        }

        protected void rptRelationshipTypes_ItemBound(object sender, RepeaterItemEventArgs e)
        {
            RelationshipType rt = (RelationshipType)e.Item.DataItem;

            CheckBox cb = (CheckBox)e.Item.FindControl("chkRelationshipType");

            cb.Text = rt.Text;
            cb.Checked = rt.Selected;
            cb.Attributes.Add("onclick", "JavaScript:ShowStatus();");

        }
        private List<RelationshipType> RelationshipTypes { get; set; }

        protected void chkRelationshipTypes_OnCheckedChanged(object sender, EventArgs e)
        {
            CheckBox cb = (CheckBox)sender;

            Utilities.DataIO data = new Profiles.Framework.Utilities.DataIO();
            data.SetActiveNetwork(Convert.ToInt64(HttpContext.Current.Request.QueryString["subject"]), this.FindRelationshipType(cb.Text).Value, cb.Checked);
            this.DrawProfilesModule();
        }

        private RelationshipType FindRelationshipType(string relationshipname)
        {
            RelationshipType rt;
            rt = this.RelationshipTypes.Find(delegate(RelationshipType rtt) { return rtt.Text == relationshipname; });
            return rt;
        }

        public class RelationshipType
        {
            public RelationshipType(string text, string value, bool selected)
            {
                this.Text = text;
                this.Value = value;
                this.Selected = selected;
            }
            public string Text { get; set; }
            public string Value { get; set; }
            public bool Selected { get; set; }

        }
        public class NetworkItem
        {
            public NetworkItem(string name, Int64 nodeid, string uri)
            {
                this.Name = name;
                this.NodeID = nodeid;
                this.URI = uri;
            }

            public string Name { get; set; }
            public Int64 NodeID { get; set; }
            public string URI { get; set; }

        }

        public string ClassURI { get; set; }


    }





}