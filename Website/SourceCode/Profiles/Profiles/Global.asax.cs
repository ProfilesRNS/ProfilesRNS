/*  
 
    Copyright (c) 2008-2012 by the President and Fellows of Harvard College. All rights reserved.  
    Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
    and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
    National Center for Research Resources and Harvard University.


    Code licensed under a BSD License. 
    For details, see: LICENSE.txt 
  
*/
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.Security;
using System.Web.SessionState;
using System.Web.Routing;
using System.Web.Compilation;
using System.Configuration;
using System.Diagnostics;
using System.Data;

using Profiles.Profile.Utilities;

using Profiles.Framework.Utilities;

namespace Profiles
{
    public class Global : System.Web.HttpApplication
    {
        //***************************************************************************************************************************************
        /// <summary>
        /// 
        ///   When a request is submitted to the ISAPI filter the following steps are executed in order to process a RESTful URL:
        ///     1. IIS will trigger the ProfilesRouteHandler that's defined in the Global.asax.cs file.  
        ///     2. All parameters of the RESTful URL are then packed into the HttpContext.Current.Items hash table and the request is transferred to the Alias.aspx page.   
        ///     
        /// </summary>
        /// <param name="sender"> .Net context object</param>
        /// <param name="e"> .Net Event Arguments</param>
        protected void Application_Start(object sender, EventArgs e)
        {
            RegisterRoutes(RouteTable.Routes);
            LoadModuleCatalogue();
        }


        //***************************************************************************************************************************************
        /// <summary>
        /// 
        ///     Starts a Profiles instance of Profiles Session Management and Session State Information used for
        ///     security/data filters, tracking, auditing.
        ///     
        /// </summary>
        /// <param name="sender"> .Net context object</param>
        /// <param name="e"> .Net Event Arguments</param>
        protected void Session_Start(object sender, EventArgs e)
        {                     
            SessionManagement session = new SessionManagement();
            session.SessionCreate();
            
            Framework.Utilities.DebugLogging.Log("SESSION CREATED for: " + session.Session().SessionID);
            session = null;
        }


        //***************************************************************************************************************************************
        /// <summary>
        /// This method loads the module names and locations into RAM.  This code is located in the Profiles.Framework.Utilities.ModuleCatalogueCache.cs file
        /// </summary>
        private void LoadModuleCatalogue()
        {
            if (ModuleCatalogueCache.Instance != null)
            {
            }
        }

        //***************************************************************************************************************************************
        /// <summary>
        /*
             
            This method implements the loading of all URLs patterns that contain file extensions that need to be ignored and 
            all URLs patterns that need to be processed:           
          
            
            Example of patterns to process:
            routes.Add("ProfilesAliasPath2", new Route("{Param0}/{Param1}/{Param2}", new ProfilesRouteHandler()));     
                The above example will register a URL pattern for processing by the Alias.aspx page.  When IIS makes a request,
                the URL pattern of http://domain.com/profile/person/32213, will trigger the .Net System.Web.Routing library to call ProfilesRouteHandler.GetHttpHandler(RequestContext requestContext){}.  This method will process the URL pattern into parameters and load the HttpContext.Current.Items hash table and then direct the request to the Alias.aspx page for processing.

         */

        /// </summary>
        /// <param name="routes">RouteTable.Routes is passed as a RouteCollection by ref used to store all routes in the routing framework.</param>
        private static void RegisterRoutes(RouteCollection routes)
        {
            Framework.Utilities.DataIO d = new Framework.Utilities.DataIO();

            System.Data.SqlClient.SqlDataReader reader;         

            //The REST Paths are built based on the applicaitons setup in the Profiles database.
            reader = d.GetRESTApplications();
            int loop = 0;

            routes.RouteExistingFiles = false;            
         
            while (reader.Read())
            {
                routes.Add("ProfilesAliasPath0" + loop, new Route(reader[0].ToString(), new ProfilesRouteHandler()));                
                routes.Add("ProfilesAliasPath1" + loop, new Route(reader[0].ToString() + "/{Param1}", new ProfilesRouteHandler()));                
                routes.Add("ProfilesAliasPath2" + loop, new Route(reader[0].ToString() + "/{Param1}/{Param2}", new ProfilesRouteHandler()));
                routes.Add("ProfilesAliasPath3" + loop, new Route(reader[0].ToString() + "/{Param1}/{Param2}/{Param3}", new ProfilesRouteHandler()));
                routes.Add("ProfilesAliasPath4" + loop, new Route(reader[0].ToString() + "/{Param1}/{Param2}/{Param3}/{Param4}", new ProfilesRouteHandler()));
                routes.Add("ProfilesAliasPath5" + loop, new Route(reader[0].ToString() + "/{Param1}/{Param2}/{Param3}/{Param4}/{Param5}", new ProfilesRouteHandler()));
                routes.Add("ProfilesAliasPath6" + loop, new Route(reader[0].ToString() + "/{Param1}/{Param2}/{Param3}/{Param4}/{Param5}/{Param6}", new ProfilesRouteHandler()));
                routes.Add("ProfilesAliasPath7" + loop, new Route(reader[0].ToString() + "/{Param1}/{Param2}/{Param3}/{Param4}/{Param5}/{Param6}/{Param7}", new ProfilesRouteHandler()));
                routes.Add("ProfilesAliasPath8" + loop, new Route(reader[0].ToString() + "/{Param1}/{Param2}/{Param3}/{Param4}/{Param5}/{Param6}/{Param7}/{Param8}", new ProfilesRouteHandler()));
                routes.Add("ProfilesAliasPath9" + loop, new Route(reader[0].ToString() + "/{Param1}/{Param2}/{Param3}/{Param4}/{Param5}/{Param6}/{Param7}/{Param8}/{Param9}", new ProfilesRouteHandler()));

                Framework.Utilities.DebugLogging.Log("REST PATTERN(s) CREATED FOR " + reader[0].ToString());         
                loop++;
            }

            if (!reader.IsClosed)
                reader.Close();          

        }

