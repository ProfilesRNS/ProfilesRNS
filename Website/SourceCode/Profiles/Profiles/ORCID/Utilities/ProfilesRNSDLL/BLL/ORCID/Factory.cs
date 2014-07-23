using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL
{
    public partial class Factory 
    {
        # region private variables
        private ProfilesRNSDLL.BLL.ORCID.ORCID _ORCID = null;
        private ProfilesRNSDLL.BLL.ORCID.OAuth _OAuth = null; //ZAP - Needed to add .ORCID to the ref
        # endregion // private variables

        public ProfilesRNSDLL.BLL.ORCID.ORCID ORCID
        {
            get
            {
                if (_ORCID == null)
                {
                    _ORCID = new ProfilesRNSDLL.BLL.ORCID();
                }
                return _ORCID;
            }
        }
        public ProfilesRNSDLL.BLL.ORCID.OAuth OAuth
        {
            get
            {
                if (_OAuth == null)
                {
                    _OAuth = new ProfilesRNSDLL.BLL.OAuth();
                }
                return _OAuth;
            }
        }
    }
}
