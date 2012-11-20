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
using System.Linq;
using System.Web;
using System.Web.Security;

/// <summary>
/// Customized Membership user that inherits from the base ASP.NET MembershipUser class
/// </summary>
public class ProfilesMembershipUser : MembershipUser
{
    #region HasProfile getter Property
    private readonly bool m_hasProfile;
    public bool HasProfile
    {
        get { return m_hasProfile; }
    }
    #endregion

    #region UserID property
    private readonly int m_userId;
    public int UserID
    {
        get { return m_userId; }
    }
    #endregion

    #region ProfileID property
    private readonly int m_profileId;
    public int ProfileID
    {
        get { return m_profileId; }
    }
    #endregion

    #region DisplayName property
    private readonly string m_DisplayName;
    public string DisplayName
    {
        get { return m_DisplayName; }
    }
    #endregion

    #region FirstName

    private readonly string m_FirstName;
    public string FirstName
    {
        get { return m_FirstName; }
    }
    #endregion

    #region LastName

    private readonly string m_LastName;
    public string LastName
    {
        get { return m_LastName; }
    }
    #endregion

    #region FullName
    public string FullName
    {
        get { return string.Format("{0} {1}", FirstName, LastName).Trim(); }
    }
    #endregion

    #region DepartmentFullname

    private readonly string m_departmentFullname;
    public string DepartmentFullname
    {
        get { return m_departmentFullname; }
    }
    #endregion

    #region DivisionFullname

    private readonly string m_divisionFullname;
    public string DivisionFullname
    {
        get { return m_divisionFullname; }
    }
    #endregion

    #region InstitutionFullname

    private readonly string m_institutionFullname;
    public string InstitutionFullname
    {
        get { return m_institutionFullname; }
    }
    #endregion



    #region OfficePhone

    private readonly string m_officePhone;
    public string OfficePhone
    {
        get { return m_officePhone; }
    }
    #endregion

    #region PasswordAnswer

    private readonly string m_passwordAnswer;
    public string PasswordAnswer
    {
        get { return m_passwordAnswer; }
    }
    #endregion

    public ProfilesMembershipUser(
        string providerName, string username, object providerUserKey, string email, string passwordQuestion, string comment, bool isApproved, bool isLockedOut,
        DateTime creationDate, DateTime lastLoginDate, DateTime lastActivityDate, DateTime changedDate, DateTime lockedOutDate, bool hasProfile, int userId,
        int profileId,
        string displayName, string firstName, string lastName,
        string departmentFullname, string divisionFullName, string institutionFullname,
        string officePhone, string passwordAnswer)
        : base(providerName,
            username, providerUserKey, email, passwordQuestion, comment, isApproved, isLockedOut,
            creationDate, lastLoginDate, lastActivityDate, changedDate, lockedOutDate)
    {
        m_hasProfile = hasProfile;
        m_userId = userId;
        m_profileId = profileId;
        m_DisplayName = displayName;

        m_FirstName = firstName;
        m_LastName = lastName;
        m_departmentFullname = departmentFullname;
        m_divisionFullname = divisionFullName;
        m_institutionFullname = institutionFullname;
        m_officePhone = officePhone;
        m_passwordAnswer = passwordAnswer;
    }
}