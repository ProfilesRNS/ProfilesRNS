using System;
using System.Collections;
using System.IO;

using SemWeb;
using SemWeb.Stores;

using name.levering.ryan.sparql.parser;
using name.levering.ryan.sparql.parser.model;
using name.levering.ryan.sparql.model;
using name.levering.ryan.sparql.model.data;
using name.levering.ryan.sparql.common;
using name.levering.ryan.sparql.common.impl;
using name.levering.ryan.sparql.logic.expression;
using name.levering.ryan.sparql.logic.function;

using SemWebVariable = SemWeb.Variable;
using SparqlVariable = name.levering.ryan.sparql.common.Variable;
using ExpressionLogic = name.levering.ryan.sparql.model.logic.ExpressionLogic;

#if !DOTNET2
using VariableList = System.Collections.ArrayList;
using VarKnownValuesType = System.Collections.Hashtable;
using VarKnownValuesList = System.Collections.ArrayList;
using LitFilterList = System.Collections.ArrayList;
using LitFilterMap = System.Collections.Hashtable;
#else
using VariableList = System.Collections.Generic.List<SemWeb.Variable>;
using VarKnownValuesType = System.Collections.Generic.Dictionary<SemWeb.Variable,System.Collections.Generic.ICollection<SemWeb.Resource>>;
using VarKnownValuesList = System.Collections.Generic.List<SemWeb.Resource>;
using LitFilterList = System.Collections.Generic.List<SemWeb.LiteralFilter>;
using LitFilterMap = System.Collections.Generic.Dictionary<SemWeb.Variable,System.Collections.Generic.ICollection<SemWeb.LiteralFilter>>;
#endif

namespace SemWeb.Query {

	public class SparqlEngine : SemWeb.Query.Query {
		static bool DisableQuery = System.Environment.GetEnvironmentVariable("SEMWEB_DISABLE_QUERY") != null;
	
		private const string BNodePersistUri = "tag:taubz.for.net,2005:bnode_persist_uri/";

		string queryString;
		name.levering.ryan.sparql.parser.model.QueryNode query;
		ArrayList extFunctions = new ArrayList();
		
		public bool AllowPersistBNodes = false;
		
		string preferredMimeType = null;
		
		public enum QueryType {
			Ask,
			Construct,
			Describe,
			Select
		}
		
		/* CONSTRUCTORS */
		
		public SparqlEngine(TextReader query)
			: this(query.ReadToEnd()) {
		}
	
		public SparqlEngine(string query) {
			queryString = query;
			
			if (queryString.Trim().Length == 0)
				throw new QueryFormatException("SPARQL syntax error: Empty query.");
			
			try {
				this.query = (name.levering.ryan.sparql.parser.model.QueryNode)SPARQLParser.parse(new java.io.StringReader(query));
				if (this.query is SelectQuery) {
					SelectQuery sq = (SelectQuery)this.query;
					ReturnLimit = sq.getLimit();
					ReturnStart = sq.getOffset();
				}
			} catch (TokenMgrError e) {
				throw new QueryFormatException("SPARQL syntax error at: " + e.Message);
			} catch (ParseException e) {
				throw new QueryFormatException("SPARQL syntax error: " + e.getMessage());
			} catch (java.util.EmptyStackException e) {
				throw new QueryFormatException("SPARQL syntax error: Unknown error. (java.util.EmptyStackException)");
			}
			
			extFunctions.Add(new TestFunction());
			extFunctions.Add(new LCFunction());
			extFunctions.Add(new UCFunction());
		}
		
		/* QUERY TYPE AND OUTPUT CONTROL PROPERTIES */
		
		public QueryType Type {
			get {
				if (query is AskQuery)
					return QueryType.Ask;
				if (query is ConstructQuery)
					return QueryType.Construct;
				if (query is DescribeQuery)
					return QueryType.Describe;
				if (query is SelectQuery)
					return QueryType.Select;
				throw new NotSupportedException("Query is of an unsupported type.");
			}
		}
		
		public override string MimeType {
			get {
				if (preferredMimeType == null) {
					if (query is AskQuery)
						return SparqlXmlQuerySink.MimeType;
					if (query is ConstructQuery)
						return "application/rdf+xml";
					if (query is DescribeQuery)
						return "application/rdf+xml";
					if (query is SelectQuery)
						return SparqlXmlQuerySink.MimeType;
					throw new NotSupportedException("Query is of an unsupported type.");
				} else {
					return preferredMimeType;
				}
			}
			set {
				if (query is AskQuery && value != SparqlXmlQuerySink.MimeType && value != "text/xml" && value != "text/plain")
					throw new NotSupportedException("That MIME type is not supported for ASK queries.");
				if (query is SelectQuery && value != SparqlXmlQuerySink.MimeType && value != "text/xml" && value != "text/html" && value != "text/csv")
					throw new NotSupportedException("That MIME type is not supported for SPARQL queries.");
				
				if (query is ConstructQuery || query is DescribeQuery) {
					// this throws if we don't recognize the type
					RdfWriter.Create(value, TextWriter.Null);
				}
				
				preferredMimeType = value;
			}
		}
		
		/* QUERY EXECUTION CONTROL METHODS */
		
		public void AddExternalFunction(RdfFunction function) {
			extFunctions.Add(function);
		}
		
		public override string GetExplanation() {
			return query.ToString();
		}
		
		public string[] GetDefaultDatasets() {
			ArrayList ret = new ArrayList();
			java.util.Collection c = query.getDefaultDatasets();

			object[] c2 = c.toArray();
			for (int i = 0; i < c2.Length; i++) {
				name.levering.ryan.sparql.common.URI uri = (name.levering.ryan.sparql.common.URI)c2.GetValue(i);
				ret.Add(uri.getURI());
			}
			return (string[])ret.ToArray(typeof(string));
		}
        
		public string[] GetNamedDatasets() {
			ArrayList ret = new ArrayList();
			java.util.Collection c = query.getNamedDatasets();

			object[] c2 = c.toArray();
			for (int i = 0; i < c2.Length; i++) {
				name.levering.ryan.sparql.common.URI uri = (name.levering.ryan.sparql.common.URI)c2.GetValue(i);
				ret.Add(uri.getURI());
			}
			return (string[])ret.ToArray(typeof(string));
		}

      /* QUERY EXECUTION METHODS */
	
		public override void Run(SelectableSource source, TextWriter output) {
			if (query is AskQuery)
				Ask(source, output);
			else if (query is ConstructQuery)
				Construct(source, output);
			else if (query is DescribeQuery)
				Describe(source, output);
			else if (query is SelectQuery)
				Select(source, output);
			else
				throw new NotSupportedException("Query is of an unsupported type.");
		}
	
