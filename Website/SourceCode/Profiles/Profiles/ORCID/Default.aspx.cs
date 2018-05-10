using System;

namespace Profiles.ORCID
{
    public partial class Default : Profiles.ORCID.Utilities.ProfileData
    {
        public override string PathToPresentationXMLFile
        {
            get { return AppDomain.CurrentDomain.BaseDirectory + "/ORCID/PresentationXML/DefaultPresentation.xml"; }
        }
        public void Page_Init(object sender, EventArgs e)
        {
            base.Initialize();
            Default1.Initialize(base.RDFData, base.RDFNamespaces, base.RDFTriple);
        }
    }
}