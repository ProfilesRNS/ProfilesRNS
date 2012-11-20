using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Caching;
using System.Data.SqlClient;

using Profiles.Search.Utilities;

namespace Profiles.Framework
{
    public class UserManagement
    {
        public UserManagement()
        {


        }

        public User GetUser()
        {
            User user = null;

            if (HttpContext.Current.Session["PROFILES_USER"] != null)
            {
                user = (User)(HttpContext.Current.Session["PROFILES_USER"]);
            }

            return user;

        }

        private void SaveUser(User user)
        {

            HttpContext.Current.Session["PROFILES_USER"] = user;

        }

        public void UpdateUserInfo(Framework.User thisUser)
        {
            Login.Utilities.DataIO oDataIO = new Login.Utilities.DataIO();
            oDataIO.UpdateUserDetails(thisUser);
        }

        public void LogOut()
        {
            Framework.Utilities.SessionManagement sessionmanagement = new Profiles.Framework.Utilities.SessionManagement();
            sessionmanagement.SessionLogout();

            this.SaveUser(null);

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="userid"></param>
        /// <param name="password"></param>
        /// <returns></returns>
        public bool LogIn(string username, string password)
        {
            bool rtn = false;
            try
            {
                Framework.Utilities.SessionManagement sessionmanagement = new Framework.Utilities.SessionManagement();
                User user = new User();

                Framework.Utilities.Session session = sessionmanagement.Session();
                user.UserName = username;

                //ZAP - need to do an MD5 Hash on the password
                user.Password = password;


                Login.Utilities.DataIO dataio = new Login.Utilities.DataIO();
                dataio.UserLogin(ref user, ref session);

                if (user.Roles != null)
                {
                    rtn = true;
                }


                this.SaveUser(user);


            }
            catch (Exception ex)
            {
                //ZAP- need an error log.
                ex = ex;
                rtn = false;
            }

            //ZAP-  need to cross this bridge soon
            //Find out if they have a profile
            //If they have a profile Get the users proxies

            return rtn;
        }

        public bool RoleExists(string role)
        {


            Role testrole = null;

            if (this.GetUser() != null)
            {
                List<Role> roles = this.GetUser().Roles;
                testrole = roles.Find(delegate(Role delrole) { return delrole.Value.ToLower().Trim() == role.ToLower().Trim(); });
            }

            if (testrole != null)
            {
                return true;
            }
            else
            {
                return false;
            }


        }

        public User GetUserDetails(string UserID)
        {
            Login.Utilities.DataIO oDataIO = new Login.Utilities.DataIO();
            User thisUser = new User();
            SqlDataReader dbreader = oDataIO.GetUserDetails(UserID);
            dbreader.Read();
            thisUser.PersonID = dbreader["PersonID"].ToString();
            thisUser.UserID = (Int32)dbreader["UserID"];
            thisUser.IsActive = dbreader["IsActive"].ToString();
            thisUser.CanBeProxy = dbreader["CanBeProxy"].ToString();
            thisUser.FirstName = dbreader["FirstName"].ToString();
            thisUser.LastName = dbreader["LastName"].ToString();
            thisUser.DisplayName = dbreader["DisplayName"].ToString();
            thisUser.OfficePhone = dbreader["OfficePhone"].ToString();
            thisUser.EmailAddr = dbreader["EmailAddr"].ToString();
            thisUser.InstitutionFullName = dbreader["InstitutionFullName"].ToString();
            thisUser.DepartmentFullName = dbreader["DepartmentFullName"].ToString();
            thisUser.DivisionFullName = dbreader["DivisionFullName"].ToString();
            thisUser.UserName = dbreader["UserName"].ToString();
            thisUser.Password = dbreader["Password"].ToString();
            thisUser.PasswordFormat = dbreader["PasswordFormat"].ToString();
            thisUser.PasswordQuestion = dbreader["PasswordQuestion"].ToString();
            thisUser.PasswordAnswer = dbreader["PasswordAnswer"].ToString();
            thisUser.InternalUserName = dbreader["InternalUserName"].ToString();
            thisUser.InternalLDAPUserName = dbreader["InternalLDAPUserName"].ToString();

            if (!dbreader.IsClosed)
                dbreader.Close();


            return thisUser;
        }

        public void GetUserProxies(Int32 UserID)
        {
            Login.Utilities.DataIO oDataIO = new Login.Utilities.DataIO();
            System.Data.DataTable dt = new System.Data.DataTable();
            oDataIO.GetUserProxies(dt, UserID, 0, "N", "Y", "Y", "Y");
            User thisUser = new User();  
            foreach (System.Data.DataRow dr in dt.Rows) { 
                Proxie newProxy = new Proxie("");
                newProxy.Proxy = Convert.ToInt32(dr[0]); 
                thisUser.Proxies.Add(newProxy);
            }  
        }

        public Proxie GetProxieDetails(Int32 UserID, string ProxyDefaultID, Int32 Proxy) {
            Proxie thisProxy = new Proxie(ProxyDefaultID);
            Login.Utilities.DataIO oDataIO = new Login.Utilities.DataIO();
            System.Data.DataTable dt = new System.Data.DataTable();
            oDataIO.GetUserProxies(dt, UserID, Proxy, "N", "Y", "Y", "Y");
            if (dt.Rows.Count > 0){
                thisProxy.ProxyDefaultID = ProxyDefaultID;
                thisProxy.IsHidden = 'N';
                thisProxy.EditName = (Int16)dt.Rows[0]["EditName"];
                thisProxy.EditPhoto = (Int16)dt.Rows[0]["EditPhoto"];
                thisProxy.EditTitles = (Int16)dt.Rows[0]["EditTitles"];
                thisProxy.EditEmail  = (Int16)dt.Rows[0]["EditEmail"];
                thisProxy.EditAddress = (Int16)dt.Rows[0]["EditAddress"];
                thisProxy.EditEducation = (Int16)dt.Rows[0]["EditEducation"];
                thisProxy.EditAwards = (Int16)dt.Rows[0]["EditAwards"];
                thisProxy.EditNarrative = (Int16)dt.Rows[0]["EditNarrative"];
                thisProxy.EditPublications = (Int16)dt.Rows[0]["EditPublications"];
                thisProxy.EditWebsites = (Int16)dt.Rows[0]["EditWebsites"];
            } 
            return thisProxy; 
        }

        public void UpdateProxy(Proxie ThisProxie){
            Login.Utilities.DataIO oDataIO = new Login.Utilities.DataIO();
            oDataIO.UpdateProxieDetails(ThisProxie);
        }

    }

