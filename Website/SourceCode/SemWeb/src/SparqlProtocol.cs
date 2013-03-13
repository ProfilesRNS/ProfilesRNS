using System;
using System.Collections;
using System.IO;

using SemWeb;
using SemWeb.Stores;

namespace SemWeb.Query {

	public class SparqlProtocolServerHandler : System.Web.IHttpHandler {
		static bool Debug = System.Environment.GetEnvironmentVariable("SEMWEB_DEBUG_SPARQL") != null;
	
		public int MaximumLimit = -1;
		
		Hashtable sources = new Hashtable();
	
		bool System.Web.IHttpHandler.IsReusable { get { return true; } }
		
		public virtual void ProcessRequest(System.Web.HttpContext context) {
			try {
				string query = context.Request["query"];
				if (query == null || query.Trim() == "")
					throw new QueryFormatException("No query provided.");

				if (Debug) {
					Console.Error.WriteLine(query);
					Console.Error.WriteLine();
				}
				
				// Buffer the response so that any errors while
				// executing don't get outputted after the response
				// has begun.
				
				MemoryStream buffer = new MemoryStream();

				bool closeAfterQuery;
				
				SelectableSource source = GetDataSource(out closeAfterQuery);
				try {
					Query sparql = CreateQuery(query);
					
					// Try setting the preferred output MIME type based
					// on the HTTP Accept header, in the order that we
					// get them from System.Web (?).
					if (context.Request.AcceptTypes != null)
					foreach (string acceptType in context.Request.AcceptTypes) {
						// Setting the MIME type may throw, so we
						// break on the first successful set.
						try {
							sparql.MimeType = acceptType;
							break;
						} catch {
						}
					}
					
					if (context.Request["outputMimeType"] != null)
						sparql.MimeType = context.Request["outputMimeType"];
					
					TextWriter writer = new StreamWriter(buffer, System.Text.Encoding.UTF8);
					RunQuery(sparql, source, writer);
					writer.Flush();

					if (context.Request["outputMimeType"] == null || context.Request["outputMimeType"].Trim() == "")
						context.Response.ContentType = sparql.MimeType;
					else
						context.Response.ContentType = context.Request["outputMimeType"];

					context.Response.OutputStream.Write(buffer.GetBuffer(), 0, (int)buffer.Length);
				
				} finally {
					if (closeAfterQuery && source is IDisposable)
						((IDisposable)source).Dispose();
				}
				
			} catch (QueryFormatException e) {
				context.Response.ContentType = "text/plain";
				context.Response.StatusCode = 400;
				context.Response.StatusDescription = e.Message;
				context.Response.Write(e.Message);
				if (Debug) {
					Console.Error.WriteLine(e);
					Console.Error.WriteLine();
				}
			} catch (QueryExecutionException e) {
				context.Response.ContentType = "text/plain";
				context.Response.StatusCode = 500;
				context.Response.StatusDescription = e.Message;
				context.Response.Write(e.Message);
				if (Debug) {
					Console.Error.WriteLine(e);
					Console.Error.WriteLine();
				}
			}
		}

		protected virtual SelectableSource GetDataSource(out bool closeAfterQuery) {
			closeAfterQuery = false;
			
			if (System.Web.HttpContext.Current == null)
				throw new InvalidOperationException("This method is not valid outside of an ASP.NET request.");

			string path = System.Web.HttpContext.Current.Request.Path;
			lock (sources) {
				SelectableSource source = (SelectableSource)sources[path];
				if (source != null) return source;

				System.Collections.Specialized.NameValueCollection config = (System.Collections.Specialized.NameValueCollection)System.Configuration.ConfigurationSettings.GetConfig("sparqlSources");
				if (config == null)
					throw new InvalidOperationException("No sparqlSources config section is set up.");

				string spec = config[path];
				if (spec == null)
					throw new InvalidOperationException("No data source is set for the path " + path + ".");
					
				bool reuse = true;
				if (spec.StartsWith("noreuse,")) {
					reuse = false;
					closeAfterQuery = true;
					spec = spec.Substring("noreuse,".Length);
				}

				Store src = Store.Create(spec);
					
				if (reuse)
					sources[path] = src;

				return (SelectableSource)src;
			}
		}
		
		protected virtual Query CreateQuery(string query) {
			Query sparql = new SparqlEngine(query);
			if (MaximumLimit != -1 && (sparql.ReturnLimit == -1 || sparql.ReturnLimit > MaximumLimit)) sparql.ReturnLimit = MaximumLimit;
			return sparql;
		}
		
		protected virtual void RunQuery(Query query, SelectableSource source, TextWriter output) {
			query.Run(source, output);
		}
	}
		
	internal class HTMLQuerySink : QueryResultSink {
		TextWriter output;
		
		public HTMLQuerySink(TextWriter output) { this.output = output; }

		public override void Init(Variable[] variables) {
			output.WriteLine("<table>");
			output.WriteLine("<tr>");
			foreach (Variable var in variables) {
				if (var.LocalName == null) continue;
				output.WriteLine("<th>" + var.LocalName + "</th>");
			}
			output.WriteLine("</tr>");
		}
		
		public override void Finished() {
			output.WriteLine("</table>");
		}
		
		public override bool Add(VariableBindings result) {
			output.WriteLine("<tr>");
			foreach (Variable var in result.Variables) {
				if (var.LocalName == null) continue;
				Resource varTarget = result[var];
				string t = "";
				if (varTarget != null) {
					t = varTarget.ToString();
					if (varTarget is Literal) t = ((Literal)varTarget).Value;
				}
				t = t.Replace("&", "&amp;");
				t = t.Replace("<", "&lt;");
				output.WriteLine("<td>" + t + "</td>");
			}
			output.WriteLine("</tr>");			
			return true;
		}
	}

	internal class CSVQuerySink : QueryResultSink {
		TextWriter output;
		
		private static readonly char[] reservedChars = new char[] { ',', '\n', '\r' };
		
		public CSVQuerySink(TextWriter output) { this.output = output; }

		public override void Init(Variable[] variables) {
			bool first = true;
			foreach (Variable var in variables) {
				if (var.LocalName == null) continue;
				if (!first) output.Write(","); first = false;
				output.Write(var.LocalName);
			}
			output.WriteLine();
		}
		
		public override void Finished() {
		}
		
		public override bool Add(VariableBindings result) {
			bool first = true;
			foreach (Variable var in result.Variables) {
				if (var.LocalName == null) continue;
				Resource varTarget = result[var];
				string t = "";
				if (varTarget != null) {
					t = varTarget.ToString();
					if (varTarget is Literal) t = ((Literal)varTarget).Value;
					if (varTarget.Uri != null) t = varTarget.Uri;
				}
				if (t.IndexOfAny(reservedChars) >= 0 || t != t.Trim())
					t = "\"" + t.Replace("\"", "\"\"") + "\"";
				if (!first) output.Write(","); first = false;
				output.Write(t);
			}
			output.WriteLine();			
			return true;
		}
	}
}
