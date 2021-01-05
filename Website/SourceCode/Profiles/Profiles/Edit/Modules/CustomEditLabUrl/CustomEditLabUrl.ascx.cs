using System;
using System.Collections.Generic;
using System.Collections;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.Xml.Xsl;
using Profiles.Framework.Utilities;
using Profiles.Profile.Utilities;
using System.Globalization;
using Profiles.Edit.Utilities;
using System.Web.UI.HtmlControls;
using System.Configuration;

namespace Profiles.Edit.Modules.CustomEditLabUrl
{
    public partial class CustomEditLabUrl : BaseModule
    {
        Edit.Utilities.DataIO data;
        Profiles.Profile.Utilities.DataIO propdata;
        private Int64 SubjectID { get; set; }
        private Int64 PredicateID { get; set; }
        private string PredicateURI { get; set; }

        private XmlDocument XMLData { get; set; }

        private XmlDocument PropertyListXML { get; set; }
        private string PropertyLabel { get; set; }
        private string MaxCardinality { get; set; }
        private string MinCardinality { get; set; }

        private string OriginalLabUrl { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {

        }
    }
}