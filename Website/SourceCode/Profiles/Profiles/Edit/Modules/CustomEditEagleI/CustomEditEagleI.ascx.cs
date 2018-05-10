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
using System.Text;
using System.Xml;
using System.Configuration;

using Profiles.Framework.Utilities;


namespace Profiles.Edit.Modules.CustomEditEagleI
{
    public partial class CustomEditEagleI : BaseModule
    {
        Edit.Utilities.DataIO data;
        protected void Page_Load(object sender, EventArgs e)
        {
            DrawProfilesModule();
        }

        public CustomEditEagleI() : base() { }
        public CustomEditEagleI(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
            : base(pagedata, moduleparams, pagenamespaces)
        {
            SessionManagement sm = new SessionManagement();
            base.BaseData = pagedata;

            Profiles.Profile.Utilities.DataIO propdata = new Profiles.Profile.Utilities.DataIO();
            data = new Edit.Utilities.DataIO();



            if (Request.QueryString["subject"] != null)
                this.SubjectID = Convert.ToInt64(Request.QueryString["subject"]);
            else if (base.GetRawQueryStringItem("subject") != null)
                this.SubjectID = Convert.ToInt64(base.GetRawQueryStringItem("subject"));
            else
                Response.Redirect("~/search");

            string predicateuri = Request.QueryString["predicateuri"].Replace("!", "#");
            this.PropertyListXML = propdata.GetPropertyList(this.BaseData, base.PresentationXML, predicateuri, false, true, false);
            litBackLink.Text = "<a href='" + Root.Domain + "/edit/" + this.SubjectID.ToString() + "'>Edit Menu</a> &gt; <b>" + PropertyListXML.SelectSingleNode("PropertyList/PropertyGroup/Property/@Label").Value + "</b>";


            //create a new network triple request.
            base.RDFTriple = new RDFTriple(this.SubjectID, data.GetStoreNode(predicateuri));

            base.RDFTriple.Expand = true;
            base.RDFTriple.ShowDetails = true;
            base.GetDataByURI();//This will reset the data to a Network.



            securityOptions.Subject = this.SubjectID;
            securityOptions.PredicateURI = predicateuri;
            securityOptions.PrivacyCode = Convert.ToInt32(this.PropertyListXML.SelectSingleNode("PropertyList/PropertyGroup/Property/@ViewSecurityGroup").Value);
            securityOptions.SecurityGroups = new XmlDataDocument();
            securityOptions.SecurityGroups.LoadXml(base.PresentationXML.DocumentElement.LastChild.OuterXml);
        }
        private void DrawProfilesModule()
        {

            Profiles.Profile.Utilities.DataIO dataIO = new Profiles.Profile.Utilities.DataIO();
            StringBuilder html = new StringBuilder();
            List<string> reader = dataIO.GetEagleI(this.SubjectID);
            string eagleIEmail = ConfigurationManager.AppSettings["EAGLEI.EmailAddress"];
            string eagleIInstitution = ConfigurationManager.AppSettings["EAGLEI.InstitutionName"];

            html.Append("<div class='mentor-completed'>Information in the research resource module is provided automatically from the ");
            html.Append(eagleIInstitution);
            html.Append(" repository of the eagle-i Network. To update information or list your resources in eagle-i, please contact <a href='mailto:");
            html.Append(eagleIEmail);
            html.Append("'>");
            html.Append(eagleIEmail);
            html.Append("</a>. For more information about the eagle-i research resource network, visit <a href='http://www.eagle-i.net'>www.eagle-i.net</a>.</div><br>");


            if (reader.Count == 0)
            {
                html
                   .Append("<div class='mentor-current'>")
                   .AppendFormat("<div><i>You have no current records in the eagle-i system.</i></div></div>");
            }
            else
            {
                for (int loop = 0; loop < reader.Count;loop++ )
                {
                    html
                        .Append("<div class='mentor-current'>")
                        .Append(reader[loop])
                        .Append("</div>");

                }

            }


            // Pass to control
            litEagleI.Text = html.ToString();

        }
        public Int64 SubjectID { get; set; }
        public XmlDocument PropertyListXML { get; set; }




    }
}