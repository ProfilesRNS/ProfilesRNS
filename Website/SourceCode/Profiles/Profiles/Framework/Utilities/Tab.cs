/*  
 
    Copyright (c) 2008-2012 by the President and Fellows of Harvard College. All rights reserved.  
    Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
    and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
    National Center for Research Resources and Harvard University.


    Code licensed under a BSD License. 
    For details, see: LICENSE.txt 
  
*/

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
            return "<ul class='tabmenu'>";
        }
/*        static public string DrawTabsStartMarginTop(string marginTop)
        {
            return "<div class='tabBack' style='margin-top:" + marginTop + "px;'>";
        }*/
        static public string DrawActiveTab(string tempLabel)
        {
            return "<li  class='tab selected'>" + tempLabel + "</li>";
        }
        static public string DrawDisabledTab(string tempLabel, string tempAction)
        {
            return "<li class='tab' style='cursor:pointer;' onclick=\"window.location='" + tempAction + "';\" ><a href='" + tempAction + "'>" + tempLabel + "</a></li>";
        }
        static public string DrawTabsEnd()
        {

            return "<li class='last'/></ul>";
        }


    }
}
