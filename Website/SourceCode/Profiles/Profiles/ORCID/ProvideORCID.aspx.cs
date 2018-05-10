using System;

namespace Profiles.ORCID
{
    public partial class ProvideORCID : Profiles.ORCID.Utilities.ProfileData
    {
        public override string PathToPresentationXMLFile
        {
            get { return AppDomain.CurrentDomain.BaseDirectory + "/ORCID/PresentationXML/ProvideORCIDPresentation.xml"; }
        }
        public void Page_Init(object sender, EventArgs e)
        {
            base.Initialize();
            ProvideORCID1.Initialize(base.RDFData, base.RDFNamespaces, base.RDFTriple);
        }
    }
}