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
using System.ServiceModel;
using System.ServiceModel.Activation;
using Connects.Profiles.Service.DataContracts;
using Connects.Profiles.Utility;


using System.IO;



namespace Connects.Profiles.Service.ServiceImplementation
{
    public class NetworkBrowserServiceAdapter
    {
        public LocalNetwork GetProfileNetworkForBrowser(int profileId)
        {
            //Debug logging
            Connects.Profiles.Service.ServiceImplementation.DebugLogging.Log("Line1: profileid:" + profileId);

           DataIO nb = new DataIO();
        

            try
            {              
                
                    Type type = typeof(LocalNetwork);
                
                    string responseXML;

                    responseXML = nb.GetProfileNetworkForBrowser(profileId).OuterXml;                

                    LocalNetwork ln = XmlUtilities.DeserializeObject(responseXML, type) as LocalNetwork;

                    return ln;
                
            }
            catch (Exception ex)
            {
                DebugLogging.Log("ERROR: " + ex.Message + " " + ex.StackTrace + " ,,,, INNER EXCEPTION: " + ex.InnerException.Message + ex.InnerException.StackTrace);
                throw ex;
            }


        }

    }

}
