using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Text;
using System.IO;
using System.Xml;


namespace Search
{
    // NOTE: If you change the interface name "IProfilesSPARQLAPI" here, you must also update the reference to "IProfilesSPARQLAPI" in Web.config.
	[ServiceContract(Namespace = "http://www.w3.org/2007/SPARQL/protocol-types#")]
	[XmlSerializerFormat]
    public interface IProfilesSPARQLAPI
    {		
		[ServiceKnownType(typeof(queryrequest))]
		[ServiceKnownType(typeof(sparql))]
		[ServiceKnownType(typeof(malformedquery))]
        [OperationContract(Name="Search",IsTerminating = false, IsInitiating = true, IsOneWay = false, AsyncPattern = false, Action = "Search")]
        [WebInvoke(Method = "POST", UriTemplate = "Search",ResponseFormat =WebMessageFormat.Xml )]
		object Search(queryrequest xml);
    }

}
