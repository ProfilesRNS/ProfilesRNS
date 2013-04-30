using System;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using Profiles.CustomAPI.Utilities;

public partial class EditedCount : System.Web.UI.Page
{

    protected void Page_Load(object sender, EventArgs e)
    {
        DataIO data = new DataIO();
        Response.Write(data.GetEditedCount());
    }

}
