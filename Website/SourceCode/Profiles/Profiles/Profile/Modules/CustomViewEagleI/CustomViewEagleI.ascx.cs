using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.Configuration;

using Profiles.Framework.Utilities;


namespace Profiles.Profile.Modules
{
    public partial class CustomViewEagleI : BaseModule
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            DrawProfilesModule();
        }

        public CustomViewEagleI() : base() { }
        public CustomViewEagleI(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
            : base(pagedata, moduleparams, pagenamespaces)
        {
            base.RDFTriple = new RDFTriple(Convert.ToInt64(Request.QueryString["Subject"]));
        }

        public void DrawProfilesModule()
        {
            Utilities.DataIO dataIO = new Profiles.Profile.Utilities.DataIO();
            StringBuilder html = new StringBuilder();
            List<string> reader = dataIO.GetEagleI(base.RDFTriple.Subject);
            string eagleIEmail = ConfigurationManager.AppSettings["EAGLEI.EmailAddress"];

            litHead.Text = "<table><tr><td><table style='width:480px;font-weight:bold;color:#888;padding:5px 0px;'>" +
                "<tr><td valign='top' xstyle='width:90%'>This researcher has shared information about their research resources <br/>in the eagle-i Network.  To update or add resource records, contact <br/>" +
                "<a href='mailto:" + eagleIEmail + "'>" + eagleIEmail + "</a>.</td>" +
                "</tr></table></td><td align='center' valign='middle'><img src='" + Root.Domain + "/profile/modules/CustomViewEagleI/Images/logo.gif'/></td></tr></table>";
                

            for (int i = 0; i < reader.Count; i++)
            {
                html.Append("<div class='mentor-completed'>");
                html.Append(reader[i]);
                html.Append("</div>");
            }

            litHtml.Text = html.ToString();
        }

    }
}