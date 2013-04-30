using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Profiles.ORNG.Utilities
{

    public interface ORNGCallbackResponder
    {
        string getCallbackResponse(OpenSocialManager om, string channel);
    }

}