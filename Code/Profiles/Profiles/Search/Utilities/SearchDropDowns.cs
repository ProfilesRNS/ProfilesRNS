using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

using Profiles.Framework.Utilities;
namespace Profiles.Search.Utilities
{
    public static class SearcDropDowns
    {


        public static string BuildDropdown(string type,string width)
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

            output += "<option value=\"\">&nbsp;&nbsp;-- Select One --&nbsp;&nbsp;</option>";

            foreach (GenericListItem item in list)
            {
                output += "<option value=\"" + item.Value + "\">" + item.Text + "</option>";

            }

            return "<select id=\"" + type + "\" style=\"width:" + width + "\">" + output + "</select>";

        }

    }
}