        //***************************************************************************************************************************************
        /// <summary>
        /// 
        /// </summary>
        /// <param name="sender"> .Net context object</param>
        /// <param name="e"> .Net Event Arguments</param>
        void Application_BeginRequest(object sender, EventArgs e)
        {
            String path = Request.Url.ToString();
            Framework.Utilities.DebugLogging.Log("*** {Application_BeginRequest} IIS IS Processing: " + path);           
        }

        //***************************************************************************************************************************************
        /// <summary>
        /// 
        ///     Global Error Handler.
        ///     
        ///     When this event is triggered, the error is logged to the server event log and then loaded into the user Session and 
        ///     redirected to the error page for display to the user.  
        ///     
        ///     Note:
        ///         There is a profiles request/response debug tool that can be accessed in the browser if the Debug flag is set to true in the
        ///         web.config file.
        /// </summary>
        /// <param name="sender"> .Net context object</param>
        /// <param name="e"> .Net Event Arguments</param>
        void Application_Error(object sender, EventArgs e)
        {
            //Each error that occurs will trigger this event.
            try
            {
                //get reference to the source of the exception chain
                Exception ex = Server.GetLastError().GetBaseException();

                Framework.Utilities.DebugLogging.Log("You are in the Global.asax Application_Error event.  Something broke!");
                Framework.Utilities.DebugLogging.Log(ex.Message);
                Framework.Utilities.DebugLogging.Log(ex.Source.ToString());
                Framework.Utilities.DebugLogging.Log(ex.StackTrace);

                if (ex.Message.ToLower().Contains("file does not exist"))
                {//This can happen if the REST routing wildcard is not setup correctly in IIS.
                    Framework.Utilities.DebugLogging.Log("File Does Not Exist!!!!  Check if your IIS Wildcard path is setup correctly.");
                    return;
                }

               EventLog.WriteEntry("Profiles",
                 "MESSAGE: " + ex.Message +
                 "\nSOURCE: " + ex.Source +
                 "\nFORM: " + Request.Form.ToString() +
                 "\nQUERYSTRING: " + Request.QueryString.ToString() +
                 "\nTARGETSITE: " + ex.TargetSite +
                 "\nSTACKTRACE: " + ex.StackTrace,
                 EventLogEntryType.Error);
                    
               HttpContext.Current.Session.Add("GLOBAL_ERROR", "MESSAGE: " + ex.Message +
                  "\nSOURCE: " + ex.Source +
                  "\nFORM: " + Request.Form.ToString() +
                  "\nQUERYSTRING: " + Request.QueryString.ToString());


               //After the error is written to the event log, a copy of the same message is loaded into a session variable and then
               //displayed in the ErrorPage.aspx file.

               Response.Redirect("~/Error/default.aspx",true);       
             
            }
            catch (Exception ex)
            {
                Framework.Utilities.DebugLogging.Log(ex.Message + " ++ " + ex.StackTrace);
            
            }
        }
    }

    //***************************************************************************************************************************************
    /// <summary>
    /// The Profiles Route Handler:
    /// 
    /// This class processes the event that RESTful path is requested and matches the routes defined in the RegisterRoutes method of this file.
    /// </summary>
    public class ProfilesRouteHandler : IRouteHandler
    {
        private string VirtualPath { get; set; }

        public ProfilesRouteHandler()
        {
            this.VirtualPath = string.Empty;
        }

        public ProfilesRouteHandler(string virtualpath)
        {
            this.VirtualPath = virtualpath;
        }

        public IHttpHandler GetHttpHandler(RequestContext requestContext)
        {
            String path = HttpContext.Current.Request.Url.ToString();

            string PathWithoutRoot = path.Substring(Root.Domain.Length + 1);

            //This manualy loads the Profiles Application into Param0 of the collection.  
            if (PathWithoutRoot.Contains('/'))
            {
                HttpContext.Current.Items["Param0"] = PathWithoutRoot.Substring(0, PathWithoutRoot.IndexOf('/'));
            }
            else
            {
                HttpContext.Current.Items["Param0"] = PathWithoutRoot;
            }


            //Loop each of the parts of the path and pack them into the current request context as 
            //parameters so they can be processed by the REST.aspx process
            foreach (var urlParm in requestContext.RouteData.Values)
            {
                HttpContext.Current.Items[urlParm.Key] = urlParm.Value;
            }

            if (this.VirtualPath == "")
            {
                this.VirtualPath = "~/REST.aspx";
            }

            return BuildManager.CreateInstanceFromVirtualPath(this.VirtualPath, typeof(Page)) as IHttpHandler;

        }
    }
}