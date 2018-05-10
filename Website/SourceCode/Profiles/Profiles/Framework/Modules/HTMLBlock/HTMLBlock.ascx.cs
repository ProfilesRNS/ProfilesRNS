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
using System.Xml;

using Profiles.Framework.Utilities;

namespace Profiles.Framework.Modules.HTMLBlock
{
    public partial class HTMLBlock : BaseModule
    {

        protected void Page_Load(object sender, EventArgs e)
        {
            DrawProfilesModule();
        }

        public HTMLBlock() { }

        public HTMLBlock(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
            : base(pagedata, moduleparams, pagenamespaces)
        {
        }
        public void DrawProfilesModule()
        {
            if (base.GetModuleParamString("ItemURLText") != null)
            {
              //  documentdata.Append(" ItemURLText=\"" + CustomParse.Parse(base.GetModuleParamString("ItemURLText"), item.Data, base.Namespaces));
            }

            lblHTMLBlock.Text = base.GetModuleParamXml("HTML").InnerXml.Replace("[[[Root]]]",Root.Domain);
        }
    }
}