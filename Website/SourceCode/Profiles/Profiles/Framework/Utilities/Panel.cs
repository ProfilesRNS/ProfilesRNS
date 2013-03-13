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

namespace Profiles.Framework.Utilities
{
    /// <summary>
    /// This class processes a PresentationXML panel and the modules with in a Panel.
    /// </summary>
    public class Panel
    {
        ModulesProcessing mp;
        public Panel(XmlNode xml)
        {
            try
            {
                this.XML = new XmlDocument();
                this.XML.LoadXml(xml.OuterXml);
            }
            catch (Exception ex)
            {
                Framework.Utilities.DebugLogging.Log(ex.Message + " ++ " + ex.StackTrace);
                throw new Exception("XML not well formed: " + ex.Message);
            }

            this.LoadProperties();
            mp = new ModulesProcessing();
            this.Modules = mp.LoadModules(this.XML);
        }
        public Panel() {}        
        private void LoadProperties()
        {
            if (this.XML == null) { throw new Exception("Constructor did not load XML FrameworkPanel items"); }

            //Load up params            

            XmlNode buffer;

            buffer = ((XML).DocumentElement).Attributes["Name"];
            if (buffer != null) { this.Name = ((XML).DocumentElement).Attributes["Name"].Value; }
            else { this.Name = null; }

            buffer = ((XML).DocumentElement).Attributes["Alias"];
            if (buffer != null) { this.Alias = ((XML).DocumentElement).Attributes["Alias"].Value; }
            else { this.Alias = null; }

            buffer = ((XML).DocumentElement).Attributes["Type"];
            if (buffer != null) { this.Type = ((XML).DocumentElement).Attributes["Type"].Value; }
            else { this.Type = null; }

            buffer = ((XML).DocumentElement).Attributes["TabType"];
            if (buffer != null) { this.TabType = ((XML).DocumentElement).Attributes["TabType"].Value; }
            else { this.TabType = null; }

            buffer = ((XML).DocumentElement).Attributes["TabSort"];
            if (buffer != null) { this.TabSort = ((XML).DocumentElement).Attributes["TabSort"].Value; }
            else { this.TabSort = null; }

            buffer = ((XML).DocumentElement).Attributes["DisplayRule"];
            if (buffer != null) { this.DisplayRule = ((XML).DocumentElement).Attributes["DisplayRule"].Value; }
            else { this.DisplayRule = null; }


        }

    
        private XmlDocument XML { get; set; }
        public List<Module> Modules { get; set; }
        public string Name { get; set; }
        public string Alias { get; set; }
        public string Type { get; set; }
        public string TabType { get; set; }
        public string TabSort { get; set; }
        public string DisplayRule { get; set; }

        public bool DefaultTab { get; set; }
        public List<Framework.Utilities.Tab> Tabs { get; set; }

    }
}