		public bool Ask(SelectableSource source) {
			if (!(query is AskQuery))
				throw new InvalidOperationException("Only ASK queries are supported by this method (" + query.GetType() + ").");
			AskQuery q = (AskQuery)query;
			RdfSourceWrapper sourcewrapper = BindLogic(source);
			try {
				return q.execute(sourcewrapper);
			} catch (name.levering.ryan.sparql.common.QueryException e) {
				throw new QueryExecutionException("Error executing query: " + e.Message, e);
			}
		}
		
		public void Ask(SelectableSource source, TextWriter output) {
			bool result = Ask(source);
			if (MimeType == SparqlXmlQuerySink.MimeType || MimeType == "text/xml") {
				System.Xml.XmlTextWriter w = new System.Xml.XmlTextWriter(output);
				w.Formatting = System.Xml.Formatting.Indented;
				w.WriteStartElement("sparql");
				w.WriteAttributeString("xmlns", "http://www.w3.org/2001/sw/DataAccess/rf1/result");
				w.WriteStartElement("head");
				w.WriteEndElement();
				w.WriteStartElement("boolean");
				w.WriteString(result ? "true" : "false");
				w.WriteEndElement();
				w.WriteEndElement();
				w.Flush();
			} else if (MimeType == "text/plain") {
				output.WriteLine(result ? "true" : "false");
			} else {
			}
		}
	
		public void Construct(SelectableSource source, StatementSink sink) {
			if (!(query is ConstructQuery))
				throw new InvalidOperationException("Only CONSTRUCT queries are supported by this method (" + query.GetType() + ").");
			ConstructQuery q = (ConstructQuery)query;
			RdfSourceWrapper sourcewrapper = BindLogic(source);
			try {
				RdfGraph graph = q.execute(sourcewrapper);
				WriteGraph(graph, sourcewrapper, sink);
			} catch (name.levering.ryan.sparql.common.QueryException e) {
				throw new QueryExecutionException("Error executing query: " + e.Message, e);
			}
		}
		
		public NamespaceManager GetQueryPrefixes() {
			NamespaceManager ns = new NamespaceManager();
			java.util.Map prefixes = ((QueryData)query).getPrefixExpansions();
			for (java.util.Iterator i = prefixes.keySet().iterator(); i.hasNext(); ) {
				string prefix = (string)i.next();
				string uri = prefixes.get(prefix).ToString(); // surrounded in < >
				uri = uri.Substring(1, uri.Length-2); // not sure how to get this directly
				ns.AddNamespace(uri, prefix);
			}
			return ns;
		}
		
		void WriteGraph(RdfGraph graph, RdfSourceWrapper sourcewrapper, StatementSink sink) {
			if (sink is RdfWriter)
				((RdfWriter)sink).Namespaces.AddFrom(GetQueryPrefixes());
		
			java.util.Iterator iter = graph.iterator();
			while (iter.hasNext()) {
				GraphStatement stmt = (GraphStatement)iter.next();
				Statement s;
				if (stmt is GraphStatementWrapper) {
					s = ((GraphStatementWrapper)stmt).s;
				} else {
					s = new Statement(
						sourcewrapper.ToEntity(stmt.getSubject()),
						sourcewrapper.ToEntity(stmt.getPredicate()),
						sourcewrapper.ToResource(stmt.getObject()),
						stmt.getGraphName() == null ? Statement.DefaultMeta : sourcewrapper.ToEntity(stmt.getGraphName()));
				}
				
				if (s.AnyNull) continue; // unbound variable, or literal in bad position
				sink.Add(s);
			}
		}
		
		public void Construct(SelectableSource source, TextWriter output) {
			using (RdfWriter w = RdfWriter.Create(MimeType, output))
				Construct(source, w);
		}

		public void Describe(SelectableSource source, StatementSink sink) {
			if (!(query is DescribeQuery))
				throw new InvalidOperationException("Only DESCRIBE queries are supported by this method (" + query.GetType() + ").");
			DescribeQuery q = (DescribeQuery)query;
			RdfSourceWrapper sourcewrapper = BindLogic(source);
			try {
				RdfGraph graph = q.execute(sourcewrapper);
				WriteGraph(graph, sourcewrapper, sink);
			} catch (name.levering.ryan.sparql.common.QueryException e) {
				throw new QueryExecutionException("Error executing query: " + e.Message, e);
			}
		}

		public void Describe(SelectableSource source, TextWriter output) {
			using (RdfWriter w = RdfWriter.Create(MimeType, output))
				Describe(source, w);
		}

		public void Select(SelectableSource source, TextWriter output) {
			QueryResultSink sink;
			if (MimeType == SparqlXmlQuerySink.MimeType || MimeType == "text/xml")
				sink = new SparqlXmlQuerySink(output);
            //else if (MimeType == "text/html")
            //    sink = new HTMLQuerySink(output);
            //else if (MimeType == "text/csv")
            //    sink = new CSVQuerySink(output);
			else
				throw new InvalidOperationException("MIME type not supported.");
			Select(source, sink);
		}

		public void Select(SelectableSource source, QueryResultSink sink) {
			if (!(query is SelectQuery))
				throw new InvalidOperationException("Only SELECT queries are supported by this method (" + query.GetType() + ").");
			Run(source, sink);
		}

		public override void Run(SelectableSource source, QueryResultSink resultsink) {
			if (!(query is SelectQuery))
				throw new InvalidOperationException("Only SELECT queries are supported by this method (" + query.GetType() + ").");

			// Perform the query
			SelectQuery squery = (SelectQuery)query;
			RdfSourceWrapper sourcewrapper = BindLogic(source);

			RdfBindingSet results;
			try {
				results = squery.execute(sourcewrapper);
			} catch (name.levering.ryan.sparql.common.QueryException e) {
				throw new QueryExecutionException("Error executing query: " + e.Message, e);
			}
			
			// Prepare binding objects
			java.util.List vars = results.getVariables();
			SparqlVariable[] svars = new SparqlVariable[vars.size()];
			SemWebVariable[] vars2 = new SemWebVariable[vars.size()];
			for (int i = 0; i < svars.Length; i++) {
				svars[i] = (SparqlVariable)vars.get(i);
				vars2[i] = new SemWebVariable(svars[i].getName());
			}
			
			// Initialize the result sink
			resultsink.Init(vars2); // set distinct and ordered
			
			// Set the comments
			resultsink.AddComments(queryString + "\n");
			resultsink.AddComments(sourcewrapper.GetLog());

			// Iterate the bindings
			java.util.Iterator iter = results.iterator();
			long ctr = -1, ctr2 = 0;
			while (iter.hasNext()) {
				RdfBindingRow row = (RdfBindingRow)iter.next();

				// Since SPARQL processing may be lazy-delayed,
				// add any new comments that might have been logged.
				resultsink.AddComments(sourcewrapper.GetLog());

				ctr++;
			
				if (ctr < ReturnStart && ReturnStart != -1) continue;
				
				Resource[] bindings = new Resource[vars2.Length];

				for (int i = 0; i < bindings.Length; i++) {
					Resource r = sourcewrapper.ToResource(row.getValue(svars[i]));
					r = sourcewrapper.Persist(r);
					bindings[i] = r;
				}

				resultsink.AddComments(sourcewrapper.GetLog());
				
				resultsink.Add(new VariableBindings(vars2, bindings));

				ctr2++;
				if (ctr2 >= ReturnLimit && ReturnLimit != -1) break;
			}
			
			resultsink.AddComments(sourcewrapper.GetLog());
			
			// Close the result sink.
			resultsink.Finished();
		}
		
