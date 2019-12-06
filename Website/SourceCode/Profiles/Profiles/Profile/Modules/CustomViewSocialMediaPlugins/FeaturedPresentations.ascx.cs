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

namespace Profiles.Profile.Modules.CustomViewSocialMediaPlugins
{
    public partial class FeaturedPresentations : BaseSocialMediaModule
    {
        protected void Page_load(object sender, EventArgs e)
        {
          

        }
        public FeaturedPresentations() : base() {  }
        public FeaturedPresentations(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
            : base(pagedata, moduleparams, pagenamespaces)
        {

            LoadAssets();

        }

        private void LoadAssets()
        {

            HtmlGenericControl jsscript1 = new HtmlGenericControl("script");
            jsscript1.Attributes.Add("type", "text/javascript");
            jsscript1.Attributes.Add("src", Root.Domain + "/Profile/Modules/CustomViewSocialMediaPlugins/SlideShareJquery.js");
            Page.Header.Controls.Add(jsscript1);


            litjs.Text = base.jsStart + "var rss = " + Get(Framework.Utilities.GenericRDFDataIO.GetSocialMediaPlugInData(this.SubjectID, "FeaturedPresentations")) + "; rssCallback(rss);" + base.jsEnd;

            this.PlugInName = "FeaturedPresentations";

            HtmlLink Displaycss = new HtmlLink();
            Displaycss.Href = Root.Domain + "/Profile/Modules/CustomViewSocialMediaPlugins/style.css";
            Displaycss.Attributes["rel"] = "stylesheet";
            Displaycss.Attributes["type"] = "text/css";
            Displaycss.Attributes["media"] = "all";
            Page.Header.Controls.Add(Displaycss);
        }
      
        private string Get(string rssfeed)
        {
            string uri = "https://www.slideshare.net/rss/user/" + HttpUtility.UrlEncode(rssfeed);
            List<Framework.Utilities.GenericRDFDataIO.items> items = new List<Framework.Utilities.GenericRDFDataIO.items>();
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

                int loop = 0;  

                foreach (XmlNode node in nn[0].SelectNodes("channel/item"))
                {
                    items.Add(new Framework.Utilities.GenericRDFDataIO.items { id=loop , title = node.SelectSingleNode("title").InnerText, embed = node.SelectSingleNode("slideshare:embed", xmm).InnerText,thumb = node.SelectSingleNode("slideshare:meta/slideshare:thumbnail", xmm).InnerText });
                    loop++;
                }

            }
            catch (Exception ex)
            {


            }
            return JsonConvert.SerializeObject(items);
        }
    }
}