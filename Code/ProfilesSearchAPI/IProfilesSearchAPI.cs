using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Text;
using System.Xml;

using ProfilesSearchAPI.Utilities;

namespace Search
{
    // NOTE: If you change the interface name "IProfilesSearchAPI" here, you must also update the reference to "IProfilesSearchAPI" in Web.config.
    [ServiceContract(SessionMode=SessionMode.Allowed)]   
    [XmlSerializerFormat]
    public interface IProfilesSearchAPI
    {		
        [OperationContract(IsTerminating = false, IsInitiating = true, IsOneWay = false, AsyncPattern = false, Action = "Search")]
        [WebInvoke(Method = "POST", UriTemplate = "Search",ResponseFormat = WebMessageFormat.Xml )]
        XmlElement Search(SearchOptions SearchOptions);
        


    }
}
