using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Profiles.Framework.Utilities;
using System.Web.UI;
using System.Web.Script.Serialization;
using System.Configuration;

namespace Profiles.ORNG.Utilities
{
    public abstract class ORNGCallbackResponder
    {
        private static readonly string KEY_PREFIX = "ORNG.ORNGCallbackResponder :";

        public static string CURRENT_PAGE_ITEMS = "currentPageItems";
        public static string CURRENT_PAGE_ITEMS_METADATA = "currentPageItemsMetadata";
        private static int searchLimit;

        private static List<WeakReference> managers = new List<WeakReference>();

        private OpenSocialManager om;
        private string requestToRespondTo;
        JavaScriptSerializer serializer = new JavaScriptSerializer();

        static ORNGCallbackResponder()
        {
            // should make this able to take a Dictionary of things
            searchLimit = Convert.ToInt32(ConfigurationManager.AppSettings["ORNG.CallbackResponderSearchLimit"].ToString());
        }

        public ORNGCallbackResponder(string uri, Page page, bool editMode, string request)
        {
            this.om = OpenSocialManager.GetOpenSocialManager(uri, page, editMode);
            this.requestToRespondTo = request;
            // Add to Session so that it does not get prematurely garbage collected
            HttpContext.Current.Session[KEY_PREFIX + requestToRespondTo + ":" + om.GetGuid().ToString()] = this;
            managers.Add(new WeakReference(this));
        }

        public OpenSocialManager GetOpenSocialManager()
        {
            return this.om;
        }

        public int GetSearchLimit()
        {
            return searchLimit;
        }

        // JSON Helper Functions
        public string BuildJSONPersonIds(List<string> uris, string message)
        {
            // we send out an object with the following structure
            //  {message : "message", 
            //   personIds : [{baseURI : "http://whatever", suffix : [123, 456]}, 
            //                {baseURI : "http://somethingElse", suffix : [789, 111]}]
            //  }
            Dictionary<string, List<string>> allPeople = new Dictionary<string, List<string>>();
            string baseURI = new DataIO().GetRESTBaseURI();
            allPeople.Add(baseURI, new List<string>());
            foreach (String uri in uris) 
            {
                if (uri.StartsWith(baseURI))
                {
                    allPeople[baseURI].Add(uri.Substring(baseURI.Length));
                }
                else
                {   // this should not happen in Profiles, but just in case...
                    // don't bother with logic to find common baseURI's just now
                    if (!allPeople.ContainsKey(""))
                    {
                        allPeople.Add("", new List<string>());
                    }
                    allPeople[""].Add(uri);
                }
            }
            Dictionary<string, Object> foundPeople = new Dictionary<string, Object>();
            foundPeople.Add("personIds", allPeople);
            foundPeople.Add("message", message);
            return Serialize(foundPeople);
        }

        protected string Serialize(Object obj)
        {
            return serializer.Serialize(obj);
        }

        public string BuildJSONPersonIds(string uri, string message)
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