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
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Data.Common;
using System.Globalization;
using System.Text;
using System.Xml;
using System.Xml.Xsl;
using System.Web.Caching;

using Profiles.Framework.Utilities;
using Profiles.Profile.Utilities;
using Profiles.Edit.Utilities;


namespace Profiles.Edit.Modules.EditPropertyContainer
{
    public partial class EditPropertyContainer : BaseModule
    {

        SessionManagement session;

        private ModulesProcessing mp;

        override protected void OnInit(EventArgs e)
        {
            string method = string.Empty;

            session = new SessionManagement();

            DrawProfilesModule();

        }

        protected void Page_Load(object sender, EventArgs e)
        {


        }

        public EditPropertyContainer() : base() { }
        public EditPropertyContainer(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
            : base(pagedata, moduleparams, pagenamespaces)
        {
            mp = new ModulesProcessing();


            footer.MasterPage = base.MasterPage;

        }
        

        private void DrawProfilesModule()
        {
            XmlDocument moduledoc = new XmlDocument();
            string moduletype = string.Empty;
            string objecttype = string.Empty;
            System.Text.StringBuilder html = new System.Text.StringBuilder();

            if (Request.QueryString["Module"] != null || Request.Form["Module"] != null)
            {
                if (Request.Form["Module"] != null)
                    moduletype = Request.Form["Module"].ToString().ToLower();
                else if(Request.QueryString["Module"] != null)
                    moduletype = Request.QueryString["Module"].ToString().ToLower();

                session.CurrentEditModule = moduletype;

            }
            else if (session.CurrentEditModule != null)
            {
                moduletype = session.CurrentEditModule;
            }

            if (Request.QueryString["ObjectType"] != null)
            {
                objecttype = Request.QueryString["ObjectType"].ToString().ToLower();
            }

            if (Request.QueryString["predicateuri"] != null)
                session.CurrentEditPredicateURI = Request.QueryString["predicateuri"].Replace("!", "#");
            
            switch (moduletype)
            {

                case "displayitemtoedit":

                    if (base.PresentationXML.SelectSingleNode("//PropertyList/PropertyGroup/Property[@URI='" + session.CurrentEditPredicateURI + "']/@CustomEdit").Value == "true")
                    {
                        // CustomEdit
                        if (base.PresentationXML.SelectSingleNode("//PropertyList/PropertyGroup/Property[@URI='" + session.CurrentEditPredicateURI + "']").InnerXml.ToLower().Contains("<module"))
                            moduledoc = this.CustomModule;
                        else
                            moduledoc = this.EditVisibilityOnly;
                    }
                    else
                    {           
                        if (objecttype.ToLower() == "literal")
                            moduledoc = this.EditDataTypeProperty;
                        else
                            moduledoc = this.DefaultEditEntity;
                    }

                    break;

                               
                default:
                    moduledoc = this.EditPropertyList;
                    break;
            }

            //html.Append(base.RenderCustomControl(moduledoc, base.BaseData));
            base.RenderAndAttachCustomControl(ref phControlContainer, moduledoc, base.BaseData);



        }


        private XmlDocument EditPropertyList
        {
            get
            {
                XmlDocument module = new XmlDocument();
                module.LoadXml("<CustomModule><Module ID=\"EditPropertyList\" Type=\"fixed\"></Module></CustomModule>");


                return module;

            }
        }
      

        private XmlDocument EditDataTypeProperty
        {
            get
            {

                XmlDocument module = new XmlDocument();
                module.LoadXml("<CustomModule><Module ID=\"EditDataTypeProperty\" Type=\"fixed\"></Module></CustomModule>");

                return module;

            }
        }

        private XmlDocument EditVisibilityOnly
        {
            get
            {

                XmlDocument module = new XmlDocument();
                module.LoadXml("<CustomModule><Module ID=\"EditVisibilityOnly\" Type=\"fixed\"></Module></CustomModule>");

                return module;

            }
        }

        private XmlDocument DefaultEditEntity
        {
            get
            {

                XmlDocument module = new XmlDocument();
                module.LoadXml("<CustomModule><Module ID=\"EditObjectTypeProperty\" Type=\"fixed\"></Module></CustomModule>");

                return module;

            }
        }

        private XmlDocument CustomModule
        {
            get
            {
                XmlDocument node = new XmlDocument();
                node.LoadXml("<CustomModule>" + base.PresentationXML.SelectSingleNode("//PropertyList/PropertyGroup/Property[@URI='" + session.CurrentEditPredicateURI + "']").InnerXml + "</CustomModule>");
                return node;
            }
        }

        




    }
}