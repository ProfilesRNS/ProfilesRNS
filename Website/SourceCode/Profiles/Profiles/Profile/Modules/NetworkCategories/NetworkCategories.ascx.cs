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
using System.Xml.Xsl;
using System.Xml.Linq;

using Profiles.Framework.Utilities;
using Profiles.Profile.Utilities;



namespace Profiles.Profile.Modules.NetworkCategories
{
    public partial class NetworkCategories : BaseModule
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            DrawProfilesModule();
        }

        public NetworkCategories() { }
        public NetworkCategories(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
            : base(pagedata, moduleparams, pagenamespaces)
        {

        }

        public void DrawProfilesModule()
        {
            XmlDocument document = new XmlDocument();
            string xml = string.Empty;


            Utilities.DataIO data = new Profiles.Profile.Utilities.DataIO();
            RDFTriple request = new RDFTriple(Convert.ToInt64(Request.QueryString["subject"]));


            document.LoadXml(data.GetNetworkCategory(request).ToString());

            XslCompiledTransform xslt = new XslCompiledTransform();
            XsltArgumentList args = new XsltArgumentList();
            args.AddParam("root", "", Root.Domain);

            litCategoryList.Text = Framework.Utilities.XslHelper.TransformInMemory(Server.MapPath("~/Profile/modules/NetworkCategories/NetworkCategories.xslt"), args, document.OuterXml);

        }





        //We moved this to the Database because it was just too slow once a profile
        //hit more than 1000 concepts.  
        //public void DrawProfilesModule()
        //{
        //    //If your module performs a data request, based on the DataURI parameter then call ReLoadBaseData
        //    base.GetDataByURI();

        //    XmlDocument document = new XmlDocument();
        //    System.Text.StringBuilder documentdata = new System.Text.StringBuilder();


        //    string itemtextbuffer = string.Empty;
        //    string itemurlbuffer = string.Empty;

        //    List<string> categories = new List<string>();
        //    List<Item> items = new List<Item>();
        //    List<CategoryListData> concpetcategorydata = new List<CategoryListData>();

        //    XNamespace rdf = "http://www.w3.org/1999/02/22-rdf-syntax-ns#";
        //    XNamespace rdfs = "http://www.w3.org/2000/01/rdf-schema#";
        //    XNamespace prns = "http://profiles.catalyst.harvard.edu/ontology/prns#";


        //    var c = XDocument.Parse(base.BaseData.OuterXml).Descendants(rdf + "RDF").Elements(rdf + "Description")
        //                               .Select(e => (string)e.Element(prns + "meshSemanticGroupName"))
        //                               .Distinct()
        //                               .ToList();
        //    c.Remove(null);
        //    c.Sort((x, y) => (x.CompareTo(y)));

        //    foreach (string categoryitem in c)
        //    {
        //        foreach (XmlNode item in base.BaseData.SelectNodes("//rdf:RDF/rdf:Description[prns:meshSemanticGroupName='" + categoryitem + "']", base.Namespaces))
        //        {
        //            //IEnumerable<XElement> list = from itemss in XDocument.Parse(item.OuterXml).XPathSelectElements(base.GetModuleParamString("CategoryPath"), base.Namespaces)                                                                                                  

        //            //foreach (XElement result in list)
        //            //{
        //            //    string k = result.ToString();
        //            //}

        //         //   XmlNodeList category = item.SelectNodes(base.GetModuleParamString("CategoryPath") + "[text()='" + categoryitem + "']", base.Namespaces);
                    
                    

        //                itemurlbuffer = CustomParse.Parse(base.GetModuleParamString("ItemText"), item, base.Namespaces);
        //                itemtextbuffer = CustomParse.Parse(base.GetModuleParamString("ItemURL"), item, base.Namespaces);

                    


        //            items.Add(new Item(itemurlbuffer, itemtextbuffer, item, Convert.ToDouble(item.SelectSingleNode("prns:uniquenessWeight", base.Namespaces).InnerText)));
        //            itemurlbuffer = string.Empty;
        //            itemtextbuffer = string.Empty;

        //        }

        //        items.Sort((x, y) => (y.Weight.CompareTo(x.Weight)));

        //        concpetcategorydata.Add(new CategoryListData(categoryitem, items));
        //        items = new List<Item>();
        //    }

        //    documentdata.Append("<Items InfoCaption=\"" + base.GetModuleParamString("InfoCaption") + "\">");

        //    foreach (CategoryListData d in concpetcategorydata)
        //    {

        //        documentdata.Append("<DetailList");
        //        documentdata.Append(" Category=\"" + d.Category + "\">");

        //        foreach (Item item in d.Items)
        //        {
        //            documentdata.Append("<Item");

        //            if (base.GetModuleParamString("ItemURL") != string.Empty)
        //            {
        //                documentdata.Append(" URL=\"" + CustomParse.Parse(base.GetModuleParamString("ItemURL"), item.Data, base.Namespaces));
        //                documentdata.Append("\"");
        //                documentdata.Append(" ItemURLText=\"" + CustomParse.Parse(base.GetModuleParamString("ItemURLText"), item.Data, base.Namespaces));
        //                documentdata.Append("\"");
        //            }

        //            documentdata.Append(">");
        //            documentdata.Append(CustomParse.Parse(base.GetModuleParamString("ItemText"), item.Data, base.Namespaces));
        //            documentdata.Append("</Item>");
        //        }

        //        documentdata.Append("</DetailList>");

        //    }

        //    documentdata.Append("</Items>");

        //    document.LoadXml(documentdata.ToString().Replace("&", "&amp;"));

        //    XslCompiledTransform xslt = new XslCompiledTransform();
        //    XsltArgumentList args = new XsltArgumentList();
        //    args.AddParam("root", "", Root.Domain);

        //    litCategoryList.Text = Framework.Utilities.XslHelper.TransformInMemory(Server.MapPath("~/Profile/modules/NetworkCategories/NetworkCategories.xslt"), args, document.OuterXml);

        //}

    }
    public class CategoryListData
    {
        public CategoryListData(string category, List<Item> items)
        {
            this.Category = category;
            this.Items = items;
        }

        public string Category { get; set; }
        public List<Item> Items { get; set; }

    }
    public class Item
    {
        public Item(string item, string itemid, XmlNode data, double weight)
        {
            this.item = item;
            this.ItemID = itemid;
            this.Data = data;
            this.Weight = weight;
        }
        public string item { get; set; }
        public string ItemID { get; set; }
        public double Weight { get; set; }
        public XmlNode Data { get; set; }

    }
}