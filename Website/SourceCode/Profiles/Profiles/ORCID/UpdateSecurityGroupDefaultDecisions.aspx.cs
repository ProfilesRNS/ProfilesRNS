using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Profiles.ORCID
{
    public partial class UpdateSecurityGroupDefaultDecisions : Profiles.ORCID.Utilities.ProfileData
    {
        public override string PathToPresentationXMLFile
        {
            get { return AppDomain.CurrentDomain.BaseDirectory + "/ORCID/PresentationXML/UpdateSecurityGroupDefaultDecisionsPresentation.xml"; }
        }
        public void Page_Init(object sender, EventArgs e)
        {
            base.Initialize();
        }
    }
}