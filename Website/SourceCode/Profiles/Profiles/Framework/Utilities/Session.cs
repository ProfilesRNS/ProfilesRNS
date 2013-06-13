/*  
 
    Copyright (c) 2008-2012 by the President and Fellows of Harvard College. All rights reserved.  
    Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
    and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
    National Center for Research Resources and Harvard University.


    Code licensed under a BSD License. 
    For details, see: LICENSE.txt 
  
*/
using System;
using System.Web;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Text.RegularExpressions;

namespace Profiles.Framework.Utilities
{
    /// <summary>
    ///     This class stores the Profiles custom session state
    /// 
    /// </summary>
    public class Session
    {
        private bool _canedit;
        private DateTime _logoutdate;
        public Session()
        {
            this.PersonURI = string.Empty;


            this.UserAgent = HttpContext.Current.Request.UserAgent;
        }
        public string SessionID { get; set; }
        public string SessionSequence { get; set; }
        public string CreateDate { get; set; }
        public DateTime LastUsedDate { get; set; }
        public DateTime LoginDate { get; set; }
        public DateTime LogoutDate { get; set; }
        public string RequestIP { get; set; }
        public int UserID { get; set; }
        public int PersonID { get; set; }
        public Int64 NodeID { get; set; }
        public string PersonURI { get; set; }
        public string UserAgent { get; set; }
        public bool IsBot { get; set; }
        public string GetRDFTripleKeySegment()
        {   // Treat all bots the same, and treat all anonymous users the same.  Logged in users get their globally unique SessionID
            return IsBot ? "BOT" : (UserID == 0 ? "ANONYMOUS" : SessionID);
        }
    }
    public class SessionHistory
    {
        public string SessionID { get; set; }
        public string PageURL { get; set; }
        public string PageName { get; set; }
        public string PageType { get; set; }
        public string PageID { get; set; }
        public bool IsVisible { get; set; }

    }

    /// <summary>
    ///     This Class is used to manage the custom Profiles session data and processes
    ///     
    /// !!!!!!!!!!!
    /// 
    ///         I COMMENTED OUT THIS AND THE SESSION.DATAIO STUFF AS WELL DEALING WITH SESSION UNTILL WE GET THE RDF DESIGN WORKED OUT.
    /// 
    /// 
    /// 
    /// 
    /// </summary>
    public class SessionManagement
    {
        // UCSF
        private static List<string> BotUserAgents = new List<string>();
        static SessionManagement() 
        {
            using (SqlDataReader reader = new DataIO().GetSQLDataReader("ProfilesDB", "select UserAgent from [User.Session].[Bot]", CommandType.Text, CommandBehavior.CloseConnection, null))
            {
                while (reader.Read())
                {
                    BotUserAgents.Add(reader[0].ToString());
                }
            }
        }

