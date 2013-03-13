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

namespace Profiles.Profile.Modules.ConceptConnection
{
	public partial class ConceptConnection : BaseModule
	{
		public ConceptConnection() : base()
		{ }

		public ConceptConnection(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager namespaces)
			: base(pagedata, moduleparams, namespaces)
        {
			// Querystring node id's
			Int64 qsNodeId;

			// Get subject node id
			if (Int64.TryParse(HttpContext.Current.Request.QueryString["subject"].ToString(), out qsNodeId))
				this.Subject.NodeId = qsNodeId;
			else
				throw new InvalidOperationException(String.Format("Expected Int64 NodeId, '{0}' was returned.", HttpContext.Current.Request.QueryString["subject"].ToString()));

			// Get object node id
			if (Int64.TryParse(HttpContext.Current.Request.QueryString["object"].ToString(), out qsNodeId))
				this.Object.NodeId = qsNodeId;
			else
				throw new InvalidOperationException(String.Format("Expected Int64 NodeId, '{0}' was returned.", HttpContext.Current.Request.QueryString["object"].ToString()));
        }
                
		protected void Page_Load(object sender, EventArgs e)
		{
			SetNameAndUri();
			SetConnectionData();
		}
		
		protected virtual void SetNameAndUri()
		{
			this.Subject.Name = 
				this.BaseData.SelectSingleNode("rdf:RDF/rdf:Description[@rdf:about=/rdf:RDF/rdf:Description[1]/rdf:subject/@rdf:resource]/foaf:firstName", this.Namespaces).InnerText + " " +
				this.BaseData.SelectSingleNode("//rdf:RDF/rdf:Description[@rdf:about=/rdf:RDF/rdf:Description[1]/rdf:subject/@rdf:resource]/foaf:lastName", this.Namespaces).InnerText;
			this.Subject.Uri = this.BaseData.SelectSingleNode(base.GetModuleParamString("SubjectURI"), this.Namespaces).InnerText;
			this.Object.Name = this.BaseData.SelectSingleNode(base.GetModuleParamString("ObjectName"), this.Namespaces).InnerText;
			this.Object.Uri = this.BaseData.SelectSingleNode(base.GetModuleParamString("ObjectURI"), this.Namespaces).InnerText;		
		}
		
		protected virtual void SetConnectionData()
		{
			var dataIO = new Profiles.Profile.Utilities.DataIO();
			this.ConnectionDetails = new List<Publication>();
			
			// Loop through reader and fill object
			using (var rdr = dataIO.GetProfileConnection(new RDFTriple(this.Subject.NodeId, 0, this.Object.NodeId), this.StoredProcedureName))
			{
				bool headerLoaded = false;
				while (rdr.Read())
				{
					// Data is denormalized.  Load header object once
					if (headerLoaded == false)
					{
						this.ConnectionStrength = double.Parse(rdr["TotalOverallWeight"].ToString());
					}

					this.ConnectionDetails.Add(new Publication
					{
						PMID = long.Parse(rdr["PMID"].ToString()),
						Description = rdr["Reference"].ToString(),
						Score = double.Parse(rdr["OverallWeight"].ToString())
					});

					headerLoaded = true;
				}
			}
		}

		protected virtual string StoredProcedureName
		{
			get
			{
				return "[Profile.Module].[ConnectionDetails.Person.HasResearchArea.GetData]";
			}
		}
		
		protected virtual List<Publication> ConnectionDetails { get; set; }

		private Single _Subject = new Single();
		protected Single Subject { get { return _Subject;}}
		
		private Single _Object = new Single();
		protected Single Object { get { return _Object; }}
		
		protected double ConnectionStrength { get; set; }

		protected class Single
		{
			public Int64 NodeId { get; set; }
			public string Name { get; set; }
			public string Uri { get; set; }
		}
		
		public class Publication
		{
			public Int64 PMID { get; set; }
			public string Description { get; set; }
			public double Score { get; set; }

		}
	}
}