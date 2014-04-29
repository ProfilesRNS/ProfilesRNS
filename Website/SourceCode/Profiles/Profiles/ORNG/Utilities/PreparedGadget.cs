using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Configuration;
using System.Text;
using Profiles.Framework.Utilities;


namespace Profiles.ORNG.Utilities
{

    public class PreparedGadget : IComparable<PreparedGadget>
    {
        private static SocketConnectionPool sockets = null;

        private GadgetSpec gadgetSpec;
        private OpenSocialManager openSocialManager;
        private string securityToken;
        private string view;
        private string optParams;
        private string chromeId;

        internal static void Init()
        {
            string[] tokenService = ORNGSettings.getSettings().TokenService.Split(':');
            int min = ORNGSettings.getSettings().SocketPoolMin;
            int max = ORNGSettings.getSettings().SocketPoolMax;
            int expire = ORNGSettings.getSettings().SocketPoolExpire;
            int timeout = ORNGSettings.getSettings().SocketReceiveTimeout;

            sockets = new SocketConnectionPool(tokenService[0], Int32.Parse(tokenService[1]), min, max, expire, timeout);
        }

        // tool gadgets
        public PreparedGadget(GadgetSpec gadgetSpec, OpenSocialManager openSocialManager)
        {
            this.gadgetSpec = gadgetSpec;
            this.openSocialManager = openSocialManager;
            this.securityToken = SocketSendReceive(openSocialManager.GetViewerURI(), openSocialManager.GetOwnerURI(), gadgetSpec.GetGadgetURL());

            // look at the view requirements and what page we are on to set some things
            GadgetViewRequirements viewReqs = GetGadgetViewRequirements();
            if (viewReqs != null)
            {
                this.view = viewReqs.GetView();
                this.chromeId = viewReqs.GetChromeId();
                this.optParams = viewReqs.GetOptParams();
            }
            else  // must be a sandbox gadget
            {
                this.view = "";
                this.chromeId = "gadgets-test-" + gadgetSpec.GetAppId();
                this.optParams = "{}";
            }
        }

        // OntologyGadgets
        public PreparedGadget(GadgetSpec gadgetSpec, OpenSocialManager openSocialManager, string view, string optParams, string chromeId)
        {
            this.gadgetSpec = gadgetSpec;
            this.openSocialManager = openSocialManager;
            this.securityToken = SocketSendReceive(openSocialManager.GetViewerURI(), openSocialManager.GetOwnerURI(), gadgetSpec.GetGadgetURL());
            this.view = view;
            this.chromeId = chromeId;
            this.optParams = optParams == null || optParams.Trim() == string.Empty ? "{}" : optParams;
        }

        public int CompareTo(PreparedGadget other)
        {
            GadgetViewRequirements gvr1 = this.GetGadgetViewRequirements();
            GadgetViewRequirements gvr2 = other.GetGadgetViewRequirements();
            return ("" + this.GetChromeId() + (gvr1 != null ? 1000 + gvr1.GetDisplayOrder() : Int32.MaxValue)).CompareTo("" + other.GetChromeId() + (gvr2 != null ? 1000 + gvr2.GetDisplayOrder() : Int32.MaxValue));
        }

        private GadgetViewRequirements GetGadgetViewRequirements() 
        {
            return gadgetSpec.GetGadgetViewRequirements(openSocialManager.GetPageName());
        }

        public string GetSecurityToken()
        {
            return securityToken;
        }

        public string GetChromeId()
        {
            return chromeId;
        }

        public string GetView()
        {
            return view;
        }

        public string GetOptParams()
        {
            return optParams;
        }

        // passthroughs
        public int GetAppId()
        {
            return gadgetSpec.GetAppId();
        }

        public string GetLabel()
        {
            return gadgetSpec.GetLabel();
        }

        public string GetGadgetURL()
        {
            return gadgetSpec.GetGadgetURL();
        }

        public string GetUnavailableMessage()
        {
            return gadgetSpec.GetUnavailableMessage();
        }

        public bool RequiresRegistration()
        {
            return gadgetSpec.RequiresRegitration();
        }

        public bool IsSandboxGadget()
        {
            return gadgetSpec.IsSandboxGadget();
        }

        #region Socket Communications

        private static string SocketSendReceive(string viewer, string owner, string gadget)
        {
            //  These keys need to match what you see in edu.ucsf.profiles.shindig.service.SecureTokenGeneratorService in Shindig
            string request = "c=default" + (viewer != null ? "&v=" + HttpUtility.UrlEncode(viewer) : "") +
                    (owner != null ? "&o=" + HttpUtility.UrlEncode(owner) : "") + "&u=" + HttpUtility.UrlEncode(gadget) + "\r\n";
            Byte[] bytesSent = System.Text.Encoding.ASCII.GetBytes(request);
            Byte[] bytesReceived = new Byte[256];

            // Create a socket connection with the specified server and port.
            //Socket s = ConnectSocket(tokenService[0], Int32.Parse(tokenService[1]));

            // during startup we might fail a few times, so be will to retry 
            string page = "";
            for (int i = 0; i < 3 && page.Length == 0; i++)
            {
                CustomSocket s = null;
                try
                {
                    s = sockets.GetSocket();

                    if (s == null)
                        return ("Connection failed");

                    // Send request to the server.
                    DebugLogging.Log("Sending Bytes");
                    s.Send(bytesSent, bytesSent.Length, 0);

                    // Receive the server home page content.
                    int bytes = 0;

                    // The following will block until te page is transmitted.
                    do
                    {
                        DebugLogging.Log("Receiving Bytes");
                        bytes = s.Receive(bytesReceived, bytesReceived.Length, 0);
                        page = page + Encoding.ASCII.GetString(bytesReceived, 0, bytes);
                        DebugLogging.Log("Socket Page=" + page + "|");
                    }
                    while (page.Length == page.TrimEnd().Length && bytes > 0);
                }
                catch (Exception ex)
                {
                    DebugLogging.Log("Socket Error :" + ex.Message);
                    page = "";
                }
                finally
                {
                    sockets.PutSocket(s);
                }
            }
            return page.TrimEnd();
        }
        #endregion
    }

}