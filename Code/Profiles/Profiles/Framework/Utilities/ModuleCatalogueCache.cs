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
using System.Web.Caching;
using System.IO;

namespace Profiles.Framework.Utilities
{
    //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    public class Module
    {
        private string _path;
        private string _key;
        private List<ModuleParams> _paramlist;


        //***************************************************************************************************************************************
        public Module(string path, string key, List<ModuleParams> paramlist, string displayrule)
        {
            this.Path = path;
            this.Key = key;
            this.ParamList = paramlist;
            this.DisplayRule = displayrule;
        }

        public string Path { get { return _path.Replace("\r\n", "").Trim(); } set { _path = value; } }
        public string Key { get { return _key.Replace("\r\n", "").Trim(); } set { _key = value; } }
        public List<ModuleParams> ParamList { get { return _paramlist; } set { _paramlist = value; } }
        public string DisplayRule { get; set; }

    }


    //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    public class ModuleParams
    {
        //***************************************************************************************************************************************
        public ModuleParams(XmlNode node)
        {
            this.Node = node;
        }
        public XmlNode Node { get; set; }
    }
    //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    public sealed class ModuleCatalogueCache
    {
        private List<Module> _modules;

        public static ModuleCatalogueCache Instance { get; private set; }

        static ModuleCatalogueCache() { Instance = new ModuleCatalogueCache(); }

        public ModuleCatalogueCache()
        {
            _modules = new List<Module>();
            LoadModules();
        }

        public void LoadModules()
        {
            if (HttpRuntime.Cache["MODULES"] == null)
            {
                XmlDocument applicationcatalogue = new XmlDocument();

                applicationcatalogue.Load(new StreamReader(AppDomain.CurrentDomain.BaseDirectory + "\\applicationmodulecatalogue.xml"));
                XmlDocument modulecache = new XmlDocument();
                List<ModuleParams> moduleparams = new List<ModuleParams>();
                string modulepath = string.Empty;

                foreach (XmlNode app in applicationcatalogue.SelectNodes("ApplicationList/Application"))
                {
                    if (app.SelectSingleNode("@Enabled").Value == "true")
                    {
                        modulecache.Load(new StreamReader(AppDomain.CurrentDomain.BaseDirectory + app.SelectSingleNode("@ApplicaitonPath").Value + "\\" + app.SelectSingleNode("@ModulePath").Value + "\\Modulecatalogue.xml"));

                        foreach (XmlNode module in modulecache.SelectNodes("ModuleList/Module"))
                        {
                            if (module.SelectSingleNode("@Enabled").Value == "true")
                            {
                                modulepath = "~/" + app.SelectSingleNode("@ApplicaitonPath").Value + "/" + module.SelectSingleNode("@ModulePath").Value + "/" + module.SelectSingleNode("@NameSpace").Value + "/" + module.SelectSingleNode("@FileName").Value;
                                if (this.GetModule(module.SelectSingleNode("@NameSpace").Value)==null){
                                    _modules.Add(new Module(modulepath, module.SelectSingleNode("@NameSpace").Value, null, ""));
                                }
                                _modules.Add(new Module(modulepath, app.SelectSingleNode("@ApplicaitonPath").Value+"."+module.SelectSingleNode("@NameSpace").Value, null, ""));
                                moduleparams = new List<ModuleParams>();
                            }
                        }

                        modulecache = new XmlDocument();
                    }
                }

                System.Web.Caching.CacheItemRemovedCallback callback = new System.Web.Caching.CacheItemRemovedCallback(OnRemove);
                HttpRuntime.Cache.Insert("MODULES", _modules, null, DateTime.Now.AddHours(1), TimeSpan.Zero, System.Web.Caching.CacheItemPriority.Default, callback);
            }
        }

        //***************************************************************************************************************************************
        public Module GetModule(string modulekey)
        {
            List<Module> modules = (List<Module>)HttpRuntime.Cache["MODULES"];
            Module rtnmodule = null;
            try
            {
            
                rtnmodule = modules.Find(delegate(Module module) { return module.Key == modulekey; });

            }
            catch (Exception ex) { }

            return rtnmodule;
        }

        //***************************************************************************************************************************************
        public static void OnRemove(string key, object cacheItem, System.Web.Caching.CacheItemRemovedReason reason)
        {
            //When the cache expires then reload it from the API call.
            ModuleCatalogueCache.Instance.LoadModules();
        }


    }
}

