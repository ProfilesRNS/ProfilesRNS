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

namespace Connects.Profiles.Common
{
    public class UserPreferences
    {
        public string Address { get; set; }
        public string AwardsHonors { get; set; }
        public string Email { get; set; }
        public string Narrative { get; set; }
        public string Publications { get; set; }
        public string Photo { get; set; }
        public string Username { get; set; }
        public int PhotoPref { get; set; }
        public bool ProfileExists { get; set; }

    }
}
