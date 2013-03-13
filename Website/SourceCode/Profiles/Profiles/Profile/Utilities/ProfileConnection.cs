using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Profiles.Framework.Utilities;
using System.Xml;

namespace Profiles.Profile.Utilities
{
	public interface IProfileConnection
	{
		SinglePredicate Subject { get; set; }
		SinglePredicate Object { get; set; }
		double ConnectionStrength { get; set; }
	}
	
	public class ConceptConnect : ProfileConnect
	{
		public ConceptConnect(SinglePredicate subject_predicate, SinglePredicate object_predicate)
			: base(subject_predicate, object_predicate)
		{}
		
		public override IProfileConnection GetConnection()
		{
			var dataIO = new DataIO();

			// Loop through reader and fill object
			using (var rdr = dataIO.GetProfileConnection(new RDFTriple(this.Subject.NodeId, 0, this.Object.NodeId), this.StoredProcedure))
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
			
			return this;
		}
		
		protected override string StoredProcedure
		{
			get { return "[Profile.Module].[ConnectionDetails.Person.HasResearchArea.GetData]"; }
		}

		private List<Publication> _ConnectionDetails = new List<Publication>();
		public new List<Publication> ConnectionDetails {get { return _ConnectionDetails;}}

		public class Publication
		{
			public Int64 PMID { get; set; }
			public string Description { get; set; }
			public double Score { get; set; }
		}
	}
	
	public class CoAuthorConnect : ConceptConnect
	{
		public CoAuthorConnect(SinglePredicate subject_predicate, SinglePredicate object_predicate)
			: base(subject_predicate, object_predicate)
		{}
		
		protected override string StoredProcedure
		{
			get { return "[Profile.Module].[ConnectionDetails.Person.CoAuthorOf.GetData]"; }
		}
	}
	
	public class SimilarConnect : ProfileConnect
	{
		public SimilarConnect(SinglePredicate subject_predicate, SinglePredicate object_predicate)
			: base(subject_predicate, object_predicate)
		{}
		
		public override IProfileConnection GetConnection()
		{
			var dataIO = new DataIO();

			// Loop through reader and fill object
			using (var rdr = dataIO.GetProfileConnection(new RDFTriple(this.Subject.NodeId, 0, this.Object.NodeId), this.StoredProcedure))
			{
				bool headerLoaded = false;
				while (rdr.Read())
				{
					// Data is denormalized.  Load header object once
					if (headerLoaded == false)
					{
						this.ConnectionStrength = double.Parse(rdr["TotalOverallWeight"].ToString());
					}

					SimilarConcept concept = new SimilarConcept
					{
						MeshTerm = rdr["MeshHeader"].ToString(),
						OverallWeight = double.Parse(rdr["OverallWeight"].ToString()),
						ConceptProfile = rdr["ObjectURI"].ToString()
					};

					concept.Subject.KeywordWeight = double.Parse(rdr["KeywordWeight1"].ToString());
					concept.Subject.ConceptConnectionURI = rdr["ConnectionURI1"].ToString();
					concept.Object.KeywordWeight = double.Parse(rdr["KeywordWeight2"].ToString());
					concept.Object.ConceptConnectionURI = rdr["ConnectionURI2"].ToString();

					this.ConnectionDetails.Add(concept);

					headerLoaded = true;
				}
			}

			return this;
		}
		
		protected override string StoredProcedure
		{
			get { return "[Profile.Module].[ConnectionDetails.Person.SimilarTo.GetData]"; }
		}

		private List<SimilarConcept> _ConnectionDetails = new List<SimilarConcept>();
		public new List<SimilarConcept> ConnectionDetails { get { return _ConnectionDetails; } }

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
	
	public abstract class ProfileConnect : IProfileConnection
	{
		public ProfileConnect(SinglePredicate subject_predicate, SinglePredicate object_predicate)
		{
			// nodeid, name and uri all required
			if ((subject_predicate.NodeId>0)==false || subject_predicate.Name.IsNullOrEmpty() || subject_predicate.Uri.IsNullOrEmpty())
				throw new ArgumentException("Subject predicate NodeId, Name and Uri required.");

			if ((object_predicate.NodeId > 0) == false || object_predicate.Name.IsNullOrEmpty() || object_predicate.Uri.IsNullOrEmpty())
				throw new ArgumentException("Object predicate NodeId, Name and Uri required.");
				
			Subject = subject_predicate;
			Object = object_predicate;	
		}		
				
		public abstract IProfileConnection GetConnection();
		
		protected abstract string StoredProcedure { get; }
		public SinglePredicate Subject { get; set; }
		public SinglePredicate Object { get; set; }
		public double ConnectionStrength { get; set; }
		public virtual List<object> ConnectionDetails { get; set; }				
	}

	public class SinglePredicate
	{
		public Int64 NodeId { get; set; }
		public string Name { get; set; }
		public string Uri { get; set; }
	}
}
