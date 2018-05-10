/*  
 
    Copyright (c) 2008-2012 by the President and Fellows of Harvard College. All rights reserved.  
    Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
    and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
    National Center for Research Resources and Harvard University.


    Code licensed under a BSD License. 
    For details, see: LICENSE.txt 
  
*/


using System;
using System.Xml;

using Profiles.Framework.Utilities;
using Profiles.ORNG.Utilities;

namespace Profiles.ORNG
{
    public partial class Default : System.Web.UI.Page
    {
        Profiles.Framework.Template masterpage;

        public void Page_Load(object sender, EventArgs e)
        {
            if (Request.RawUrl.ToLower().Contains("clearcache"))
            {
                Cache.Remove(OpenSocialManager.ORNG_GADGET_SPEC_KEY);
            }
            masterpage = (Framework.Template)base.Master;

            LoadPresentationXML();
            this.LoadAssets();
            masterpage.PresentationXML = this.PresentationXML;

        }

        private void LoadAssets()
        {
        }

        public void LoadPresentationXML()
        {
            string presentationxml = string.Empty;

            presentationxml = System.IO.File.ReadAllText(AppDomain.CurrentDomain.BaseDirectory + "/ORNG/PresentationXML/SandboxFormPresentation.xml");

            this.PresentationXML = new XmlDocument();
            this.PresentationXML.LoadXml(presentationxml);
            Framework.Utilities.DebugLogging.Log(presentationxml);

        }
        public XmlDocument PresentationXML { get; set; }

        [System.Web.Services.WebMethod]
        public static string CallORNGRPC(string guid, string request)
        {
            DebugLogging.Log("CallORNGRPC " + guid + ":" + request);
            ORNGRPCService responder = ORNGRPCService.GetRPCService(new Guid(guid));
            string retval = responder != null ? responder.call(request) : null;
            DebugLogging.Log("CallORNGRPC " + (responder == null ? "ORNGRPCService not found! guid =" : guid));
            return retval != null ? retval : "";
        }

    }

}
