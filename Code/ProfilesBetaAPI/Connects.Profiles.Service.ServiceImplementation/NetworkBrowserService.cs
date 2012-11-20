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

using System.IO;

namespace Connects.Profiles.Service.ServiceImplementation
{
    [KnownType(typeof(Connects.Profiles.Service.DataContracts.LocalNetwork))]
    [AspNetCompatibilityRequirements(RequirementsMode = AspNetCompatibilityRequirementsMode.Required)]
    public class NetworkBrowserService : INetworkBrowserService
    {
        #region INetworkBrowserService Members

        public LocalNetwork GetProfileNetworkForBrowser(string profileId)
        {
            try
            {
                return new NetworkBrowserServiceAdapter().GetProfileNetworkForBrowser(Convert.ToInt32(profileId));
            }
            catch (Exception ex)
            {
                DebugLogging.Log("message==>" + ex.Message + " stacktrace==>" + ex.StackTrace + " source==" + ex.Source + " INNER: stack trace==> " + ex.InnerException.StackTrace + " message==>" + ex.InnerException.Message);
                throw ex;
            }
        }



        #endregion
    }
}
