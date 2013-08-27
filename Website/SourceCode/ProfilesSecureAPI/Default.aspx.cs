using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;

namespace ProfilesSecureAPI
{
    public partial class _Default : System.Web.UI.Page
    {
        private static string profilesdb = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            Response.ContentType = "text/plain";
            using (SqlConnection conn = new SqlConnection(profilesdb)) 
            {
                conn.Open();
                using (SqlDataReader dbreader = new SqlCommand("SELECT internalusername, nodeid from UCSF.vwPersonExport", conn).ExecuteReader(CommandBehavior.CloseConnection))
                {
                    while (dbreader.Read())
                    {
                        Response.Write(dbreader[0].ToString() + ", " + dbreader[1].ToString() + Environment.NewLine);
                    }
                }
            }
        }
    }
}