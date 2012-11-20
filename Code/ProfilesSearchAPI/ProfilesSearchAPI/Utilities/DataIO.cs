using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Xml;

namespace ProfilesSearchAPI.Utilities
{
    public class DataIO
    {

		public XmlDocument Search(Search.SearchOptions searchoptions, bool lookup)
        {
            string xmlstr = string.Empty;

            XmlDocument xmlrtn = new XmlDocument();

            xmlstr = Utilities.SerializeXML.SerializeToString(searchoptions);

            xmlstr = xmlstr.Replace("<?xml version=\"1.0\" encoding=\"utf-8\"?>", "");
            xmlstr = xmlstr.Replace("<?xml version=\"1.0\" encoding=\"utf-16\"?>", "");

            try
            {
                string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;
                bool secure = Convert.ToBoolean(ConfigurationManager.AppSettings["IsSecure"]);

                SqlConnection dbconnection = new SqlConnection(connstr);
                SqlCommand dbcommand = new SqlCommand();

                SqlDataReader dbreader;
                dbconnection.Open();
                dbcommand.CommandType = CommandType.StoredProcedure;

                dbcommand.CommandText = "[Search.].[GetNodes]";
                dbcommand.CommandTimeout = this.GetCommandTimeout();

                
                if (secure)
                    dbcommand.Parameters.Add(new SqlParameter("@UseCache", "Private"));

                dbcommand.Parameters.Add(new SqlParameter("@SearchOptions", xmlstr));
                dbcommand.Parameters.Add(new SqlParameter("@sessionid", DBNull.Value));

                if (lookup)
                    dbcommand.Parameters.Add(new SqlParameter("@Lookup", 1));

                dbcommand.Connection = dbconnection;

                dbreader = dbcommand.ExecuteReader(CommandBehavior.CloseConnection);

                xmlstr = string.Empty;

                while (dbreader.Read())
                {
                    xmlstr += dbreader[0].ToString();
                }



                xmlrtn.LoadXml(xmlstr);

                if (!dbreader.IsClosed)
                    dbreader.Close();


                Utilities.DebugLogging.Log(xmlstr);

            }
            catch (Exception e)
            {
                Utilities.DebugLogging.Log(e.Message + " " + e.StackTrace);
                throw new Exception(e.Message);
            }

            return xmlrtn;

        }

        public int GetCommandTimeout()
        {
            return Convert.ToInt32(ConfigurationSettings.AppSettings["COMMANDTIMEOUT"]);

        }
    }
}
