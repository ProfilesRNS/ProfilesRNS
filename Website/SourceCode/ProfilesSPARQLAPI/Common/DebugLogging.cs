using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Configuration;
using System.IO;


namespace Search.Common
{
    public static class DebugLogging
    {
        /// <summary>
        /// Debug tool for logging information during runtime. Just call it when you want to load debug data to a file, or errors.
        /// </summary>
        /// <param name="msg"></param>
        public static void Log(string msg)
        {
            try
            {

                if (Convert.ToBoolean(ConfigurationSettings.AppSettings["LogService"]) == true)
                {

                    //Each error that occurs will trigger this event.
                    try
                    {
                        using (StreamWriter w = File.AppendText(ConfigurationSettings.AppSettings["DEBUG_PATH"]))
                        {
                            // write a line of text to the file
                            w.WriteLine(DateTime.Now.ToLongDateString() + ": " + DateTime.Now.ToLongTimeString() + " " + msg);                         
                            w.Close();
                        }             
                    }
                    catch (Exception ex) { throw ex; }
                }
            }
            catch { }
        }


    }
}
