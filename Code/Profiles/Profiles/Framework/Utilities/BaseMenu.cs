/*  
 
    Copyright (c) 2008-2012 by the President and Fellows of Harvard College. All rights reserved.  
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
    public class BaseMenu : System.Web.UI.UserControl
    {

        System.Text.StringBuilder menulist;
        SessionManagement sm;

        public BaseMenu()
        {

            menulist = new System.Text.StringBuilder();
            sm = new SessionManagement();

        }

        protected string BuildMainMenu()
        {

            menulist.Append("<ul>");

            menulist.Append("<li><a href='" + Root.Domain + "/search'>Search</a></li>");

            menulist.Append("<li><a href='" + Root.Domain + "/SPARQL/default.aspx'>SPARQL</a></li>");

            menulist.Append("<li><a href='" + Root.Domain + "/about/default.aspx'>About</a></li>");

            if (sm.Session().UserID == 0)
            {
                if (!Root.AbsolutePath.Contains("login"))
                {
                    menulist.Append("<li><a href='" + Root.Domain + "/login/default.aspx?method=login&redirectto=" + Root.Domain + Root.AbsolutePath + "'>Login</a></li>");
                }
                
            }
            else
            {
                menulist.Append("<li><a href='" + Root.Domain + "/login/default.aspx?method=logout&redirectto=" + Root.Domain + Root.AbsolutePath + "'>Logout</a></li>");
            }
            menulist.Append("</ul>");

            return menulist.ToString();

        }


    }
}
