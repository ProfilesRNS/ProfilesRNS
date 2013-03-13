
using System;
using System.Drawing;
using System.Linq;
using System.Threading;
using System.Web;
using System.Web.UI.WebControls;
using DotNetOpenAuth.Messaging;
using DotNetOpenAuth.OAuth2;
using Google.Apis.Authentication.OAuth2;
using Google.Apis.Tasks.v1;
using Google.Apis.Tasks.v1.Data;
using Google.Apis.Samples.Helper;
using Google.Apis.Util;
using System.Configuration;


namespace Profiles.Login.Utilities
{
    public class OAuth2
    {

        private static TasksService _service; // We don't need individual service instances for each client.
        private static OAuth2Authenticator<WebServerClient> _authenticator;
        private IAuthorizationState _state;

        /// <summary>
        /// Returns the authorization state which was either cached or set for this session.
        /// </summary>
        private IAuthorizationState AuthState
        {
            get
            {
                return _state ?? HttpContext.Current.Session["AUTH_STATE"] as IAuthorizationState;
            }
        }

        public OAuth2()
        {
            // Create the Tasks-Service if it is null.
            if (_service == null)
            {
                _service = new TasksService(_authenticator = CreateAuthenticator());
            }
            else
            {
                try
                {
                    // Fetch all TasksLists of the user asynchronously.
                    TaskLists response = _service.Tasklists.List().Fetch();
                    
                }
                catch (ThreadAbortException)
                {
                    // User was not yet authenticated and is being forwarded to the authorization page.
                    throw;
                }
                catch (Exception ex)
                {
          
                }
                
            }

            // Check if we received OAuth2 credentials with this request; if yes: parse it.
            if (HttpContext.Current.Request["code"] != null)
            {
                _authenticator.LoadAccessToken();
            }

            //This needs to be a redirect to the edit or proxy function depending on what the
            //user wants to do.
            HttpContext.Current.Response.Write("Did it");
        }

        private OAuth2Authenticator<WebServerClient> CreateAuthenticator()
        {
            // Register the authenticator.
            string clientid = ConfigurationSettings.AppSettings["ClientID"];
            string clientsecret = ConfigurationSettings.AppSettings["ClientSecret"];
            var provider = new WebServerClient(GoogleAuthenticationServer.Description, clientid, clientsecret);
            //provider.ClientIdentifier = ClientCredentials.ClientID;
            //provider.ClientSecret = ClientCredentials.ClientSecret;
            var authenticator = new OAuth2Authenticator<WebServerClient>(provider, GetAuthorization) { NoCaching = true };
            return authenticator;
        }

        private IAuthorizationState GetAuthorization(WebServerClient client)
        {
            // If this user is already authenticated, then just return the auth state.
            IAuthorizationState state = AuthState;
            if (state != null)
            {
                return state;
            }

            // Check if an authorization request already is in progress.
            state = client.ProcessUserAuthorization(new HttpRequestInfo(HttpContext.Current.Request));
            if (state != null && (!string.IsNullOrEmpty(state.AccessToken) || !string.IsNullOrEmpty(state.RefreshToken)))
            {
                // Store and return the credentials.
                HttpContext.Current.Session["AUTH_STATE"] = _state = state;
                return state;
            }

            // Otherwise do a new authorization request.
            string scope = TasksService.Scopes.TasksReadonly.GetStringValue();
            OutgoingWebResponse response = client.PrepareRequestUserAuthorization(new[] { scope },"");
            response.Send(); // Will throw a ThreadAbortException to prevent sending another response.
            return null;
        }







    }
}
