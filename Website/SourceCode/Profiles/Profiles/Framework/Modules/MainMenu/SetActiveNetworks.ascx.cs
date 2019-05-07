/*  
 
    Copyright (c) 2008-2012 by the President and Fellows of Harvard College. All rights reserved.  
    Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
    and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
    National Center for Research Resources and Harvard University.


    Code licensed under a BSD License. 
    For details, see: LICENSE.txt 
  
*/

using System;
using System.Web;
using System.Web.UI.WebControls;
using Profiles.Framework.Utilities;
using Profiles.ActiveNetwork.Modules.MyNetwork;

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
            //Int64 subject = 0;

            if (HttpContext.Current.Request.QueryString["subject"] != null)
            {
                this.Subject = Convert.ToInt64(HttpContext.Current.Request.QueryString["subject"]);
            }

            hdSubject.Value = this.Subject.ToString();

            if (sm.Session().UserID != 0)
            {
                if (this.Subject != sm.Session().NodeID && (!Root.AbsolutePath.Contains("/proxy") && !Root.AbsolutePath.Contains("/edit") && !Root.AbsolutePath.Contains("/search") && !Root.AbsolutePath.Contains("/activenetwork") && !Root.AbsolutePath.Contains("/about") && !Root.AbsolutePath.Contains("/history")))
                {
                    int count = RelationshipTypeUtils.GetRelationshipTypes(Convert.ToInt64(Subject)).Count;

                    if (count > 0)
                    { 
                        rptRelationshipTypes.DataSource = RelationshipTypeUtils.GetRelationshipTypes(Convert.ToInt64(Subject)) ;
                        rptRelationshipTypes.DataBind();
                        this.Count = count;
                    }
                }
            }
        }

        protected void rptRelationshipTypes_ItemBound(object sender, RepeaterItemEventArgs e)
        {
            RelationshipType rt = (RelationshipType)e.Item.DataItem;          

            CheckBox cb = (CheckBox)e.Item.FindControl("chkRelationshipType");

            cb.Text = rt.Text;
            cb.Checked = rt.Selected;         
                        

        }

     
      

        public string ClassURI { get; set; }

        public int Count { get; set; }
        public Int64 Subject
        {
            get
            {
                return Convert.ToInt64(Session["NETWORK"]);
            }
            set { Session.Add("NETWORK", value); }
        }



    }

}