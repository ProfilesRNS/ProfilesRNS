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
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.Xml.Xsl;
using System.Configuration;

using Profiles.Profile.Utilities;
using Profiles.Search.Utilities;
using Profiles.Framework.Utilities;

namespace Profiles.Search.Modules.MiniSearch
{
    public partial class MiniSearch : BaseModule
    {
                
        protected void Page_Load(object sender, EventArgs e)
        {

            DrawProfilesModule();       
        
        }

        public MiniSearch() : base() { }

        public MiniSearch(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
        {
            

        }
        private void DrawProfilesModule()
        {

            //Profiles.Search.Utilities.DataIO dropdowns = new Profiles.Search.Utilities.DataIO();
            if (Convert.ToBoolean(ConfigurationSettings.AppSettings["ShowInstitutions"]) == true)
            {
                litInstitution.Text = SearcDropDowns.BuildDropdown("institution","150","");
            }
            else
            {
                trInstitution.Visible = false;
            }
            

        }

        public string GetURLDomain()
        {
            return Root.Domain;
        }



    }
}