using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Security.Principal;
using System.Runtime.InteropServices;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DevelopmentBase.Utilities
{
    public class SecurityClass
    {
        [DllImport("advapi32.dll", SetLastError = true)]

        private static extern bool LogonUser(string lpszUserName, string lpszDomain, string lpszPassword, int dwLogonType, int dwLogonProvider, out IntPtr phToken);

        public delegate void RunAsDelegate();

        public static void RunAs(RunAsDelegate MethodToRunAs, string Username, string Password)
        {

            string userName;
            string domain;

            if (Username.IndexOf('\\') > 0)
            {
                //a domain name was supplied
                string[] usernameArray = Username.Split('\\');
                userName = usernameArray[1];
                domain = usernameArray[0];
            }
            else
            {
                //there was no domain name supplied
                userName = Username;
                domain = ".";
            }
            RunAs(MethodToRunAs, userName, Password, domain);
        }

        public static void RunAs(RunAsDelegate MethodToRunAs, string Username, string Password, string Domain)
        {

            IntPtr imp_token;
            WindowsIdentity wid_admin = null;
            WindowsImpersonationContext wic = null;
            try
            {
                if (LogonUser(Username, string.IsNullOrEmpty(Domain) ? "." : Domain, Password, 9, 0, out imp_token))
                {
                    //the impersonation suceeded
                    wid_admin = new WindowsIdentity(imp_token);
                    wic = wid_admin.Impersonate();
                    //run the delegate method
                    MethodToRunAs();
                }
                else
                { 
                    throw new Exception(string.Format("Could not impersonate user {0} in domain {1} with the specified password.", Username, Domain));
                }
            }
            catch (Exception se)
            {
                int ret = Marshal.GetLastWin32Error();
                if (wic != null)
                {
                    wic.Undo();
                }
                throw new Exception("Error code: " + ret.ToString(), se);
            }
            finally
            {
                //revert to self
                if (wic != null)
                {
                    wic.Undo();

                }
            }
        }
    }
}