		/* INTERNAL METHODS TO CONTROL QUERY EXECUTION */
		
		private RdfSourceWrapper BindLogic(SelectableSource source) {
			RdfSourceWrapper sourcewrapper = new RdfSourceWrapper(source, this);
			
			MyLogicFactory logic = new MyLogicFactory();
			foreach (RdfFunction f in extFunctions)
				logic.registerExternalFunction(
					new URIWrapper(f.Uri),
					new ExtFuncWrapper(sourcewrapper, f));
			
			query.prepare(sourcewrapper, logic);
			
			return sourcewrapper;
		}
		
		class MyLogicFactory : name.levering.ryan.sparql.logic.StreamedLogic {
		    public override name.levering.ryan.sparql.model.logic.ConstraintLogic getGroupConstraintLogic(name.levering.ryan.sparql.model.data.GroupConstraintData data) {
        		return new RdfGroupLogic(data, new name.levering.ryan.sparql.logic.streamed.IndexedSetIntersectLogic());
    		}
		}
	
		class RdfSourceWrapper : AdvancedRdfSource,
				SPARQLValueFactory {
				
			public readonly SelectableSource source;
			Hashtable bnodes = new Hashtable();
			SparqlEngine sparql;
			
			System.Text.StringBuilder log = new System.Text.StringBuilder();
			
			public RdfSourceWrapper(SelectableSource source, SparqlEngine sparql) {
				this.source = source;
				this.sparql = sparql;
			}
			
			public void Log(string message) {
				log.Append(message);
				log.Append('\n');
			}
			
			public string GetLog() {
				string ret = log.ToString();
				log.Length = 0;
				return ret;
			}
		
			private java.util.Iterator GetIterator(Statement statement, int limit) {
				return GetIterator(statement.Subject == null ? null : new Entity[] { statement.Subject },
					statement.Predicate == null ? null : new Entity[] { statement.Predicate },
					statement.Object == null ? null : new Resource[] { statement.Object },
					statement.Meta == null ? null : new Entity[] { statement.Meta },
					null,
					limit);
			}
			
			private java.util.Iterator GetIterator(Statement statement, Entity[] metas, int limit) {
				return GetIterator(statement.Subject == null ? null : new Entity[] { statement.Subject },
					statement.Predicate == null ? null : new Entity[] { statement.Predicate },
					statement.Object == null ? null : new Resource[] { statement.Object },
					metas,
					null,
					limit);
			}

			private java.util.Iterator GetIterator(Entity[] subjects, Entity[] predicates, Resource[] objects, Entity[] metas, object[] litFilters, int limit) {
				if (subjects == null && predicates == null && objects == null && limit == -1)
					throw new QueryExecutionException("Query would select all statements in the store!");
				
				if (subjects != null) Depersist(subjects);
				if (predicates != null) Depersist(predicates);
				if (objects != null) Depersist(objects);
				if (metas != null) Depersist(metas);
				
				if (subjects != null && subjects.Length == 0) return new EmptyIterator();
				if (predicates != null && predicates.Length == 0) return new EmptyIterator();
				if (objects != null && objects.Length == 0) return new EmptyIterator();
				if (metas != null && metas.Length == 0) return new EmptyIterator();
				
				SelectFilter filter = new SelectFilter(subjects, predicates, objects, metas);
				if (litFilters != null) {
					filter.LiteralFilters = new LiteralFilter[litFilters.Length];
					for (int i = 0; i < litFilters.Length; i++)
						filter.LiteralFilters[i] = (LiteralFilter)litFilters[i];
				}
				if (limit == 0)
					filter.Limit = 1;
				else if (limit > 0)
					filter.Limit = limit;
					
				return new StatementIterator(source, filter, this);
			}
			
			/**
			 * Gets all statements with a specific subject, predicate and/or object in
			 * the default graph of the repository. All three parameters may be null to
			 * indicate wildcards. This is only used in SPARQL queries when no graph
			 * names are indicated.
			 * 
			 * @param subj subject of pattern
			 * @param pred predicate of pattern
			 * @param obj object of pattern
			 * @return iterator over statements
			 */
     		public java.util.Iterator getDefaultGraphStatements (name.levering.ryan.sparql.common.Value subject, name.levering.ryan.sparql.common.URI predicate, name.levering.ryan.sparql.common.Value @object) {
				return GetIterator( new Statement(ToEntity(subject), ToEntity(predicate), ToResource(@object), Statement.DefaultMeta), -1 );
			}

     		public java.util.Iterator getDefaultGraphStatements (name.levering.ryan.sparql.common.Value[] subject, name.levering.ryan.sparql.common.Value[] predicate, name.levering.ryan.sparql.common.Value[] @object, object[] litFilters, int limit) {
				return GetIterator( ToEntities(subject), ToEntities(predicate), ToResources(@object), new Entity[] { Statement.DefaultMeta }, litFilters, limit );
     		}
			
			/**
			 * Gets all statements with a specific subject, predicate and/or object in
			 * a named graph of the repository. All three parameters may be null to
			 * indicate wildcards. This is only used in SPARQL queries when no graph
			 * names are indicated.
			 * 
			 * @param subj subject of pattern
			 * @param pred predicate of pattern
			 * @param obj object of pattern
			 * @return iterator over statements
			 */
     		public java.util.Iterator getNamedGraphStatements (name.levering.ryan.sparql.common.Value subject, name.levering.ryan.sparql.common.URI predicate, name.levering.ryan.sparql.common.Value @object) {
				return GetIterator( new Statement(ToEntity(subject), ToEntity(predicate), ToResource(@object), null), -1 );
			}

     		public java.util.Iterator getNamedGraphStatements (name.levering.ryan.sparql.common.Value[] subject, name.levering.ryan.sparql.common.Value[] predicate, name.levering.ryan.sparql.common.Value[] @object, object[] litFilters, int limit) {
				return GetIterator( ToEntities(subject), ToEntities(predicate), ToResources(@object), null, litFilters, limit );
     		}
     		
			/**
			 * Gets all statements with a specific subject, predicate and/or object, within
			 * a certain set of graphs. The graphs might be from FROM or FROM NAMED clauses.
			 * subj, pred, and obj, and graph may be null. If graph is null, both FROM and
			 * FROM NAMED graphs may match.
			 * 
			 * @param subj subject of pattern
			 * @param pred predicate of pattern
			 * @param obj object of pattern
			 * @param graph the context with which to match the statements against
			 * @return iterator over statements
			 */
     		public java.util.Iterator getStatements (name.levering.ryan.sparql.common.Value subject, name.levering.ryan.sparql.common.URI predicate, name.levering.ryan.sparql.common.Value @object, name.levering.ryan.sparql.common.URI[] graphs) {
				return GetIterator( new Statement(ToEntity(subject), ToEntity(predicate), ToResource(@object)), ToEntities(graphs), -1 );
			}
			
     		public java.util.Iterator getStatements (name.levering.ryan.sparql.common.Value[] subject, name.levering.ryan.sparql.common.Value[] predicate, name.levering.ryan.sparql.common.Value[] @object, name.levering.ryan.sparql.common.URI[] graphs, object[] litFilters, int limit) {
				return GetIterator( ToEntities(subject), ToEntities(predicate), ToResources(@object), ToEntities(graphs), litFilters, limit );
     		}
     		
			public name.levering.ryan.sparql.common.SPARQLValueFactory getValueFactory() {
				return this;
			}
			
			private bool has(Statement statement) {
				bool ret = source.Contains(statement);
				Log("CONTAINS: " + statement + " ("  + ret + ")");
				return ret;
			}
			
			private bool has(Statement statement, Entity[] graphs) {
				foreach (Entity e in graphs) {
					statement.Meta = e;
					bool ret = source.Contains(statement);
					Log("CONTAINS: " + statement + " ("  + ret + ")");
					if (ret)
						return true;
				}
				return false;
			}

			public bool hasDefaultGraphStatement (name.levering.ryan.sparql.common.Value subject, name.levering.ryan.sparql.common.URI @predicate, name.levering.ryan.sparql.common.Value @object) {
				return has(new Statement(ToEntity(subject), ToEntity(predicate), ToResource(@object), Statement.DefaultMeta));
			}
			
			public bool hasNamedGraphStatement (name.levering.ryan.sparql.common.Value subject, name.levering.ryan.sparql.common.URI @predicate, name.levering.ryan.sparql.common.Value @object) {
				return has(new Statement(ToEntity(subject), ToEntity(predicate), ToResource(@object), null));
			}
	
			public bool hasStatement (name.levering.ryan.sparql.common.Value subject, name.levering.ryan.sparql.common.URI @predicate, name.levering.ryan.sparql.common.Value @object, name.levering.ryan.sparql.common.URI[] graphs) {
				return has(new Statement(ToEntity(subject), ToEntity(predicate), ToResource(@object)), ToEntities(graphs));
			}
			
			public Entity ToEntity(name.levering.ryan.sparql.common.Value ent) {
				if (ent == null) return null;
				if (ent is BNodeWrapper) return ((BNodeWrapper)ent).r;
				if (ent is URIWrapper) return ((URIWrapper)ent).r;
				if (ent is name.levering.ryan.sparql.common.BNode) {
					name.levering.ryan.sparql.common.BNode bnode = (name.levering.ryan.sparql.common.BNode)ent;
					Entity r = (Entity)bnodes[bnode.getID()];
					if (r == null) {
						r = new BNode();
						bnodes[bnode.getID()] = r;
					}
					return r;
				} else if (ent is name.levering.ryan.sparql.common.URI) {
					name.levering.ryan.sparql.common.URI uri = (name.levering.ryan.sparql.common.URI)ent;
					return new Entity(uri.getURI());
				} else {
					return null;
				}
			}
			
			public Resource ToResource(name.levering.ryan.sparql.common.Value value) {
				if (value == null) return null;
				if (value is LiteralWrapper) return ((LiteralWrapper)value).r;
				if (value is name.levering.ryan.sparql.common.Literal) {
					name.levering.ryan.sparql.common.Literal literal = (name.levering.ryan.sparql.common.Literal)value;
					return new Literal(literal.getLabel(), literal.getLanguage(), literal.getDatatype() == null ? null : literal.getDatatype().getURI());
				} else {
					return ToEntity(value);
				}
			}
			
			public Entity[] ToEntities(name.levering.ryan.sparql.common.Value[] ents) {
				if (ents == null) return null;
				ArrayList ret = new ArrayList();
				for (int i = 0; i < ents.Length; i++)
					if (!(ents[i] is name.levering.ryan.sparql.common.Literal))
						ret.Add( ToEntity(ents[i]) );
				return (Entity[])ret.ToArray(typeof(Entity));
			}
			public Resource[] ToResources(name.levering.ryan.sparql.common.Value[] ents) {
				if (ents == null) return null;
				Resource[] ret = new Resource[ents.Length];
				for (int i = 0; i < ents.Length; i++)
					ret[i] = ToResource(ents[i]);
				return ret;
			}
			public Resource[] ToResources(name.levering.ryan.sparql.model.logic.ExpressionLogic[] ents, name.levering.ryan.sparql.common.RdfBindingRow binding) {
				if (ents == null) return null;
				Resource[] ret = new Resource[ents.Length];
				for (int i = 0; i < ents.Length; i++) {
					if (ents[i] is SparqlVariable)
						ret[i] = ToResource(binding.getValue((SparqlVariable)ents[i]));
					else
						ret[i] = ToResource((name.levering.ryan.sparql.common.Value)ents[i]);
				}
				return ret;
			}
	
			public name.levering.ryan.sparql.common.Value createValue(name.levering.ryan.sparql.common.Value value) {
				if (value is BNodeWrapper) return value;
				if (value is LiteralWrapper) return value;
				if (value is URIWrapper) return value;
				return Wrap(ToResource(value));
			}
			public name.levering.ryan.sparql.common.BNode createBNode(name.levering.ryan.sparql.common.BNode value) {
				return (name.levering.ryan.sparql.common.BNode)createValue(value);
			}
			public name.levering.ryan.sparql.common.Literal createLiteral(name.levering.ryan.sparql.common.Literal value) {
				return (name.levering.ryan.sparql.common.Literal)createValue(value);
			}
			public name.levering.ryan.sparql.common.URI createURI(name.levering.ryan.sparql.common.URI value) {
				return (name.levering.ryan.sparql.common.URI)createValue(value);
			}
			
			public name.levering.ryan.sparql.common.BNode createBNode() {
				return new BNodeWrapper(new BNode());
			}
			public name.levering.ryan.sparql.common.BNode createBNode(string id) {
				return new BNodeWrapper(new BNode(id));
			}
			public name.levering.ryan.sparql.common.Literal createLiteral(string value, string lang) {
				return new LiteralWrapper(new Literal(value, lang, null));
			}
			public name.levering.ryan.sparql.common.Literal createLiteral(string value, name.levering.ryan.sparql.common.URI datatype) {
				return new LiteralWrapper(new Literal(value, null, datatype.getURI()));
			}
			public name.levering.ryan.sparql.common.Literal createLiteral(string value) {
				return new LiteralWrapper(new Literal(value));
			}
			public name.levering.ryan.sparql.common.Literal createLiteral(float value) {
				return new LiteralWrapper(Literal.FromValue(value));
			}
			public name.levering.ryan.sparql.common.Literal createLiteral(double value) {
				return new LiteralWrapper(Literal.FromValue(value));
			}
			public name.levering.ryan.sparql.common.Literal createLiteral(byte value) {
				return new LiteralWrapper(Literal.FromValue(value));
			}
			public name.levering.ryan.sparql.common.Literal createLiteral(short value) {
				return new LiteralWrapper(Literal.FromValue(value));
			}
			public name.levering.ryan.sparql.common.Literal createLiteral(int value) {
				return new LiteralWrapper(Literal.FromValue(value));
			}
			public name.levering.ryan.sparql.common.Literal createLiteral(long value) {
				return new LiteralWrapper(Literal.FromValue(value));
			}
			public name.levering.ryan.sparql.common.Literal createLiteral(bool value) {
				return new LiteralWrapper(Literal.FromValue(value));
			}
			public name.levering.ryan.sparql.common.URI createURI(string ns, string ln) {
				return createURI(ns + ln);
			}
			public name.levering.ryan.sparql.common.URI createURI(string uri) {
				return new URIWrapper(new Entity(uri));
			}
			public name.levering.ryan.sparql.common.Statement createStatement (name.levering.ryan.sparql.common.Resource subject, name.levering.ryan.sparql.common.URI @predicate, name.levering.ryan.sparql.common.Value @object) {
				return new Stmt(subject, predicate, @object); 
			}
			
			class Stmt : name.levering.ryan.sparql.common.Statement {
				name.levering.ryan.sparql.common.Resource subject;
				name.levering.ryan.sparql.common.URI predicate;
				name.levering.ryan.sparql.common.Value @object;
				public Stmt(name.levering.ryan.sparql.common.Resource subject, name.levering.ryan.sparql.common.URI @predicate, name.levering.ryan.sparql.common.Value @object) {
					this.subject = subject;
					this.predicate = predicate;
					this.@object = @object;
				}
				public name.levering.ryan.sparql.common.Resource getSubject() { return subject; }
				public name.levering.ryan.sparql.common.URI getPredicate() { return predicate; }
				public name.levering.ryan.sparql.common.Value getObject() { return @object; }
				public bool equals(object other) {
					name.levering.ryan.sparql.common.Statement s = (name.levering.ryan.sparql.common.Statement)other;
					return getSubject().Equals(s.getSubject())
						&& getPredicate().Equals(s.getPredicate())
						&& getObject().Equals(s.getObject());
				}
				public int hashCode() { return getSubject().GetHashCode(); }
			}
			
			public void Depersist(Resource[] r) {
				for (int i = 0; i < r.Length; i++)
					r[i] = Depersist(r[i]);
			}
			
			public Resource Depersist(Resource r) {
				if (r.Uri == null || !sparql.AllowPersistBNodes) return r;
				if (!(source is StaticSource)) return r;
				if (!r.Uri.StartsWith(SparqlEngine.BNodePersistUri)) return r;
				
				StaticSource spb = (StaticSource)source;
				string uri = r.Uri;
				string id = uri.Substring(SparqlEngine.BNodePersistUri.Length);
				BNode node = spb.GetBNodeFromPersistentId(id);
				if (node != null)
					return node;
				
				return r;
			}
			
			public Resource Persist(Resource r) {
				if (!(r is BNode) || !sparql.AllowPersistBNodes) return r;
				if (!(source is StaticSource)) return r;
				StaticSource spb = (StaticSource)source;
				string id = spb.GetPersistentBNodeId((BNode)r);
				if (id == null) return r;
				return new Entity(SparqlEngine.BNodePersistUri + ":" + id);
			}
			
			public static name.levering.ryan.sparql.common.Value Wrap(Resource res, Hashtable cache) {
				if (cache.ContainsKey(res))
					return (name.levering.ryan.sparql.common.Value)cache[res];
				name.levering.ryan.sparql.common.Value value = Wrap(res);
				cache[res] = value;
				return value;
			}

			public static name.levering.ryan.sparql.common.Value Wrap(Resource res) {
				if (res is Literal)
					return new LiteralWrapper((Literal)res);
				else if (res.Uri == null)
					return new BNodeWrapper((BNode)res);
				else
					return new URIWrapper((Entity)res);
			}
		}
		
