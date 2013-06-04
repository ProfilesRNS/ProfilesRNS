using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.Common;
using System.Net.Sockets;
using System.Net;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.Script.Serialization;
using System.Web.UI.HtmlControls;
using System.Text;
using Profiles.Framework.Utilities;

namespace Profiles.ORNG.Utilities
{
    public class OpenSocialManager
    {
        public static string OPENSOCIAL_DEBUG = "OPENSOCIAL_DEBUG";
        public static string OPENSOCIAL_NOCACHE = "OPENSOCIAL_NOCACHE";
        public static string OPENSOCIAL_GADGETS = "OPENSOCIAL_GADGETS";

        public static string JSON_PERSONID_CHANNEL = "JSONPersonIds";
        public static string CHANNEL = "CHANNEL";
        public static string SENDER = "SENDER";
        public static string RESPONSE = "RESPONSE";

        // Visibility Values.  TODO Should be an Enum
        public static string PUBLIC = "Public";
        public static string USERS = "Users";
        public static string PRIVATE = "Private";
        public static string IS_REGISTERED = "IsRegistered";
        public static string REGISTRY_DEFINED = "RegistryDefined";
        public static string NOBODY = "Nobody";

        private static string OPENSOCIAL_MANAGER = "OPENSOCIAL_MANAGER";
        private static string OPENSOCIAL_PAGE_REQUESTS = "OPENSOCIAL_PAGE_REQUESTS";

        public static string GADGET_SPEC_KEY = "ORNG.GADGET_SPEC_KEY";

        #region "LocalVars"

        private List<PreparedGadget> gadgets = new List<PreparedGadget>();
        private Dictionary<string, ORNGCallbackResponder> callbackResponders = new Dictionary<string, ORNGCallbackResponder>();
        private Guid guid;
        private string viewerUri = null;
        internal string ownerUri = null;
        internal bool isDebug = false;
        internal bool noCache = false;
        private string pageName;
        private Page page;
        private static SocketConnectionPool sockets = null;
        private static List<WeakReference> managers = new List<WeakReference>();


        #endregion

        #region InitPage Helpers

        static OpenSocialManager()
        {            
            if (ConfigurationManager.AppSettings["ORNG.ShindigURL"] == null)
                return;
            string[] tokenService = ConfigurationManager.AppSettings["ORNG.TokenService"].ToString().Trim().Split(':');
            int min = Convert.ToInt32(ConfigurationManager.AppSettings["ORNG.SocketPoolMin"].ToString());
            int max = Convert.ToInt32(ConfigurationManager.AppSettings["ORNG.SocketPoolMax"].ToString());
            int expire = Convert.ToInt32(ConfigurationManager.AppSettings["ORNG.SocketPoolExpire"].ToString());
            int timeout = Convert.ToInt32(ConfigurationManager.AppSettings["ORNG.SocketReceiveTimeout"].ToString());

            sockets = new SocketConnectionPool(tokenService[0], Int32.Parse(tokenService[1]), min, max, expire, timeout);
        }

        public static OpenSocialManager GetOpenSocialManager(string ownerUri, Page page, bool editMode)
        {
            return GetOpenSocialManager(ownerUri, page, editMode, false);
        }

        public static OpenSocialManager GetOpenSocialManager(string ownerUri, Page page, bool editMode, bool loadingAssets)
        {
            // synchronize?  From the debugger this seems to be single threaded, so synchronization is not needed
            if (page.Items.Contains(OPENSOCIAL_MANAGER))
            {
                if (loadingAssets)
                {
                    int currentCount = (int)page.Items[OPENSOCIAL_PAGE_REQUESTS];
                    page.Items[OPENSOCIAL_PAGE_REQUESTS] = ++currentCount;
                }
            }
            else
            {
                page.Items.Add(OPENSOCIAL_MANAGER, new OpenSocialManager(ownerUri, page, editMode));
                page.Items.Add(OPENSOCIAL_PAGE_REQUESTS, loadingAssets ? 1 : 0);
            }
            return (OpenSocialManager)page.Items[OPENSOCIAL_MANAGER];
        }

