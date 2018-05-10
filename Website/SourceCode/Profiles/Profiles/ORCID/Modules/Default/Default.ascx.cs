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
using System.Web.UI.WebControls;
using System.Xml;
using Profiles.Framework.Utilities;

using System.Data;

namespace Profiles.ORCID.Modules.Default
{
    public partial class Default : ORCIDBaseModule
    {
        public override Label Errors
        {
            get { return lblErrors; }
        }
        public void Initialize(XmlDocument basedata, XmlNamespaceManager namespaces, RDFTriple rdftriple)
        {
            BaseData = basedata;
            Namespaces = namespaces;
            RDFTriple = rdftriple;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            Utilities.ProfilesRNSDLL.BO.ORCID.Person person = GetPerson();
            if (!IsPostBack)
            {
                //check to make sure BUID is associated your ORCID
                if (person.HasValidORCID)
                {
                    if (HasResponseFromORCID)
                    {
                        ProcessORCIDResponse(person);
                    }
                    UploadPendingData(person);
                }
                else
                {
                    // Before uploading any data you must first associate your ORCID with your BUID
                    Response.Redirect("~/ORCID/ProvideORCID.aspx", true);
                }

            }
        }

        private void ProcessORCIDResponse(Utilities.ProfilesRNSDLL.BO.ORCID.Person person)
        {
            if (HasORCID_OAuthCode)
            {
                PersonTokenBLL.UpdateUserToken(OAuthCode, person, "Default.aspx", LoggedInInternalUsername);
            }
            else if (HasORCID_ResponseError)
            {
                ProcessError(person);
            }
        }
        private List<Utilities.ProfilesRNSDLL.BO.ORCID.PersonMessage> GetPersonMessagesWaitingForApproval(Utilities.ProfilesRNSDLL.BO.ORCID.Person person)
        {
            int waitingForApproval = (int)Utilities.ProfilesRNSDLL.BO.ORCID.REFRecordStatus.REFRecordStatuss.Waiting_for_ORCID_User_for_approval;
            return (from pm in PersonMessageBLL.GetByPersonIDAndRecordStatusID(person.PersonID, waitingForApproval) orderby pm.PersonMessageID select pm).ToList();
        }
        private void UploadPendingData(Utilities.ProfilesRNSDLL.BO.ORCID.Person person)
        {
            // This method loads any pending interactions with ORCID.
            List<Utilities.ProfilesRNSDLL.BO.ORCID.PersonMessage> personMessagesWaitingForApproval = GetPersonMessagesWaitingForApproval(person);
            if (personMessagesWaitingForApproval.Count > 0)
            {
                foreach (Utilities.ProfilesRNSDLL.BO.ORCID.PersonMessage personMessage in personMessagesWaitingForApproval)
                {
                    Utilities.ProfilesRNSDLL.BO.ORCID.REFPermission refPermission = REFPermissionBLL.Get(personMessage.PermissionID);
                    Utilities.ProfilesRNSDLL.BO.ORCID.PersonToken personToken = PersonTokenBLL.GetByPersonIDAndPermissionID(person.PersonID, personMessage.PermissionID);
                    if (!personToken.Exists || personToken.IsExpired)
                    {
                        // Go to ORCID and get a Token for this action.
                        Response.Redirect(Utilities.ProfilesRNSDLL.BLL.ORCID.OAuth.GetUserPermissionURL(refPermission.PermissionScope, "Default.aspx"), true);
                        return;
                    }

                    switch ((Utilities.ProfilesRNSDLL.BO.ORCID.REFPermission.REFPermissions)personMessage.PermissionID)
                    {
                        case Utilities.ProfilesRNSDLL.BO.ORCID.REFPermission.REFPermissions.orcid_profile_read_limited:
                        case Utilities.ProfilesRNSDLL.BO.ORCID.REFPermission.REFPermissions.orcid_bio_read_limited:
                        case Utilities.ProfilesRNSDLL.BO.ORCID.REFPermission.REFPermissions.orcid_works_read_limited:
                            ORCIDBLL.ReadORCIDProfile(person, personMessage, refPermission, LoggedInInternalUsername);
                            break;
                        default:
                            ORCIDBLL.SendORCIDXMLMessage(person, personToken.AccessToken, personMessage, refPermission);
                            break;
                    }
                }
            }
            LoadUserMessages(person);
        }
        private void LoadUserMessages(Utilities.ProfilesRNSDLL.BO.ORCID.Person person)
        {
            List<Utilities.ProfilesRNSDLL.BO.ORCID.PersonMessage> messages = (from m in PersonMessageBLL.GetByPersonID(person.PersonID) where m.UserMessageIsNull == false orderby m.PostDate descending select m).ToList();
            divMessages.Visible = messages.Count > 0;
            rptMessages.DataSource = messages;
            rptMessages.DataBind();
        }
        private void ProcessError(Utilities.ProfilesRNSDLL.BO.ORCID.Person person)
        {
            List<Utilities.ProfilesRNSDLL.BO.ORCID.PersonMessage> personMessages = GetPersonMessagesWaitingForApproval(person);
            if (personMessages.Count > 0)
            {
                PersonMessageBLL.ProcessORCID_ResponseError(personMessages[0], ORCID_ResponseError, ORCID_ResponseErrorDescription);
            }
        }
        private bool HasResponseFromORCID
        {
            get
            {
                return HasORCID_OAuthCode || HasORCID_ResponseError;
            }
        }
        private bool HasORCID_OAuthCode
        {
            get
            {
                return !OAuthCode.Equals(string.Empty);
            }
        }
        private bool HasORCID_ResponseError
        {
            get
            {
                return !ORCID_ResponseError.Equals(string.Empty);
            }
        }
        private string ORCID_ResponseError
        {
            get
            {
                return Utilities.ProfilesRNSDLL.DevelopmentBase.Helpers.QueryString.GetQueryString("error");
            }
        }
        private string ORCID_ResponseErrorDescription
        {
            get
            {
                return Utilities.ProfilesRNSDLL.DevelopmentBase.Helpers.QueryString.GetQueryString("error_description");
            }
        }
    }
}