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
using System.Xml;
using System.Xml.XPath;
using System.Xml.Xsl;


namespace Profiles.Framework.Utilities
{
    /// <summary>
    /// All modules that inherent this base class will have the ablity to extract the module parameters defined in a PresentationXML and provide an additional
    /// data call based on a Data URI supplied as a module parameter.
    /// </summary>
    public class BaseModule : System.Web.UI.UserControl
    {
        public BaseModule() { }
        public BaseModule(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
        {
            Utilities.DebugLogging.Log("Module created from " + this.Page.ToString());
            this.LoadRawQueryString();

            this.BaseData = pagedata;
            this.ModuleParams = moduleparams;
            this.Namespaces = pagenamespaces;

            this.MasterPage = (Framework.Template)Page.Master;
        }
        public void BaseModule_Init(object sender, EventArgs e)
        {
            

        }

        public void GetDataByURI()
        {
           
            Profile.Utilities.DataIO dataio = new Profile.Utilities.DataIO();

            Namespace rdfnamespaces = new Namespace();
            try
            {
                if (this.RDFTriple == null)
                    this.RDFTriple = new RDFTriple(this.BaseData.SelectSingleNode(this.GetModuleParamString("DataURI"), this.Namespaces).InnerText);

                if (this.GetModuleParamString("Offset") != string.Empty)
                    this.RDFTriple.Offset = this.GetModuleParamString("Offset");
                else
                    this.RDFTriple.Offset = string.Empty;



                if (this.GetModuleParamString("Limit") != string.Empty)
                    this.RDFTriple.Limit = this.GetModuleParamString("Limit");
                else
                    this.RDFTriple.Limit = string.Empty;


                if (this.GetModuleParamString("Edit") == "true")
                    this.RDFTriple.Edit = true;

                this.RDFTriple.ShowDetails = true;
                this.RDFTriple.Expand = true;
                this.BaseData = dataio.GetRDFData(this.RDFTriple);
                this.Namespaces = rdfnamespaces.LoadNamespaces(this.BaseData);

            }
            catch (Exception ex) { Framework.Utilities.DebugLogging.Log(ex.Message + " ++ " + ex.StackTrace); }

        }

        public void GetNetworkProfile(Int64 subject, Int64 predicate)
        {
            Profile.Utilities.DataIO dataio = new Profile.Utilities.DataIO();

            Namespace rdfnamespaces = new Namespace();
            try
            {
                this.RDFTriple = new RDFTriple(subject,predicate);

                this.RDFTriple.ShowDetails = true;
                this.RDFTriple.Expand = true;
                //This method is used during the edit process.
                this.RDFTriple.Edit = true;

                  this.BaseData = dataio.GetRDFData(this.RDFTriple);
                this.Namespaces = rdfnamespaces.LoadNamespaces(this.BaseData);

            }
            catch (Exception ex) { Framework.Utilities.DebugLogging.Log(ex.Message + " ++ " + ex.StackTrace); }



        }
        public void GetSubjectProfile()
        {
            Profile.Utilities.DataIO dataio = new Profile.Utilities.DataIO();

            Namespace rdfnamespaces = new Namespace();
            try
            {
                this.RDFTriple = new RDFTriple(Convert.ToInt64(HttpContext.Current.Request.QueryString["subject"]));

                this.RDFTriple.ShowDetails = true;
                this.RDFTriple.Expand = true;
                //This method is used during the edit process.
                this.RDFTriple.Edit = true;

               this.BaseData = dataio.GetRDFData(this.RDFTriple);
                this.Namespaces = rdfnamespaces.LoadNamespaces(this.BaseData);

            }
            catch (Exception ex) { Framework.Utilities.DebugLogging.Log(ex.Message + " ++ " + ex.StackTrace); }

        }
        public List<ModuleParams> ModuleParams { get; set; }
        public RDFTriple RDFTriple { get; set; }

		// Helpers
		public string GetRootDomain()
		{
			return Root.Domain;
		}

        //The data
        public XmlDocument BaseData { get; set; }
        public Profiles.Framework.Template MasterPage { get; set; }
        public XmlDocument PresentationXML
        {
            get
            {
                if (this.MasterPage == null)
                    this.MasterPage = (Framework.Template)Page.Master;

                return this.MasterPage.PresentationXML;
            }
        }
        public XmlNamespaceManager Namespaces { get; set; }
        public string GetModuleParamString(string param)
        {
            string rtn = string.Empty;
            try
            {
                if (this.GetModuleParamXml(param) != null)
                    rtn = this.GetModuleParamXml(param).InnerText;
            }
            catch (Exception ex)
            {
                Framework.Utilities.DebugLogging.Log(ex.Message + " ++ " + ex.StackTrace);

            }

            return rtn;
        }
        public XmlNode GetModuleParamXml(string param)
        {
            XmlNode rtn = null;

            ModuleParams mp = null;
            mp = this.ModuleParams.Find(delegate(ModuleParams module) { return module.Node.SelectSingleNode(".").Attributes[0].Value == param; });

            try
            {
                if (mp != null)
                    rtn = mp.Node;
            }
            catch (Exception ex)
            {
                Framework.Utilities.DebugLogging.Log(ex.Message + " ++ " + ex.StackTrace);
            }

            return rtn;
        }
        public void LoadRawQueryString()
        {


            string[] rawurl = HttpContext.Current.Request.RawUrl.Substring(HttpContext.Current.Request.RawUrl.IndexOf("?") + 1).Split('&');

            List<RawQueryStringItem> items = new List<RawQueryStringItem>();

            for (int i = 0; i < rawurl.Length; i++)
            {
                if (rawurl[i].Split('=').Length > 1)
                    items.Add(new RawQueryStringItem(rawurl[i].Split('=')[0], rawurl[i].Split('=')[1]));
            }

            this.RawQueryStringItems = items;


        }
        private List<RawQueryStringItem> RawQueryStringItems { get; set; }
        public string GetRawQueryStringItem(string key)
        {
            List<RawQueryStringItem> nodes = this.RawQueryStringItems;

            RawQueryStringItem node;
            node = RawQueryStringItems.Find(delegate(RawQueryStringItem localnode) { return localnode.Key.ToLower() == key.ToLower(); });
            if (node == null)
            {
                return string.Empty;
            }
            else
            {
                return node.Value;
            }
        }
        private class RawQueryStringItem
        {

            public RawQueryStringItem(string key, string value)
            {
                this.Key = key;
                this.Value = value;
            }
            public string Key { get; set; }
            public string Value { get; set; }


        }
        public string RenderCustomControl(string modulexml,XmlDocument node)
        {
            XmlDocument module = new XmlDocument();
            module.LoadXml(modulexml);

            return this.RenderCustomControl(module,node);
        }

        public string RenderCustomControl(XmlDocument moduledoc,XmlDocument node)
        {
            System.Text.StringBuilder html = new System.Text.StringBuilder();
            Framework.Utilities.ModulesProcessing mp = new ModulesProcessing();

            foreach (XmlNode module in moduledoc)
            {
                this.Modules = mp.FetchModules(module);

                foreach (Module m in this.Modules)
                {
                    html.Append(mp.RenderView(mp.LoadControl(m.Path, this.MasterPage, node, m.ParamList, this.Namespaces)));

                }
                this.Modules = null;
            }

            return html.ToString();
        }
        public void RenderAndAttachCustomControl(ref System.Web.UI.WebControls.PlaceHolder ph, XmlDocument moduledoc, XmlDocument node)
        {
            System.Text.StringBuilder html = new System.Text.StringBuilder();
            Framework.Utilities.ModulesProcessing mp = new ModulesProcessing();

            foreach (XmlNode module in moduledoc)
            {
                this.Modules = mp.FetchModules(module);

                foreach (Module m in this.Modules)
                {
                    ph.Controls.Add(mp.LoadControl(m.Path, this.MasterPage, node, m.ParamList, this.Namespaces));

                }
                this.Modules = null;
            }
        }

        private List<Module> Modules { get; set; }
		
    }
}
