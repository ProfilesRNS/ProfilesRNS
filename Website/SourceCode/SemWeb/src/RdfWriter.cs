using System;
using System.IO;

using SemWeb.IO;

namespace SemWeb {
	public abstract class RdfWriter : IDisposable, StatementSink {
		string baseuri;
		bool closed;
		
		public abstract NamespaceManager Namespaces { get; set; }
		
		public string BaseUri {
			get {
				return baseuri;
			}
			set {
				baseuri = value;
			}
		}

		protected object GetResourceKey(Resource resource) {
			return resource.GetResourceKey(this);
		}

		protected void SetResourceKey(Resource resource, object value) {
			resource.SetResourceKey(this, value);
		}
		
		internal static TextWriter GetWriter(string dest) {
			if (dest == "-")
				return Console.Out;
			return new StreamWriter(dest);
		}
		
		bool StatementSink.Add(Statement statement) {
			Add(statement);
			return true;
		}
		
		public abstract void Add(Statement statement);

		public virtual void Close() {
			if (closed) return;
			closed = true;
		}
		
		public virtual void Write(StatementSource source) {
			source.Select(this);
		}
		
		void IDisposable.Dispose() {
			Close();
		}
		
		public static RdfWriter Create(string type, TextWriter output) {
			switch (RdfReader.NormalizeMimeType(type)) {
				case "xml":
					#if !SILVERLIGHT
						return new RdfXmlWriter(output);
					#else
						throw new NotSupportedException("RDF/XML output is not supported by the Silverlight build of the SemWeb library.");
					#endif
				case "n3":
					#if DOTNET2
					return new N3Writer(output);
					#endif
				case "turtle":
                    return new TurtleWriter(output);
				case "nt":
				case "ntriples":
					return new NTriplesWriter(output);
				case "dot":
					return new GraphVizWriter(output);
				default:
					throw new ArgumentException("Unknown parser or MIME type: " + type);
			}
		}

		public static RdfWriter Create(string type, string file) {
			switch (RdfReader.NormalizeMimeType(type)) {
				case "xml":
					#if !SILVERLIGHT
						return new RdfXmlWriter(file);
					#else
						throw new NotSupportedException("RDF/XML output is not supported by the Silverlight build of the SemWeb library.");
					#endif
				case "n3":
					#if DOTNET2
					return new N3Writer(file);
					#endif
				case "turtle":
                    return new TurtleWriter(file);
				case "nt":
				case "ntriples":
					return new NTriplesWriter(file);
				case "dot":
					return new GraphVizWriter(file);
				default:
					throw new ArgumentException("Unknown parser or MIME type: " + type);
			}
		}
	}
	
	public interface CanForgetBNodes {
		void ForgetBNode(BNode bnode);
	}
}