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
using System.Xml.Xsl;
using Profiles.Framework.Utilities;
using Profiles.Profile.Utilities;

namespace Profiles.Profile.Modules.CoAuthorConnection
{
	public partial class CoAuthorConnection : Profiles.Profile.Modules.ConceptConnection.ConceptConnection
	{
		public CoAuthorConnection()
			: base()
		{}

		public CoAuthorConnection(XmlDocument data, List<ModuleParams> moduleparams, XmlNamespaceManager namespaces)
            : base(data, moduleparams, namespaces)
        {}
        
		protected void Page_Load(object sender, EventArgs e)
		{
			SetNameAndUri();
			SetConnectionData();
		}

		protected override void SetNameAndUri()
		{
			this.Subject.Name =
				this.BaseData.SelectSingleNode("rdf:RDF/rdf:Description[@rdf:about=/rdf:RDF/rdf:Description[1]/rdf:subject/@rdf:resource]/foaf:firstName", this.Namespaces).InnerText + " " +
				this.BaseData.SelectSingleNode("//rdf:RDF/rdf:Description[@rdf:about=/rdf:RDF/rdf:Description[1]/rdf:subject/@rdf:resource]/foaf:lastName", this.Namespaces).InnerText;
			this.Subject.Uri = this.BaseData.SelectSingleNode(base.GetModuleParamString("SubjectURI"), this.Namespaces).InnerText;
			this.Object.Name =
				this.BaseData.SelectSingleNode("//rdf:RDF/rdf:Description[@rdf:about=/rdf:RDF/rdf:Description[1]/rdf:object/@rdf:resource]/foaf:firstName", this.Namespaces).InnerText + " " +
				this.BaseData.SelectSingleNode("//rdf:RDF/rdf:Description[@rdf:about=/rdf:RDF/rdf:Description[1]/rdf:object/@rdf:resource]/foaf:lastName", this.Namespaces).InnerText;
			this.Object.Uri = this.BaseData.SelectSingleNode(base.GetModuleParamString("ObjectURI"), this.Namespaces).InnerText;	
		}
		protected override string StoredProcedureName
		{
			get
			{
				return "[Profile.Module].[ConnectionDetails.Person.CoAuthorOf.GetData]";
			}
		}
		
	}
}