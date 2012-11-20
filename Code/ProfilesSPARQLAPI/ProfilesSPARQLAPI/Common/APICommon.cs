/*  
 
    Copyright (c) 2008-2012 by the President and Fellows of Harvard College. All rights reserved.  
    Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
    and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
    National Center for Research Resources and Harvard University.


    Code licensed under a BSD License. 
    For details, see: LICENSE.txt 
  
*/
using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using System.Xml;
using System.Text;
using System.Configuration;

using SemWeb;
using SemWeb.Query;

namespace Search
{
    public class APICommon : System.Web.UI.Page
    {
            
        public void DebugLogging(string text)
        {
            try
            {
                //Each error that occurs will trigger this event.
                try
                {
                    using (StreamWriter w = File.AppendText(AppDomain.CurrentDomain.BaseDirectory + "/API_LOG.txt"))
                    {
                        // write a line of text to the file
                        w.WriteLine(DateTime.Now.ToLongDateString() + ": " + DateTime.Now.ToLongTimeString() + " " + Environment.NewLine + text + Environment.NewLine + "<----------------------------------------->");
                        // close the stream
                        w.Close();
                    }
                }
                catch (Exception ex) { throw ex; }
            }
            catch { }

        }

    }
}
