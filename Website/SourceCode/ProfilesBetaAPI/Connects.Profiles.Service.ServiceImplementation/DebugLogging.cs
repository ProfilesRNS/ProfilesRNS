using System;
using System.Configuration;
using System.IO;


namespace Connects.Profiles.Service.ServiceImplementation
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
                    using (StreamWriter w = File.AppendText(AppDomain.CurrentDomain.BaseDirectory + "/ProfilesDebuggingLog.txt"))
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
