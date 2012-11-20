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
    [ServiceContract(Namespace = "http://connects.profiles.schema/profiles", Name = "IProfileService")]
    [XmlSerializerFormat]
    public interface IProfileService
    {
        /// <summary>
        /// The ProfileSearch action provides an XML-based query mechanism for Profiles data.  ProfileSearch takes
        /// an XML request using the Profiles XML schema and returns XML data formatted according to the PersonList XML schema.
        /// </summary>
        /// <param name="Profiles">An XML request using the Profiles XML schema</param>
        /// <returns>Profiles data formatted according to the PersonList XML schema</returns>
        [OperationContract(IsTerminating = false, IsInitiating = true, IsOneWay = false,
            AsyncPattern = false, Action = "ProfileSearch")]
        [WebInvoke(Method = "POST", UriTemplate="ProfileSearch")]
        PersonList ProfileSearch(Connects.Profiles.Service.DataContracts.Profiles Profiles);

    }
}
