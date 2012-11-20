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

namespace Profiles.Framework.Modules.NetworkList
{
    public partial class NetworkList : BaseModule
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            DrawProfilesModule();
        }
        public NetworkList() { }
        public NetworkList(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
            : base(pagedata, moduleparams, pagenamespaces)
        {

        }
        public void DrawProfilesModule()
        {

            //If your module performs a data request, based on the DataURI parameter then call ReLoadBaseData
            base.GetDataByURI();
            List<CloudItem> weights = new List<CloudItem>();

            double weight;
            double firsttwenty = 0.0;
            double lasttwenty = 0.0;

            if (base.BaseData.SelectNodes(base.GetModuleParamString("NetworkListNode"), base.Namespaces) != null && base.GetModuleParamString("CloudWeightNode") != string.Empty)
            {
                foreach (XmlNode networknode in base.BaseData.SelectNodes(base.GetModuleParamString("NetworkListNode"), base.Namespaces))
                {
                    if (base.GetModuleParamString("CloudWeightNode") != string.Empty)
                    {
                        weight = Convert.ToDouble(networknode.SelectSingleNode(base.GetModuleParamString("CloudWeightNode"), base.Namespaces).InnerText);
                        weights.Add(new CloudItem(weight, networknode.SelectSingleNode("./rdf:object/@rdf:resource", this.Namespaces).Value));
                    }
                }

                weights = weights.OrderByDescending(clouditem => clouditem.Weight).ToList();

                firsttwenty = weights.Count * .2;
                lasttwenty = weights.Count * .8;

                int cnt = 0;
                foreach (CloudItem ci in weights)
                {
                    if (cnt > firsttwenty && cnt < lasttwenty)
                    {
                        ci.Rank = "med";
                    }
                    if (cnt < firsttwenty)
                    {
                        ci.Rank = "big";
                    }
                    if (cnt > lasttwenty)
                    {
                        ci.Rank = "small";
                    }

                    cnt++;
                }
            }

            XmlDocument document = new XmlDocument();
            System.Text.StringBuilder documentdata = new System.Text.StringBuilder();

            documentdata.Append("<ListView");
            documentdata.Append(" Columns=\"");
            documentdata.Append(base.GetModuleParamString("Columns"));
            documentdata.Append("\"");
            if (base.GetModuleParamString("BulletType") != string.Empty)
            {
                documentdata.Append(" Bullet=\"");
                documentdata.Append(base.GetModuleParamString("BulletType"));
                documentdata.Append("\"");
            }
            documentdata.Append(" InfoCaption=\"");
            documentdata.Append(base.GetModuleParamString("InfoCaption"));
            documentdata.Append("\"");

            documentdata.Append(" Description=\"");
            documentdata.Append(base.GetModuleParamString("Description"));

            documentdata.Append("\">");
            string item = string.Empty;

            if (base.BaseData.SelectNodes(base.GetModuleParamString("NetworkListNode"), base.Namespaces) != null)
            {

                foreach (XmlNode networknode in base.BaseData.SelectNodes(base.GetModuleParamString("NetworkListNode"), base.Namespaces))
                {
                    documentdata.Append("<Item");

                    if (base.GetModuleParamString("ItemURL") != string.Empty)
                    {
                        documentdata.Append(" ItemURL=\"" + CustomParse.Parse(base.GetModuleParamString("ItemURL"), networknode, base.Namespaces));
                        documentdata.Append("\"");

                        if (base.GetModuleParamString("CloudWeightNode") != string.Empty)
                        {
                            documentdata.Append(" Weight=\"" + GetCloudRank(networknode.SelectSingleNode("./rdf:object/@rdf:resource", base.Namespaces).InnerText, weights));
                            documentdata.Append("\"");
                        }

                        if (networknode.SelectSingleNode("prns:hasConnectionDetails/@rdf:resource", base.Namespaces) != null)
                        {
                            if (base.BaseData.SelectSingleNode("rdf:RDF/rdf:Description[@rdf:about='" + networknode.SelectSingleNode("prns:hasConnectionDetails/@rdf:resource", base.Namespaces).Value + "']/prns:isAlsoCoAuthor", base.Namespaces) != null)
                            {
                                documentdata.Append(" CoAuthor=\"" + base.BaseData.SelectSingleNode("rdf:RDF/rdf:Description[@rdf:about='" + networknode.SelectSingleNode("prns:hasConnectionDetails/@rdf:resource", base.Namespaces).Value + "']/prns:isAlsoCoAuthor", base.Namespaces).InnerText);
                                documentdata.Append("\"");
                            }
                            if (networknode.SelectSingleNode("prns:sortOrder", base.Namespaces) != null)
                            {
                                documentdata.Append(" sortOrder=\"" + networknode.SelectSingleNode("prns:sortOrder", base.Namespaces).InnerText);
                                documentdata.Append("\"");
                            }
                        }

                        string itemxpath = CustomParse.Parse(base.GetModuleParamString("ItemURLText"), networknode, base.Namespaces);
                        if (itemxpath != string.Empty)
                            item = base.BaseData.SelectSingleNode("rdf:RDF/rdf:Description[@rdf:about= '" + itemxpath + "']/rdfs:label", base.Namespaces).InnerText;

                        documentdata.Append(" ItemURLText=\"" + item);
                        documentdata.Append("\"");
                    }
                    
                    documentdata.Append(">");
                    documentdata.Append(CustomParse.Parse(base.GetModuleParamString("ItemText"), networknode, base.Namespaces));
                    documentdata.Append("</Item>");
                }
            }


            documentdata.Append("</ListView>");
            document.LoadXml(documentdata.ToString().Replace("&", "&amp;"));

            XsltArgumentList args = new XsltArgumentList();
            string xmlbuffer;
            if(base.GetModuleParamString("SortBy").Equals("Weight")) xmlbuffer = XslHelper.TransformInMemory(Server.MapPath("~/Profile/Modules/NetworkList/SortIntermediateByWeight.xslt"), args, document.OuterXml);
            else xmlbuffer = XslHelper.TransformInMemory(Server.MapPath("~/Profile/Modules/NetworkList/SortIntermediate.xslt"), args, document.OuterXml);
            litListView.Text = XslHelper.TransformInMemory(Server.MapPath("~/Profile/Modules/NetworkList/NetworkList.xslt"), args, xmlbuffer);


        }

        //***************************************************************************************************************************************
        public string GetCloudRank(string resource, List<CloudItem> items)
        {
            CloudItem weight = null;
            weight = items.Find(delegate(CloudItem item) { return item.About == resource; });

            return weight.Rank;
        }
    }

    public class CloudItem
    {
        public CloudItem(double weight, string about)
        {
            this.Weight = weight;
            this.About = about;
        }
        public double Weight { get; set; }
        public String About { get; set; }
        public string Rank { get; set; }
    }

}