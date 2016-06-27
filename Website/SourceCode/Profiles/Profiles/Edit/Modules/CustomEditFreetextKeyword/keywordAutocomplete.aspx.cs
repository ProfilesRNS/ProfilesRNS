using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Profiles.Edit.Modules.CustomEditFreetextKeyword
{
    public partial class keywordAutocomplete : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string keys = Request.QueryString["keys"];
            Profiles.Edit.Utilities.DataIO data = new Profiles.Edit.Utilities.DataIO();
            string suggestions = data.getAutoCompleteSuggestions(keys);

            litTest.Text = suggestions;
            return;
        }
    }
}