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
using System.Xml;
using Profiles.Framework.Utilities;


namespace Profiles.Profile.Modules.PropertyList
{
    public partial class PropertyList : BaseModule
    {
        private ModulesProcessing mp;        
        protected void Page_Load(object sender, EventArgs e)
        {
            DrawProfilesModule();
        }

        public PropertyList() { }
        public PropertyList(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
            : base(pagedata, moduleparams, pagenamespaces)
        {

            
            XmlDocument presentationxml = base.PresentationXML;
            SessionManagement sm = new SessionManagement();

            Profiles.Profile.Utilities.DataIO data = new Profiles.Profile.Utilities.DataIO();
            

            this.PropertyListXML = data.GetPropertyList(pagedata, presentationxml,"",false,false,true);

            mp = new ModulesProcessing();

        }

        private void DrawProfilesModule()
        {

            string label = string.Empty;
            System.Text.StringBuilder html = new System.Text.StringBuilder();
            System.Text.StringBuilder itembuffer = new System.Text.StringBuilder();
            
            bool hasitems = false;

            // UCSF OpenSocial items
            string uri = null;
            // code to convert from numeric node ID to URI
            if (base.Namespaces.HasNamespace("rdf"))
            {
                XmlNode node = this.BaseData.SelectSingleNode("rdf:RDF/rdf:Description/@rdf:about", base.Namespaces);
                uri = node != null ? node.Value : null;
            }
            foreach (XmlNode propertygroup in this.PropertyListXML.SelectNodes("PropertyList/PropertyGroup"))
            {                

                if (base.GetModuleParamXml("PropertyGroupURI") == null || base.GetModuleParamString("PropertyGroupURI") != string.Empty)
                {

                    if ((propertygroup.SelectNodes("Property/Network/Connection").Count > 0 && propertygroup.SelectNodes("Property[@CustomDisplay='false']").Count > 0) || propertygroup.SelectNodes("Property/CustomModule").Count > 0)
                    {
                        html.Append("<div class='PropertyGroup' tabindex=\"0\" style='cursor:pointer;' onkeypress=\"if (event.keyCode == 13) javascript:toggleBlock('propertygroup','" + propertygroup.SelectSingleNode("@URI").Value + "');\" onclick=\"javascript:toggleBlock('propertygroup','" + propertygroup.SelectSingleNode("@URI").Value + "');\"  role=\"region\"><br>");
                        html.Append("<img id=\"propertygroup" + propertygroup.SelectSingleNode("@URI").Value + "\" src='" + Root.Domain + "/Profile/Modules/PropertyList/images/minusSign.gif' alt='Collapse' style='border: none; text-decoration: none !important' border='0' width='9' height='9'/>&nbsp;"); //add image and onclick here.
                        html.Append("<input  type='hidden' id=\"imgon" + propertygroup.SelectSingleNode("@URI").Value + "\" value='" + Root.Domain + "/Profile/Modules/PropertyList/images/minusSign.gif' alt='Collapse' width='9'/>");
                        html.Append("<input type='hidden' id=\"imgoff" + propertygroup.SelectSingleNode("@URI").Value + "\" value='" + Root.Domain + "/Profile/Modules/PropertyList/images/plusSign.gif' alt='Expand' />");
                        
                        html.Append(propertygroup.SelectSingleNode("@Label").Value);
                        html.Append("&nbsp;<br></div>");
                        html.Append("<div class='PropertyGroupItem'  id='" + propertygroup.SelectSingleNode("@URI").Value + "'>");

                        foreach (XmlNode propertyitem in propertygroup.SelectNodes("Property"))
                        {
                            if (base.GetModuleParamXml("PropertyURI") == null || base.GetModuleParamString("PropertyURI") != string.Empty)
                            {
                                itembuffer = new System.Text.StringBuilder();
                                if (propertyitem.SelectSingleNode("@CustomDisplay").Value == "false")
                                {
                                    hasitems = false;

                                    itembuffer.Append("<input type='hidden' id=\"imgon" + propertyitem.SelectSingleNode("@URI").Value + "\" value='" + Root.Domain + "/Profile/Modules/PropertyList/images/minusSign.gif' alt='Collapse'  width='9' height='9'/>");
                                    itembuffer.Append("<input type='hidden' id=\"imgoff" + propertyitem.SelectSingleNode("@URI").Value + "\" value='" + Root.Domain + "/Profile/Modules/PropertyList/images/plusSign.gif' alt='Expand' />");
                                    itembuffer.Append("<div>");
                                    itembuffer.Append("<div class='PropertyItemHeader' style='cursor:pointer;' tabindex=\"0\" onkeypress=\"if (event.keyCode == 13)javascript:toggleBlock('propertyitem','" + propertyitem.SelectSingleNode("@URI").Value + "');\" onclick=\"javascript:toggleBlock('propertyitem','" + propertyitem.SelectSingleNode("@URI").Value + "');\" role=\"region\">");
                                    itembuffer.Append("<img id=\"propertyitem" + propertyitem.SelectSingleNode("@URI").Value + "\" src='" + Root.Domain + "/Profile/Modules/PropertyList/images/minusSign.gif' alt='Collapse'  border='0' width='9' height='9' />&nbsp;"); //add image and onclick here.
                                    itembuffer.Append(propertyitem.SelectSingleNode("@Label").Value);
                                    itembuffer.Append("</div>");
                                    itembuffer.Append("<div class='PropertyGroupData'>");
                                    itembuffer.Append("<div style='padding-top:6px;padding-right:6px;padding-left:6px' id='" + propertyitem.SelectSingleNode("@URI").Value + "'>");

                                    foreach (XmlNode connection in propertyitem.SelectNodes("Network/Connection"))
                                    {
                                        if (hasitems) itembuffer.Append("<br>");
                                        if (connection.SelectSingleNode("@ResourceURI") != null)
                                        {
                                            itembuffer.Append("<a href='");
                                            itembuffer.Append(connection.SelectSingleNode("@ResourceURI").Value);
                                            itembuffer.Append("'>");
                                            itembuffer.Append(connection.InnerText.Replace("\n", "<br/>"));
                                            itembuffer.Append("</a><br>");
                                            hasitems = true;

                                        }
                                        else
                                        {
                                            itembuffer.Append(connection.InnerText.Replace("\n","<br/>") + "<br>");
                                            hasitems = true;

                                        }
                                    }

                                    itembuffer.Append("</div></div></div>");

                                }
                                else if (propertyitem.SelectSingleNode("@CustomDisplay").Value == "true" && propertyitem.SelectNodes("CustomModule").Count > 0)
                                {
                                    itembuffer.Append("<input type='hidden' id=\"imgon" + propertyitem.SelectSingleNode("@URI").Value + "\" value='" + Root.Domain + "/Profile/Modules/PropertyList/images/minusSign.gif' alt='Collapse'  width='9' height='9' />");
                                    itembuffer.Append("<input type='hidden' id=\"imgoff" + propertyitem.SelectSingleNode("@URI").Value + "\" value='" + Root.Domain + "/Profile/Modules/PropertyList/images/plusSign.gif'alt='Expand'  />");
                                    itembuffer.Append("<div>");
                                    itembuffer.Append("<div class='PropertyItemHeader' style='cursor:pointer;' tabindex=\"0\" onkeypress=\"if (event.keyCode == 13) javascript:toggleBlock('propertyitem','" + propertyitem.SelectSingleNode("@URI").Value + "');\" onclick=\"javascript:toggleBlock('propertyitem','" + propertyitem.SelectSingleNode("@URI").Value + "');\" role=\"region\">");
                                    itembuffer.Append("<img id=\"propertyitem" + propertyitem.SelectSingleNode("@URI").Value + "\" src='" + Root.Domain + "/Profile/Modules/PropertyList/images/minusSign.gif' alt='Collapse' style='border: none; text-decoration: none !important' border='0' width='9' height='9' />&nbsp;"); //add image and onclick here.
                                    itembuffer.Append(propertyitem.SelectSingleNode("@Label").Value);
                                    itembuffer.Append("</div>");
                                    itembuffer.Append("<div class='PropertyGroupData'>");
                                    itembuffer.Append("<div id='" + propertyitem.SelectSingleNode("@URI").Value + "'>");
                                    
                                    foreach(XmlNode node in propertyitem.SelectNodes("CustomModule")){
                                        Framework.Utilities.ModulesProcessing mp = new ModulesProcessing();
                                        XmlDocument modules = new XmlDocument();
                                        modules.LoadXml(node.OuterXml);

                                        foreach (XmlNode module in modules)
                                        {
                                            this.Modules = mp.FetchModules(module);

                                            foreach (Module m in this.Modules)
                                            {
                                                if(m.css != null)
                                                {
                                                    System.Web.UI.HtmlControls.HtmlLink css = new System.Web.UI.HtmlControls.HtmlLink();
                                                    css.Href = m.css;
                                                    css.Attributes["rel"] = "stylesheet";
                                                    css.Attributes["type"] = "text/css";
                                                    css.Attributes["media"] = "all";
                                                    Page.Header.Controls.Add(css);
                                                }

                                            }
                                            this.Modules = null;
                                        }
                                        hasitems = true;
                                        itembuffer.Append(base.RenderCustomControl(node.OuterXml,base.BaseData));
                                    }

                                    itembuffer.Append("</div></div></div>");

                                }



                                if (hasitems)
                                {
                                    html.Append(itembuffer.ToString());

                                }

                            }

                        } //End of property item loop

                        html.Append("</div>");

                    }
                }


            }//End of property group loop

            litPropertyList.Text = html.ToString();

        }

       
        private List<Module> Modules { get; set; }
        private XmlDocument PropertyListXML { get; set; }

    }

}