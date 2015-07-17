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
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.Web.UI.HtmlControls;
using System.Configuration;
using System.IO;
using System.Net;

using Profiles.Login.Utilities;
using Profiles.Framework.Utilities;
using Profiles.ORNG.Utilities;

namespace Profiles.ORNG.Modules.GadgetSandbox
{
    public partial class GadgetSandbox : System.Web.UI.UserControl
    {
        Framework.Utilities.SessionManagement sm;
        string sandboxPassword = String.Empty;

        protected void Page_Load(object sender, EventArgs e)
        {           

            if (!IsPostBack)
            {
                // don't let them in if the configuration is not set up!  You want it this way in production
                if (sandboxPassword == null || sandboxPassword.Length == 0)
                {
                    Response.Redirect(Root.Domain);
                }
                else
                {
                    string gadgetURLs = "";
                    foreach (GadgetSpec gadget in OpenSocialManager.GetAllDBGadgets(false).Values)
                    {
                        gadgetURLs += gadget.GetGadgetURL() + Environment.NewLine;
                    }
                    txtGadgetURLS.Text = gadgetURLs;
                }
            }

        }

        public GadgetSandbox() { }
        public GadgetSandbox(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
        {
           sm = new Profiles.Framework.Utilities.SessionManagement();
           sandboxPassword = ORNGSettings.getSettings().SandboxPassword;
           if (sandboxPassword != null && sandboxPassword.Length > 0)
           {
               LoadAssets();
           }
        }

        protected void cmdSearch_Click(object sender, EventArgs e)
        {
            // get the list that we already have
            String[] existingGadgetURLs = txtGadgetURLS.Text.Split(Environment.NewLine.ToCharArray());
            List<String> existingFileNames = new List<String>();
            foreach (String url in existingGadgetURLs)
            {
                existingFileNames.Add(GadgetSpec.GetGadgetFileNameFromURL(url));
            }

            try
            {
                // don't include any that we already have, based on file name
                HttpWebRequest myReq = (HttpWebRequest)WebRequest.Create(txtNewGadgetsLocation.Text);
                Uri newGadgetsUri = new Uri(txtNewGadgetsLocation.Text);
                using (StreamReader sr = new StreamReader(myReq.GetResponse().GetResponseStream()))
                {
                    bool newGadgetsFound = false;
                    String[] newGadgetHtmlCunks = sr.ReadToEnd().Split(new string[] { "<A HREF=\"" }, StringSplitOptions.None);
                    foreach (String newGadgetHtmlChunk in newGadgetHtmlCunks)
                    {
                        if (!newGadgetHtmlChunk.Contains("\">"))
                        {
                            continue;
                        }
                        String linkName = newGadgetHtmlChunk.Substring(0, newGadgetHtmlChunk.IndexOf("\">"));
                        if (linkName.EndsWith(".xml") && !existingFileNames.Contains(GadgetSpec.GetGadgetFileNameFromURL(linkName)))
                        {
                            txtGadgetURLS.Text += newGadgetsUri.Scheme + "://" + newGadgetsUri.Host + HttpUtility.UrlDecode(linkName) + Environment.NewLine;
                            newGadgetsFound = true;
                        }
                    }
                    if (!newGadgetsFound)
                    {
                        lblError.Text = "No new gadgets found at " + txtNewGadgetsLocation.Text;
                    }
                }
            }
            catch (Exception ex)
            {
                lblError.Text = "Unable to read " + txtNewGadgetsLocation.Text;
            }
        }

        protected void cmdSubmit_Click(object sender, EventArgs e)
        {

            Profiles.Login.Utilities.DataIO data = new Profiles.Login.Utilities.DataIO();

            Profiles.Login.Utilities.User user = new Profiles.Login.Utilities.User();
            user.UserName = txtUserName.Text.Trim();
            user.Password = txtUserName.Text.Trim();  // works on dev just now, need to change!

            if (user.UserName.Length == 0 && user.Password.Length == 0)
            {
                // Allow anonymous access.  Do not log in person.
                // Add the gadgets
                Session[OpenSocialManager.ORNG_GADGETS] = txtGadgetURLS.Text;
                Session[OpenSocialManager.ORNG_DEBUG] = chkDebug.Checked;
                Session[OpenSocialManager.ORNG_NOCACHE] = !chkUseCache.Checked;
                Response.Redirect(Root.Domain);
            }
            else if (sandboxPassword.Equals(txtPassword.Text.Trim()) && data.UserLogin(ref user))
            {
                // User logged in, now add the gadgets
                // add the gadgets
                Session[OpenSocialManager.ORNG_GADGETS] = txtGadgetURLS.Text;
                Session[OpenSocialManager.ORNG_DEBUG] = chkDebug.Checked;
                Session[OpenSocialManager.ORNG_NOCACHE] = !chkUseCache.Checked; 
                Response.Redirect(Root.Domain);
            }
            else
            {
                lblError.Text = "Login failed, please try again";
                txtPassword.Text = "";
                txtPassword.Focus();
            }

        }

        private void LoadAssets()
        {
            HtmlLink Searchcss = new HtmlLink();
            Searchcss.Href = Root.Domain + "/Search/CSS/search.css";
            Searchcss.Attributes["rel"] = "stylesheet";
            Searchcss.Attributes["type"] = "text/css";
            Searchcss.Attributes["media"] = "all";
            Page.Header.Controls.Add(Searchcss);

            Response.Write("<script>var _path = \"" + Root.Domain + "\";</script>");


        }


    }
}