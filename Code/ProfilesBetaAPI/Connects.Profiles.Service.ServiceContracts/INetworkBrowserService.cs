/*  
 
    Copyright (c) 2008-2010 by the President and Fellows of Harvard College. All rights reserved.  
    Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
    and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
    National Center for Research Resources and Harvard University.


    Code licensed under a BSD License. 
    For details, see: LICENSE.txt 
  
*/
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Text;
using Connects.Profiles.Service.DataContracts;

namespace Connects.Profiles.Service.ServiceContracts
{
    [ServiceContract(Namespace = "http://connects.profiles.schema/profiles", Name = "INetworkBrowserService")]
    [XmlSerializerFormat]
    public interface INetworkBrowserService
    {
        /// <summary>
        /// </summary>
        /// <param name="Profiles"></param>
        /// <returns></returns>
        [OperationContract(IsTerminating = false, IsInitiating = true, IsOneWay = false, Action = "GetProfileNetworkForBrowser", AsyncPattern=false)]
        [WebInvoke(Method = "GET", UriTemplate = "profiles/{profileId}")]
        LocalNetwork GetProfileNetworkForBrowser(string profileId);

    }
}