        public static OpenSocialManager GetOpenSocialManager(Guid guid)
        {
            OpenSocialManager retval = null;
            foreach (WeakReference wr in managers.ToArray<WeakReference>()) 
            {
                if (wr.Target == null)
                {
                    managers.Remove(wr);
                }
                else if (guid.Equals(((OpenSocialManager)wr.Target).guid))
                {
                    retval = wr.Target as OpenSocialManager;
                }
            }
            return retval;
        }
        
        private OpenSocialManager(string ownerUri, Page page, bool editMode)
        {
            this.guid = Guid.NewGuid();
            managers.Add(new WeakReference(this));
            this.isDebug = page.Session != null && page.Session[OPENSOCIAL_DEBUG] != null && (bool)page.Session[OPENSOCIAL_DEBUG];
            this.noCache = page.Session != null && page.Session[OPENSOCIAL_NOCACHE] != null && (bool)page.Session[OPENSOCIAL_NOCACHE];
            this.page = page;
            this.pageName = page.AppRelativeVirtualPath.Substring(2).ToLower();

            DebugLogging.Log("Creating OpenSocialManager for " + ownerUri + ", " + pageName);
            if (ConfigurationManager.AppSettings["ORNG.ShindigURL"] == null)
            {
                // do nothing
                return;
            }

            this.ownerUri = ownerUri;
    		// in editMode we need to set the viewer to be the same as the owner
	    	// otherwise, the gadget will not be able to save appData correctly            
            if (editMode)
            {
                viewerUri = ownerUri;
            }
            else
            {
                Profiles.Framework.Utilities.SessionManagement sm = new Profiles.Framework.Utilities.SessionManagement();
                viewerUri = sm.Session().PersonURI;
                if (viewerUri != null && viewerUri.Trim().Length == 0)
                {
                    viewerUri = null;
                }

            }

            string requestAppId = page.Request.QueryString["appId"];

            DebugLogging.Log("OpenSocialManager GetAllDBGadgets " + !noCache);
            Dictionary<string, GadgetSpec> allDBGadgets = GetAllDBGadgets(!noCache);

            // if someone used the sandbox to log in, grab those gadgets refreshed from the DB
            if (page.Session != null && (string)page.Session[OPENSOCIAL_GADGETS] != null)
            {
                gadgets = GetSandboxGadgets(allDBGadgets, requestAppId);
            }
            else
            {
                DebugLogging.Log("OpenSocialManager GetSecurityToken " + !noCache);
                foreach (GadgetSpec gadgetSpec in allDBGadgets.Values)
                {
                    // only add ones that are visible in this context!
                    int moduleId = 0;
                    if (((requestAppId == null && gadgetSpec.IsEnabled()) || gadgetSpec.GetAppId() == Convert.ToInt32(requestAppId)) && gadgetSpec.Show(viewerUri, ownerUri, GetPageName()))
                    {
                        String securityToken = SocketSendReceive(viewerUri, ownerUri, gadgetSpec.GetGadgetURL());
                        gadgets.Add(new PreparedGadget(gadgetSpec, this, moduleId++, securityToken));
                    }
                }
            }
            // if we are in edit mode, clear the cache
            if (editMode)
            {
                ClearOwnerCache();
            }

            // sort the gadgets
            DebugLogging.Log("Visible Gadget Count : " + gadgets.Count);
            gadgets.Sort();
        }

        public void ClearOwnerCache()
        {
            if (ownerUri != null)
            {
                Framework.Utilities.Cache.AlterDependency(GetNodeID(ownerUri).ToString());
            }
        }

        private static string GetGadgetFileNameFromURL(string url)
        {
            string[] urlbits = url.ToString().Split('/');
            return urlbits[urlbits.Length - 1];
        }

        public static Int64 GetNodeID(string uri)
        {
            string[] s = uri.Split('/');
            return Convert.ToInt64(s[s.Length - 1]);
        }

        public bool IsDebug()
        {
            return isDebug;
        }

        public bool NoCache()
        {
            return noCache;
        }

        // JSON Helper Functions
        public static string BuildJSONPersonIds(List<string> uris, string message)
        {
            Dictionary<string, Object> foundPeople = new Dictionary<string, object>();
            foundPeople.Add("personIds", uris);
            foundPeople.Add("message", message);
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            return serializer.Serialize(foundPeople);
        }

