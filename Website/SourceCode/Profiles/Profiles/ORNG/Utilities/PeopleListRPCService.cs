using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.Script.Serialization;
using Profiles.Framework.Utilities;
//using Connects.Profiles.Service.ServiceImplementation;

namespace Profiles.ORNG.Utilities
{
    public abstract class PeopleListRPCService : ORNGRPCService
    {
        // add more as you see fit
        public static readonly string REQUEST_PEOPLE_LIST_METADATA = "REQUEST_PEOPLE_LIST_METADATA";
        public static readonly string REQUEST_PEOPLE_LIST = "REQUEST_PEOPLE_LIST";

        JavaScriptSerializer serializer = new JavaScriptSerializer();

        public PeopleListRPCService(string uri, Page page, bool editMode)
            : base(null, page, editMode)
        {
        }

        public override string call(string request)
        {
            if (REQUEST_PEOPLE_LIST_METADATA.Equals(request))
            {
                return getPeopleListMetadata();                                                   
            }
            else if (REQUEST_PEOPLE_LIST.Equals(request))
            {
                return BuildJSONPersonIds(getPeople());                                                   
            }
            return null;
        }

        public abstract string getPeopleListMetadata();

        // return a list of URIs
        public abstract List<string> getPeople();

        // JSON Helper Functions
        private string BuildJSONPersonIds(List<string> uris)
        {
            // we send out an object with the following structure
            //  {baseURI : "http://whatever", suffix : [123, 456]}, 
            //  {baseURI2 : "http://somethingElse", suffix : [789, 111]}
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
            return Serialize(allPeople);
        }

        private string Serialize(Object obj)
        {
            return serializer.Serialize(obj);
        }

        private string BuildJSONPersonIds(string uri)
        {
            DebugLogging.Log("BuildJSONPersonIds " + uri );
            List<string> personIds = new List<string>();
            personIds.Add(uri);
            return BuildJSONPersonIds(personIds);
        }

    }
}