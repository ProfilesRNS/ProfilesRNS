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

namespace Profiles.ORCID.Modules
{
    public abstract class ORCIDBaseModule : BaseModule
    {
        public abstract System.Web.UI.WebControls.Label Errors { get; }
        private Profiles.ORCID.Utilities.DataIO data;
        public ORCIDBaseModule()
        { data = new Profiles.ORCID.Utilities.DataIO(); }
        public ORCIDBaseModule(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
            : base(pagedata, moduleparams, pagenamespaces)
        { data = new Profiles.ORCID.Utilities.DataIO(); }
        public string LoggedInInternalUsername
        {
            get
            {
                return data.GetInternalUserID();
            }
        }
        public Utilities.ProfilesRNSDLL.BO.ORCID.Person GetPerson()
        {
            Utilities.ProfilesRNSDLL.BLL.ORCID.Person personBLL = new Utilities.ProfilesRNSDLL.BLL.ORCID.Person();
            Utilities.ProfilesRNSDLL.BO.ORCID.Person person = personBLL.GetByInternalUsername(LoggedInInternalUsername);
            return person;
        }
        public void LogException(Exception ex)
        {
            if (ex.GetType().IsSubclassOf(typeof(Utilities.ProfilesRNSDLL.DevelopmentBase.BO.ExceptionSafeToDisplay)) || ex.GetType().IsSubclassOf(typeof(Utilities.ProfilesRNSDLL.DevelopmentBase.BO.ExceptionSafeToDisplay)))
            {
                AddError(ex.Message);
            }
            else
            {
                AddError("An unexpected error occurred.  Please contact the help desk for assistance.");
            }
            LogExceptionOnly(ex);
        }
        public string ORCID_WordPress_Agreement
        {
            get
            {
                return Profiles.ORCID.Utilities.config.InfoSite + "agreement/";
            }
        }

        protected void AddError(string error)
        {
            this.Errors.Visible = true;
            this.Errors.Text += error + "<br />";
        }
        protected string OAuthCode
        {
            get
            {
                return Utilities.ProfilesRNSDLL.DevelopmentBase.Helpers.QueryString.GetQueryString("Code");
            }
        }
        protected void LogExceptionOnly(Exception ex)
        {
            Utilities.ProfilesRNSDLL.BLL.ORCID.ErrorLog.LogError(ex, LoggedInInternalUsername);
        }
        protected string ORCID_WordPress_AgreementConfirmation
        {
            get
            {
                return Profiles.ORCID.Utilities.config.InfoSite + "orcid-agreement-confirmation/";
            }
        }
        protected string GetFieldFromRDF(string fieldname)
        {
            if (this.BaseData != null && this.BaseData.SelectSingleNode("rdf:RDF[1]/rdf:Description[1]/" + fieldname, this.Namespaces) != null)
            {
                return this.BaseData.SelectSingleNode("rdf:RDF[1]/rdf:Description[1]/" + fieldname, this.Namespaces).InnerText;
            }
            else
            {
                return string.Empty;
            }
        }
        protected SessionManagement sm
        {
            get
            {
                if (_sm == null)
                {
                    _sm = new SessionManagement();
                }
                return _sm;
            }
        }
        protected Utilities.ProfilesRNSDLL.BLL.ORCID.PersonToken PersonTokenBLL
        {
            get
            {
                if (_PersonTokenBLL == null)
                {
                    _PersonTokenBLL = new Utilities.ProfilesRNSDLL.BLL.ORCID.PersonToken();
                }
                return _PersonTokenBLL;
            }
        }
        protected Utilities.ProfilesRNSDLL.BLL.ORCID.PersonMessage PersonMessageBLL
        {
            get
            {
                if (_PersonMessageBLL == null)
                {
                    _PersonMessageBLL = new Utilities.ProfilesRNSDLL.BLL.ORCID.PersonMessage();
                }
                return _PersonMessageBLL;
            }
        }
        protected Utilities.ProfilesRNSDLL.BLL.ORCID.REFPermission REFPermissionBLL
        {
            get
            {
                if (_REFPermissionBLL == null)
                {
                    _REFPermissionBLL = new Utilities.ProfilesRNSDLL.BLL.ORCID.REFPermission();
                }
                return _REFPermissionBLL;
            }
        }
        protected Utilities.ProfilesRNSDLL.BLL.ORCID.ORCID ORCIDBLL
        {
            get
            {
                if (_ORCIDBLL == null)
                {
                    _ORCIDBLL = new Utilities.ProfilesRNSDLL.BLL.ORCID.ORCID();
                }
                return _ORCIDBLL;
            }
        }
        protected Utilities.ProfilesRNSDLL.BLL.ORCID.Person PersonBLL
        {
            get
            {
                if (_PersonBLL == null)
                {
                    _PersonBLL = new Utilities.ProfilesRNSDLL.BLL.ORCID.Person();
                }
                return _PersonBLL;
            }
        }

        private SessionManagement _sm = null;
        private Utilities.ProfilesRNSDLL.BLL.ORCID.PersonToken _PersonTokenBLL = null;
        private Utilities.ProfilesRNSDLL.BLL.ORCID.PersonMessage _PersonMessageBLL = null;
        private Utilities.ProfilesRNSDLL.BLL.ORCID.REFPermission _REFPermissionBLL = null;
        private Utilities.ProfilesRNSDLL.BLL.ORCID.ORCID _ORCIDBLL = null;
        private Utilities.ProfilesRNSDLL.BLL.ORCID.Person _PersonBLL = null;
    }
}