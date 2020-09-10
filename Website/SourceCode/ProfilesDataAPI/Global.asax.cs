using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;
//using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;
using System.Data.SqlClient;
using System.Configuration;
using System.Data;
using System.Net.Http;



namespace ProfilesDataAPI
{
    public class WebApiApplication : System.Web.HttpApplication
    {
        protected void Application_Start()
        {
            //AreaRegistration.RegisterAllAreas();
            GlobalConfiguration.Configure(WebApiConfig.Register);
            //FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);
        }
    }


    public class ProfilesAPIController : ApiController
    {

        [Route("")]
        [HttpGet]
        public System.Net.Http.HttpResponseMessage rootPage()
        {

            string str = string.Empty;
            try
            {
                string connstr = ConfigurationManager.ConnectionStrings["ProfilesDataAPIDB"].ConnectionString;
                SqlConnection dbconnection = new SqlConnection(connstr);
                SqlCommand dbcommand = new SqlCommand("[Profile.Module].[ProfilesDataAPI.GetInstructionText]");
                dbcommand.CommandTimeout = Convert.ToInt32(ConfigurationSettings.AppSettings["COMMANDTIMEOUT"]);

                SqlDataReader dbreader;
                dbconnection.Open();
                dbcommand.CommandType = CommandType.StoredProcedure;

                dbcommand.Connection = dbconnection;
                dbreader = dbcommand.ExecuteReader(CommandBehavior.CloseConnection);

                while (dbreader.Read())
                    str += dbreader[0].ToString();


                if (!dbreader.IsClosed)
                    dbreader.Close();

            }
            catch (Exception ex)
            {
                return new HttpResponseMessage(System.Net.HttpStatusCode.InternalServerError)
                {
                    ReasonPhrase = "An Error Occurred",
                    Content = new StringContent(ex.Message, System.Text.Encoding.UTF8, "text/plain")
                };
            }
            return new HttpResponseMessage()
            {
                Content = new StringContent(str, System.Text.Encoding.UTF8, "text/html")
            };
        }


