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
using System.ComponentModel;
using System.Runtime.Serialization;
using System.ServiceModel.Activation;
using Connects.Profiles.Service.DataContracts;
using Connects.Profiles.Service.ServiceContracts;
using Connects.Profiles.Utility;

namespace Connects.Profiles.Service.ServiceImplementation
{
    [KnownType(typeof(InternalID))]
    [KnownType(typeof(InternalIDList))]
    [KnownType(typeof(OutputFilter))]
    [KnownType(typeof(OutputFilterList))]
    [KnownType(typeof(OutputOptions))]
    [KnownType(typeof(Connects.Profiles.Service.DataContracts.Profiles))]
    [AspNetCompatibilityRequirements(RequirementsMode = AspNetCompatibilityRequirementsMode.Required)]
    public class ProfileService : IProfileService
    {
        /// <summary>
        /// The ProfileSearch action provides an XML-based query mechanism for Profiles data.  ProfileSearch takes
        /// an XML request using the Profiles XML schema and returns XML data formatted according to the PersonList XML schema.
        /// </summary>
        /// <param name="Profiles">An XML request using the Profiles XML schema</param>
        /// <returns>Profiles data formatted according to the PersonList XML schema</returns>
        public PersonList ProfileSearch(Connects.Profiles.Service.DataContracts.Profiles pq)
        {
            bool isSecure = System.Convert.ToBoolean(ConfigUtil.GetConfigItem("IsSecure"));
            return new ProfileServiceAdapter().ProfileSearch(pq, isSecure);
        }

        public PersonList GetPersonFromPersonId(int personId)

        {
            return new ProfileServiceAdapter().GetPersonFromPersonId(personId);
        }

        public int GetPersonIdFromInternalId(string internalTag, string internalValue)
        {
            return new ProfileServiceAdapter().GetPersonIdFromInternalId(internalTag, internalValue);
        }


    }
}
