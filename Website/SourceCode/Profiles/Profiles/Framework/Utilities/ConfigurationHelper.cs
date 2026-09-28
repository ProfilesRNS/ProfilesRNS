using System.Configuration;
using System;
using System.Web.Configuration;
using System.Web;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;
using static System.Net.WebRequestMethods;

namespace Profiles.Framework.Utilities
{
    /// <summary>
    /// This class is used for all database IO of the web data layer of profiles.
    /// Plus contains generic data base IO methods for building Command Objects, Data Readers ect...
    ///
    /// </summary>
    public static class ConfigurationHelper
    {
        public static string ProfilesRootRelativePath = "";
        public static string ProfilesRootURL = "";
        public static string ProfilesSiteName = "";
        public static string ProfilesInstitution = "";
        public static string GlobalJavascriptVariables = "";
        public static string GlobalJavascriptVariablesProfilePage = "";
        public static string GlobalGoogleTrackingCode = "";
        public static bool SendConnectionPagesToBotDatabase = false;

        public enum PageTypes { profile, concept, person, personCoAuthors, personSimilarPeople, personConcepts, personCoAuthorConnection, 
                personSimilarConnection, personConceptConnection, publication, MentoringCurrentStudentOpportunity, MentoringCompletedStudentProject,
                AwardReceipt, group, groupRole };

        private static PageTypes[] PresentationIDMapping;

        private static string liveConnectionString;
        private static string botConnectionString;


        public static void initializePageTypes()
        {
            //SELECT TOP(100) [PresentationID],[Type],[Subject],[Predicate],[Object] FROM[Ontology.Presentation].[XML]

            int presentationID; string presentationCode; 
            //initialize variables
            PresentationIDMapping = new PageTypes[100];

            try
            {
                string connstr = ConfigurationHelper.GetConnectionString();
                SqlConnection dbconnection = new SqlConnection(connstr);
                SqlCommand dbcommand = new SqlCommand("SELECT TOP (100) [PresentationID], [Type] + '||' + isnull([Subject], '') + '||' + isnull([Predicate], '') + '||' + isnull([Object], '') as PresentationCode FROM [Ontology.Presentation].[XML]");
                dbcommand.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["COMMANDTIMEOUT"]);

                SqlDataReader dbreader;
                dbconnection.Open();
                dbcommand.CommandType = CommandType.Text;
                //dbcommand.CommandTimeout = base.GetCommandTimeout();

                dbcommand.Connection = dbconnection;
                dbreader = dbcommand.ExecuteReader(CommandBehavior.CloseConnection);

                while (dbreader.Read())
                {
                    presentationID = Int32.Parse(dbreader["PresentationID"].ToString());
                    presentationCode = dbreader["PresentationCode"].ToString();

                    switch (presentationCode)
                    {
                        case "P||||||": PresentationIDMapping[presentationID] = PageTypes.profile; break;
                        case "N||||||": PresentationIDMapping[presentationID] = PageTypes.profile; break;
                        case "C||||||": PresentationIDMapping[presentationID] = PageTypes.profile; break;
                        case "P||http://www.w3.org/2004/02/skos/core#Concept||||": PresentationIDMapping[presentationID] = PageTypes.concept; break;
                        case "P||http://xmlns.com/foaf/0.1/Person||||": PresentationIDMapping[presentationID] = PageTypes.person; break;
                        case "N||http://xmlns.com/foaf/0.1/Person||http://profiles.catalyst.harvard.edu/ontology/prns#coAuthorOf||": PresentationIDMapping[presentationID] = PageTypes.personCoAuthors; break;
                        case "N||http://xmlns.com/foaf/0.1/Person||http://profiles.catalyst.harvard.edu/ontology/prns#similarTo||": PresentationIDMapping[presentationID] = PageTypes.personSimilarPeople; break;
                        case "N||http://xmlns.com/foaf/0.1/Person||http://vivoweb.org/ontology/core#hasResearchArea||": PresentationIDMapping[presentationID] = PageTypes.personConcepts; break;
                        case "C||http://xmlns.com/foaf/0.1/Person||http://profiles.catalyst.harvard.edu/ontology/prns#coAuthorOf||http://xmlns.com/foaf/0.1/Person": PresentationIDMapping[presentationID] = PageTypes.personCoAuthorConnection; break;
                        case "C||http://xmlns.com/foaf/0.1/Person||http://profiles.catalyst.harvard.edu/ontology/prns#similarTo||http://xmlns.com/foaf/0.1/Person": PresentationIDMapping[presentationID] = PageTypes.personSimilarConnection; break;
                        case "C||http://xmlns.com/foaf/0.1/Person||http://vivoweb.org/ontology/core#hasResearchArea||http://www.w3.org/2004/02/skos/core#Concept": PresentationIDMapping[presentationID] = PageTypes.personConceptConnection; break;
                        case "P||http://vivoweb.org/ontology/core#InformationResource||||": PresentationIDMapping[presentationID] = PageTypes.publication; break;
                        case "P||http://profiles.catalyst.harvard.edu/ontology/catalyst#MentoringCurrentStudentOpportunity||||": PresentationIDMapping[presentationID] = PageTypes.MentoringCurrentStudentOpportunity; break;
                        case "P||http://profiles.catalyst.harvard.edu/ontology/catalyst#MentoringCompletedStudentProject||||": PresentationIDMapping[presentationID] = PageTypes.MentoringCompletedStudentProject; break;
                        case "P||http://vivoweb.org/ontology/core#AwardReceipt||||": PresentationIDMapping[presentationID] = PageTypes.AwardReceipt; break;
                        case "P||http://xmlns.com/foaf/0.1/Group||||": PresentationIDMapping[presentationID] = PageTypes.group; break;
                        case "N||http://xmlns.com/foaf/0.1/Group||http://vivoweb.org/ontology/core#contributingRole||": PresentationIDMapping[presentationID] = PageTypes.groupRole; break;

                    }
                }
                if (!dbreader.IsClosed)
                    dbreader.Close();

            }
            catch (Exception ex) { Framework.Utilities.DebugLogging.Log($"Profile/Display.aspx.cs : {ex.Message}"); }
        }