        [Route("getPeople/{param1name}/{param1value}")]
        [Route("getPeople/{param1name}/{param1value}/{param2name}/{param2value}")]
        [Route("getPeople/{param1name}/{param1value}/{param2name}/{param2value}/{param3name}/{param3value}")]
        [Route("getPeople/{param1name}/{param1value}/{param2name}/{param2value}/{param3name}/{param3value}/{param4name}/{param4value}")]
        [Route("getPeople/{param1name}/{param1value}/{param2name}/{param2value}/{param3name}/{param3value}/{param4name}/{param4value}/{param5name}/{param5value}")]
        [Route("getPeople/{param1name}/{param1value}/{param2name}/{param2value}/{param3name}/{param3value}/{param4name}/{param4value}/{param5name}/{param5value}/{param6name}/{param6value}")]
        [Route("getPeople/{param1name}/{param1value}/{param2name}/{param2value}/{param3name}/{param3value}/{param4name}/{param4value}/{param5name}/{param5value}/{param6name}/{param6value}/{param7name}/{param7value}")]
        [Route("getPeople/{param1name}/{param1value}/{param2name}/{param2value}/{param3name}/{param3value}/{param4name}/{param4value}/{param5name}/{param5value}/{param6name}/{param6value}/{param7name}/{param7value}/{param8name}/{param8value}")]
        [Route("getPeople/{param1name}/{param1value}/{param2name}/{param2value}/{param3name}/{param3value}/{param4name}/{param4value}/{param5name}/{param5value}/{param6name}/{param6value}/{param7name}/{param7value}/{param8name}/{param8value}/{param9name}/{param9value}")]
        [Route("getPeople/{param1name}/{param1value}/{param2name}/{param2value}/{param3name}/{param3value}/{param4name}/{param4value}/{param5name}/{param5value}/{param6name}/{param6value}/{param7name}/{param7value}/{param8name}/{param8value}/{param9name}/{param9value}/{param10name}/{param10value}")]
        [Route("getPeople/xml/{param1name}/{param1value}")]
        [Route("getPeople/xml/{param1name}/{param1value}/{param2name}/{param2value}")]
        [Route("getPeople/xml/{param1name}/{param1value}/{param2name}/{param2value}/{param3name}/{param3value}")]
        [Route("getPeople/xml/{param1name}/{param1value}/{param2name}/{param2value}/{param3name}/{param3value}/{param4name}/{param4value}")]
        [Route("getPeople/xml/{param1name}/{param1value}/{param2name}/{param2value}/{param3name}/{param3value}/{param4name}/{param4value}/{param5name}/{param5value}")]
        [Route("getPeople/xml/{param1name}/{param1value}/{param2name}/{param2value}/{param3name}/{param3value}/{param4name}/{param4value}/{param5name}/{param5value}/{param6name}/{param6value}")]
        [Route("getPeople/xml/{param1name}/{param1value}/{param2name}/{param2value}/{param3name}/{param3value}/{param4name}/{param4value}/{param5name}/{param5value}/{param6name}/{param6value}/{param7name}/{param7value}")]
        [Route("getPeople/xml/{param1name}/{param1value}/{param2name}/{param2value}/{param3name}/{param3value}/{param4name}/{param4value}/{param5name}/{param5value}/{param6name}/{param6value}/{param7name}/{param7value}/{param8name}/{param8value}")]
        [Route("getPeople/xml/{param1name}/{param1value}/{param2name}/{param2value}/{param3name}/{param3value}/{param4name}/{param4value}/{param5name}/{param5value}/{param6name}/{param6value}/{param7name}/{param7value}/{param8name}/{param8value}/{param9name}/{param9value}")]
        [Route("getPeople/xml/{param1name}/{param1value}/{param2name}/{param2value}/{param3name}/{param3value}/{param4name}/{param4value}/{param5name}/{param5value}/{param6name}/{param6value}/{param7name}/{param7value}/{param8name}/{param8value}/{param9name}/{param9value}/{param10name}/{param10value}")]
        [Route("getPeople/xml/{param1name}/{param1value}/{param2name}/{param2value}/{param3name}/{param3value}/{param4name}/{param4value}/{param5name}/{param5value}/{param6name}/{param6value}/{param7name}/{param7value}/{param8name}/{param8value}/{param9name}/{param9value}/{param10name}/{param10value}/{param11name}/{param11value}")]
        [Route("getPeople/xml/{param1name}/{param1value}/{param2name}/{param2value}/{param3name}/{param3value}/{param4name}/{param4value}/{param5name}/{param5value}/{param6name}/{param6value}/{param7name}/{param7value}/{param8name}/{param8value}/{param9name}/{param9value}/{param10name}/{param10value}/{param11name}/{param11value}/{param12name}/{param12value}")]
        [Route("getPeople/xml/{param1name}/{param1value}/{param2name}/{param2value}/{param3name}/{param3value}/{param4name}/{param4value}/{param5name}/{param5value}/{param6name}/{param6value}/{param7name}/{param7value}/{param8name}/{param8value}/{param9name}/{param9value}/{param10name}/{param10value}/{param11name}/{param11value}/{param12name}/{param12value}/{param13name}/{param13value}")]
        [Route("getPeople/xml/{param1name}/{param1value}/{param2name}/{param2value}/{param3name}/{param3value}/{param4name}/{param4value}/{param5name}/{param5value}/{param6name}/{param6value}/{param7name}/{param7value}/{param8name}/{param8value}/{param9name}/{param9value}/{param10name}/{param10value}/{param11name}/{param11value}/{param12name}/{param12value}/{param13name}/{param13value}/{param14name}/{param14value}")]
        [HttpGet]
        public System.Net.Http.HttpResponseMessage xmlAPI(string param1name = null, string param1value = null, string param2name = null, string param2value = null,
                                                            string param3name = null, string param3value = null, string param4name = null, string param4value = null,
                                                            string param5name = null, string param5value = null, string param6name = null, string param6value = null,
                                                            string param7name = null, string param7value = null, string param8name = null, string param8value = null,
                                                            string param9name = null, string param9value = null, string param10name = null, string param10value = null,
                                                            string param11name = null, string param11value = null, string param12name = null, string param12value = null,
                                                            string param13name = null, string param13value = null, string param14name = null, string param14value = null)
        {
            string str = string.Empty;
            try
            {
                string connstr = ConfigurationManager.ConnectionStrings["ProfilesDataAPIDB"].ConnectionString;
                SqlConnection dbconnection = new SqlConnection(connstr);
                SqlCommand dbcommand = new SqlCommand("[Profile.Module].[ProfilesDataAPI.GetPersonData]");
                dbcommand.CommandTimeout = Convert.ToInt32(ConfigurationSettings.AppSettings["COMMANDTIMEOUT"]);

                SqlDataReader dbreader;
                dbconnection.Open();
                dbcommand.CommandType = CommandType.StoredProcedure;
                //dbcommand.CommandTimeout = base.GetCommandTimeout();
                dbcommand.Parameters.Add(new SqlParameter("@Format", "XML"));
                dbcommand.Parameters.Add(new SqlParameter("@param1name", param1name));
                dbcommand.Parameters.Add(new SqlParameter("@param1value", param1value));
                dbcommand.Parameters.Add(new SqlParameter("@param2name", param2name));
                dbcommand.Parameters.Add(new SqlParameter("@param2value", param2value));
                dbcommand.Parameters.Add(new SqlParameter("@param3name", param3name));
                dbcommand.Parameters.Add(new SqlParameter("@param3value", param3value));
                dbcommand.Parameters.Add(new SqlParameter("@param4name", param4name));
                dbcommand.Parameters.Add(new SqlParameter("@param4value", param4value));
                dbcommand.Parameters.Add(new SqlParameter("@param5name", param5name));
                dbcommand.Parameters.Add(new SqlParameter("@param5value", param5value));
                dbcommand.Parameters.Add(new SqlParameter("@param6name", param6name));
                dbcommand.Parameters.Add(new SqlParameter("@param6value", param6value));
                dbcommand.Parameters.Add(new SqlParameter("@param7name", param7name));
                dbcommand.Parameters.Add(new SqlParameter("@param7value", param7value));
                dbcommand.Parameters.Add(new SqlParameter("@param8name", param8name));
                dbcommand.Parameters.Add(new SqlParameter("@param8value", param8value));
                dbcommand.Parameters.Add(new SqlParameter("@param9name", param9name));
                dbcommand.Parameters.Add(new SqlParameter("@param9value", param9value));
                dbcommand.Parameters.Add(new SqlParameter("@param10name", param10name));
                dbcommand.Parameters.Add(new SqlParameter("@param10value", param10value));
                dbcommand.Parameters.Add(new SqlParameter("@param11name", param11name));
                dbcommand.Parameters.Add(new SqlParameter("@param11value", param11value));
                dbcommand.Parameters.Add(new SqlParameter("@param12name", param13name));
                dbcommand.Parameters.Add(new SqlParameter("@param12value", param13value));
                dbcommand.Parameters.Add(new SqlParameter("@param13name", param13name));
                dbcommand.Parameters.Add(new SqlParameter("@param13value", param13value));
                dbcommand.Parameters.Add(new SqlParameter("@param14name", param14name));
                dbcommand.Parameters.Add(new SqlParameter("@param14value", param14value));

                dbcommand.Connection = dbconnection;
                dbreader = dbcommand.ExecuteReader(CommandBehavior.CloseConnection);

                while (dbreader.Read())
                    str += dbreader[0].ToString();


                if (!dbreader.IsClosed)
                    dbreader.Close();

            }
            catch (Exception ex)
            {
                return new HttpResponseMessage(System.Net.HttpStatusCode.InternalServerError)
                {
                    ReasonPhrase = "An Error Occurred",
                    Content = new StringContent(ex.Message, System.Text.Encoding.UTF8, "text/plain")
                };
            }
            return new HttpResponseMessage()
            {
                Content = new StringContent(str, System.Text.Encoding.UTF8, "application/xml")
            };
        }