        public static string BuildJSONPersonIds(string uri, string message)
        {
            DebugLogging.Log("BuildJSONPersonIds " + uri + " : " + message);
            List<string> personIds = new List<string>();
            personIds.Add(uri);
            return BuildJSONPersonIds(personIds, message);
        }


        public void RegisterORNGCallbackResponder(string channel, ORNGCallbackResponder responder)
        {
            if (callbackResponders.ContainsKey(channel))
            {
                callbackResponders.Remove(channel);
            }
            if (responder != null)
            {
                callbackResponders.Add(channel, responder);
            }
        }

        public string GetCallbackRespose(string channel)
        {
            if (callbackResponders.ContainsKey(channel))
            {
                return callbackResponders[channel].getCallbackResponse(this, channel);
            }
            return null;
        }

        public void RemoveGadget(string name)
        {
            // if any visible gadgets depend on pubsub data that isn't present, throw them out
            PreparedGadget gadgetToRemove = null;
            foreach (PreparedGadget gadget in gadgets)
            {
                if (name.Equals(gadget.GetName()))
                {
                    gadgetToRemove = gadget;
                    break;
                }
            }
            gadgets.Remove(gadgetToRemove);
        }

        public string GetPageName()
        {
            return pageName;
        }

        public string GetIdToUrlMapJavascript()
        {
            string retval = "var idToUrlMap = {";
            foreach (PreparedGadget gadget in gadgets)
            {
                //retval += gadget.GetAppId() + ":'" + gadget.GetGadgetURL() + "', ";
                retval += "'remote_iframe_" + gadget.GetAppId() + "':'" + gadget.GetGadgetURL() + "', ";
            }
            return retval.Substring(0, retval.Length - 2) + "};";
        }

        public bool IsVisible()
        {
            // always have turned on for Profile/Display.aspx because we want to generate the "profile was viewed" in Javascript (bot proof) 
            // regardless of any gadgets being visible, and we need this to be True for the shindig javascript libraries to load
            bool retval = ConfigurationManager.AppSettings["ORNG.ShindigURL"] != null && (GetVisibleGadgets().Count > 0 || GetPageName().Equals("Profile/Display.aspx"));
            DebugLogging.Log("OpenSocialIsVisible = " + retval);
            return retval;

        }

        public List<PreparedGadget> GetVisibleGadgets()
        {
            return gadgets;
        }

        #endregion

        #region PostActivity
        public static void PostActivity(int userId, string title)
        {
            PostActivity(userId, title, null, null, null);
        }

        public static void PostActivity(int userId, string title, string body)
        {
            PostActivity(userId, title, body, null, null);
        }

        public static void PostActivity(int userId, string title, string body, string xtraId1Type, string xtraId1Value)
        {
            Profiles.ORNG.Utilities.DataIO data = new Profiles.ORNG.Utilities.DataIO();

            string sql = "INSERT INTO shindig_activity (userId, activity, xtraId1Type, xtraId1Value) VALUES (" + userId +
                ",'<activity xmlns=\"http://ns.opensocial.org/2008/opensocial\"><postedTime>" +
                Convert.ToInt64((DateTime.UtcNow - new DateTime(1970, 1, 1)).TotalMilliseconds) + "</postedTime><title>" + title + "</title>"
                + (body != null ? "<body>" + body + "</body>" : "") + "</activity>','" + xtraId1Type + "','" + xtraId1Value + "');";

            data.ExecuteSQLDataCommand(sql);

        }
        #endregion

        #region Socket Communications

        private static string SocketSendReceive(string viewer, string owner, string gadget)
        {
            //  These keys need to match what you see in edu.ucsf.profiles.shindig.service.SecureTokenGeneratorService in Shindig
            string[] tokenService = ConfigurationManager.AppSettings["ORNG.TokenService"].ToString().Trim().Split(':');

            string request = "c=default" + (viewer != null ? "&v=" + HttpUtility.UrlEncode(viewer) : "") +
                    (owner != null ? "&o=" + HttpUtility.UrlEncode(owner) : "") + "&g=" + HttpUtility.UrlEncode(gadget) + "\r\n";
            Byte[] bytesSent = Encoding.ASCII.GetBytes(request);
            Byte[] bytesReceived = new Byte[256];

            // Create a socket connection with the specified server and port.
            //Socket s = ConnectSocket(tokenService[0], Int32.Parse(tokenService[1]));
            CustomSocket s = null;
            string page = "";
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
            }
            finally
            {
                sockets.PutSocket(s);
            }

