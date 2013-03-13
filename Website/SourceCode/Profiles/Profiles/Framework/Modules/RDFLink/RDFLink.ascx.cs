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

using Profiles.Framework.Utilities;
using Profiles.Profile.Utilities;

namespace Profiles.Framework.Modules.RDFLink
{
    public partial class RDFLink : BaseModule
    {

        protected void Page_Load(object sender, EventArgs e)
        {
            DrawProfilesModule();
        }
        public RDFLink() { }
        public RDFLink(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
            : base(pagedata, moduleparams, pagenamespaces)
        {
        }
        private void DrawProfilesModule()
        {
            string uri = base.BaseData.SelectSingleNode("//rdf:RDF/rdf:Description/@rdf:about", base.Namespaces).Value;

            //IF the URI is in our system then we build the link. If not then we do not build the link for the data.
            if (uri.Contains(Root.Domain))
            {
                string file = string.Empty;
                string spostring = string.Empty;
                string[] spoarray;                

                spostring = uri.ToLower().Replace(Root.Domain.ToLower() + "/profile/", "");
                spoarray = spostring.Split('/');

                for (int i = 0; i < spoarray.Length; i++)
                {
                    file = file + spoarray[i] + "_";
                }

                file = file.Substring(0, file.Length - 1);

                lblRDFLink.Text = "<div style=\"margin-bottom:10px;\"><a href=\"" + uri + "/" + file + ".rdf\" target=\"_blank\">" + "View RDF" + "</a></div>";

                if (base.MasterPage != null)
                {
                    System.Web.UI.HtmlControls.HtmlContainerControl Head1;
                    Head1 = (System.Web.UI.HtmlControls.HtmlContainerControl)base.MasterPage.FindControl("Head1");
                    //If a masterpage exists, you need to to create an ASP.Net Literal object and pass it to the masterpage so it can process the link in the Head block.
                    string link = "<link rel=\"alternate\" type=\"application/rdf+xml\" href=\"" + uri + "/" + file + ".rdf\" />";
                    Head1.Controls.Add(new LiteralControl(link));
                }

            }
        }
    }
}