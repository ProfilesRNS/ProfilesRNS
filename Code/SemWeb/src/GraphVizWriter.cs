using System;
using System.Collections;
#if DOTNET2
using System.Collections.Generic;
#endif
using System.IO;
using System.Text;

using SemWeb;

namespace SemWeb.IO {
	public class GraphVizWriter : RdfWriter {
		TextWriter writer;
		NamespaceManager ns = new NamespaceManager();
		bool closed = false;
		bool closeStream = false;
		
		int nodeCounter = 0;
		
		#if !DOTNET2
		Hashtable entityIds = new Hashtable();
		#else
		Dictionary<Entity,int> entityIds = new Dictionary<Entity,int>();
		#endif
		
		string shapeLiteral = "ellipse";
		string shapeVariable = "circle";
		string shapeBNode = "trapezium";
		string shapeEntity = "box3d";
		
		public GraphVizWriter(string file) : this(GetWriter(file)) { closeStream = true; }

		public GraphVizWriter(TextWriter writer) {
			this.writer = writer;
			writer.WriteLine("digraph G {");
		}
		
		public override NamespaceManager Namespaces { get { return ns; } set { ns = value; } }
		
		public override void Add(Statement statement) {
			if (statement.AnyNull) throw new ArgumentNullException();
			
			//if (statement.Object is Literal) // hmm
			//	return;
			if (statement.Predicate == NS.RDF + "type")
				return;

			int sbj = Entity(statement.Subject);
			int obj = statement.Object is Entity ? Entity((Entity)statement.Object) : Literal((Literal)statement.Object);
			
			string predicateshape, predicatetext;
			GetEntityInfo(statement.Predicate, -1, out predicateshape, out predicatetext);
			
			writer.WriteLine("\tn" +  sbj + " -> n" + obj + " [label=\"" + Escape(predicatetext, 30) + "\"]");
		}

		public override void Close() {
			base.Close();
			if (closed) return;
			writer.WriteLine("}");
			closed = true;
			if (closeStream)
				writer.Close();
			else
				writer.Flush();
		}
		
		private string Escape(string str, int truncate) {
			if (str.Length > truncate)
				str = str.Substring(0, truncate-3) + "...";
			return str.Replace("\"", "''");
		}

		private int Literal(Literal literal) {
			writer.WriteLine("\tn" + nodeCounter + " [label=\"\\\"" + Escape(literal.Value, 15) + "\\\"\" shape=" + shapeLiteral + "]");
			return nodeCounter++;
		}
		
		private int Entity(Entity entity) {
			int id;
			bool isNew;
			if (entityIds.ContainsKey(entity)) {
				id = (int)entityIds[entity];
				isNew = false;
			} else {
				id = nodeCounter++;
				entityIds[entity] = id;
				isNew = true;
			}
			
			string shape, text;
			GetEntityInfo(entity, id, out shape, out text);
			
			if (isNew) {
				writer.WriteLine("\tn" + id + " [label=\"" + Escape(text, 30) + "\" shape=" + shape + "]");
			}
			
			return id;
		}

		void GetEntityInfo(Entity entity, int id, out string shape, out string text) {
			if (entity is Variable && ((Variable)entity).LocalName != null) {
				text = "?" + ((Variable)entity).LocalName;
				shape = shapeVariable;
			} else if (entity is BNode && ((BNode)entity).LocalName != null) {
				text = ((BNode)entity).LocalName;
				shape = shapeBNode;
			} else if (entity is BNode) {
				if (id != -1)
					text = "bnode:" + id;
				else
					text = "bnode";
				shape = shapeBNode;
			} else {
				shape = shapeEntity;
				text = ns.Normalize(entity.Uri);
				if (text[0] == '<') { // no namespace prefix available
					string effectiveBaseUri = BaseUri == null ? "#" : BaseUri;
					if (effectiveBaseUri != null && entity.Uri.StartsWith(effectiveBaseUri)) {
						text = entity.Uri.Substring(effectiveBaseUri.Length);
					}
				}
			}
		}
	
	}
}
