using Profiles.Framework.Utilities;
using System;
using System.Collections.Generic;
using System.Xml;
using Newtonsoft.Json;
using System.Web.UI.WebControls;
using System.Text.RegularExpressions;
using Profiles.Profile.Modules;

namespace Profiles.Edit.Modules.CustomEditSocialMediaPlugIns
{
    public partial class FeaturedVideos : BaseSocialMediaModule
    {
        private string data = string.Empty;
        public FeaturedVideos() : base() { }
        public FeaturedVideos(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
            : base(pagedata, moduleparams, pagenamespaces)
        {

            SessionManagement sm = new SessionManagement();
            securityOptions.Subject = base.SubjectID;
            securityOptions.PredicateURI = base.PredicateURI.Replace("!", "#");
            securityOptions.PrivacyCode = Convert.ToInt32(base.PropertyListXML.SelectSingleNode("PropertyList/PropertyGroup/Property/@ViewSecurityGroup").Value);
            securityOptions.SecurityGroups = new XmlDocument();
            securityOptions.SecurityGroups.LoadXml(base.PresentationXML.DocumentElement.LastChild.OuterXml);
            securityOptions.BubbleClick += SecurityDisplayed;

            this.PlugInName = "FeaturedVideos";
            this.data = Profiles.Framework.Utilities.GenericRDFDataIO.GetSocialMediaPlugInData(this.SubjectID, this.PlugInName);


            litBackLink.Text = "<a href='" + Root.Domain + "/edit/default.aspx?subject=" + this.SubjectID + "'>Edit Menu</a> &gt; <b>" + PropertyListXML.SelectSingleNode("PropertyList/PropertyGroup/Property/@Label").Value + "</b>";


        }
        protected void Page_Load(object sender, EventArgs e)
        {
            ReadJson();
            base.InitUpDownArrows(ref GridViewVideos);
            upnlEditSection.Update();
        }

        private void SecurityDisplayed(object sender, EventArgs e)
        {

            if (Session["pnlSecurityOptions.Visible"] == null)
            {

                pnlAddEdit.Visible = true;
            }
            else
            {
                pnlAddEdit.Visible = false;
            }

            upnlEditSection.Update();
        }
        protected void btnAddEdit_OnClick(object sender, EventArgs e)
        {
            if (Session["pnlImportYouTube.Visible"] == null)
            {
                pnlImportYouTube.Visible = true;
                imbAddArrow.ImageUrl = "~/Framework/Images/icon_squareDownArrow.gif";


                phSecuritySettings.Visible = false;
                Session["pnlImportYouTube.Visible"] = true;
            }
            else
            {
                pnlImportYouTube.Visible = false;
                imbAddArrow.ImageUrl = "~/Framework/Images/icon_squareArrow.gif";
                Session["pnlImportYouTube.Visible"] = null;
                phSecuritySettings.Visible = true;
            }

        }      

        protected void btnSaveAndClose_OnClick(object sender, EventArgs e)
        {
            if (txtURL.Text.Trim() != string.Empty)
            {
                string search = string.Empty;

                string id = hdnURL.Value.Trim();

                if (this.Videos == null) { this.Videos = new List<Video>(); }

                Video vf = this.Videos.Find(f => f.id == id);
                if (vf != null) { this.Videos.Remove(vf); }               


                this.Videos.Add(new Video { id = id, name = txtName.Text, url = txtURL.Text });

                foreach (Video v in this.Videos)
                {
                    search += " " + v.name;
                }


                Profiles.Framework.Utilities.GenericRDFDataIO.AddEditPluginData(this.PlugInName, this.SubjectID, this.SerializeJson(), search);
            }
            ResetDisplay();
        }
      
        protected void btnDeleteCancel_OnClick(object sender, EventArgs e)
        {
            ResetDisplay();
        }
        protected void btnCancel_OnClick(object sender, EventArgs e)
        {
            ResetDisplay();
        }

        private void ResetDisplay()
        {
            phSecuritySettings.Visible = true;
            pnlAddEdit.Visible = true;
            Session["pnlImportYouTube.Visible"] = null;
            txtName.Text = string.Empty;
            txtURL.Text = string.Empty;
            this.data = string.Empty;
            this.Videos = null;


            this.data = Profiles.Framework.Utilities.GenericRDFDataIO.GetSocialMediaPlugInData(this.SubjectID, this.PlugInName);
            
            ReadJson();            
            upnlEditSection.Update();

        }
        private void ReadJson()
        {
            List<Video> videos = JsonConvert.DeserializeObject<List<Video>>(this.data);
            if (videos == null)
            {
                divNoVideos.Visible = true;
                GridViewVideos.Visible = false;
            }
            else
            {
                divNoVideos.Visible = false;
                GridViewVideos.Visible = true;
                GridViewVideos.DataSource = videos;
                GridViewVideos.DataBind();
                base.InitUpDownArrows(ref GridViewVideos);
                this.Videos = videos;
            }
        }
        private string SerializeJson()
        { string rtn = "";  
            //the first video was just added so the Vidoes list is empty
            if(this.Videos.Count == 0 && txtURL.Text.Trim() != string.Empty && txtName.Text != string.Empty)
            {                
                this.data = "[{\"name\":\"" + txtName.Text.Trim() + "\",\"id\":\""+ txtURL.Text.Trim().Split('=')[1] + "\",\"url\":\"" + txtURL.Text.Trim() + "\"}]";
                this.ReadJson();
            }

            rtn = Regex.Replace(JsonConvert.SerializeObject(this.Videos, Newtonsoft.Json.Formatting.Indented), @"\t|\n|\r", "");

            return rtn.Replace("[]","");  // make it empty if its empty json
        }
        
    


        #region "Grid"
        protected void GridViewVideos_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            TextBox txtVideoDescription = null;
            Literal litPreview = null;
            ImageButton lnkEdit = null;
            ImageButton lnkDelete = null;
            e.Row.Cells[1].Attributes.Add("style", "width:200px;text-align:center;padding-top:7px;");          


            Video videostate = null;
            videostate = (Video)e.Row.DataItem;

            if (e.Row.RowType == DataControlRowType.DataRow)
            {

                litPreview = (Literal)e.Row.Cells[1].FindControl("litPreview");

                lnkEdit = (ImageButton)e.Row.Cells[2].FindControl("lnkEdit");
                lnkDelete = (ImageButton)e.Row.Cells[2].FindControl("lnkDelete");


                litPreview.Text = "<iframe width=\"125px\" height=\"75px\"  src=\"https://www.youtube.com/embed/" + videostate.id + "?autoplay=0&rel=0\"></iframe>";
            }

            if (e.Row.RowType == DataControlRowType.DataRow && (e.Row.RowState & DataControlRowState.Edit) == DataControlRowState.Edit)
            {
                txtVideoDescription = (TextBox)e.Row.Cells[0].FindControl("txtVideoDescription");
                txtVideoDescription.Text = videostate.name;

                litPreview.Text = "<iframe width=\"125px\" height=\"75px\" border=\"0px\"  src=\"https://www.youtube.com/embed/" + videostate.id + "?autoplay=0&rel=0\"></iframe>";
            }
        }
        protected void GridViewVideos_RowEditing(object sender, GridViewEditEventArgs e)
        {
            GridViewVideos.EditIndex = e.NewEditIndex;
            ReadJson();
            upnlEditSection.Update();
        }
        protected void GridViewVideos_RowUpdated(object sender, GridViewUpdatedEventArgs e)
        {
            ResetDisplay();
            base.InitUpDownArrows(ref GridViewVideos);
            upnlEditSection.Update();
        }
        protected void GridViewVideos_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            TextBox txtURL = (TextBox)GridViewVideos.Rows[e.RowIndex].FindControl("txtURL");
            TextBox txtVideoDescription = (TextBox)GridViewVideos.Rows[e.RowIndex].FindControl("txtVideoDescription");

