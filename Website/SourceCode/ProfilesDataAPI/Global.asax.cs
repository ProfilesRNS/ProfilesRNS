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
        [Route("getPeople/Institution/{inst}")]
        [Route("getPeople/Institution/{inst}/Department/{dept}")]
        [Route("getPeople/Institution/{inst}/Department/{dept}/Division/{div}")]
        [Route("getPeople/Institution/{inst}/Count/{count:int}/Offset/{offset:int}")]
        [Route("getPeople/Institution/{inst}/Department/{dept}/Count/{count:int}/Offset/{offset:int}")]
        [Route("getPeople/Institution/{inst}/Department/{dept}/Division/{div}/Count/{count:int}/Offset/{offset:int}")]
        [Route("getPeople/Keyword/{keyword}")]
        [Route("getPeople/Keyword/{keyword}/Count/{count:int}/Offset/{offset:int}")]
        [Route("getPeople/Keyword/{keyword}/Institution/{inst}")]
        [Route("getPeople/Keyword/{keyword}/Institution/{inst}/Department/{dept}")]
        [Route("getPeople/Keyword/{keyword}/Institution/{inst}/Department/{dept}/Division/{div}")]
        [Route("getPeople/Keyword/{keyword}/Institution/{inst}/Count/{count:int}/Offset/{offset:int}")]
        [Route("getPeople/Keyword/{keyword}/Institution/{inst}/Department/{dept}/Count/{count:int}/Offset/{offset:int}")]
        [Route("getPeople/Keyword/{keyword}/Institution/{inst}/Department/{dept}/Division/{div}/Count/{count:int}/Offset/{offset:int}")]
        [Route("getPeople/PersonIDs/{personIDs}")]
        [HttpGet]
        public System.Net.Http.HttpResponseMessage getPeopleByInstitutionAndDept(string keyword = null, string inst = null, string dept = null, string division = null, int count = -1, int offset = 0, string personIDs = null)
        {
            string str = string.Empty;

            try
            {
                string connstr = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;
                SqlConnection dbconnection = new SqlConnection(connstr);
                SqlCommand dbcommand = new SqlCommand("[Profile.Module].[ProfilesDataAPI.GetPersonData]");
                dbcommand.CommandTimeout = Convert.ToInt32(ConfigurationSettings.AppSettings["COMMANDTIMEOUT"]);

                SqlDataReader dbreader;
                dbconnection.Open();
                dbcommand.CommandType = CommandType.StoredProcedure;
                //dbcommand.CommandTimeout = base.GetCommandTimeout();
                dbcommand.Parameters.Add(new SqlParameter("@PersonList", personIDs));
                dbcommand.Parameters.Add(new SqlParameter("@Institution", inst));
                //dbcommand.Parameters.Add(new SqlParameter("@InstitutionAbbr", pmid));
                dbcommand.Parameters.Add(new SqlParameter("@Department", dept));
                dbcommand.Parameters.Add(new SqlParameter("@Division", division));
                //dbcommand.Parameters.Add(new SqlParameter("@FacultyRank", pmid));
                dbcommand.Parameters.Add(new SqlParameter("@SearchString", keyword));
                if (count > 0)
                {
                    dbcommand.Parameters.Add(new SqlParameter("@offset", offset));
                    dbcommand.Parameters.Add(new SqlParameter("@count", count));
                }
                dbcommand.Parameters.Add(new SqlParameter("@IncludeSecondary", 0));

                dbcommand.Connection = dbconnection;
                dbreader = dbcommand.ExecuteReader(CommandBehavior.CloseConnection);

                while (dbreader.Read())
                    str += dbreader[0].ToString();

                //               Framework.Utilities.DebugLogging.Log(str);

                if (!dbreader.IsClosed)
                    dbreader.Close();

                //                   Framework.Utilities.Cache.Set(request.Key + "GetJournalHeadingsForProfile", str);
            }
            catch (Exception ex)
            {
                //                Framework.Utilities.DebugLogging.Log(ex.Message + " ++ " + ex.StackTrace);
            }
            return new HttpResponseMessage()
            {
                Content = new StringContent(str, System.Text.Encoding.UTF8, "application/xml")
            };
        }

        [Route("")]
        [HttpGet]
        public string rootPage()
        {

            return "";
        }
    }
}