        [Route("getPeople/json/{param1name}/{param1value}")]
        [Route("getPeople/json/{param1name}/{param1value}/{param2name}/{param2value}")]
        [Route("getPeople/json/{param1name}/{param1value}/{param2name}/{param2value}/{param3name}/{param3value}")]
        [Route("getPeople/json/{param1name}/{param1value}/{param2name}/{param2value}/{param3name}/{param3value}/{param4name}/{param4value}")]
        [Route("getPeople/json/{param1name}/{param1value}/{param2name}/{param2value}/{param3name}/{param3value}/{param4name}/{param4value}/{param5name}/{param5value}")]
        [Route("getPeople/json/{param1name}/{param1value}/{param2name}/{param2value}/{param3name}/{param3value}/{param4name}/{param4value}/{param5name}/{param5value}/{param6name}/{param6value}")]
        [Route("getPeople/json/{param1name}/{param1value}/{param2name}/{param2value}/{param3name}/{param3value}/{param4name}/{param4value}/{param5name}/{param5value}/{param6name}/{param6value}/{param7name}/{param7value}")]
        [Route("getPeople/json/{param1name}/{param1value}/{param2name}/{param2value}/{param3name}/{param3value}/{param4name}/{param4value}/{param5name}/{param5value}/{param6name}/{param6value}/{param7name}/{param7value}/{param8name}/{param8value}")]
        [Route("getPeople/json/{param1name}/{param1value}/{param2name}/{param2value}/{param3name}/{param3value}/{param4name}/{param4value}/{param5name}/{param5value}/{param6name}/{param6value}/{param7name}/{param7value}/{param8name}/{param8value}/{param9name}/{param9value}")]
        [Route("getPeople/json/{param1name}/{param1value}/{param2name}/{param2value}/{param3name}/{param3value}/{param4name}/{param4value}/{param5name}/{param5value}/{param6name}/{param6value}/{param7name}/{param7value}/{param8name}/{param8value}/{param9name}/{param9value}/{param10name}/{param10value}")]
        [Route("getPeople/json/{param1name}/{param1value}/{param2name}/{param2value}/{param3name}/{param3value}/{param4name}/{param4value}/{param5name}/{param5value}/{param6name}/{param6value}/{param7name}/{param7value}/{param8name}/{param8value}/{param9name}/{param9value}/{param10name}/{param10value}/{param11name}/{param11value}")]
        [Route("getPeople/json/{param1name}/{param1value}/{param2name}/{param2value}/{param3name}/{param3value}/{param4name}/{param4value}/{param5name}/{param5value}/{param6name}/{param6value}/{param7name}/{param7value}/{param8name}/{param8value}/{param9name}/{param9value}/{param10name}/{param10value}/{param11name}/{param11value}/{param12name}/{param12value}")]
        [Route("getPeople/json/{param1name}/{param1value}/{param2name}/{param2value}/{param3name}/{param3value}/{param4name}/{param4value}/{param5name}/{param5value}/{param6name}/{param6value}/{param7name}/{param7value}/{param8name}/{param8value}/{param9name}/{param9value}/{param10name}/{param10value}/{param11name}/{param11value}/{param12name}/{param12value}/{param13name}/{param13value}")]
        [Route("getPeople/json/{param1name}/{param1value}/{param2name}/{param2value}/{param3name}/{param3value}/{param4name}/{param4value}/{param5name}/{param5value}/{param6name}/{param6value}/{param7name}/{param7value}/{param8name}/{param8value}/{param9name}/{param9value}/{param10name}/{param10value}/{param11name}/{param11value}/{param12name}/{param12value}/{param13name}/{param13value}/{param14name}/{param14value}")]
        [HttpGet]
        public System.Net.Http.HttpResponseMessage jsonAPI(string param1name = null, string param1value = null, string param2name = null, string param2value = null,
                                                    string param3name = null, string param3value = null, string param4name = null, string param4value = null,
                                                    string param5name = null, string param5value = null, string param6name = null, string param6value = null,
                                                    string param7name = null, string param7value = null, string param8name = null, string param8value = null,
                                                    string param9name = null, string param9value = null, string param10name = null, string param10value = null,
                                                    string param11name = null, string param11value = null, string param12name = null, string param12value = null,
                                                    string param13name = null, string param13value = null, string param14name = null, string param14value = null)
        {
            string str = string.Empty;
            try
            {
                string connstr = ConfigurationManager.ConnectionStrings["ProfilesDataAPIDB"].ConnectionString;
                SqlConnection dbconnection = new SqlConnection(connstr);
                SqlCommand dbcommand = new SqlCommand("[Profile.Module].[ProfilesDataAPI.GetPersonData]");
                dbcommand.CommandTimeout = Convert.ToInt32(ConfigurationSettings.AppSettings["COMMANDTIMEOUT"]);

                SqlDataReader dbreader;
                dbconnection.Open();
                dbcommand.CommandType = CommandType.StoredProcedure;
                //dbcommand.CommandTimeout = base.GetCommandTimeout();
                dbcommand.Parameters.Add(new SqlParameter("@Format", "JSON"));
                dbcommand.Parameters.Add(new SqlParameter("@param1name", param1name));
                dbcommand.Parameters.Add(new SqlParameter("@param1value", param1value));
                dbcommand.Parameters.Add(new SqlParameter("@param2name", param2name));
                dbcommand.Parameters.Add(new SqlParameter("@param2value", param2value));
                dbcommand.Parameters.Add(new SqlParameter("@param3name", param3name));
                dbcommand.Parameters.Add(new SqlParameter("@param3value", param3value));
                dbcommand.Parameters.Add(new SqlParameter("@param4name", param4name));
                dbcommand.Parameters.Add(new SqlParameter("@param4value", param4value));
                dbcommand.Parameters.Add(new SqlParameter("@param5name", param5name));
                dbcommand.Parameters.Add(new SqlParameter("@param5value", param5value));
                dbcommand.Parameters.Add(new SqlParameter("@param6name", param6name));
                dbcommand.Parameters.Add(new SqlParameter("@param6value", param6value));
                dbcommand.Parameters.Add(new SqlParameter("@param7name", param7name));
                dbcommand.Parameters.Add(new SqlParameter("@param7value", param7value));
                dbcommand.Parameters.Add(new SqlParameter("@param8name", param8name));
                dbcommand.Parameters.Add(new SqlParameter("@param8value", param8value));
                dbcommand.Parameters.Add(new SqlParameter("@param9name", param9name));
                dbcommand.Parameters.Add(new SqlParameter("@param9value", param9value));
                dbcommand.Parameters.Add(new SqlParameter("@param10name", param10name));
                dbcommand.Parameters.Add(new SqlParameter("@param10value", param10value));
                dbcommand.Parameters.Add(new SqlParameter("@param11name", param11name));
                dbcommand.Parameters.Add(new SqlParameter("@param11value", param11value));
                dbcommand.Parameters.Add(new SqlParameter("@param12name", param13name));
                dbcommand.Parameters.Add(new SqlParameter("@param12value", param13value));
                dbcommand.Parameters.Add(new SqlParameter("@param13name", param13name));
                dbcommand.Parameters.Add(new SqlParameter("@param13value", param13value));
                dbcommand.Parameters.Add(new SqlParameter("@param14name", param14name));
                dbcommand.Parameters.Add(new SqlParameter("@param14value", param14value));

                dbcommand.Connection = dbconnection;
                dbreader = dbcommand.ExecuteReader(CommandBehavior.CloseConnection);

                while (dbreader.Read())
                    str += dbreader[0].ToString();


                if (!dbreader.IsClosed)
                    dbreader.Close();

            }
            catch (Exception ex)
            {
                return new HttpResponseMessage(System.Net.HttpStatusCode.InternalServerError)
                {
                    ReasonPhrase = "An Error Occurred",
                    Content = new StringContent(ex.Message, System.Text.Encoding.UTF8, "text/plain")
                };
            }
            return new HttpResponseMessage()
            {
                Content = new StringContent(str, System.Text.Encoding.UTF8, "application/xml")
            };
        }
    }
}