            string data = GridViewVideos.DataKeys[e.RowIndex].Values[1].ToString();
            var found = this.Videos.Find(f => f.id == data);

            found.name = txtVideoDescription.Text;

            string search = string.Empty;
            foreach (Video v in this.Videos)
            {
                search += " " + v.name;
            }
            //this needs to be the json desz'd
            Profiles.Framework.Utilities.GenericRDFDataIO.AddEditPluginData(this.PlugInName, this.SubjectID, this.SerializeJson(), search);
            ResetDisplay();

            GridViewVideos.EditIndex = -1;
            ResetDisplay();
            upnlEditSection.Update();
        }
        protected void GridViewVideos_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            GridViewVideos.EditIndex = -1;

            ResetDisplay();
            upnlEditSection.Update();
        }
        protected void GridViewVideos_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            string name = GridViewVideos.DataKeys[e.RowIndex].Values[0].ToString();
            string url = GridViewVideos.DataKeys[e.RowIndex].Values[2].ToString();
            string id = GridViewVideos.DataKeys[e.RowIndex].Values[1].ToString();


            var found = this.Videos.Find(x => x.id == id);
            if (found != null) this.Videos.Remove(found);

            string search = string.Empty;
            foreach (Video v in this.Videos)
            {
                search += " " + v.name;
            }
            //this needs to be the json desz'd
            Profiles.Framework.Utilities.GenericRDFDataIO.AddEditPluginData(this.PlugInName, this.SubjectID, this.SerializeJson(), search);
            if (GridViewVideos.Rows.Count == 1) //they just deleted their last row
                Profiles.Framework.Utilities.GenericRDFDataIO.RemovePluginData(this.PlugInName, this.SubjectID);

            ResetDisplay();
            base.InitUpDownArrows(ref GridViewVideos);
            upnlEditSection.Update();
        }
        protected void ibUp_Click(object sender, EventArgs e)
        {

            GridViewRow row = ((ImageButton)sender).DataItemContainer as GridViewRow;

            GridViewVideos.EditIndex = -1;
            int newIndex = row.RowIndex - 1;
            int oldIndex = row.RowIndex;

            var item = this.Videos[oldIndex];

            this.Videos.RemoveAt(oldIndex);
            this.Videos.Insert(newIndex, item);
            string search = string.Empty;
            foreach (Video v in this.Videos)
            {
                search += " " + v.name;
            }
            Profiles.Framework.Utilities.GenericRDFDataIO.AddEditPluginData(this.PlugInName, this.SubjectID, this.SerializeJson(), search);

            SerializeJson();
            ResetDisplay();

        }
        protected void ibDown_Click(object sender, EventArgs e)
        {
            GridViewRow row = ((ImageButton)sender).DataItemContainer as GridViewRow;
            GridViewVideos.EditIndex = -1;

            int newIndex = row.RowIndex+1;
            int oldIndex = row.RowIndex;

            var item = this.Videos[oldIndex];

            this.Videos.RemoveAt(oldIndex);            
            this.Videos.Insert(newIndex, item);

            string search = string.Empty;
            foreach (Video v in this.Videos)
            {
                search += " " + v.name;
            }
            Profiles.Framework.Utilities.GenericRDFDataIO.AddEditPluginData(this.PlugInName, this.SubjectID, this.SerializeJson(), search);

            ResetDisplay();
        }
        #endregion
        private List<Video> Videos { get; set; }
    }

    public class Video
    {
        public string name { get; set; }
        public string id { get; set; }
        public string url { get; set; }


    }
}