using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DevelopmentBase.BO
{
    public abstract class LoginCredentials : ILoginCredentials
    {
        public string LastName
        {
            get
            {
                return Name.Split(',')[0];
            }
        }
        public string FirstName
        {
            get
            {
                return Name.Split(',')[1];
            }
        }
        public abstract string Message { get; }
        public abstract string BUID { get; }
        public abstract string Alias { get; }
        public abstract string Email { get; }
        public abstract string Name { get; }
        public abstract string XMLResponse { get; }
        public abstract bool IsSuccessful { get; }
        public string FailureMsg { get; set; }
        public string ExceptionType {get; set;}
    }
}
