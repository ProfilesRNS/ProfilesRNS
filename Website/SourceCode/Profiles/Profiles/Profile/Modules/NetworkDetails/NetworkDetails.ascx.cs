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

namespace Profiles.Framework.Modules.NetworkDetails
{
    public partial class NetworkDetails : BaseModule
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            DrawProfilesModule();
        }
        public NetworkDetails() { }
        public NetworkDetails(XmlDocument pagedata,List<ModuleParams> moduleparams,XmlNamespaceManager pagenamespaces)
            : base(pagedata,moduleparams,pagenamespaces){
            
        }

        public void DrawProfilesModule()
        {
            //If your module performs a data request, based on the DataURI parameter then call ReLoadBaseData
            base.GetDataByURI();

            //If the two counts don't match then their are more header columns than data or more data than header.
            if (base.GetModuleParamXml("TableHeader").SelectNodes("Header/Column").Count != base.GetModuleParamXml("TableRow").SelectNodes("Data/Column").Count)
            {
                throw new Exception("TableHeader count does not match TableRow count in PresentationXML");
            }

            XmlDocument document = new XmlDocument();
            System.Text.StringBuilder documentdata = new System.Text.StringBuilder();
            XmlNode connectionnode;

            ////Format any URL Nodes that might exist, this uses a single hop parse for the Connection information within a Network.
            ////If your presentationXML has Connection data that needs to be parsed out of the XML data, you should use the HopParse method.
            ////This enables you to access (SingleHop) Entity/Network/Connection data and display it any way you need.
            ////[IE. You can map all of a single persons co-authors, but not their co-authors, co-authors.]
            //foreach (XmlNode col in base.TableRow.SelectNodes("Data/Column"))
            //{
            //    foreach (XmlNode node in base.BaseData.SelectNodes(base.NetworkListNode))
            //    {
            //        col["URL"].InnerText = CustomParse.HopParse(col["URL"].InnerText, base.BaseData,node);
            //    }
            //}

            documentdata.Append("<DetailTable");
            documentdata.Append(" Columns=\"");
            documentdata.Append(base.GetModuleParamXml("TableHeader").SelectNodes("Header/Column").Count);
            documentdata.Append("\"");
            documentdata.Append(" InfoCaption=\"");
            documentdata.Append(base.GetModuleParamString("InfoCaption"));
            documentdata.Append("\"");
            documentdata.Append(">");

            //Loop the Header Columns to build the first row of the table.
            documentdata.Append("<Row type=\"header\">");
            foreach (XmlNode header in base.GetModuleParamXml("TableHeader").SelectNodes("Header/Column"))
            {
                documentdata.Append("<Column Justify=\"" + header["Justify"].InnerText + "\"");
                documentdata.Append(" Width=\"" + header["Width"].InnerText + "\"");
                documentdata.Append(">" + header["Name"].InnerXml + "</Column>");
            }
            documentdata.Append("</Row>");

            //Loop the Data Columns to supply the rows after the header.
            foreach (XmlNode networknode in base.BaseData.SelectNodes(base.GetModuleParamString("NetworkListNode")))
            {
                documentdata.Append("<Row type=\"data\" url=\"" + Root.Domain + CustomParse.Parse(base.GetModuleParamString("RowURL"), networknode, base.Namespaces) + "\">");

                connectionnode = base.BaseData.SelectSingleNode(CustomParse.Parse(base.GetModuleParamString("ConnectionListNode"), networknode, base.Namespaces));

                foreach (XmlNode col in base.GetModuleParamXml("TableRow").SelectNodes("Data/Column"))
                {
                    documentdata.Append("<Column url=\"" + Root.Domain + CustomParse.Parse(col["URL"].InnerText, base.BaseData, networknode, base.Namespaces) + "\"");

                    if (col["Data"].InnerText.Contains("Profile"))
                    {
                        documentdata.Append(">" + CustomParse.Parse(col["Data"].InnerText, networknode, base.Namespaces) + "</Column>");
                    }
                    else
                    {
                        documentdata.Append(">" + CustomParse.Parse(col["Data"].InnerText, connectionnode, base.Namespaces) + "</Column>");
                    }
                }

                documentdata.Append("</Row>");
            }

            documentdata.Append("</DetailTable>");

            document.LoadXml(documentdata.ToString());

            XslCompiledTransform xslt = new XslCompiledTransform();
            XsltArgumentList args = new XsltArgumentList();
            args.AddParam("root", "", Root.Domain);

            litNetworkDetails.Text = Utilities.XslHelper.TransformInMemory(Server.MapPath("~/framework/modules/NetworkDetails/NetworkDetails.xslt"), args, base.BaseData.OuterXml);            

        }

    }

}