		class EmptyIterator : java.util.Iterator {
			public bool hasNext() {
				return false;
			}
			
			public object next() {
				throw new InvalidOperationException();
			}
			
			public void remove() {
				throw new InvalidOperationException();
			}
		}

		class StatementIterator : java.util.Iterator {
			SelectableSource source;
			SelectFilter filter;
			RdfSourceWrapper wrapper;
			bool wantMetas;

			Statement[] statements;
			int curindex = -1;
			
			Hashtable cache = new Hashtable();
		
			public StatementIterator(SelectableSource source, SelectFilter filter, RdfSourceWrapper wrapper) {
				this.source = source;
				this.filter = filter;
				this.wrapper = wrapper;
				this.wantMetas = true;
			}
			
			public bool hasNext() {
				if (statements == null) {
					System.DateTime start = System.DateTime.Now;

					MemoryStore results = new MemoryStore();
					StatementSink sink = results;
				
					if (!source.Distinct)
						sink = new SemWeb.Util.DistinctStatementsSink(results, !wantMetas);

					source.Select(filter, sink);
				
					wrapper.Log("SELECT: " + filter + " => " + results.StatementCount + " statements [" + (System.DateTime.Now-start) + "s]");
					
					statements = results.ToArray();
				}
				
				return curindex + 1 < statements.Length;
			}
			
