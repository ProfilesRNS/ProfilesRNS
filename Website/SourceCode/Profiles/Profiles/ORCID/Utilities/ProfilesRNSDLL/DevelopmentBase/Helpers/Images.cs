using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DevelopmentBase.Helpers
{
    public class Images
    {

        private string PathToImages
        {
            get
            {
                return "http://wwwapp.bumc.bu.edu/it/bumcitapplibrary/images/";
            }
        }

        public string SuccessImage
        {
            get {
                return PathToImages + "CheckMark.GIF";
            }
        }

        public string FailedImage
        {
            get
            {
                return PathToImages + "redX.JPG";
            }
        }

    }
}
