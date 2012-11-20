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

namespace Profiles.Framework.Utilities
{
    /// <summary>
    /// This class is used to hold the state and process the HTML for tabs that are defined Panels of type="main"
    /// </summary>
    public class Tab
    {
        public Tab(string name, string url, bool active,bool defaulttab){

            this.Name = name;
            this.URL = url;
            this.Active = active;
            this.Default = defaulttab;

    }
        public string Name { get; set; }
        public string URL { get; set; }
        public bool Active { get; set; }
        public bool Default { get; set; }
    }
    static public class Tabs
    {

        static public string DrawTabsStart()
        {
            return "<div class='tabBack'>";
        }
        static public string DrawTabsStartMarginTop(string marginTop)
        {
            return "<div class='tabBack' style='margin-top:" + marginTop + "px;'>";
        }
        static public string DrawActiveTab(string tempLabel)
        {
            return "<div class='activeTab'><div class='tabLeft'></div><div class='tabCenter'>" + tempLabel + "</div><div class='tabRight'></div></div>";
        }
        static public string DrawDisabledTab(string tempLabel, string tempAction)
        {
            return "<div class='disabledTab'><a href='" + tempAction + "'><div class='tabLeft'></div><div class='tabCenter'>" + tempLabel + "</div><div class='tabRight'></div></a></div>";
        }
        static public string DrawTabsEnd()
        {
            return "</div>";
        }    


    }
}