			public object next() {
				curindex++;
				return new GraphStatementWrapper(statements[curindex], cache);
			}
			
			public void remove() {
				throw new InvalidOperationException();
			}
		}
		
		class GraphStatementWrapper : GraphStatement {
			public readonly Statement s;
			name.levering.ryan.sparql.common.Value S;
			name.levering.ryan.sparql.common.URI P;
			name.levering.ryan.sparql.common.Value O;
			name.levering.ryan.sparql.common.URI G;
			
			public GraphStatementWrapper(Statement statement, Hashtable cache) {
				s = statement;
				S = RdfSourceWrapper.Wrap(s.Subject, cache);
				if (s.Predicate.Uri == null)
					throw new QueryExecutionException("Statement's predicate is a blank node.");
				P = RdfSourceWrapper.Wrap(s.Predicate, cache) as name.levering.ryan.sparql.common.URI;
				O = RdfSourceWrapper.Wrap(s.Object, cache);
				G = RdfSourceWrapper.Wrap(s.Meta, cache) as name.levering.ryan.sparql.common.URI;
			}
			
			public name.levering.ryan.sparql.common.URI getGraphName() { return G; }
			
			public name.levering.ryan.sparql.common.Value getSubject() { return S; }
	
			public name.levering.ryan.sparql.common.URI getPredicate() { return P; }
				
