using System;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DevelopmentBase.BO
{
    public class ExceptionSafeToDisplay : ApplicationException
    {
        public ExceptionSafeToDisplay() : base()
        {
        }

        public ExceptionSafeToDisplay(string FriendlyMsg)
            : base(FriendlyMsg)
        {
        }

        //public ExceptionSafeToDisplay(string FriendlyMsg, Exception inner)
        //    : base(FriendlyMsg, inner)
        //{
        //}
    }
}
