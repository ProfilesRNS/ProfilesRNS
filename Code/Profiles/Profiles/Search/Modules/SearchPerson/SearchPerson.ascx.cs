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
using System.Configuration;

using Profiles.Framework.Utilities;
using Profiles.Search.Utilities;


namespace Profiles.Search.Modules.SearchPerson
{
    public partial class SearchPerson : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            //Profiles.Search.Utilities.DataIO dropdowns = new Profiles.Search.Utilities.DataIO();
            if (Convert.ToBoolean(ConfigurationSettings.AppSettings["ShowInstitutions"]) == true)
            {
                litInstitution.Text = SearcDropDowns.BuildDropdown("institution", "249");
            }
            else
            {
                trInstitution.Visible = false;
            }

            if (Convert.ToBoolean(ConfigurationSettings.AppSettings["ShowDepartments"]) == true)
            {
                litDepartment.Text = SearcDropDowns.BuildDropdown("department", "249");
            }
            else
            {
                trDepartment.Visible = false;
            }

            if (Convert.ToBoolean(ConfigurationSettings.AppSettings["ShowDivisions"]) == true)
            {
                litDivision.Text = SearcDropDowns.BuildDropdown("division", "249");
            }
            else
            {
                trDivision.Visible = false;
            }


            BuildFilters();

        }

        public SearchPerson() { }
        public SearchPerson(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
        {

        }

        private void ModifySearch()
        {

        }


        public string GetURLDomain()
        {
            return Root.Domain;
        }




        private void BuildFilters()
        {

            Utilities.DataIO data = new Profiles.Search.Utilities.DataIO();

            System.Data.DataSet ds = data.GetPersonTypes();

            ctcFirst.DataMasterName = "DataMasterName";
            ctcFirst.DataDetailName = "DataDetailName";

            ctcFirst.DataMasterIDField = "personTypeGroupId";
            ctcFirst.DataMasterTextField = "personTypeGroup";

            ctcFirst.DataDetailIDField = "personTypeFlagId";
            ctcFirst.DataDetailTextField = "personTypeFlag";

            ctcFirst.DataSource = ds;
            ctcFirst.DataBind();

        }




    }
}
