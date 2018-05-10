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
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using Profiles.Framework.Utilities;
using System.Web.UI.HtmlControls;

namespace Profiles.Activity.Modules.ActivityHistory
{
    public partial class ActivityHistory : BaseModule
    {
        
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        public ActivityHistory() { }

        public ActivityHistory(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
            : base(pagedata, moduleparams, pagenamespaces)
        {
            DrawProfilesModule(); 
        }

        public void setModuleParams(List<ModuleParams> moduleparams)
        {
            base.ModuleParams = moduleparams;
        }

        public void DrawProfilesModule()
        {
            LoadAssets();
            int count = Convert.ToInt32(base.GetModuleParamString("Show"));
            linkSeeMore.Visible = "True".Equals(base.GetModuleParamString("SeeMore"));
            if ("True".Equals(base.GetModuleParamString("Scrolling"))) 
            {
                pnlActivities.ScrollBars = ScrollBars.Vertical;
                pnlActivities.Height = 7 * count;
                pnlActivities.Attributes.Add("onscroll", "ScrollAlert()");
            }
            else 
            {
                pnlActivities.ScrollBars = ScrollBars.None;
            }

            // grab a bunch of activities from the Database
            Profiles.Activity.Utilities.DataIO data = new Profiles.Activity.Utilities.DataIO();
            List<Profiles.Activity.Utilities.Activity> activities = data.GetActivity(-1, count, true);
            rptActivityHistory.DataSource = activities;
            rptActivityHistory.DataBind();
        }

        public void rptActivityHistory_OnItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            Profiles.Activity.Utilities.Activity activity = (Profiles.Activity.Utilities.Activity)e.Item.DataItem;
            if (activity != null)
            {
                HyperLink linkThumbnail = (HyperLink)e.Item.FindControl("linkThumbnail");
                HyperLink linkProfileURL = (HyperLink)e.Item.FindControl("linkProfileURL");
                Literal litDate = (Literal)e.Item.FindControl("litDate");
                Literal litMessage = (Literal)e.Item.FindControl("litMessage");
                Literal litId = (Literal)e.Item.FindControl("litId");

                linkThumbnail.ImageUrl = activity.Profile.Thumbnail;
                linkThumbnail.NavigateUrl = activity.Profile.URL;
                linkProfileURL.NavigateUrl = activity.Profile.URL;
                linkProfileURL.Text = activity.Profile.Name;

                litDate.Text = activity.Date;
                litMessage.Text = activity.Message;
                litId.Text = "" + activity.Id;
            }
        }

        // return an empty string for false so that Javscript will interpret it correctly
        public string FixedSize()
        {
            return "True".Equals(base.GetModuleParamString("Scrolling")) ? "" : "True";
        }

        public string GetURLDomain()
        {
            return Root.Domain;
        }

        private void LoadAssets()
        {
            HtmlLink Searchcss = new HtmlLink();
            Searchcss.Href = Root.Domain + "/Activity/CSS/activity.css";
            Searchcss.Attributes["rel"] = "stylesheet";
            Searchcss.Attributes["type"] = "text/css";
            Searchcss.Attributes["media"] = "all";
            Page.Header.Controls.Add(Searchcss);

            // Inject script into HEADER
            Literal script = new Literal();
            script.Text = "<script>var _path = \"" + Root.Domain + "\";</script>";
            Page.Header.Controls.Add(script);
        }
    }
}