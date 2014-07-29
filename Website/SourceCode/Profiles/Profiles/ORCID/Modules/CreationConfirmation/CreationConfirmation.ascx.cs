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

namespace Profiles.ORCID.Modules.CreationConfirmation
{
    public partial class CreationConfirmation : ORCIDBaseModule
    {
        public CreationConfirmation()
        {
            base.RDFTriple = new RDFTriple(Convert.ToInt64(sm.Session().NodeID.ToString()));             
        }
        public void Initialize(XmlDocument basedata, XmlNamespaceManager namespaces, RDFTriple rdftriple)
        {
            BaseData = basedata;
            Namespaces = namespaces;
            RDFTriple = rdftriple;
        }
        public override Label Errors
        {
            get { return this.lblErrors; }
        }

        protected void Page_Load(object sender, System.EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    DrawProfilesModule();
                }
            }
            catch (Exception ex)
            {
                LogException(ex);
            }
        }
        protected void DrawProfilesModule()
        {
            bool proxy = false;
            if (Request.Params["Proxy"] != null)
            {
                proxy = Convert.ToBoolean(Request.Params["Proxy"]);
            }
            
            if (proxy)
            {
                pnlUserText.Visible = false;
                pnlProxyText.Visible = true;
                imgORCIDProxy.Src = Root.Domain + "/Framework/Images/orcid_16x16(1).gif";
                string userORCID = Request.Params["UserORCID"];

                hlORCIDUrlProxy.Text = Profiles.ORCID.Utilities.config.ORCID_URL + "/" + userORCID;
                hlORCIDUrlProxy.NavigateUrl = Profiles.ORCID.Utilities.config.ORCID_URL + "/" + userORCID;
                hlORCIDUrlProxy.Target = "_blank";
            }
            else
            {
                pnlUserText.Visible = true;
                pnlProxyText.Visible = false;
                imgOrcid.Src = Root.Domain + "/Framework/Images/orcid_16x16(1).gif";
                Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID.Person person = GetPerson();
                if (person.Exists && !person.ORCIDIsNull && !person.ORCID.Equals(string.Empty))
                {
                    hlORCIDUrl.Text = person.ORCIDUrl;
                    hlORCIDUrl.NavigateUrl = person.ORCIDUrl;
                    hlORCIDUrl.Target = "_blank";
                    spanYourORCID.Visible = true;
                }
            }
        }
    }
}