    public class User
    {
        public User()
        {
            this.UserID = 0;
            this.Password = string.Empty;
            this.PersonID = string.Empty;
        }

        public int UserID { get; set; }
        public string Password { get; set; }
        public string UserName { get; set; }
        public string PersonID { get; set; }
        public List<Role> Roles { get; set; }
        public List<Proxie> Proxies { get; set; }
        public bool ProfileExists() { return false; }
        public string OfficePhone { get; set; }
        public string EmailAddr { get; set; }
        public string PasswordFormat { get; set; }

        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string IsActive { get; set; }
        public string CanBeProxy { get; set; }
        public string DisplayName { get; set; }
        public string PasswordQuestion { get; set; }
        public string PasswordAnswer { get; set; }
        public string DepartmentFullName { get; set; }
        public string DivisionFullName { get; set; }
        public string InstitutionFullName { get; set; }
        public string InternalUserName { get; set; }
        public string InternalLDAPUserName { get; set; }
        public string IsApproved { get; set; }
    }

    public class Role
    {
        public Role(string role)
        {
            this.Value = role;
        }
        public string Value { get; set; }
    }

    public class Proxie
    {
        public Proxie(string proxie)
        {
            this.Value = proxie;

        }

        public string Value { get; set; }

        public String ProxyDefaultID { get; set; }
        public string InstitutionFullName { get; set; }
        public string DepartmentFullName { get; set; }
        public int Proxy { get; set; }
        public Char IsHidden { get; set; }
        public Int16 EditName { get; set; }
        public Int16 EditTitles { get; set; }
        public Int16 EditAddress { get; set; }
        public Int16 EditEmail { get; set; }
        public Int16 EditPhoto { get; set; }
        public Int16 EditWebsites { get; set; }
        public Int16 EditAwards { get; set; }
        public Int16 EditEducation { get; set; }
        public Int16 EditNarrative { get; set; }
        public Int16 EditPublications { get; set; }
    }



}
