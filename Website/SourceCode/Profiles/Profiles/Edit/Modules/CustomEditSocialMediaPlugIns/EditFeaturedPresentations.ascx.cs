using System;
using System.Collections.Generic;
using System.Xml;
using Profiles.Framework.Utilities;
using System.Web.UI.HtmlControls;
using Newtonsoft.Json;
using System.IO;
using System.Net;
using System.Text;
using System.Web.Script.Serialization;
using System.Web;
using Profiles.Profile.Modules;

namespace Profiles.Edit.Modules.EditSocialMedia.FeaturedPresentations
{
    public partial class FeaturedPresentations : BaseSocialMediaModule
    {
        Boolean dataexists = false;
        string data = string.Empty;
        public FeaturedPresentations() : base() { }
        public FeaturedPresentations(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
            : base(pagedata, moduleparams, pagenamespaces)
        {
            SessionManagement sm = new SessionManagement();
            securityOptions.Subject = base.SubjectID;
            securityOptions.PredicateURI = base.PredicateURI.Replace("!", "#");            
            securityOptions.PrivacyCode = Convert.ToInt32(base.PropertyListXML.SelectSingleNode("PropertyList/PropertyGroup/Property/@ViewSecurityGroup").Value);
            securityOptions.SecurityGroups = new XmlDataDocument();
            securityOptions.SecurityGroups.LoadXml(base.PresentationXML.DocumentElement.LastChild.OuterXml);
            securityOptions.BubbleClick += SecurityDisplayed;
            this.PlugInName = "FeaturedPresentations";
            data = Profiles.Framework.Utilities.GenericRDFDataIO.GetSocialMediaPlugInData(this.SubjectID, this.PlugInName);

            litBackLink.Text = "<a href='" + Root.Domain + "/edit/default.aspx?subject=" + this.SubjectID + "'>Edit Menu</a> &gt; <b>" + PropertyListXML.SelectSingleNode("PropertyList/PropertyGroup/Property/@Label").Value + "</b>";

            if (data.Length > 0)
                dataexists = true;

            txtUsername.Text = data;
            lblUsername.Text = data;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            HtmlGenericControl jsscript1 = new HtmlGenericControl("script");
            jsscript1.Attributes.Add("type", "text/javascript");
            jsscript1.Attributes.Add("src", Root.Domain + "/Profile/Modules/CustomViewSocialMediaPlugins/SlideShareJquery.js");
            Page.Header.Controls.Add(jsscript1);

            litjs.Text = base.jsStart + "var rss = " + Get(data) + "; rssCallback(rss);" + base.jsEnd;


            LoadAssets();
            SetDeleteButtons();
            upnlEditSection.Update();
        }
        private void LoadAssets()
        {
            HtmlGenericControl jsscript1 = new HtmlGenericControl("script");
            jsscript1.Attributes.Add("type", "text/javascript");
            jsscript1.Attributes.Add("src", Root.Domain + "/Profile/Modules/CustomViewSocialMediaPlugins/SlideShareJquery.js");
            Page.Header.Controls.Add(jsscript1);
            txtUsername.Attributes.Add("style", "width:300px");
        }



        private void SetDeleteButtons()
        {
            if (dataexists)
            {
                btnDeleteGray.Visible = false;
                imbDeleteArrow.Visible = true;
                btnDelete.Visible = true;
                btnImgDeleteGray.Visible = false;
                divNoSlideshare.Visible = false;
                divShowSlideShare.Visible = true;
            }
            else
            {
                btnDeleteGray.Visible = true;
                btnDelete.Visible = false;
                imbDeleteArrow.Visible = false;
                btnImgDeleteGray.Visible = true;
                divNoSlideshare.Visible = true;
                divShowSlideShare.Visible = false;
            }


        }
        private void SecurityDisplayed(object sender, EventArgs e)
        {

            if (Session["pnlSecurityOptions.Visible"] == null)
            {
                pnlDelete.Visible = true;
                pnlAddEdit.Visible = true;

            }
            else
            {
                pnlDelete.Visible = false;
                pnlAddEdit.Visible = false;

            }

            upnlEditSection.Update();
        }
        protected void btnAddEdit_OnClick(object sender, EventArgs e)
        {
            if (Session["pnlImportSlides.Visible"] == null)
            {
                pnlImportSlides.Visible = true;
                imbAddArrow.ImageUrl = "~/Framework/Images/icon_squareDownArrow.gif";
                pnlDeleteSlides.Visible = false;
                pnlDelete.Visible = false;
                phSecuritySettings.Visible = false;
                Session["pnlImportSlides.Visible"] = true;
            }
            else
            {
                pnlImportSlides.Visible = false;
                imbAddArrow.ImageUrl = "~/Framework/Images/icon_squareArrow.gif";
                pnlDeleteSlides.Visible = false;
                phSecuritySettings.Visible = true;
                pnlDelete.Visible = true;
            }

        }
        protected void btnDelete_OnClick(object sender, EventArgs e)
        {

            if (Session["pnlDeleteSlides.Visible"] == null)
            {
                pnlImportSlides.Visible = false;
                imbDeleteArrow.ImageUrl = "~/Framework/Images/icon_squareDownArrow.gif";
                pnlDeleteSlides.Visible = true;
                pnlDelete.Visible = false;
                phSecuritySettings.Visible = false;
                Session["pnlDeleteSlides.Visible"] = true;
            }
            else
            {
                Session["pnlDeleteSlides.Visible"] = null;
                pnlImportSlides.Visible = false;
                imbDeleteArrow.ImageUrl = "~/Framework/Images/icon_squareArrow.gif";
                pnlDeleteSlides.Visible = false;
                phSecuritySettings.Visible = true;
                pnlDelete.Visible = true;
            }

        }

        protected void btnSaveAndClose_OnClick(object sender, EventArgs e)
        {
            Profiles.Framework.Utilities.GenericRDFDataIO.AddEditPluginData(this.PlugInName, this.SubjectID, txtUsername.Text.Trim(), "SlideShare Slide Share");
            Response.Redirect(Request.Url.AbsoluteUri);
            Response.End();
        }
        protected void btnDeleteClose_OnClick(object sender, EventArgs e)
        {
            Profiles.Framework.Utilities.GenericRDFDataIO.AddEditPluginData(this.PlugInName, this.SubjectID, "", "");
            Profiles.Framework.Utilities.GenericRDFDataIO.RemovePluginData(this.PlugInName, this.SubjectID);
            dataexists = false;
            txtUidToDelete.Text = "";
            txtUsername.Text = "";
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
            pnlDelete.Visible = true;

            pnlDeleteSlides.Visible = false;
            pnlImportSlides.Visible = false;
            Session["pnlImportSlides.Visible"] = null;

            dataexists = false;
            string data = Profiles.Framework.Utilities.GenericRDFDataIO.GetSocialMediaPlugInData(this.SubjectID, this.PlugInName);
            if (data.Length > 0)
            {
                dataexists = true;
                lblUsername.Text = data;
            }
            //
            //make sure dataexists is set to false then reset if data exists,  this should be its own function in the base class
            SetDeleteButtons();
            upnlEditSection.Update();

        }

        private string Get(string rssfeed)
        {
            string uri = "https://www.slideshare.net/rss/user/" + HttpUtility.UrlEncode(rssfeed);
            List<Profiles.Framework.Utilities.GenericRDFDataIO.items> items = new List<Profiles.Framework.Utilities.GenericRDFDataIO.items>();
            try
            {
                JavaScriptSerializer serializer = new JavaScriptSerializer();
                string result;
                HttpWebRequest request = null;
                request = (HttpWebRequest)WebRequest.Create(uri);
                request.Method = "POST";
                request.ContentType = "applicaiton/text";

                request.ContentLength = uri.Length;

                ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls
         | SecurityProtocolType.Tls11
         | SecurityProtocolType.Tls12
         | SecurityProtocolType.Ssl3;

                using (Stream writeStream = request.GetRequestStream())
                {
                    UTF8Encoding encoding = new UTF8Encoding();
                    byte[] bytes = encoding.GetBytes(uri);
                    writeStream.Write(bytes, 0, bytes.Length);
                }

                using (HttpWebResponse response = (HttpWebResponse)request.GetResponse())
                {
                    using (Stream responseStream = response.GetResponseStream())
                    {
                        using (StreamReader readStream = new StreamReader(responseStream, Encoding.UTF8))
                        {
                            result = readStream.ReadToEnd();
                            readStream.Close();
                        }
                        responseStream.Close();
                    }
                    response.Close();
                }

                XmlDocument x = new XmlDocument();

                x.LoadXml(result);

                Namespace n = new Namespace();
                XmlNamespaceManager xmm = n.LoadNamespaces(x);
                XmlNodeList nn = x.SelectNodes("rss", xmm);

                string title = string.Empty;
                string embed = string.Empty;
                string thumb = string.Empty;
                int loop = 0;


                foreach (XmlNode node in nn)
                {
                    try
                    {
                        title = (node.SelectSingleNode("channel/item/title", xmm).InnerText);
                    }
                    catch (Exception) { title = "Not Valid"; }

                    try
                    {
                        embed = node.SelectSingleNode("channel/item/slideshare:embed", xmm).InnerText;
                    }
                    catch (Exception) { embed = ""; }
                    try
                    {
                        thumb = node.SelectSingleNode("channel/item/slideshare:meta/slideshare:thumbnail", xmm).InnerText;
                    }
                    catch (Exception) { thumb = ""; }



                    items.Add(new Profiles.Framework.Utilities.GenericRDFDataIO.items { id = loop, title = title, embed = embed, thumb = thumb });
                    loop++;
                }

            }
            catch (Exception)
            {//blank
                items = new List<Profiles.Framework.Utilities.GenericRDFDataIO.items>();

            }
            return JsonConvert.SerializeObject(items);
        }
    }
}
