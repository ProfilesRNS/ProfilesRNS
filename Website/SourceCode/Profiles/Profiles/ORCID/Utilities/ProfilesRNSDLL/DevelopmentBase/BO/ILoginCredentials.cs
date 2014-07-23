using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DevelopmentBase.BO
{
    public interface ILoginCredentials
    {
        string Message { get; }
        string BUID { get; }
        string Alias { get; }
        string Email { get; }
        string Name { get; }
        string LastName  { get; }
        string FirstName { get; }
        string XMLResponse { get; }
        bool IsSuccessful { get; }
        string FailureMsg { get; set; }
        string ExceptionType { get; set; }
    }
}
