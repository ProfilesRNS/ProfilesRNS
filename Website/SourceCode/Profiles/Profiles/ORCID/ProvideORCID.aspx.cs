using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Xml;
using System.Web.UI.WebControls;
using System.IO;
using System.Web.UI.HtmlControls;

using Profiles.Framework.Utilities;
using Profiles.Search.Utilities;
using Profiles.Profile.Utilities;

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