using System;

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