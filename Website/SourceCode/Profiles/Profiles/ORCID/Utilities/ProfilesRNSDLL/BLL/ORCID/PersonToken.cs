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
using System.Data.Common;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.ORCID
{
    public partial class PersonToken
    {
        public bool Save(BO.ORCID.PersonToken bo)
        {
            if (bo.Exists)
            {
                return base.Edit(bo);
            }
            else
            {
                return base.Add(bo);
            }
        }
        public new BO.ORCID.PersonToken GetByPersonIDAndPermissionID(int personID, int permissionID)
        {
            return base.GetByPersonIDAndPermissionID(personID, permissionID);
        }
        public bool CheckForValidToken(BO.ORCID.Person person, BO.ORCID.REFPermission refPermission)
        {
            ProfilesRNSDLL.BO.ORCID.PersonToken personToken = new BLL.ORCID.PersonToken().GetByPersonIDAndPermissionID(person.PersonID, refPermission.PermissionID);
            return personToken.Exists && !personToken.IsExpired;
        }
        public ProfilesRNSDLL.BO.ORCID.PersonToken Get(BO.ORCID.Person person, BO.ORCID.REFPermission refPermission)
        {
            ProfilesRNSDLL.BO.ORCID.PersonToken personToken = new BLL.ORCID.PersonToken().GetByPersonIDAndPermissionID(person.PersonID, refPermission.PermissionID);
            if (personToken.Exists && !personToken.IsExpired)
            {
                return personToken;
            }
            else
            {
                BO.ORCID.PersonToken bo = new BO.ORCID.PersonToken();
                bo.PersonID = person.PersonID;
                bo.PermissionID = refPermission.PermissionID;
                return bo;
            }
        }
        public void UpdateUserToken(Dictionary<string, object> items, BO.ORCID.Person person, string loggedInInternalUsername)
        {
            try
            {
                BO.ORCID.PersonToken accessToken = PersonToken.GetAPIUserAccessToken(items, person);
                if (!Save(accessToken))
                {
                    throw new Exception("An unexpected error occurred while saving the token");
                }
                if (accessToken.PermissionID == (int)BO.ORCID.REFPermission.REFPermissions.orcid_profile_read_limited)
                {
                    BLL.ORCID.PersonMessage personMessageBLL = new PersonMessage();
                    List<BO.ORCID.PersonMessage> personMessages = personMessageBLL.GetByPersonIDAndRecordStatusIDAndPermissionID(person.PersonID,
                        (int)BO.ORCID.REFRecordStatus.REFRecordStatuss.Waiting_for_ORCID_User_for_approval,
                        (int)accessToken.PermissionID, false);
                    foreach (BO.ORCID.PersonMessage personMessage in personMessages)
                    {
                        personMessage.RecordStatusID = (int)BO.ORCID.REFRecordStatus.REFRecordStatuss.Success;
                        if (!personMessageBLL.Save(personMessage))
                        {
                            throw new Exception("Token was saved but an unexpected error occurred while updating the related messages.");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw BLL.ORCID.ErrorLog.LogError(ex, loggedInInternalUsername, "Error saving token information to table: ProfileToken in databae: BUMC_ORCID.");
            }
        }
        public void UpdateUserToken(string oAuthCode, BO.ORCID.Person person, string returnPage, string loggedInInternalUsername)
        {
            try
            {
                Dictionary<string, object> items = ProfilesRNSDLL.BLL.ORCID.OAuth.GetUserAccessTokenItems(oAuthCode, returnPage, loggedInInternalUsername);
                UpdateUserToken(items, person, loggedInInternalUsername);
            }
            catch (Exception ex)
            {
                throw BLL.ORCID.ErrorLog.LogError(ex, loggedInInternalUsername, "Error saving token information to table: ProfileToken in databae: BUMC_ORCID.");
            }
        }

        internal static BO.ORCID.PersonToken GetAPIUserAccessToken(Dictionary<string, object> items, BO.ORCID.Person person)
        {
            if (!items["orcid"].ToString().Equals(person.ORCID))
            {
                throw new Exception("The token ORCID does not match what is in the database.");
            }
            int permissionID = REFPermission.GetPermissionID(items["scope"].ToString());

            BO.ORCID.PersonToken bo = new ProfilesRNSDLL.BLL.ORCID.PersonToken().
                GetByPersonIDAndPermissionID(person.PersonID, permissionID);

            bo.PersonID = person.PersonID;
            bo.PermissionID = permissionID;
            bo.TokenExpiration = DateTime.Now.AddSeconds(Convert.ToInt32(items["expires_in"]));
            bo.AccessToken = items["access_token"].ToString();
            //bo.RefreshToken = items["refresh_token"].ToString();
            return bo;
        }
    }
}
