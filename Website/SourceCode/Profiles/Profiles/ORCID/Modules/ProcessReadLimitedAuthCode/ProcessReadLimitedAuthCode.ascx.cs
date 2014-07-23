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

namespace Profiles.ORCID.Modules.ProcessReadLimitedAuthCode
{
    public partial class ProcessReadLimitedAuthCode : ORCIDBaseModule
    {
        public ProcessReadLimitedAuthCode()
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
                    Utilities.ProfilesRNSDLL.BO.ORCID.Person person = GetPerson();
                    if (!HasError(person))
                    {
                        Dictionary<string, object> items = Utilities.ProfilesRNSDLL.BLL.ORCID.OAuth.GetUserAccessTokenItems(OAuthCode, "ProcessRead-LimitedAuthCode.aspx", person.InternalUsername);
                        string orcid = items["orcid"].ToString();

                        if (!person.Exists)
                        {
                            throw new Utilities.ProfilesRNSDLL.DevelopmentBase.BO.ExceptionSafeToDisplay("This ORCID has not been recorded in the " +
                                Profiles.ORCID.Utilities.config.OrganizationName + " ORCID database.");
                        }
                        else
                        {
                            if (!string.IsNullOrEmpty(OAuthCode))
                            {
                                new Utilities.ProfilesRNSDLL.BLL.ORCID.PersonToken().UpdateUserToken(items, person, person.InternalUsername);
                            }
                            Response.Redirect(person.ORCIDUrl, false);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                LogException(ex);
            }
        }
        
        private bool HasError(Utilities.ProfilesRNSDLL.BO.ORCID.Person person)
        {
            string queryStringError = Utilities.ProfilesRNSDLL.DevelopmentBase.Helpers.QueryString.GetQueryString("error");
            string queryStringErrorDescription = Utilities.ProfilesRNSDLL.DevelopmentBase.Helpers.QueryString.GetQueryString("error_description");
            bool haserror = !queryStringError.Equals(string.Empty);

            if (haserror)
            {
                if (queryStringError == "access_denied")
                {
                    Response.Redirect(person.ORCIDUrl, false);
                }
                else
                {
                    throw new Utilities.ProfilesRNSDLL.DevelopmentBase.BO.ExceptionSafeToDisplay(queryStringError);
                }
            }
            return haserror;
        }
    }
}