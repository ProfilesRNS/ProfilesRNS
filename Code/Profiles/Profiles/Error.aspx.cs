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
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;

namespace Profiles
{
    public partial class aError : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["GLOBAL_ERROR"] != null)
            {               

                litError.Text = HttpContext.Current.Session["GLOBAL_ERROR"].ToString();
            }
            Session["GLOBAL_ERROR"] = null;
        }
    }
}
