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


namespace Profiles.Profile.Modules.SimilarConnection
{
    public partial class SimilarConnection : Profiles.Profile.Modules.ConceptConnection.ConceptConnection
    {
        public SimilarConnection()
        { }

        public SimilarConnection(XmlDocument data, List<ModuleParams> moduleparams, XmlNamespaceManager namespaces)
            : base(data, moduleparams, namespaces)
        { }

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

        protected override void SetConnectionData()
        {
            var dataIO = new Profiles.Profile.Utilities.DataIO();

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

                    SimilarConcept sim = new SimilarConcept
                    {
                        MeshTerm = rdr["MeshHeader"].ToString(),
                        OverallWeight = double.Parse(rdr["OverallWeight"].ToString()),
                        ConceptProfile = rdr["ObjectURI"].ToString()
                    };

                    sim.Subject.KeywordWeight = double.Parse(rdr["KeywordWeight1"].ToString());
                    sim.Subject.ConceptConnectionURI = rdr["ConnectionURI1"].ToString();
                    sim.Object.KeywordWeight = double.Parse(rdr["KeywordWeight2"].ToString());
                    sim.Object.ConceptConnectionURI = rdr["ConnectionURI2"].ToString();

                    this.ConnectionDetails.Add(sim);

                    headerLoaded = true;
                }
                rdr.Close();
            }
        }

        protected override string StoredProcedureName
        {
            get
            {
                return "[Profile.Module].[ConnectionDetails.Person.SimilarTo.GetData]";
            }
        }

        private List<SimilarConcept> _ConnectionDetails = new List<SimilarConcept>();
        protected new List<SimilarConcept> ConnectionDetails { get { return _ConnectionDetails; } }

        public class SimilarConcept
        {
            public SimilarConcept()
            {
                Subject = new Person();
                Object = new Person();
            }

            public string MeshTerm { get; set; }
            public Person Subject { get; set; }
            public Person Object { get; set; }
            public double OverallWeight { get; set; }
            public string ConceptProfile { get; set; }

            public class Person
            {
                public double KeywordWeight { get; set; }
                public string ConceptConnectionURI { get; set; }
            }
        }


    }
}