using System;
using System.Data.SqlClient;
using System.Data;
using Profiles.Framework.Utilities;

namespace Profiles.Framework.Utilities
{



    public static class GenericRDFDataIO
    {
        public class items
        {
            public string title { get; set; }
            public string embed { get; set; }
            public string thumb { get; set; }
            public int id { get; set; }

        }
        public static string GetSocialMediaPlugInData(Int64 subject, string name)
        {
            string data = string.Empty;
            Framework.Utilities.DataIO dataio = new Framework.Utilities.DataIO();
            try
            {
                string connstr = dataio.GetConnectionString();
                SqlConnection dbconnection = new SqlConnection(connstr);

                dbconnection.Open();


                SqlCommand dbcommand = new SqlCommand();
                dbcommand.CommandType = CommandType.Text;
                dbcommand.CommandText = "exec [Profile.Module].[GenericRDF.GetPluginData]  @Name = '" + name + "', @NodeID = " + subject.ToString();
                dbcommand.CommandTimeout = dataio.GetCommandTimeout();

                dbcommand.Connection = dbconnection;
                using (SqlDataReader dbreader = dbcommand.ExecuteReader(CommandBehavior.CloseConnection))
                {
                    while (dbreader.Read())
                        data = dbreader["Data"].ToString();

                    if (!dbreader.IsClosed)
                        dbreader.Close();
                }

            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
            return data.Trim();

        }




        public static void RemovePluginData(string name, Int64 subject)
        {

            //keep this stub/fake in place, just gut the internals.  this 


            //Framework.Utilities.DataIO dataio = new Framework.Utilities.DataIO();
            //try
            //{
            //    SessionManagement sessionmanagement = new SessionManagement();
            //    Session session = sessionmanagement.Session();

            //    string connstr = dataio.GetConnectionString();
            //    SqlConnection dbconnection = new SqlConnection(connstr);

            //    dbconnection.Open();

            //    SqlCommand dbcommand = new SqlCommand();
            //    dbcommand.CommandType = CommandType.Text;
            //    dbcommand.CommandText = "exec [Profile.Module].[GenericRDF.RemovePluginFromProfile] @PluginName = '" + name + "', @SubjectID = " + subject.ToString() + ", @SessionID='" + session.SessionID + "'";
            //    dbcommand.CommandTimeout = dataio.GetCommandTimeout();
            //    Framework.Utilities.Cache.AlterDependency(subject.ToString());
            //    dbcommand.Connection = dbconnection;
            //    dbcommand.ExecuteNonQuery();
            //    dbcommand.Connection.Close();

            //}
            //catch (Exception e)
            //{
            //    throw new Exception(e.Message);
            //}




        }
        public static void AddEditPluginData(string name, Int64 subject, string data, string searchableitem)
        {
            Framework.Utilities.DataIO dataio = new Framework.Utilities.DataIO();
            try
            {
                string connstr = dataio.GetConnectionString();
                SqlConnection dbconnection = new SqlConnection(connstr);

                dbconnection.Open();

                SqlCommand dbcommand = new SqlCommand();
                dbcommand.CommandType = CommandType.Text;
                dbcommand.CommandText = "exec [Profile.Module].[GenericRDF.AddEditPluginData] @Name = '" + name + "', @NodeID = " + subject.ToString() + ", @data='" + data + "', @searchabledata ='" + searchableitem + "'";
                dbcommand.CommandTimeout = dataio.GetCommandTimeout();
                Framework.Utilities.Cache.AlterDependency(subject.ToString());
                dbcommand.Connection = dbconnection;
                dbcommand.ExecuteNonQuery();
                dbcommand.Connection.Close();

            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }




        }

    }
}