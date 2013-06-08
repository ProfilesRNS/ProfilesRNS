using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Profiles.Framework.Utilities;
using System.Web.UI;
using System.Web.Script.Serialization;

namespace Profiles.ORNG.Utilities
{
    public abstract class ORNGCallbackResponder
    {
        private static readonly string KEY_PREFIX = "ORNG.ORNGCallbackResponder :";

        public static string JSON_PERSONID_REQ = "JSONPersonIds";
        public static string CLEAR_OWNER_CACHE_REQ = "ClearOwnerCache";

        private static List<WeakReference> managers = new List<WeakReference>();

        private OpenSocialManager om;
        private string requestToRespondTo;

        public ORNGCallbackResponder(string uri, Page page, bool editMode, string request)
        {
            this.om = OpenSocialManager.GetOpenSocialManager(uri, page, editMode, false);
            this.requestToRespondTo = request;
            // Add to Session so that it does not get prematurely garbage collected
            HttpContext.Current.Session[KEY_PREFIX + requestToRespondTo + ":" + om.GetGuid().ToString()] = this;
            managers.Add(new WeakReference(this));
        }

        public OpenSocialManager GetOpenSocialManager()
        {
            return this.om;
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

        public static ORNGCallbackResponder GetORNGCallbackResponder(Guid guid, string request)
        {
            DebugLogging.Log("GetORNGCallbackResponder guid :" + guid + ":" + request);
            ORNGCallbackResponder retval = null;
            foreach (WeakReference wr in managers.ToArray<WeakReference>())
            {
                if (wr.Target == null)
                {
                    DebugLogging.Log("GetORNGCallbackResponder removing WeakReference :" + wr);
                    managers.Remove(wr);
                }
                else if (request.Equals(((ORNGCallbackResponder)wr.Target).requestToRespondTo) && guid.Equals(((ORNGCallbackResponder)wr.Target).om.GetGuid()))
                {
                    retval = wr.Target as ORNGCallbackResponder;
                }
            }
            return retval;
        }

        public abstract string getCallbackResponse();
    }

}