            return page.TrimEnd();
        }
        #endregion

        public void LoadAssets()
        {
            // Only do this once per page, and do it only for the last request!
            // should synchronize
            int currentCount = (int)page.Items[OPENSOCIAL_PAGE_REQUESTS];
            page.Items[OPENSOCIAL_PAGE_REQUESTS] = --currentCount;

            DebugLogging.Log("OpenSocialCurrentCount = " + currentCount);
            if (!IsVisible() || currentCount > 0)
            {
                return;
            }

            // trigger the javascript to render gadgets
            HtmlGenericControl body = (HtmlGenericControl)page.Master.FindControl("bodyMaster");
            body.Attributes.Add("onload", "my.init();");

            HtmlLink gadgetscss = new HtmlLink();
            gadgetscss.Href = Root.Domain + "/ORNG/CSS/gadgets.css";
            gadgetscss.Attributes["rel"] = "stylesheet";
            gadgetscss.Attributes["type"] = "text/css";
            gadgetscss.Attributes["media"] = "all";
            page.Header.Controls.Add(gadgetscss);

            HtmlGenericControl containerjs = new HtmlGenericControl("script");
            containerjs.Attributes.Add("type", "text/javascript");
            containerjs.Attributes.Add("src", GetContainerJavascriptSrc());
            page.Header.Controls.Add(containerjs);

            HtmlGenericControl gadgetjs = new HtmlGenericControl("script");
            gadgetjs.Attributes.Add("type", "text/javascript");
            gadgetjs.InnerHtml = GetGadgetJavascipt();
            page.Header.Controls.Add(gadgetjs);

            HtmlGenericControl shindigjs = new HtmlGenericControl("script");
            shindigjs.Attributes.Add("type", "text/javascript");
            shindigjs.Attributes.Add("src", Root.Domain + "/ORNG/JavaScript/orng.js");
            page.Header.Controls.Add(shindigjs);
        }

        private string GetContainerJavascriptSrc()
        {
            return ConfigurationManager.AppSettings["ORNG.ShindigURL"].ToString().Trim() + "/gadgets/js/core:dynamic-height:osapi:pubsub:rpc:views:rdf:shindig-container.js?c=1" +
                (isDebug ? "&debug=1" : "");
        }

        private string GetGadgetJavascipt()
        {
            string gadgetScriptText = Environment.NewLine +
                    "var my = {};" + Environment.NewLine +
                    "my.gadgetSpec = function(appId, name, url, view, chrome_id, hasRegisteredVisibility, opt_params, secureToken) {" + Environment.NewLine +
                    "this.appId = appId;" + Environment.NewLine +
                    "this.name = name;" + Environment.NewLine +
                    "this.url = url;" + Environment.NewLine +
                    "this.view = view || 'default';" + Environment.NewLine +
                    "this.chrome_id = chrome_id;" + Environment.NewLine +
                    "this.hasRegisteredVisibility = hasRegisteredVisibility;" + Environment.NewLine +
                    "this.opt_params = opt_params;" + Environment.NewLine +
                    "this.secureToken = secureToken;" + Environment.NewLine +
                    "};" + Environment.NewLine;
            gadgetScriptText += "my.openSocialURL = '" + ConfigurationManager.AppSettings["ORNG.ShindigURL"].ToString().Trim() + "';" + Environment.NewLine +
                "my.guid = '" + guid.ToString() + "';" + Environment.NewLine +
                "my.debug = " + (IsDebug() ? "1" : "0") + ";" + Environment.NewLine +
                "my.noCache = " + (NoCache() ? "1" : "0") + ";" + Environment.NewLine +
                "my.gadgets = [";
            if (GetVisibleGadgets().Count > 0)
            {
                foreach (PreparedGadget gadget in GetVisibleGadgets())
                {
                    gadgetScriptText += "new my.gadgetSpec(" + gadget.GetAppId() + ",'" + gadget.GetName() + "','" + gadget.GetGadgetURL() + "','" +
                        gadget.GetView() + "','" + gadget.GetChromeId() + "'," + (gadget.GetGadgetSpec().HasRegisteredVisibility() ? "1" : "0") + "," +
                        gadget.GetOptParams() + ",'" + gadget.GetSecurityToken() + "'), " + Environment.NewLine;
                }
                gadgetScriptText = gadgetScriptText.Substring(0, gadgetScriptText.LastIndexOf(','));
            }
            gadgetScriptText += "];" + Environment.NewLine;

            return gadgetScriptText;
        }

