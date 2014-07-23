using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Collections.Specialized;
using System.Net;
using System.Text;
using System.IO;
using System.Web.Script.Serialization;
using System.IO.Compression;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.ORCID
{
    public class ORCID : ORCIDCommon, Interfaces.IORCID
    {
        public void ReadORCIDProfile(BO.ORCID.Person person, BO.ORCID.PersonMessage personMessage, BO.ORCID.REFPermission refPermission, string loggedInInternalUsername)
        {
            personMessage.RequestURL = ProfilesRNSDLL.BO.ORCID.Config.ORCID_API_URL_WITH_VERSION + "/" + person.ORCID + "/" + refPermission.MethodAndRequest;
            NameValueCollection param2 = new NameValueCollection();
            string token = BLL.ORCID.OAuth.GetClientToken(refPermission.PermissionScope, loggedInInternalUsername);
            param2.Add("Authorization", " Bearer " + token);
            param2.Add("Scope", refPermission.PermissionScope);
            GetWebResponseMethodGet(personMessage, refPermission, param2);
        }
        public void SendORCIDXMLMessage(BO.ORCID.Person person, string accessToken, BO.ORCID.PersonMessage personMessage, BO.ORCID.REFPermission refPermission)
        {
            List<string> responseMessage = new List<string>();
            BLL.ORCID.PersonMessage personMessageBLL = new PersonMessage();
            personMessage.RequestURL = ProfilesRNSDLL.BO.ORCID.Config.ORCID_API_URL_WITH_VERSION + "/" + person.ORCID + "/" + refPermission.MethodAndRequest;
            InitializePersonMessageRequestInfo(personMessage, personMessageBLL);

            string method = System.Net.WebRequestMethods.Http.Post.ToString();
            if (personMessage.PermissionID == (int)BO.ORCID.REFPermission.REFPermissions.orcid_bio_update)
            {
                method = System.Net.WebRequestMethods.Http.Put.ToString();
            }

            string msg = string.Empty;

            WebRequest httpWebRequest = WebRequest.Create(personMessage.RequestURL);
            httpWebRequest.ContentType = "application/orcid+xml";
            httpWebRequest.Method = method;

            NameValueCollection param2 = new NameValueCollection();
            string AuthBearer = "Authorization: Bearer " + accessToken;
            responseMessage.Add(AuthBearer);

            param2.Add("Authorization", " Bearer " + accessToken);

            foreach (var key in param2.AllKeys)
            {
                httpWebRequest.Headers.Add(key, param2[key]);
            }

            string profile = personMessage.XML_Sent;

            byte[] xmlBytes = Encoding.UTF8.GetBytes(profile);
            using (var requestStream = httpWebRequest.GetRequestStream())
            {
                requestStream.Write(xmlBytes, 0, xmlBytes.Length);
                requestStream.Close();
            }
            try
            {
                using (WebResponse response = httpWebRequest.GetResponse())
                {
                    HttpWebResponse httpResponse = (HttpWebResponse)response;
                    using (Stream data = response.GetResponseStream())
                    {
                        string text = new StreamReader(data).ReadToEnd();
                        personMessage.HttpResponseCode = httpResponse.StatusCode.ToString();
                        responseMessage.Add(text);
                        personMessage.MessagePostSuccess = true;
                    }
                }
            }
            catch (WebException en)
            {
                ProcessWebException(personMessage, en, httpWebRequest);
            }
            SavePersonMessage(personMessage, refPermission, personMessageBLL);
        }

        private string ResponseMessageToHtmlString(List<string> responseMessage)
        {
            string returnMessage = string.Empty;
            foreach (string m in responseMessage)
            {
                returnMessage += m + "<br/>";
            }
            return returnMessage;
        }
        private void InitializePersonMessageRequestInfo(BO.ORCID.PersonMessage personMessage, BLL.ORCID.PersonMessage personMessageBLL)
        {
            // initialize the request information
            personMessage.MessagePostSuccessIsNull = true;
            personMessage.HttpResponseCodeIsNull = true;
            personMessage.HeaderPostIsNull = true;
            personMessage.XML_ResponseIsNull = true;
            personMessage.UserMessageIsNull = true;
            personMessage.PostDateIsNull = true;
            personMessage.RecordStatusID = (int)BO.ORCID.REFRecordStatus.REFRecordStatuss.Waiting_to_be_sent_to_ORCID;
            personMessageBLL.Save(personMessage);
        }
        private void ProcessWebException(BO.ORCID.PersonMessage personMessage, WebException en, WebRequest httpWebRequest)
        {
            using (WebResponse response = en.Response)
            {
                List<string> responseMessage = new List<string>();
                foreach (string hh in response.Headers)
                {
                    responseMessage.Add(hh + " = " + response.Headers[hh].ToString());
                }
                HttpWebResponse httpResponse = (HttpWebResponse)response;
                using (Stream data = response.GetResponseStream())
                {
                    string text = new StreamReader(data).ReadToEnd();
                    personMessage.HttpResponseCode = httpResponse.StatusCode.ToString();
                    responseMessage.Add(text);
                    personMessage.RecordStatusID = (int)BO.ORCID.REFRecordStatus.REFRecordStatuss.Failed;
                    personMessage.MessagePostSuccess = false;
                    personMessage.XML_Response = ResponseMessageToHtmlString(responseMessage);
                }
            }
        }
        private void SavePersonMessage(BO.ORCID.PersonMessage personMessage, BO.ORCID.REFPermission refPermission, BLL.ORCID.PersonMessage personMessageBLL)
        {
            if (!personMessage.MessagePostSuccess)
            {
                string rsp = personMessage.XML_Response;
                int openTag = rsp.IndexOf("<error-desc>") + ("<error-desc>").Length;
                int closeTag = rsp.IndexOf("</error-desc>");

                personMessage.RecordStatusID = (int)ProfilesRNSDLL.BO.ORCID.REFRecordStatus.REFRecordStatuss.Failed;

                if (rsp.Contains("<error-desc>"))
                {
                    personMessage.UserMessage = rsp.Substring(openTag, closeTag - openTag);
                    switch ((ProfilesRNSDLL.BO.ORCID.REFPermission.REFPermissions)personMessage.PermissionID)
                    {
                        case BO.ORCID.REFPermission.REFPermissions.orcid_bio_update:
                        case BO.ORCID.REFPermission.REFPermissions.orcid_works_create:
                            personMessage.UserMessage = refPermission.FailedMessage + ".";
                            break;
                    }
                }
                else
                {
                    personMessage.UserMessage = rsp;
                }
            }
            else
            {
                personMessage.RecordStatusID = (int)ProfilesRNSDLL.BO.ORCID.REFRecordStatus.REFRecordStatuss.Success;

                switch ((ProfilesRNSDLL.BO.ORCID.REFPermission.REFPermissions)personMessage.PermissionID)
                {
                    case BO.ORCID.REFPermission.REFPermissions.orcid_bio_update:
                    case BO.ORCID.REFPermission.REFPermissions.orcid_works_create:
                    case BO.ORCID.REFPermission.REFPermissions.orcid_profile_read_limited:
                    case BO.ORCID.REFPermission.REFPermissions.affiliations_create:
                        personMessage.UserMessage = refPermission.SuccessMessage + ".";
                        break;
                    default:
                        throw new Exception("Unhandled Permission Type for Success Message.");
                }
            }
            personMessage.PostDate = DateTime.Now;
            personMessageBLL.Save(personMessage);
        }
        private void GetWebResponseMethodGet(BO.ORCID.PersonMessage personMessage, BO.ORCID.REFPermission refPermission, NameValueCollection parameters)
        {
            BLL.ORCID.PersonMessage personMessageBLL = new PersonMessage();
            InitializePersonMessageRequestInfo(personMessage, personMessageBLL);
            var httpWebRequest = (HttpWebRequest)WebRequest.Create(personMessage.RequestURL);
            try
            {

                httpWebRequest.ContentType = "application/orcid+xml";
                httpWebRequest.Method = "GET";

                foreach (var key in parameters.AllKeys)
                {
                    httpWebRequest.Headers.Add(key, parameters[key]);
                }

                WebResponse wr = httpWebRequest.GetResponse();
                personMessage.XML_Response = new StreamReader(wr.GetResponseStream()).ReadToEnd();
                personMessage.MessagePostSuccess = true;
            }
            catch (WebException en)
            {
                ProcessWebException(personMessage, en, httpWebRequest);
            }
            SavePersonMessage(personMessage, refPermission, personMessageBLL);
        }
    }
}
