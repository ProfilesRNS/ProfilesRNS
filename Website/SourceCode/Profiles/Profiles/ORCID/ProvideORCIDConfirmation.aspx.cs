using System;

namespace Profiles.ORCID
{
    public partial class ProvideORCIDConfirmation : Profiles.ORCID.Utilities.ProfileData
    {
        public override string PathToPresentationXMLFile
        {
            get { return AppDomain.CurrentDomain.BaseDirectory + "/ORCID/PresentationXML/ProvideORCIDConfirmationPresentation.xml"; }
        }
        public void Page_Init(object sender, EventArgs e)
        {
            base.Initialize();
            ProvideORCIDConfirmation1.Initialize(base.RDFData, base.RDFNamespaces, base.RDFTriple);
        }
    }
}