			public name.levering.ryan.sparql.common.Value getObject() { return O; }
		}
		
		class BNodeWrapper : java.lang.Object, name.levering.ryan.sparql.common.BNode {
			public BNode r;
			public BNodeWrapper(BNode res) { r = res; }
			public string getID() {
				if (r.LocalName != null) return r.LocalName;
				return r.GetHashCode().ToString();
			}
			public override bool equals(object other) {
				if (other is BNodeWrapper)
					return r.Equals(((BNodeWrapper)other).r);
				if (other is name.levering.ryan.sparql.common.BNode)
					return getID().Equals(((name.levering.ryan.sparql.common.BNode)other).getID());
				return false;
			}
			public override int hashCode() {
					if (r.LocalName != null) java.lang.String.instancehelper_hashCode(getID());
					return r.GetHashCode();
			}
			public object getNative() { return r; }
			public override string toString() { return r.ToString(); }
		}
	
		class URIWrapper : java.lang.Object, name.levering.ryan.sparql.common.URI {
			public Entity r;
			int hc;
			public URIWrapper(Entity res) { r = res; hc = java.lang.String.instancehelper_hashCode(r.Uri); }
			public string getURI() { return r.Uri; }
			public override string toString() { return r.Uri; }
			public override bool equals(object other) {
				if (other is URIWrapper)
					return r.Equals(((URIWrapper)other).r);
				else if (other is name.levering.ryan.sparql.common.URI)
					return r.Uri == ((name.levering.ryan.sparql.common.URI)other).getURI();
				else
					return false;
			}
			public override int hashCode() { return hc; }
			public object getNative() { return r.Uri; }
		}
	
		class LiteralWrapper : java.lang.Object, name.levering.ryan.sparql.common.Literal {
			public Literal r;
			int hc;
			public LiteralWrapper(Literal res) { r = res; hc = java.lang.String.instancehelper_hashCode(r.Value); }
			public name.levering.ryan.sparql.common.URI getDatatype() { if (r.DataType == null) return null; return new URIWrapper(r.DataType); }
			public string getLabel() { return r.Value; }
			public string getLanguage() { return r.Language; }
			public override bool equals(object other) {
				if (other is LiteralWrapper)
					return r.Equals(((LiteralWrapper)other).r);
				else if (other is name.levering.ryan.sparql.common.Literal)
					return r.Equals(GetLiteral((name.levering.ryan.sparql.common.Literal)other));
				return false;
			}
			public override int hashCode() { return hc; }
			static Literal GetLiteral(name.levering.ryan.sparql.common.Literal literal) {
				return new Literal(literal.getLabel(), literal.getLanguage(),
					literal.getDatatype() == null ? null
						: literal.getDatatype().getURI());
			}
			public object getNative() { return r; }
			public override string toString() { return r.ToString(); }
		}
		
		class ExtFuncWrapper : name.levering.ryan.sparql.logic.function.ExternalFunctionFactory, name.levering.ryan.sparql.logic.function.ExternalFunction {
			RdfSourceWrapper source;
			RdfFunction func;
			
			public ExtFuncWrapper(RdfSourceWrapper s, RdfFunction f) {
				source = s;
				func = f;
			}
			
			public name.levering.ryan.sparql.logic.function.ExternalFunction create(name.levering.ryan.sparql.model.logic.LogicFactory logicfactory, name.levering.ryan.sparql.common.SPARQLValueFactory valuefactory) {
				return this;
			}

			public name.levering.ryan.sparql.common.Value evaluate(name.levering.ryan.sparql.model.logic.ExpressionLogic[] arguments, name.levering.ryan.sparql.common.RdfBindingRow binding) {
				try {
					Resource ret = func.Evaluate(source.ToResources(arguments, binding));
					return RdfSourceWrapper.Wrap(ret);
				} catch (Exception e) {
					throw new name.levering.ryan.sparql.logic.function.ExternalFunctionException(e); 
				}
			}
		}
		
		class RdfGroupLogic : name.levering.ryan.sparql.logic.AdvancedGroupConstraintLogic {
		    public RdfGroupLogic(name.levering.ryan.sparql.model.data.GroupConstraintData data, name.levering.ryan.sparql.model.logic.helper.SetIntersectLogic logic)
		    	: base(data, logic) {
		    }
		    
