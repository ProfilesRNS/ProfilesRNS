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


namespace Profiles.Search.Modules.Browse
{
    public partial class Browse : Framework.Utilities.BaseModule
    {
        protected void Page_Load(object sender, EventArgs e)
        {          
            DrawProfilesModule();
        }

        public Browse() : base() { }
        public Browse(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
            : base(pagedata, moduleparams, pagenamespaces)
        {

            Search.Utilities.DataIO data = new Search.Utilities.DataIO();

            base.BaseData = data.Browse();
  


        }
        public void DrawProfilesModule()
        {
            XsltArgumentList args = new XsltArgumentList();
            args.AddParam("root", "", Root.Domain);

            xmlBrowse.Document = base.BaseData;
            xmlBrowse.TransformArgumentList = args;

           
            xmlBrowse.TransformSource = "SearchBrowse.xslt";
            

        }
    }
}