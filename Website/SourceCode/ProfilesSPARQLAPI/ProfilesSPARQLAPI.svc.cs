using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;
using System.Configuration;
using System.IO;
using System.Xml;

using SemWeb;
using SemWeb.Query;
using Search.Common;

namespace Search
{
    // NOTE: If you change the class name "ProfilesSPARQLAPI" here, you must also update the reference to "ProfilesSPARQLAPI" in Web.config.	
    public class ProfilesSPARQLAPI : IProfilesSPARQLAPI
    {
		public object Search(queryrequest xml)
        {
            SemWeb.Query.Query query = null;

            string q = string.Empty;

			try
			{
				query = new SparqlEngine(new StringReader(xml.query));
			}
			catch (QueryFormatException ex)
			{
				var malformed = new malformedquery();

				malformed.faultdetails = ex.Message;

				return malformed;			
			}

            // Load the data from sql server
            SemWeb.Stores.SQLStore store;

            string connstr = ConfigurationManager.ConnectionStrings["SemWebDB"].ConnectionString;

            DebugLogging.Log(connstr);

            store = (SemWeb.Stores.SQLStore)SemWeb.Store.CreateForInput(connstr);

            //Create a Sink for the results to be writen once the query is run.
            MemoryStream ms = new MemoryStream();
            XmlTextWriter writer = new XmlTextWriter(ms, System.Text.Encoding.UTF8);
            QueryResultSink sink = new SparqlXmlQuerySink(writer);

            try
            {
                // Run the query.
                query.Run(store, sink);

            }
            catch (Exception ex)
            {
                // Run the query.
                query.Run(store, sink);
                DebugLogging.Log("Run the query a second time");
                DebugLogging.Log(ex.Message);

            }
            //flush the writer then  load the memory stream
            writer.Flush();
            ms.Seek(0, SeekOrigin.Begin);

            //Write the memory stream out to the response.
            ASCIIEncoding ascii = new ASCIIEncoding();
            DebugLogging.Log(ascii.GetString(ms.ToArray()).Replace("???", ""));
            writer.Close();

            DebugLogging.Log("End of Processing");

            return SerializeXML.DeserializeObject(ascii.GetString(ms.ToArray()).Replace("???", ""), typeof(sparql)) as sparql;                      
        }    
    }
}

