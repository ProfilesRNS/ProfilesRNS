using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Configuration;
using System.IO;
using System.Diagnostics;

namespace ProfilesSearchAPI.Utilities
{
    public static class DebugLogging
    {

        public static void Log(string msg)
        {
            //Each error that occurs will trigger this event.
            try
            {
                if (Convert.ToBoolean(ConfigurationSettings.AppSettings["DEBUG"]) == true)
                {
                    using (StreamWriter w = File.AppendText(ConfigurationSettings.AppSettings["DEBUG_PATH"]))
                    {
                        // write a line of text to the file
                        w.WriteLine("\t" + msg.Trim() + " " + DateTime.Now.ToLongTimeString());
                        w.Close();
                    }
                }
            }
            catch (Exception ex)
            {               
               
            }

        }        

    }
}
