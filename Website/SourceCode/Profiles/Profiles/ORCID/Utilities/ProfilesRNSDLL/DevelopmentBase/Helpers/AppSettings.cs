using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DevelopmentBase.Helpers
{
    public class AppSettings
    {
        public static string AppSettingsXMLPath = "~/App_Data/XML/AppSettings.xml";

        public static string GetAppSettingValue(string tagName)
        {           
            if (AppSettingsFileExists)
            {
                return GetAppSettingValue(tagName, AppSettingsXMLPath);
            }
            else
            {
                return DevelopmentBase.Common.GetConfig(tagName);
            }
        }

        //public static string GetAppSettingValue(string TagName, string appSettingsPath)
        //{
        //    // Look in XML file in ~/App_Code directory first. If not found, look in web.config
        //    string CachedDocKey = "AppSettingsXML";
        //    string value = "";
        //    System.Xml.XmlDocument doc = new System.Xml.XmlDocument();
        //    if (System.Web.HttpContext.Current != null)
        //    {
        //        System.Xml.XmlDocument CachedDoc = (System.Xml.XmlDocument)DevelopmentBase.Helpers.Caching.CacheObjectGet(CachedDocKey);
        //        if ((CachedDoc == null))
        //        {
        //            System.Web.Caching.CacheDependency dep = new System.Web.Caching.CacheDependency(System.Web.HttpContext.Current.Server.MapPath(appSettingsPath));
        //            doc.Load(System.Web.HttpContext.Current.Server.MapPath(appSettingsPath));
        //            DevelopmentBase.Helpers.Caching.CacheObjectInsert(CachedDocKey, doc, dep);
        //        }
        //        else
        //        {
        //            doc = CachedDoc;
        //        }
        //    }
        //    else
        //    {
        //        // for windows applications
        //        doc.Load(AppSettingsXMLPath);
        //    }
        //    System.Xml.XmlNodeList elemList = doc.GetElementsByTagName(TagName);
        //    if ((elemList.Count == 0))
        //    {
        //        return DevelopmentBase.Common.GetConfig(TagName);
        //    }
        //    System.Xml.XmlNode child = elemList[0];
        //    if ((child.NodeType == System.Xml.XmlNodeType.Element))
        //    {
        //        if (!(child.Attributes["Value"] == null))
        //        {
        //            value = child.Attributes["Value"].Value;
        //        }
        //        else if (child.Attributes["value"] != null)
        //        {
        //            // Try lower case v in "Value"
        //            value = child.Attributes["value"].Value;
        //        }
        //        else
        //        {
        //            value = DevelopmentBase.Common.GetConfig(TagName);
        //        }
        //    }
        //    return value;
        //}

        //private static bool AppSettingsFileExists
        //{
        //    get
        //    {
        //        if (!string.IsNullOrEmpty(AppSettingsXMLPath))
        //        {
        //            if (System.Web.HttpContext.Current != null)
        //            {
        //                // for web apps
        //                return File.Exists(System.Web.HttpContext.Current.Server.MapPath(AppSettingsXMLPath));
        //            }
        //            else
        //            {
        //                // for windows
        //                return File.Exists(AppSettingsXMLPath);
        //            }
        //        }
        //        else
        //        {
        //            return false;
        //        }
        //    }
        //}
        
    }
}
