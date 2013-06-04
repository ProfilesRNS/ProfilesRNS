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



namespace Connects.Profiles.Service.ServiceImplementation
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
    /// 
    ///         
    /// 
    /// 
    /// 
    /// 
    /// </summary>
    public class SessionManagement
    {
        //ZAP - I need some type of redreict in this class for when session has expired
        public SessionManagement() { }

        /// <summary>
        /// Public method used to get the custom Profiles session object.  The object is stored in the current users session and can be accessed with the "PROFILES_SESSION" key.
        /// 
        /// If the session does not exist then this method will create the session by calling this.SessionCreate();
        /// </summary>
        /// <returns></returns>
        public string Session()
        {
            return this.SessionCreate();
        }
        public void SessionDistroy()
        {
            
        }

        /// <summary>
        ///     Public method used to create an instance of the custom Profiles session object.
        /// </summary>
        public string SessionCreate()
        {

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
                DebugLogging.Log(ex.Message + " ++ " + ex.StackTrace);
                ipaddress = "";
            }

            session.RequestIP = ipaddress;
            session.UserAgent = "PROFILES RNS";
            
            dataio.SessionCreate(ref session);
            
            //Store the object in the current session of the user.
            return session.SessionID;
        }

            
       
    }

}
