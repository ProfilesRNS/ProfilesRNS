/*  
 
    Copyright (c) 2008-2011 by the President and Fellows of Harvard College. All rights reserved.  
    Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
    and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
    National Center for Research Resources and Harvard University.


    Code licensed under a BSD License. 
    For details, see: LICENSE.txt 
  
*/
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Profiles.Framework.Utilities
{
    public class DropDownListItem
    {
        public DropDownListItem(string text, string value)
        {
            this.Text = text;
            this.Value = value;
        }

        public string Text { get; set; }
        public string Value { get; set; }

    }
}