        public static PageTypes getPageType(int PresentationID)
        {
            return PresentationIDMapping[PresentationID];
        }

        //TODO this should come from the database and be overwritten app settings as needed.
        public static void initialize()
        {
            initializeConnectionStrings();
            initializePageTypes();

            if (WebConfigurationManager.AppSettings["ProfilesRootRelativePath"] != null)
                if ("".Equals(WebConfigurationManager.AppSettings["ProfilesRootRelativePath"])) ProfilesRootRelativePath = "";
                else ProfilesRootRelativePath = "/" + WebConfigurationManager.AppSettings["ProfilesRootRelativePath"];

            if (WebConfigurationManager.AppSettings["ProfilesRootURL"] != null)
                ProfilesRootURL = WebConfigurationManager.AppSettings["ProfilesRootURL"];

            if (WebConfigurationManager.AppSettings["ProfilesSiteName"] != null)
                ProfilesSiteName = WebConfigurationManager.AppSettings["ProfilesSiteName"];

            if (WebConfigurationManager.AppSettings["ProfilesInstitution"] != null)
                ProfilesInstitution = WebConfigurationManager.AppSettings["ProfilesInstitution"];

            string bannerMessage = "";
            if (WebConfigurationManager.AppSettings["BannerMessage"] != null)
                bannerMessage = WebConfigurationManager.AppSettings["BannerMessage"];

            if (WebConfigurationManager.AppSettings["SendConnectionPagesToBotDatabase"] != null)
                SendConnectionPagesToBotDatabase = Convert.ToBoolean(WebConfigurationManager.AppSettings["SendConnectionPagesToBotDatabase"]);

            string g1 = "g.dataURLs = '{dataURLs}';" +
                        "g.tab = '{tab}';" +
                        "g.preLoad = '{preLoad}';";

            string g2 = "g.profilesPath = '" + ProfilesRootRelativePath + "';" +
                        "g.profilesRootURL = '" + ProfilesRootURL + "';" +
                        "g.staticRoot = '" + ProfilesRootRelativePath + "/StaticFiles/';" +
                        "g.apiBasePath = '" + ProfilesRootURL + "/Profile/ProfileJsonSvc.aspx';" +
                        "g.searchApiPath = '" + ProfilesRootURL + "/Search/SearchSvc.aspx';" +
                        "g.listsApiPath = '" + ProfilesRootURL + "/Lists/ListsSvc.aspx';" +
                        "g.activityApiPath = '" + ProfilesRootURL + "/Activity/ActivitySvc.aspx';" +
                        "g.DIRECTApiPath = '" + ProfilesRootURL + "/DIRECT/DIRECTSVC.aspx';" +
                        "g.editApiPath = '" + ProfilesRootURL + "/Edit/EditSvc.aspx';" +
                        "g.bannerMessage = '" + bannerMessage + "';" +
                        "g.directLink = '" + ProfilesRootRelativePath + "/Direct/default.aspx';" +
                        "console.log(\"Global values after DisplayRepository replace\", g);";

            GlobalJavascriptVariables = "<script type=\"text/javascript\">" +
                                        "let g = {};" +
                                        g2 +
                                        "</script>";

            GlobalJavascriptVariablesProfilePage = "<script type=\"text/javascript\">" +
                            "let g = {};" +
                            g1 +
                            g2 +
                            "</script>";


            GlobalGoogleTrackingCode = System.IO.File.ReadAllText(AppDomain.CurrentDomain.BaseDirectory + "/Branding/AnalyticsTrackingInsert.html");
        }


