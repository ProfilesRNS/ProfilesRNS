using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

using Profiles.Framework.Utilities;

namespace Profiles.Search.Utilities
{
    public static class SearcDropDowns
    {


        public static string BuildDropdown(string type, string width, string defaultitem)
        {
            Utilities.DataIO data = new Profiles.Search.Utilities.DataIO();
            string output = string.Empty;
            
            List<GenericListItem> list = new List<GenericListItem>();

            switch (type)
            {
                case "institution":
                    list = data.GetInstitutions();            
                    break;

                case "department":
                    list = data.GetDepartments();
                    break;
                case "division":
                    list = data.GetDivisions();
                    break;
            }

            //if (defaultitem.IsNullOrEmpty())
                output += "<option value=\"\"></option>";


            foreach (GenericListItem item in list)
            {
                if (!defaultitem.IsNullOrEmpty() && defaultitem == item.Value)
                    output += "<option selected=\"true\" value=\"" + item.Value + "\">" + item.Text + "</option>";
                else
                    output += "<option value=\"" + item.Value + "\">" + item.Text + "</option>";
            }

            return "<select name=\"" + type + "\" id=\"" + type + "\" style=\"width:" + width + "px\">" + output + "</select>";

        }

    }

}