		    protected override RdfBindingSet runTripleConstraints(java.util.List tripleConstraints, 
		    	name.levering.ryan.sparql.model.logic.ConstraintLogic.CallParams p) {
		    	if (DisableQuery)
		    		return null;
		    	
		    	RdfSourceWrapper s = (RdfSourceWrapper)p.source;
		    	
		    	if (s.source is QueryableSource) {
		    		QueryableSource qs = (QueryableSource)s.source;
		    		QueryOptions opts = new QueryOptions();
		    		
		    		opts.Limit = p.limit;
		    		
					VariableList distinguishedVars = new VariableList();
					VariableList undistinguishedVars = new VariableList();
					
               opts.VariableKnownValues = new VarKnownValuesType();
		    		
		    		Statement[] graph = new Statement[tripleConstraints.size()];
		    		Hashtable varMap1 = new Hashtable();
		    		Hashtable varMap2 = new Hashtable();

			    	Entity metaField;
		    		// In this case, we want to treat the meta fields of all of the statements
		    		// in this group as bound by a single variable.
			    	if (p.graphVariable != null) {
			    		metaField = ToRes(p.graphVariable, p.knownValues, true, varMap1, varMap2, s, opts, distinguishedVars, undistinguishedVars, p.distinguishedVariables) as Entity;
			    		
		    		// Otherwise, we are told what graph to use. If sourceDatasets is null, 
		    		// we are looking in the default graph.
		    		} else if (p.sourceDatasets == null) {
		    			/*if (p.defaultDatasets.size() == 0) {
	    					metaField = Statement.DefaultMeta;
	    				} else if (p.defaultDatasets.size() == 1) {
	    					metaField = s.ToEntity((Value)p.defaultDatasets.iterator().next());
	    				} else {
	    					metaField = new SemWebVariable();
	    					opts.VariableKnownValues[(Variable)metaField] = s.ToEntities((Value[])p.defaultDatasets.toArray(new Value[0]));
	    				}*/
						
						// For the default Graph, we always pass DefaultMeta.
						metaField = Statement.DefaultMeta;
		    		
		    		// Otherwise, we are looking in the indicated graphs.
			    	} else {
		    			if (p.sourceDatasets.size() == 0) {
	    					metaField = new SemWebVariable();
	    				} else if (p.sourceDatasets.size() == 1) {
	    					metaField = s.ToEntity((Value)p.sourceDatasets.iterator().next());
	    				} else {
	    					metaField = new SemWebVariable();
	    					opts.VariableKnownValues[(Variable)metaField] = s.ToEntities((Value[])p.sourceDatasets.toArray(new Value[0]));
	    				}
			    	}
		    	
		    		for (int i = 0; i < tripleConstraints.size(); i++) {
		    			TripleConstraintData triple = tripleConstraints.get(i) as TripleConstraintData;
		    			if (triple == null) return null;
		    			
						graph[i] = new Statement(null, null, null, null); // I don't understand why this should be necessary for a struct, but I get a null reference exception otherwise (yet, that didn't happen initially)
		    			graph[i].Subject = ToRes(triple.getSubjectExpression(), p.knownValues, true, varMap1, varMap2, s, opts, distinguishedVars, undistinguishedVars, p.distinguishedVariables) as Entity;
		    			graph[i].Predicate = ToRes(triple.getPredicateExpression(), p.knownValues, true, varMap1, varMap2, s, opts, distinguishedVars, undistinguishedVars, p.distinguishedVariables) as Entity;
		    			graph[i].Object = ToRes(triple.getObjectExpression(), p.knownValues, false, varMap1, varMap2, s, opts, distinguishedVars, undistinguishedVars, p.distinguishedVariables);
		    			graph[i].Meta = metaField;
		    			if (graph[i].AnyNull) return new RdfBindingSetImpl();
		    			if (!(graph[i].Subject is Variable) && !(graph[i].Predicate is Variable) && !(graph[i].Object is Variable) && !(graph[i].Meta is Variable))
		    				return null; // we could use Contains(), but we'll just abandon the Query() path altogether
		    		}

					if (p.distinguishedVariables == null) {
						opts.DistinguishedVariables = null;
					} else if (distinguishedVars.Count > 0) {
						opts.DistinguishedVariables = distinguishedVars;
					} else if (undistinguishedVars.Count > 0) {
						// we don't mean to make it distinguished, but we need at least one,
						// and for now we'll just take the first
						opts.DistinguishedVariables = new VariableList();
						((VariableList)opts.DistinguishedVariables).Add(undistinguishedVars[0]);
					} else {
						// no variables!
						return null;
					}

                    opts.VariableLiteralFilters = new LitFilterMap();
		    		foreach (DictionaryEntry kv in varMap1) {
		    			if (p.knownFilters != null && p.knownFilters.containsKey(kv.Key)) {
                            LitFilterList filters = new LitFilterList();
		    				for (java.util.Iterator iter = ((java.util.List)p.knownFilters.get(kv.Key)).iterator(); iter.hasNext(); )
		    					filters.Add((LiteralFilter)iter.next());
		    				opts.VariableLiteralFilters[(Variable)kv.Value] = filters;
		    			}
		    		}
		    		
		    		// too expensive to do...
		    		//if (!qs.MetaQuery(graph, opts).QuerySupported)
		    		//	return null; // TODO: We could also check if any part has NoData, we can abandon the query entirely 
		    		
		    		QueryResultBuilder builder = new QueryResultBuilder();
		    		builder.varMap = varMap2;
		    		builder.source = s;
		    		qs.Query(graph, opts, builder);
		    		return builder.bindings;
		    	}
		    	
		    	return null;
		    }
		    
		    class QueryResultBuilder : QueryResultSink {
		    	public Hashtable varMap;
		    	public RdfSourceWrapper source;
		    	public RdfBindingSetImpl bindings;
		    	
				public override void Init(Variable[] variables) {
					java.util.ArrayList vars = new java.util.ArrayList();
					foreach (Variable b in variables)
						if (varMap[b] != null) // because of bad treatment of meta
							vars.add((SparqlVariable)varMap[b]);
					
					bindings = new RdfBindingSetImpl(vars);
				}
				
				public override bool Add(VariableBindings result) {
					RdfBindingRowImpl row = new RdfBindingRowImpl(bindings);
					for (int i = 0; i < result.Count; i++) {
						row.addBinding( (SparqlVariable)varMap[result.Variables[i]], RdfSourceWrapper.Wrap(result.Values[i]) );
					}
					bindings.addRow(row);
					return true;
				}

				public override void AddComments(string comments) {
					source.Log(comments);
				}
		    }
		    
		    Resource ToRes(object expr, java.util.Map knownValues, bool entities, Hashtable varMap1, Hashtable varMap2, RdfSourceWrapper src, QueryOptions opts, VariableList distinguishedVars, VariableList undistinguishedVars, java.util.Set sparqlDistinguished) {
		    	if (expr is SparqlVariable) {
		    		Variable v;
		    		if (varMap1.ContainsKey(expr)) {
		    			v = (Variable)varMap1[expr];
		    		} else {
		    			v = new Variable(expr.ToString());
		    			varMap1[expr] = v;
		    			varMap2[v] = expr;
		    		
			    		if (knownValues != null && knownValues.get(expr) != null) {
				    		java.util.Set values = (java.util.Set)knownValues.get(expr);
	                        VarKnownValuesList values2 = new VarKnownValuesList();
				    		for (java.util.Iterator iter = values.iterator(); iter.hasNext(); ) {
				    			Resource r = src.ToResource((name.levering.ryan.sparql.common.Value)iter.next());
				    			if (r != null)
				    				values2.Add(r);
				    		}
				    		
				    		opts.VariableKnownValues[v] = values2;
				    	}
				    	
				    	if (sparqlDistinguished != null && sparqlDistinguished.contains(expr))
				    		distinguishedVars.Add(v);
						else
							undistinguishedVars.Add(v);
			    	}
		    		return v;
		    	}
		    	
	    		return entities ? src.ToEntity((name.levering.ryan.sparql.common.Value)expr) : src.ToResource((name.levering.ryan.sparql.common.Value)expr);
		    }
		    