        public static void initializeConnectionStrings()
        {
            liveConnectionString = ConfigurationManager.ConnectionStrings["ProfilesDB"].ConnectionString;
            if (ConfigurationManager.ConnectionStrings["ProfilesBotDB"] != null)
                botConnectionString = ConfigurationManager.ConnectionStrings["ProfilesBotDB"].ConnectionString;
            else botConnectionString = liveConnectionString;
        }

        public static string GetConnectionString(Framework.Utilities.Session session)
        {
            string connstr = string.Empty;
            try
            {
                if (session != null)
                {
                    if (session.IsBot)
                        connstr = botConnectionString;
                    else
                        connstr = liveConnectionString;
                }
                else
                    connstr = liveConnectionString;
            }
            catch (Exception ex)
            {//An error will kick in if this is an Application level request for the rest path data because a session does not exist. If no session exists
                Framework.Utilities.DebugLogging.Log(connstr + " CONNECTION USED" + "\r\n");
                connstr = connstr = liveConnectionString;
            }


            return connstr;
        }

        public static string GetConnectionString()
        {
            return liveConnectionString;
        }

        public static string GetBotConnectionString()
        {
            return botConnectionString;
        }

        //This allows us to send connection pages to the bot database when we need to reduce load on the primary database.
        //Spiders or unidentified bots produce huge amounts of connection page usage, where humans usage hits these pages
        //at a very low rate
        public static string GetConnectionPageConnectionString(Framework.Utilities.Session session)
        {
            string connstr = string.Empty;
            try
            {
                if (SendConnectionPagesToBotDatabase)
                {
                    connstr = botConnectionString;
                }
                else if (session != null)
                {
                    if (session.IsBot)
                        connstr = botConnectionString;
                    else
                        connstr = liveConnectionString;
                }
                else
                    connstr = connstr = liveConnectionString;
            }
            catch (Exception ex)
            {//An error will kick in if this is an Application level request for the rest path data because a session does not exist. If no session exists
                Framework.Utilities.DebugLogging.Log(connstr + " CONNECTION USED" + "\r\n");
                connstr = connstr = liveConnectionString;
            }


            return connstr;
        }

        public static string GetSessionInfoJavascriptObject(Framework.Utilities.Session session)
        {
            return GetSessionInfoJavascriptObject(session, false);
        }
        public static string GetSessionInfoJavascriptObject(Framework.Utilities.Session session, bool canEdit)
        {
            string sessionInfo;
            if (session.UserID > 0)
            {

                int listSize;
                bool parseSuccess = false;
                parseSuccess = Int32.TryParse(session.ListSize, out listSize);
                if (!parseSuccess)
                {
                    listSize = 0;
                }
                sessionInfo =
                "<script type = \"text/javascript\">" +
                    "let sessionInfo = { };" +
                    "sessionInfo.sessionID = \"" + session.SessionID + "\";" +
                    "sessionInfo.userID = " + session.UserID + ";" +
                    "sessionInfo.personID = " + session.PersonID + ";" +
                    "sessionInfo.personNodeID = " + session.NodeID + ";" +
                    "sessionInfo.personURI = \"" + session.PersonURI + "\";" +
                    "sessionInfo.canEditPage = " + (canEdit ? "true" : "false") + ";" +
                    "sessionInfo.listID = \"" + session.ListID + "\";" +
                    "sessionInfo.listSize = " + listSize + ";" +
                    "</script>";
            }
            else
            {
                sessionInfo =
                    "<script type = \"text/javascript\">" +
                        "let sessionInfo = { };" +
                        "sessionInfo.sessionID = \"" + session.SessionID + "\";" +
                        "sessionInfo.userID = 0;" +
                        "sessionInfo.personID = 0;" +
                        "sessionInfo.personNodeID = 0;" +
                        "sessionInfo.personURI = \"\";" +
                        "sessionInfo.canEditPage = false;" +
                        "sessionInfo.listID = \"\";" +
                        "sessionInfo.listSize = 0;" +
                        "</script>";
            }
            return sessionInfo;
        }
    }
}