using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Collections.Specialized;
using System.Net;
using System.IO;
using System.Web.Script.Serialization;
using System.IO.Compression;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.ORCID
{
    public partial class OAuth : ORCIDCommon
    {
        public static string GetUserPermissionURL(string scope, string redirectPage)
        {
            return ProfilesRNSDLL.BO.ORCID.Config.ORCID_URL + "/oauth/authorize?client_id=" + ProfilesRNSDLL.BO.ORCID.Config.ClientID + "&response_type=code&scope=" + scope + "&access_type=offline&redirect_uri=" + ProfilesRNSDLL.BO.ORCID.Config.WebAppURL + redirectPage;
        }
        public static string GetORCID(string oauthCode, string returnPage, string loggedInInternalUsername)
        {
            try
            {
                Dictionary<string, object> items = GetUserAccessTokenItems(oauthCode, returnPage, loggedInInternalUsername);
                return items["orcid"].ToString();
            }
            catch (Exception ex)
            {
                throw ErrorLog.LogError(ex, loggedInInternalUsername, "An error occurred while trying to get the ORCID from the OAuth code.");
            }
        }
        private static string GetUserAccessTokenFullResponse(string oauthCode, string urlredirect, string loggedInInternalUsername)
        {
            try
            {
                NameValueCollection param = new NameValueCollection();
                param.Add("client_id", ProfilesRNSDLL.BO.ORCID.Config.ClientID);
                param.Add("client_secret", ProfilesRNSDLL.BO.ORCID.Config.ClientSecret);
                param.Add("grant_type", "authorization_code");
                param.Add("code", oauthCode);
                // todo remove line below and test.
                param.Add("redirect_uri", urlredirect);
                string ORCIDURL = ProfilesRNSDLL.BO.ORCID.Config.ORCID_API_URL + "/oauth/token";
                return BLL.ORCID.ORCID.GetWebResponse(ORCIDURL, param, loggedInInternalUsername, System.Net.WebRequestMethods.Http.Post.ToString(), "application/x-www-form-urlencoded");
            }
            catch (Exception ex)
            {
                throw BLL.ORCID.ErrorLog.LogError(ex, loggedInInternalUsername, "An error occurred while connecting to ORCID.  Unable to retrieve token information to save.");
            }
        }
        public static Dictionary<string, object> GetUserAccessTokenItems(string oauthCode, string returnPage, string loggedInInternalUsername)
        {
            if (string.IsNullOrEmpty(oauthCode))
            {
                throw new Exception("The OAuth code is missing.");
            }
            string json = BLL.ORCID.OAuth.GetUserAccessTokenFullResponse(oauthCode, ProfilesRNSDLL.BO.ORCID.Config.WebAppURL + returnPage, loggedInInternalUsername);
            // Example:  string json = "{\"access_token\":\"496c81e5-1555-4676-896b-c3272ee3f151\",\"token_type\":\"bearer\",\"refresh_token\":\"9bd38870-6405-42e1-b57e-297847095fd7\",\"expires_in\":631138518,\"scope\":\"/orcid-profile/read-limited\"}";
            var jss = new JavaScriptSerializer();


            //ZAP, I had to find a way around the dynamic keyword
            //            dynamic data = jss.Deserialize<dynamic>(json);
  //          Dictionary<string, object> items = (data as Dictionary<string, object>);
          //  return items;




            var data = jss.Deserialize<Dictionary<string, object>>(json);
            return data;

        }
        internal static string GetClientToken(string scope, string loggedInInternalUsername)
        {
            try
            {
                string ORCIDURL = ProfilesRNSDLL.BO.ORCID.Config.ORCID_API_URL + "/oauth/token";
                NameValueCollection param = new NameValueCollection();
                param.Add("client_id", ProfilesRNSDLL.BO.ORCID.Config.ClientID);
                param.Add("client_secret", DevelopmentBase.Common.GetConfig("ORCID.ClientSecret"));
                param.Add("grant_type", "client_credentials");
                param.Add("scope", scope);
                string createTokenText = GetWebResponse(ORCIDURL, param, loggedInInternalUsername, System.Net.WebRequestMethods.Http.Post.ToString(), "application/x-www-form-urlencoded");
                //ResponseMessage.Add("Token = " + createTokenText);
                string[] tokenItems = createTokenText.Split(',');
                string[] AuthorizationBearer = tokenItems[0].ToString().Split(':');
                return AuthorizationBearer[1].ToString().Replace("\"", ""); ;
            }
            catch (Exception ex)
            {
                throw BLL.ORCID.ErrorLog.LogError(ex, loggedInInternalUsername, "An error occurred while connecting to ORCID.  Unable to obtain authorization to perform this action.");
            }
        }
    }
}