        public static Dictionary<string, GadgetSpec> GetAllDBGadgets(bool useCache)
        {
            // check cache first
            Dictionary<string, GadgetSpec> dbApps = useCache ? (Dictionary<string, GadgetSpec>)Cache.FetchObject(GADGET_SPEC_KEY) : null;
            if (dbApps == null)
            {
                dbApps = new Dictionary<string, GadgetSpec>();
                Profiles.ORNG.Utilities.DataIO data = new Profiles.ORNG.Utilities.DataIO();
                using (SqlDataReader dr = data.GetGadgets())
                {
                    while (dr.Read())
                    {
                        GadgetSpec spec = new GadgetSpec(Convert.ToInt32(dr[0]), dr[1].ToString(), dr[2].ToString(), Convert.ToBoolean(dr[3]), false);
                        string gadgetFileName = GetGadgetFileNameFromURL(dr[2].ToString());
                        dbApps.Add(gadgetFileName, spec);
                    }
                }

                // add to cache unless noCache is turned on 
                if (useCache)
                {
                    // set it to not timeout
                    Cache.Set(GADGET_SPEC_KEY, dbApps, -1, null);
                }
            }

            return dbApps;
        }

        private List<PreparedGadget>  GetSandboxGadgets(Dictionary<string, GadgetSpec> allDBGadgets, string requestAppId)
        {
            List<PreparedGadget> sandboxGadgets = new List<PreparedGadget>();
            // Add sandbox gadgets if there are any
            // Note that this block of code only gets executed after someone logs in with GadgetSandbox.aspx!
            String openSocialGadgetURLS = (string)page.Session[OPENSOCIAL_GADGETS];
            String[] urls = openSocialGadgetURLS.Split(Environment.NewLine.ToCharArray());
            for (int i = 0; i < urls.Length; i++)
            {
                String openSocialGadgetURL = urls[i];
                if (openSocialGadgetURL.Length == 0)
                    continue;
                int appId = 0;  // if URL matches one in the DB, use DB provided appId, otherwise generate one
                string gadgetFileName = GetGadgetFileNameFromURL(openSocialGadgetURL);
                string name = gadgetFileName;
                string[] channels = new string[0];
                bool sandboxOnly = true;
                // see if we have a gadget with the same file name in the DB, if so use its configuration
                if (allDBGadgets.ContainsKey(gadgetFileName))
                {
                    appId = allDBGadgets[gadgetFileName].GetAppId();
                    name = allDBGadgets[gadgetFileName].GetName();
                    sandboxOnly = false;
                }
                else
                {
                    CharEnumerator ce = openSocialGadgetURL.GetEnumerator();
                    while (ce.MoveNext())
                    {
                        appId += (int)ce.Current;
                    }
                }
                // if they asked for a specific one, only let it in
                if (requestAppId != null && Convert.ToInt32(requestAppId) != appId)
                {
                    continue;
                }
                GadgetSpec gadgetSpec = new GadgetSpec(appId, name, openSocialGadgetURL, true, sandboxOnly);
                // only add ones that are visible in this context!
                int moduleId = 0;
                if (sandboxOnly || gadgetSpec.Show(viewerUri, ownerUri, page.AppRelativeVirtualPath.Substring(2).ToLower()))
                {
                    String securityToken = SocketSendReceive(viewerUri, ownerUri, gadgetSpec.GetGadgetURL());
                    sandboxGadgets.Add(new PreparedGadget(gadgetSpec, this, moduleId++, securityToken));
                }
            }
            return sandboxGadgets;
        }

    }
}