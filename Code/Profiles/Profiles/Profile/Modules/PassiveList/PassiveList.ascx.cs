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



using Profiles.Framework.Utilities;

using Profiles.Profile.Utilities;

namespace Profiles.Profile.Modules.PassiveList
{
    public partial class PassiveList : BaseModule
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            DrawProfilesModule();
        }

        public PassiveList() { }

        public PassiveList(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
            : base(pagedata, moduleparams, pagenamespaces)
        {
        }
        public void DrawProfilesModule()
        {
            //If your module performs a data request, based on the DataURI parameter then call ReLoadBaseData
            base.GetDataByURI();

            XmlDocument document = new XmlDocument();
            XsltArgumentList args = new XsltArgumentList();
            bool networkexists = false;

            System.Text.StringBuilder documentdata = new System.Text.StringBuilder();

            DateTime d = DateTime.Now;

            documentdata.Append("<PassiveList");
            documentdata.Append(" InfoCaption=\"");
            documentdata.Append(base.GetModuleParamString("InfoCaption"));
            documentdata.Append("\"");
            documentdata.Append(" Description=\"");
            documentdata.Append(base.GetModuleParamString("Description"));
            documentdata.Append("\"");
            documentdata.Append(" ID=\"");
            documentdata.Append(Guid.NewGuid().ToString());
            documentdata.Append("\"");
            documentdata.Append(" MoreText=\"");            
                documentdata.Append(CustomParse.Parse(base.GetModuleParamString("MoreText"), base.BaseData, base.Namespaces));

            documentdata.Append("\"");

            documentdata.Append(" MoreURL=\"");
            if (base.GetModuleParamString("MoreURL").Contains("&"))
                documentdata.Append(Root.Domain + CustomParse.Parse(base.GetModuleParamString("MoreURL"), base.BaseData, base.Namespaces).Replace("&", "&amp;"));
            else
                documentdata.Append(CustomParse.Parse(base.GetModuleParamString("MoreURL"), base.BaseData, base.Namespaces));
            documentdata.Append("\"");

            documentdata.Append(">");
            documentdata.Append("<ItemList>");

            try
            {
                XmlNodeList nodes = this.BaseData.SelectNodes(base.GetModuleParamString("ListNode") + "[position() < " + Math.BigMul((Convert.ToInt16(base.GetModuleParamString("MaxDisplay")) + 1), 1).ToString() + "]", this.Namespaces);

                foreach (XmlNode profiles in nodes)
                {
                    networkexists = true;

                    documentdata.Append("<Item");

                    if (base.GetModuleParamString("ItemURL") != string.Empty)
                    {
                        documentdata.Append(" ItemURL=\"" + CustomParse.Parse(base.GetModuleParamString("ItemURL"), profiles, this.Namespaces));
                        documentdata.Append("\"");
                        documentdata.Append(" ItemURLText=\"" + CustomParse.Parse(base.GetModuleParamString("ItemURLText"), profiles, this.Namespaces));
                        documentdata.Append("\"");
                    }
                    documentdata.Append(">");
                    documentdata.Append(CustomParse.Parse(base.GetModuleParamString("ItemText"), profiles, this.Namespaces));
                    documentdata.Append("</Item>");
                }

            }
            catch (Exception ex) { Framework.Utilities.DebugLogging.Log(ex.Message + " ++ " + ex.StackTrace); }

            documentdata.Append("</ItemList>");
            documentdata.Append("</PassiveList>");

            if (networkexists)
            {
                document.LoadXml(documentdata.ToString());


                args.AddParam("root", "", Root.Domain);
                args.AddParam("ListNode", "", base.GetModuleParamString("ListNode"));
                args.AddParam("InfoCaption", "", base.GetModuleParamString("InfoCaption"));
                args.AddParam("Description", "", base.GetModuleParamString("Description"));
                args.AddParam("MoreUrl", "", base.GetModuleParamString("ListNode"));



                litPassiveNetworkList.Text = XslHelper.TransformInMemory(Server.MapPath("~/Profile/Modules/PassiveList/PassiveList.xslt"), args, document.OuterXml);

                Framework.Utilities.DebugLogging.Log("PASSIVE MODULE end Milliseconds:" + (DateTime.Now - d).TotalMilliseconds);
            }
        }
    }
}



















