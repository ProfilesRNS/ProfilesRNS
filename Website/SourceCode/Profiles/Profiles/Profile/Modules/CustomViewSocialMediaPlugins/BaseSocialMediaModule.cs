using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using Profiles.Framework.Utilities;

namespace Profiles.Profile.Modules
{
    public class BaseSocialMediaModule : BaseModule
    {
        private Profiles.Profile.Utilities.DataIO propdata;
        public BaseSocialMediaModule()
        {
        }
        public BaseSocialMediaModule(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
            : base(pagedata, moduleparams, pagenamespaces)
        {
            this.Init();
            this.LoadRawQueryString();
            this.BaseData = pagedata;
            this.ModuleParams = moduleparams;
            this.Namespaces = pagenamespaces;

            this.PropertyListXML = propdata.GetPropertyList(pagedata, base.PresentationXML, this.PredicateURI, false, true, false);
        }
        private new void Init()
        {

            if (Request.QueryString["subject"] != null)
                this.SubjectID = Convert.ToInt64(Request.QueryString["subject"]);
            else if (base.GetRawQueryStringItem("subject") != null)
                this.SubjectID = Convert.ToInt64(base.GetRawQueryStringItem("subject"));

            //name of the class that owns this class;
            if (Request.QueryString["predicateuri"] != null)
                this.PredicateURI = Request.QueryString["predicateuri"];
            else if (base.GetRawQueryStringItem("subject") != null)
                this.PredicateURI = base.GetRawQueryStringItem("predicateuri");


            this.propdata = new Profiles.Profile.Utilities.DataIO();
        }
        protected string SocialMediaInit(string pluginname)
        {
            if (this.SubjectID == 0) this.Init();

            return base.jsStart + pluginname + ".init('" + EscapeStringValue(Profiles.Framework.Utilities.GenericRDFDataIO.GetSocialMediaPlugInData(this.SubjectID, pluginname)) + "'); //no" + base.jsEnd;
        }
        protected string EscapeStringValue(string value)
        {
            //const char BACK_SLASH = '\\';
            //const char SLASH = '/';
            //const char DBL_QUOTE = '"';

            //var output = new StringBuilder(value.Length);
            //foreach (char c in value)
            //{
            //    switch (c)
            //    {
            //        case SLASH:
            //            output.AppendFormat("{0}{1}", BACK_SLASH, SLASH);
            //            break;

            //        case BACK_SLASH:
            //            output.AppendFormat("{0}{0}", BACK_SLASH);
            //            break;

            //        case DBL_QUOTE:
            //            output.AppendFormat("{0}{1}", BACK_SLASH, DBL_QUOTE);
            //            break;

            //        default:
            //            output.Append(c);
            //            break;
            //    }
            //}

            return value;
        }
        public long SubjectID { get; set; }
        public Int32 PersonID { get; set; }
        string _predicateuri = string.Empty;
        public string PredicateURI
        {
            get { return _predicateuri.Replace("!", "#"); }
            set { _predicateuri = value; }
        }
        public XmlDocument PropertyListXML { get; set; }

        //
        //stupid file name being the key to the module collection and so on
        private string _pluginname;
        public virtual string PlugInName { get { return _pluginname.Replace("Edit", ""); } set { _pluginname = value; } }

    }
}