using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using CsvHelper;


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
                    CsvWriter writer = new CsvWriter(Response.Output);
                    while (dbreader.Read())
                    {
                        writer.WriteField(dbreader.GetInt32(0));
                        writer.WriteField(dbreader[1].ToString());
                        writer.WriteField(dbreader[2].ToString());
                        writer.WriteField(dbreader[3].ToString());
                        writer.WriteField(dbreader.GetDateTime(4));
                        writer.WriteField(dbreader[5].ToString());
                        writer.WriteField(dbreader[6].ToString());
                        writer.WriteField(dbreader[7].ToString());
                        writer.NextRecord();
                    }
                    Response.Output.Flush();
                }
            }
        }
    }
}