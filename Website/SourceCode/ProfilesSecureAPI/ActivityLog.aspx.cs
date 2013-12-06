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
    public partial class ActivityLog : System.Web.UI.Page
    {
        private static string profilesdb = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            string methodName = Request["MethodName"];
            string afterDate = Request["AfterDate"];

            Response.ContentType = "text/plain";
            using (SqlConnection conn = new SqlConnection(profilesdb)) 
            {
                conn.Open();
                SqlCommand dbcommand = new SqlCommand("[UCSF.].[ReadActivityLog]", conn);
                dbcommand.CommandType = CommandType.StoredProcedure;
                dbcommand.Parameters.Add(methodName != null ? new SqlParameter("@methodName", methodName) : new SqlParameter("@methodName", DBNull.Value));
                dbcommand.Parameters.Add(afterDate != null ? new SqlParameter("@afterDT", afterDate) : new SqlParameter("@afterDT", DBNull.Value));
                using (SqlDataReader dbreader = dbcommand.ExecuteReader(CommandBehavior.CloseConnection))
                {
                    while (dbreader.Read())
                    {
                        Response.Write(dbreader[0].ToString() + ", '" +
                                       dbreader[1].ToString() + "', " +
                                       dbreader[2].ToString() + ", " +
                                       dbreader[3].ToString() + ", " +
                                       dbreader[4].ToString() + "', " +
                                       dbreader[5].ToString() + ", " +
                                       dbreader[6].ToString() + ", " +
                                       dbreader[7].ToString() + Environment.NewLine);
                    }
                }
            }
        }
    }
}