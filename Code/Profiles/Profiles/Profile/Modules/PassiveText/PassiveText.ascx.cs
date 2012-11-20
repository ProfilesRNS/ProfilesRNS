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
using System.Xml.XPath;

using Profiles.Profile.Utilities;
using Profiles.Framework.Utilities;

namespace Profiles.Profile.Modules.PassiveText
{
    public partial class PassiveText : BaseModule
    {        
        protected void Page_Load(object sender, EventArgs e)
        {
            DrawProfilesModule();
        }

        public PassiveText() { }
        public PassiveText(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
            : base(pagedata, moduleparams, pagenamespaces)
        {     
          
        }
        public void DrawProfilesModule()
        {
            XmlDocument document = new XmlDocument();
            System.Text.StringBuilder documentdata = new System.Text.StringBuilder();
            
            string title = string.Empty;
            string text = string.Empty;
          
            string fieldbuffer = string.Empty;

            foreach (ModuleParams mp in base.ModuleParams)
            {
                fieldbuffer = mp.Node.InnerText;

                if (mp.Node.Attributes.Count == 0) { return; }

                switch (mp.Node.Attributes[0].Value.ToLower())
                {
                    case "title":
                        title = fieldbuffer;
                        break;

                    case "text":
                        text = fieldbuffer;
                        break;
                }
            }
   
            documentdata.Append("<PassiveText");
            documentdata.Append(" Title=\"");
            documentdata.Append(title);
            documentdata.Append("\"");
            documentdata.Append(" Text=\"");
            documentdata.Append(text);
            documentdata.Append("\"");            
            documentdata.Append("/>");          

            
            document.LoadXml(documentdata.ToString());

            XslCompiledTransform xslt = new XslCompiledTransform();
            XsltArgumentList args = new XsltArgumentList();
            args.AddParam("root", "", Root.Domain);

            litPassiveTextBlock.Text = Framework.Utilities.XslHelper.TransformInMemory(Server.MapPath("~/profile/modules/PassiveText/PassiveText.xslt"), args, base.BaseData.OuterXml);            

        }


    }
}