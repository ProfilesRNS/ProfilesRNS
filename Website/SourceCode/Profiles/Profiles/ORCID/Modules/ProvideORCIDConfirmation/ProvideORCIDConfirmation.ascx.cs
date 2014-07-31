/*  
 
    Copyright (c) 2008-2012 by the President and Fellows of Harvard College. All rights reserved.  
    Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
    and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
    National Center for Research Resources and Harvard University.


    Code licensed under a BSD License. 
    For details, see: LICENSE.txt 
  
*/
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.Web.UI.HtmlControls;
using System.Web.Script.Serialization;
using Profiles.Login.Utilities;
using Profiles.Framework.Utilities;
using Profiles.ORNG.Utilities;

using System.Data;
using System.Data.SqlClient;
using System.Data.Common;
using System.Globalization;
using System.Text;
using System.Xml.Xsl;

using Profiles.Profile.Utilities;

namespace Profiles.ORCID.Modules.ProvideORCIDConfirmation
{
    public partial class ProvideORCIDConfirmation : ORCIDBaseModule
    {
        public override Label Errors
        {
            get { return lblErrors; }
        }
        public void Initialize(XmlDocument basedata, XmlNamespaceManager namespaces, RDFTriple rdftriple)
        {
            BaseData = basedata;
            Namespaces = namespaces;
            RDFTriple = rdftriple;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID.Person person = GetPerson();
                    LoadPageLabels(person);

                    if (AssociateORCIDWithOrganizationID(person, Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.ORCID.OAuth.GetORCID(OAuthCode, "ProvideORCIDConfirmation.aspx", LoggedInInternalUsername)))
                    {
                        pSuccess.Visible = true;
                        LoadPageLabels(person);
                    }
                    else
                    {
                        pSuccess.Visible = false;
                        lblErrors.Text = "An error occurred while associating your ORCID with your local identifier";
                    }
                    Int64 subjectID = new Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.Profile.Data.Person().GetNodeId(person.InternalUsername);
                    Edit.Utilities.DataIO data = new Edit.Utilities.DataIO();
                    data.AddLiteral(subjectID, data.GetStoreNode("http://vivoweb.org/ontology/core#orcidId"), data.GetStoreNode(person.ORCID));
                    pHasProfile.Visible = !subjectID.Equals(0);
                    hlProfile.NavigateUrl = "~/display/" + subjectID.ToString();
                    hlEdit.NavigateUrl = Root.Domain + "/edit/default.aspx?subject=" + subjectID.ToString() + "&predicateuri=http://vivoweb.org/ontology/core!orcidId&module=DisplayItemToEdit&ObjectType=Literal";
                }
            }
            catch (Exception ex)
            {
                LogException(ex);
            }
        }
        private void LoadPageLabels(Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID.Person person)
        {
            //lblOrganizationName.Text = ProfilesRNSDLL.DevelopmentBase.Common.GetConfig("ORCID.OrganizationName").ToString();
        }
        private bool AssociateORCIDWithOrganizationID(Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID.Person person, string orcid)
        {
            person.ORCID = orcid;
            person.PersonStatusTypeID = (int)Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID.REFPersonStatusType.REFPersonStatusTypes.ORCID_Provided;
            person.ORCIDRecorded = DateTime.Now;
            return PersonBLL.Save(person);
        }
    }
}