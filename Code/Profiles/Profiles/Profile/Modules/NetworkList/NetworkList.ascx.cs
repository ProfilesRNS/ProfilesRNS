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
            if (base.GetModuleParamString("Cloud") == "true")
                DrawProfilesCloud();
            else
                DrawProfilesModule();



        }
        public NetworkList() { }
        public NetworkList(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
            : base(pagedata, moduleparams, pagenamespaces)
        {

        }


        public void DrawProfilesCloud()
        {
            XmlDocument document = new XmlDocument();
            string xml = string.Empty;

            Profiles.Profile.Utilities.DataIO pdata = new Profiles.Profile.Utilities.DataIO();
            RDFTriple request = new RDFTriple(Convert.ToInt64(Request.QueryString["subject"]));


            document.LoadXml(pdata.GetNetworkCloud(request).ToString().Replace("&", "&amp;"));

            XslCompiledTransform xslt = new XslCompiledTransform();
            XsltArgumentList args = new XsltArgumentList();
            args.AddParam("root", "", Root.Domain);

            litListView.Text = XslHelper.TransformInMemory(Server.MapPath("~/Profile/Modules/NetworkList/NetworkList.xslt"), args, document.OuterXml);
        }



        public void DrawProfilesModule()
        {








            DateTime d = DateTime.Now;

            //If your module performs a data request, based on the DataURI parameter then call ReLoadBaseData
            base.GetDataByURI();
            List<CloudItem> weights = new List<CloudItem>();
            
            double firsttwenty = 0.0;
            double lasttwenty = 0.0;

            string cloudweightnode = string.Empty;
            string networklistnode = string.Empty;
            string itemurl = string.Empty;
            string itemurltext = string.Empty;
            string itemtext = string.Empty;







            cloudweightnode = base.GetModuleParamString("CloudWeightNode");
            networklistnode = base.GetModuleParamString("NetworkListNode");
            itemurl = base.GetModuleParamString("ItemURL");
            itemurltext = base.GetModuleParamString("ItemURLText");
            itemtext = base.GetModuleParamString("ItemText");

            if (base.BaseData.SelectNodes(networklistnode, base.Namespaces) != null && cloudweightnode != string.Empty)
            {
                if (cloudweightnode != string.Empty)
                {

                    var items = from XmlNode networknode in base.BaseData.SelectNodes(networklistnode, base.Namespaces)
                                select new
                                {
                                    weight = Convert.ToDouble(networknode.SelectSingleNode(cloudweightnode, base.Namespaces).InnerText),
                                    value = networknode.SelectSingleNode("./rdf:object/@rdf:resource", this.Namespaces).Value
                                };

                    foreach (var i in items)
                    {

                        weights.Add(new CloudItem(i.weight, i.value));

                    }

                    //foreach (XmlNode networknode in base.BaseData.SelectNodes(networklistnode, base.Namespaces))
                    //{
                    //    weight = Convert.ToDouble(networknode.SelectSingleNode(cloudweightnode, base.Namespaces).InnerText);
                    //    weights.Add(new CloudItem(weight, networknode.SelectSingleNode("./rdf:object/@rdf:resource", this.Namespaces).Value));
                    //}

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

            if (base.BaseData.SelectNodes(networklistnode, base.Namespaces) != null)
            {

                var items = from XmlNode networknode in base.BaseData.SelectNodes(networklistnode, base.Namespaces)
                            select new
                            {
                                itemurl = CustomParse.Parse(itemurl, networknode, base.Namespaces),
                                item = CustomParse.Parse(itemtext, networknode, base.Namespaces),
                                weight = GetCloudRank(networknode.SelectSingleNode("./rdf:object/@rdf:resource", base.Namespaces).InnerText, weights),
                                connectiondetails = networknode.SelectSingleNode("prns:hasConnectionDetails/@rdf:resource", base.Namespaces),
                                sortorder = networknode.SelectSingleNode("prns:sortOrder", base.Namespaces),
                                itemxpath = CustomParse.Parse(itemurltext, networknode, base.Namespaces)
                            };

                foreach (var i in items)
                {
                    //foreach (XmlNode networknode in base.BaseData.SelectNodes(networklistnode, base.Namespaces))
                    //{

                    documentdata.Append("<Item");

                    if (itemurl != string.Empty)
                    {
                        documentdata.Append(" ItemURL=\"");
                        documentdata.Append(i.itemurl);
                        documentdata.Append("\"");

                        if (cloudweightnode != string.Empty)
                        {
                            documentdata.Append(" Weight=\"");
                            documentdata.Append(i.weight);
                            documentdata.Append("\"");
                        }

                        if (i.connectiondetails != null)
                        {
                            if (base.BaseData.SelectSingleNode("rdf:RDF/rdf:Description[@rdf:about='" + i.connectiondetails.InnerText + "']/prns:isAlsoCoAuthor", base.Namespaces) != null)
                            {
                                documentdata.Append(" CoAuthor=\"");
                                documentdata.Append(base.BaseData.SelectSingleNode("rdf:RDF/rdf:Description[@rdf:about='" + i.connectiondetails.InnerText + "']/prns:isAlsoCoAuthor", base.Namespaces).InnerText);
                                documentdata.Append("\"");
                            }
                            if (i.sortorder != null)
                            {
                                documentdata.Append(" sortOrder=\"");
                                documentdata.Append(i.sortorder.InnerText);
                                documentdata.Append("\"");
                            }
                        }

                        string itemxpath = i.itemxpath;
                        if (itemxpath != string.Empty)
                            item = base.BaseData.SelectSingleNode("rdf:RDF/rdf:Description[@rdf:about= '" + itemxpath + "']/rdfs:label", base.Namespaces).InnerText;

                        documentdata.Append(" ItemURLText=\"");
                        documentdata.Append(item);
                        documentdata.Append("\"");
                    }

                    documentdata.Append(">");
                    documentdata.Append(i.item);
                    documentdata.Append("</Item>");
                }
            }


            documentdata.Append("</ListView>");
            document.LoadXml(documentdata.ToString().Replace("&", "&amp;"));

            XsltArgumentList args = new XsltArgumentList();
            string xmlbuffer;
            if (base.GetModuleParamString("SortBy").Equals("Weight")) xmlbuffer = XslHelper.TransformInMemory(Server.MapPath("~/Profile/Modules/NetworkList/SortIntermediateByWeight.xslt"), args, document.OuterXml);
            else xmlbuffer = XslHelper.TransformInMemory(Server.MapPath("~/Profile/Modules/NetworkList/SortIntermediate.xslt"), args, document.OuterXml);
            litListView.Text = XslHelper.TransformInMemory(Server.MapPath("~/Profile/Modules/NetworkList/NetworkList.xslt"), args, xmlbuffer);

            Framework.Utilities.DebugLogging.Log("Network List MODULE end Milliseconds:" + (DateTime.Now - d).TotalSeconds);

        }

        //***************************************************************************************************************************************
        public string GetCloudRank(string resource, List<CloudItem> items)
        {
            string rtn = string.Empty;
            CloudItem weight = null;
            weight = items.Find(delegate(CloudItem item) { return item.About == resource; });

            if (weight != null)
                rtn = weight.Rank;

            return rtn;
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