			protected override void extractLiteralFilters(name.levering.ryan.sparql.model.logic.ExpressionLogic node, java.util.Map literalFilters) {
				//Console.Error.WriteLine(node + " " + node.GetType());
				base.extractLiteralFilters(node, literalFilters);
			
				if (node is BinaryExpressionNode) {
					BinaryExpressionNode b = (BinaryExpressionNode)node;
					
					LiteralFilter.CompType comp;
					if (node is ASTEqualsNode)
						comp = LiteralFilter.CompType.EQ;
					else if (node is ASTNotEqualsNode)
						comp = LiteralFilter.CompType.NE;
					else if (node is ASTGreaterThanNode)
						comp = LiteralFilter.CompType.GT;
					else if (node is ASTGreaterThanEqualsNode)
						comp = LiteralFilter.CompType.GE;
					else if (node is ASTLessThanNode)
						comp = LiteralFilter.CompType.LT;
					else if (node is ASTLessThanEqualsNode)
						comp = LiteralFilter.CompType.LE;
					else
						return;
					
					SparqlVariable var;
					name.levering.ryan.sparql.common.Literal val;
					
					object left = RemoveCast(b.getLeftExpression());
					object right = RemoveCast(b.getRightExpression());
					
					if (left is ASTVar && right is name.levering.ryan.sparql.common.Literal) {
						var = (SparqlVariable)left;
						val = (name.levering.ryan.sparql.common.Literal)right;
					} else if (right is ASTVar && left is name.levering.ryan.sparql.common.Literal) {
						var = (SparqlVariable)right;
						val = (name.levering.ryan.sparql.common.Literal)left;
						switch (comp) {
						case LiteralFilter.CompType.LT: comp = LiteralFilter.CompType.GE; break;
						case LiteralFilter.CompType.LE: comp = LiteralFilter.CompType.GT; break;
						case LiteralFilter.CompType.GT: comp = LiteralFilter.CompType.LE; break;
						case LiteralFilter.CompType.GE: comp = LiteralFilter.CompType.LT; break;
						}
					} else {
						return;
					}
					
					object parsedvalue = new Literal(val.getLabel(), null, val.getDatatype() == null ? null : val.getDatatype().getURI()).ParseValue();
					
					LiteralFilter filter = LiteralFilter.Create(comp, parsedvalue);
					addLiteralFilter(var, filter, literalFilters);

				} else if (node is ASTRegexFuncNode) {
					ASTRegexFuncNode renode = (ASTRegexFuncNode)node;
					
					SparqlVariable var = RemoveCast(renode.getArguments().get(0)) as ASTVar;
					name.levering.ryan.sparql.common.Literal relit = RemoveCast(renode.getArguments().get(1)) as name.levering.ryan.sparql.common.Literal;
					
					if (var == null || relit == null) return;
					
					
					string re = relit.getLabel();
					if (re.Length == 0) return;
					
					bool startsW = removeChar(ref re, '^', 0); // chop of ^ from start, return whether it was there
					bool endsW = removeChar(ref re, '$', 1); // chop of $ from end, return whether it was there
					
					// make sure the re that's left has no special re characters
					foreach (char c in re)
						if (c == '(' || c == '[' || c == '{' || c == '*' || c == '?' || c == '+' || c == '\\' || c == '|' || c == '.')
							return;
					
					LiteralFilter filter;
					if (startsW && endsW) {
						filter = LiteralFilter.Create(LiteralFilter.CompType.EQ, re);
					} else if (startsW) {
						filter = new SemWeb.Filters.StringStartsWithFilter(re);
					} else if (endsW) {
						filter = new SemWeb.Filters.StringEndsWithFilter(re);
					} else {
						filter = new SemWeb.Filters.StringContainsFilter(re);
					}
					addLiteralFilter(var, filter, literalFilters);
				}
			}
		    
		    bool removeChar(ref string re, char c, int end) {
		    	bool ret = re[(end == 0 ? 0 : re.Length-1)] == c;
		    	if (ret) {
		    		if (end == 0)
		    			re = re.Substring(1);
		    		else
		    			re = re.Substring(0, re.Length-1);
		    	}
		    	return ret;
		    }
		    
		    object RemoveCast(object node) {
		    	if (node is ASTFunctionCall) {
		    		string name = ((ASTFunctionCall)node).getName(null).ToString();
		    		if (name.StartsWith("http://www.w3.org/2001/XMLSchema#"))
		    			return RemoveCast(((ASTFunctionCall)node).getArguments().get(0));
		    	}
		    	if (node is ASTMinusNode) {
		    		object inside = RemoveCast(((ASTMinusNode)node).getExpression());
		    		if (inside is ASTLiteral) {
		    			string value = ((ASTLiteral)inside).getLabel();
		    			double doublevalue = double.Parse(value);
		    			return new LiteralWrapper(new Literal((-doublevalue).ToString(), null, ((ASTLiteral)inside).getDatatype().getURI()));
		    		}
		    	}
		    	return node;
		    }
		}
		
		class TestFunction : RdfFunction {
			public override string Uri { get { return "http://taubz.for.net/code/semweb/test/function"; } }
			public override Resource Evaluate(Resource[] args) {
				return Literal.FromValue(args.Length == 2 && args[0].Equals(args[1]));
			}
		}
		class LCFunction : RdfFunction {
			public override string Uri { get { return "http://taubz.for.net/code/semweb/test/lc"; } }
			public override Resource Evaluate(Resource[] args) {
				if (args.Length != 1 || !(args[0] is Literal)) throw new InvalidOperationException();
				return new Literal(((Literal)args[0]).Value.ToLower());
			}
		}
		class UCFunction : RdfFunction {
			public override string Uri { get { return "http://taubz.for.net/code/semweb/test/uc"; } }
			public override Resource Evaluate(Resource[] args) {
				if (args.Length != 1 || !(args[0] is Literal)) throw new InvalidOperationException();
				return new Literal(((Literal)args[0]).Value.ToUpper());
			}
		}
	}
	
}
