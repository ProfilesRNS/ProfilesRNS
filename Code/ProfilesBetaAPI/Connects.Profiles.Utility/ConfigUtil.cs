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
using System.Text;
using System.Configuration;

namespace Connects.Profiles.Utility
{
    public static class ConfigUtil
    {

        public static string GetConfigItem(string key)
        {
            object o = ConfigurationManager.AppSettings[key];
            return (o == null) ? null : o.ToString();
        }

        public static string GetConfigItem(string section, string key)
        {
            System.Collections.Specialized.NameValueCollection nvsh =
                (System.Collections.Specialized.NameValueCollection)
                System.Configuration.ConfigurationManager.GetSection(section);

            if (nvsh == null)
                throw new ConfigurationErrorsException("can't read section " + section + " in web.config.");

            return nvsh[key];

        }

    }
}