        private static bool IsBot(string userAgent) 
        {
            foreach(string bot in BotUserAgents) 
            {
                if (new Regex(@"\A" + new Regex(@"\.|\$|\^|\{|\[|\(|\||\)|\*|\+|\?|\\").Replace(bot, ch => @"\" + ch).Replace('_', '.').Replace("%", ".*") + @"\z", RegexOptions.Singleline).IsMatch(userAgent))
                {
                    return true;
                }
            }
            return false;
        }
        
        //ZAP - I need some type of redreict in this class for when session has expired
        public SessionManagement() { }

        /// <summary>
        /// Public method used to get the custom Profiles session object.  The object is stored in the current users session and can be accessed with the "PROFILES_SESSION" key.
        /// 
        /// If the session does not exist then this method will create the session by calling this.SessionCreate();
        /// </summary>
        /// <returns></returns>
        public Session Session()
        {

            try
            {
                if ((Session)(HttpContext.Current.Session["PROFILES_SESSION"]) == null)
                {
                    this.SessionCreate();
                }
                else
                {
                    (HttpContext.Current.Session["PROFILES_SESSION"]) = this.SessionGetInfo();
                    if ((Session)(HttpContext.Current.Session["PROFILES_SESSION"]) == null)
                        this.SessionCreate();
                }
            }
            catch (Exception ex)
            {
                this.SessionCreate();
            }


            return (Session)(HttpContext.Current.Session["PROFILES_SESSION"]);
        }
        public void SessionDestroy()
        {
            HttpContext.Current.Session["PROFILES_SESSION"] = null;
            HttpContext.Current.Session.Abandon();
        }

        /// <summary>
        ///     Public method used to create an instance of the custom Profiles session object.
        /// </summary>
        public void SessionCreate()
        {
            string sessionid = string.Empty;
            string ORNGViewer = null;

            if (HttpContext.Current.Request["ContainerSessionID"] != null)
            {
                // ORNG this means it is from shindigorng. Grab the associated session and user
                sessionid = HttpContext.Current.Request["ContainerSessionID"];
                ORNGViewer = HttpContext.Current.Request["Viewer"];
            }
            else if (HttpContext.Current.Request.Headers["SessionID"] != null)
                sessionid = HttpContext.Current.Request.Headers["SessionID"];

            DataIO dataio = new DataIO();
            Session session = new Session();
            string hostname = System.Net.Dns.GetHostName();

            string ipaddress = string.Empty;
            try
            {
                ipaddress = System.Net.Dns.GetHostAddresses(hostname).GetValue(1).ToString();
            }
            catch (Exception ex)
            {
                Framework.Utilities.DebugLogging.Log(ex.Message + " ++ " + ex.StackTrace);
                ipaddress = "";
            }

            session.RequestIP = ipaddress;
            session.UserAgent = HttpContext.Current.Request.UserAgent;
            session.IsBot = IsBot(session.UserAgent);

            if (sessionid == string.Empty)
                dataio.SessionCreate(ref session);
            else
            {
                session.SessionID = sessionid;
                if (ORNGViewer != null && ORNGViewer.LastIndexOf('/') > 0)
                {
                    session.UserID = Convert.ToInt32(ORNGViewer.Substring(ORNGViewer.LastIndexOf('/') + 1));
                }
            }

            //Store the object in the current session of the user.
            HttpContext.Current.Session["PROFILES_SESSION"] = session;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns>Current Framework.Session object from the database.</returns>
        private Session SessionGetInfo()
        {
            //I commented out the SessionGetInfo(ref.... code for now


            if (HttpContext.Current.Session["PROFILES_SESSION"] == null)
            {
                SessionCreate();
            }
            else
            {
                DataIO dataio = new DataIO();
                Session session = (Session)(HttpContext.Current.Session["PROFILES_SESSION"]);

                //  dataio.SessionGetInfo(ref session);

                (HttpContext.Current.Session["PROFILES_SESSION"]) = session;

            }

            return (Session)HttpContext.Current.Session["PROFILES_SESSION"];

        }

        public RDFTriple RDFTriple
        {
            get { return (RDFTriple)HttpContext.Current.Session["PROFILES_RDFTRIPLE"]; }
            set { HttpContext.Current.Session["PROFILES_RDFTRIPLE"] = (RDFTriple)value; }
        }

        public string CurrentEditModule
        {
            get { return (string)HttpContext.Current.Session["PROFILES_CURRENTEDITMODULE"]; }
            set { HttpContext.Current.Session["PROFILES_CURRENTEDITMODULE"] = (string)value; }
        }

        public object CurrentEditEntityState
        {
            get { return (object)HttpContext.Current.Session["PROFILES_CURRENTEDITENTITYSTATE"]; }
            set { HttpContext.Current.Session["PROFILES_CURRENTEDITENTITYSTATE"] = (object)value; }
        }


        public string CurrentEditPredicateURI
        {
            get { return (string)HttpContext.Current.Session["PROFILES_PREDICATEURI"]; }
            set { HttpContext.Current.Session["PROFILES_PREDICATEURI"] = (string)value; }
        }

        public void ClearEditSession()
        {

            this.CurrentEditPredicateURI = null;
            this.CurrentEditModule = null;
            this.CurrentEditEntityState = null;


        }

        //public void SessionAddHistory(string pagename, string pagetype, string pageid, bool isvisible, bool isstackstart)
        //{
        //    SessionHistory sessionhistory = new SessionHistory();
        //    DataIO dataio = new DataIO();

        //    sessionhistory.SessionID = this.SessionGetInfo().SessionID;
        //    sessionhistory.PageURL = Root.AbsolutePath;

        //    sessionhistory.PageName = pagename;
        //    sessionhistory.PageType = pagetype;
        //    sessionhistory.PageID = pageid;
        //    sessionhistory.IsVisible = isvisible;


        //    dataio.SessionAddHistory(sessionhistory);
        //    dataio = null;
        //}
      

        public void SessionLogout()
        {

            DataIO dataio = new DataIO();
            Session session = this.Session();
            session.LogoutDate = DateTime.Now;
            dataio.SessionUpdate(ref session);

            session = null;
            dataio = null;

        }

    }

}
