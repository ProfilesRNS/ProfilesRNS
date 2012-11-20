using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;
using System.Xml;


using ProfilesSearchAPI.Utilities;
using System.ServiceModel.Web;

namespace Search
{
    // NOTE: If you change the class name "ProfilesSearchAPI" here, you must also update the reference to "ProfilesSearchAPI" in Web.config.
    public class ProfilesSearchAPI : IProfilesSearchAPI
    {
        public XmlElement Search(SearchOptions SearchOptions)
        {           

            DataIO data = new DataIO();
            XmlDocument xmlDoc = data.Search(SearchOptions, false);
              
            XmlElement doc = xmlDoc.DocumentElement;
            WebOperationContext.Current.OutgoingResponse.ContentType = "application/rdf+xml";


            return doc;
       }
               
        
    }
}
