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
using System.Linq;
using System.Xml.Linq;

using Profiles.Framework.Utilities;
using Profiles.Profile.Utilities;


namespace Profiles.Profile.Modules
{
	public partial class CustomViewConceptMeshInfo : BaseModule
	{
		protected void Page_Load(object sender, EventArgs e)
		{
			ConceptName = this.BaseData.SelectSingleNode("rdf:RDF[1]/rdf:Description[1]/rdfs:label[1]", this.Namespaces).InnerText;
			plusImage.Src = Root.Domain + "/Profile/Modules/PropertyList/images/minusSign.gif";
			DrawProfilesModule();
		}

		public CustomViewConceptMeshInfo() : base() { }
		public CustomViewConceptMeshInfo(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
			: base(pagedata, moduleparams, pagenamespaces)
		{
			base.RDFTriple = new RDFTriple(Convert.ToInt64(Request.QueryString["Subject"]));
		}

		public void DrawProfilesModule()
		{
			var dataIO = new Profiles.Profile.Utilities.DataIO();			
			
			// Get xml data
			XDocument xDoc = dataIO.GetConceptMeshInfo(base.RDFTriple);
			
			// Get nodes
			IEnumerable<XElement> conceptNodes = xDoc.Descendants("DescriptorRecord").Elements("ConceptList").Elements("Concept");									
			IEnumerable<XElement> treeNumberNodes = xDoc.Descendants("DescriptorRecord").Elements("TreeNumberList").Elements("TreeNumber");
			IEnumerable<XElement> generalConceptNodes = xDoc.Descendants("ParentDescriptors").Elements("Descriptor");
			IEnumerable<XElement> relatedConceptNodes = xDoc.Descendants("SiblingDescriptors").Elements("Descriptor");
			IEnumerable<XElement> specificConceptNodes = xDoc.Descendants("ChildDescriptors").Elements("Descriptor");
									
			// Definition tab			
			var definitionScopeNode = conceptNodes.Where(x=> x.Attribute("PreferredConceptYN").Value == "Y").Elements("ScopeNote").FirstOrDefault();
			litDefinition.Text = (definitionScopeNode != null) ? definitionScopeNode.Value : "No definition found.";

			// Details tab - DescriptorID
			litDescriptorId.Text = xDoc.Descendants("DescriptorRecord").Elements("DescriptorUI").FirstOrDefault().Value;
			
			// Details tab - MeSH Numbers
			foreach (XElement node in treeNumberNodes)
			{
				litMeshNumbers.Text += "<div>"+node.Value+"</div>";
			}

			// Details tab - Concept/Terms			
			foreach (XElement concept in conceptNodes)
			{
				string terms = "";
				foreach(XElement term in concept.Elements("TermList").Elements("Term").Select(x => x.Element("String")))
				{
					terms += String.Format("<li><span>{0}</span></li>", term.Value);
				}
				
				litConceptTerms.Text += String.Format(
					"<div><a href='javascript:void(0);'>{0}</a><ul style='display: none;'>{1}</ul></div>",
					concept.Elements("ConceptName").Elements("String").FirstOrDefault().Value,
					terms
				);
			}
			
			// More General Concepts tab
			DisableTabLink(generalConceptNodes, "generalConceptLink");
			foreach (XElement node in generalConceptNodes)
			{				
				var conceptName = node.Element("DescriptorName");
				var treeNumber = node.Element("TreeNumber");
				var nodeURI = node.Element("NodeURI");
				
				int paddingLeft = 0;
				int depth = Convert.ToInt32(node.Element("Depth").Value);
			
				if (depth > 1)
				{
					paddingLeft = 8 * depth;
				}
				
				if (paddingLeft == 0) // first item is not a link
				{
					litGeneralConcepts.Text += String.Format(
						"<li><span>{0} [{1}]</span></li>",
						(conceptName != null) ? conceptName.Value : "",
						(treeNumber != null) ? treeNumber.Value : ""
					);
				} 
				else 
				{
					litGeneralConcepts.Text += String.Format(
						"<li style='margin-left:{0}px;'><span><a href='{1}'>{2}</a> [{3}]</span></li>",
						paddingLeft.ToString(), // set indentation
						(nodeURI != null) ? nodeURI.Value : "",
						(conceptName.Value == this.ConceptName) ? "<b>"+conceptName.Value+"</b>" : conceptName.Value, // bold text if node concept is same as concept profile name												
						(treeNumber != null) ? treeNumber.Value : ""
					);
				}
			}

			// Related concept tabs
			DisableTabLink(relatedConceptNodes, "relatedConceptLink");
			foreach (XElement node in relatedConceptNodes)
			{
				var conceptName = node.Element("DescriptorName");
				var conceptUri = node.Element("NodeURI");
				int depth = Convert.ToInt32(node.Element("Depth").Value);
				int paddingLeft = (depth > 1) ? 8 * depth : 0;
				
				litRelatedConcepts.Text += String.Format(
					"<li style='margin-left:{0}px;'><span><a href='{1}'>{2}</a></span></li>",
					paddingLeft.ToString(), // set indentation
					(conceptUri != null) ? conceptUri.Value : "",
					(conceptName.Value == this.ConceptName) ? "<b>" + conceptName.Value + "</b>" : conceptName.Value // bold text if node concept is same as concept profile name																		
				);				
			}

			// Specific concept tabs
			DisableTabLink(specificConceptNodes, "specificConceptLink");
			foreach (XElement node in specificConceptNodes)
			{
				var conceptName = node.Element("DescriptorName");
				var nodeURI = node.Element("NodeURI");				
				int depth = Convert.ToInt32(node.Element("Depth").Value);
				int paddingLeft = (depth > 1) ? 8 * depth : 0;

				if (paddingLeft == 0) // first item is not a link
				{
					litSpecificConcepts.Text += String.Format(
						"<li><span>{0}</span></li>",
						(conceptName != null) ? conceptName.Value : ""
					);
				}
				else
				{
					
					litSpecificConcepts.Text += String.Format(
						"<li style='margin-left:{0}px;'><span><a href='{1}'>{2}</a></span></li>",
						paddingLeft.ToString(), // set indentation
						(nodeURI != null) ? nodeURI.Value : "",
						(conceptName.Value == this.ConceptName) ? "<b>" + conceptName.Value + "</b>" : conceptName.Value // bold text if node concept is same as concept profile name											
						
					);
				}
			}			
		}
		
		/// <summary>
		/// Disables tab links if no node data
		/// </summary>
		/// <param name="nodes"></param>
		/// <param name="linkID"></param>
		private void DisableTabLink(IEnumerable<XElement> nodes, string linkID)
		{
			if (nodes.Count() == 0)
				((System.Web.UI.HtmlControls.HtmlAnchor)this.FindControl(linkID)).Attributes.Add("class", "disabled");
		}
		
		private void DisableTabLink(XElement node, string linkID)
		{
			if (node == null)
				((System.Web.UI.HtmlControls.HtmlAnchor)this.FindControl(linkID)).Attributes.Add("class", "disabled");
		}
		
		public string ConceptName { get; set; }
	}
}