using Profiles.Framework.Utilities;
using System;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Xml;
namespace Profiles.Login
{
    public partial class PasswordReset : System.Web.UI.Page
    {
        Profiles.Framework.Template masterpage;

        public void Page_Load(object sender, EventArgs e)
        {
            masterpage = (Framework.Template)base.Master;

            LoadPresentationXML();
            masterpage.PresentationXML = this.PresentationXML;
        }

        public void LoadPresentationXML()
        {
            string presentationxml = System.IO.File.ReadAllText(AppDomain.CurrentDomain.BaseDirectory + "/Login/PresentationXML/PasswordResetPresentation.xml");

            this.PresentationXML = new XmlDocument();
            this.PresentationXML.LoadXml(presentationxml);
            Framework.Utilities.DebugLogging.Log(presentationxml);
        }

        public XmlDocument PresentationXML { get; set; }
    }
}