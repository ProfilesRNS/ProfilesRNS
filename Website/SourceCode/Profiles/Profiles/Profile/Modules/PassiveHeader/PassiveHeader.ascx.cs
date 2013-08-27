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
using System.Xml.XPath;
using Profiles.Profile.Utilities;

using Profiles.Framework.Utilities;

namespace Profiles.Profile.Modules.PassiveHeader
{
    public partial class PassiveHeader : BaseModule
    {
        protected void Page_Load(object sender, EventArgs e)
        {
          DrawProfilesModule();
        }

        public PassiveHeader() : base() { }
        public PassiveHeader(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
            : base(pagedata, moduleparams, pagenamespaces)
        {

        }
        public void DrawProfilesModule()
        {

            Framework.Utilities.DebugLogging.Log("Passive Header 1");

            this.GetDataByURI();

            Framework.Utilities.DebugLogging.Log("Passive Header 2");

            bool display = false;

            if (base.GetModuleParamXml("DisplayRule") == null)
            {
                display = true;
            }
            else
            {
                foreach (XmlNode x in base.GetModuleParamXml("DisplayRule"))
                {

                    if (base.BaseData.SelectSingleNode(x.InnerText, base.Namespaces) != null)
                    {
                        display = !display;
                    }

                }
            }

            if (display)
            {
                string lname = string.Empty;

                if (base.BaseData.SelectSingleNode("rdf:RDF/rdf:Description[@rdf:about=/rdf:RDF/rdf:Description/rdf:subject/@rdf:resource]/foaf:lastName", base.Namespaces) != null)
                {
                    lname = base.BaseData.SelectSingleNode("rdf:RDF/rdf:Description[@rdf:about=/rdf:RDF/rdf:Description/rdf:subject/@rdf:resource]/foaf:lastName", base.Namespaces).InnerText;
                }
                else
                {
                    lname = base.BaseData.SelectSingleNode("rdf:RDF/rdf:Description/foaf:lastName", base.Namespaces).InnerText;
                }

                litLname.Text = lname;

            }
            else
            {
                this.Visible = false;

            }



        }
    }
}