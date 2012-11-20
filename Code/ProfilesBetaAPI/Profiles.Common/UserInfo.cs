/*  
 
    Copyright (c) 2008-2010 by the President and Fellows of Harvard College. All rights reserved.  
    Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
    and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
    National Center for Research Resources and Harvard University.


    Code licensed under a BSD License. 
    For details, see: LICENSE.txt 
  
*/
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;

/// <summary>
/// Summary description for UserInfo
/// </summary>
[Serializable]
public class UserInfo
{
    /// <summary>
    /// Session name, where stored currently loggined user.
    /// </summary>
    public const string SessionName = "UserInfo";
    
    public readonly int UserID;
    public readonly string UserName;
    public readonly string DisplayName;


    public UserInfo(int p_UserID, string p_UserName, string p_DisplayName)
    {
        UserID = p_UserID;
        UserName = p_UserName;
        DisplayName = p_DisplayName;
    }

    public static UserInfo LoadUserInfo(string p_Login)
    {
        //StoredProcedure sp = new StoredProcedure("p_UserName_s_byLogin");
        //sp["@NTUserName"].Value = p_Login.Trim();
        //DataTable l_dtRes = sp.ExecuteDataTable();
        //if (l_dtRes.Rows.Count == 0) return null;
        //DataRow l_UserInfo = l_dtRes.Rows[0];

        //return new UserInfo((int)l_UserInfo["UserNameID"], l_UserInfo["UserID"] != DBNull.Value ? (int?)(int)l_UserInfo["UserID"] : null, l_UserInfo["NTUserName"].ToString());

        ProfilesMembershipUser l_User = (ProfilesMembershipUser) Membership.GetUser(p_Login);
        if (l_User == null) return null;

        return new UserInfo(l_User.UserID, l_User.UserName, l_User.FullName);
    }

    /// <summary>
    /// Information about currently loggined user. If guest view site, session is equal to null.
    /// </summary>
    public static UserInfo Current
    {
        get
        {
            if (HttpContext.Current == null) return null;
            if (HttpContext.Current.Session == null) return null;
            if (HttpContext.Current.Session[SessionName] == null && HttpContext.Current.User.Identity.IsAuthenticated)
            {
                HttpContext.Current.Session[SessionName] = LoadUserInfo(HttpContext.Current.User.Identity.Name);
            }
            return (UserInfo)HttpContext.Current.Session[SessionName];
        }
    }

    public static void Reset()
    {
        HttpContext.Current.Session[SessionName] = null;
    }

    public static void RefreshCurrentUser()
    {
        if (HttpContext.Current == null) return;
        if (HttpContext.Current.Session == null) return;
        if (HttpContext.Current.User.Identity.IsAuthenticated)
        {
            HttpContext.Current.Session[SessionName] = LoadUserInfo(HttpContext.Current.User.Identity.Name);
        }
    }

    public static void ResetCurrentUser()
    {
        if (HttpContext.Current == null) return;
        if (HttpContext.Current.Session == null) return;
        if (HttpContext.Current.Session[SessionName] != null)
        {
            HttpContext.Current.Session[SessionName] = null;
        }
    }
}
