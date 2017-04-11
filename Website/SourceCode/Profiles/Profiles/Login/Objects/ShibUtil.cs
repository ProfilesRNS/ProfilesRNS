using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;

namespace Profiles.Login.Objects
{
    static class ShibUtil
    {
        public static void Log(string msg)
        {
            try
            {
                string prefix = DateTime.Now.ToString("yyyy-MM-dd");
                string path = @"C:\logs\" + prefix + "-Shibboleth.log";

                using (System.IO.StreamWriter w = File.AppendText(path))
                {
                    // write a line of text to the file
                    w.WriteLine("\t" + msg.Trim() + " " + DateTime.Now.ToLongTimeString());
                    w.Close();
                }
            }
            catch { }
        }
    }
}