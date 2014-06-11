using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Xml;

namespace Profiles.Search.Utilities
{
    public class DisallowedSearchException : Exception
    {
        private static string DisallowedSearchTxt_PRE = "<rdf:RDF xmlns:geo=\"http://aims.fao.org/aos/geopolitical.owl#\" xmlns:afn=\"http://jena.hpl.hp.com/ARQ/function#\" xmlns:prns=\"http://profiles.catalyst.harvard.edu/ontology/prns#\" xmlns:obo=\"http://purl.obolibrary.org/obo/\" xmlns:dcelem=\"http://purl.org/dc/elements/1.1/\" xmlns:dcterms=\"http://purl.org/dc/terms/\" xmlns:event=\"http://purl.org/NET/c4dm/event.owl#\" xmlns:bibo=\"http://purl.org/ontology/bibo/\" xmlns:vann=\"http://purl.org/vocab/vann/\" xmlns:ucsf=\"http://ucsf/ontology#\" xmlns:vitro07=\"http://vitro.mannlib.cornell.edu/ns/vitro/0.7#\" xmlns:vitro=\"http://vitro.mannlib.cornell.edu/ns/vitro/public#\" xmlns:vivo=\"http://vivoweb.org/ontology/core#\" xmlns:pvs=\"http://vivoweb.org/ontology/provenance-support#\" xmlns:scirr=\"http://vivoweb.org/ontology/scientific-research-resource#\" xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\" xmlns:rdfs=\"http://www.w3.org/2000/01/rdf-schema#\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema#\" xmlns:owl=\"http://www.w3.org/2002/07/owl#\" xmlns:swvs=\"http://www.w3.org/2003/06/sw-vocab-status/ns#\" xmlns:skco=\"http://www.w3.org/2004/02/skos/core#\" xmlns:owl2=\"http://www.w3.org/2006/12/owl2-xml#\" xmlns:skos=\"http://www.w3.org/2008/05/skos#\" xmlns:foaf=\"http://xmlns.com/foaf/0.1/\"> " +
                                                  "<rdf:Description rdf:nodeID=\"SearchResults\">" +
                                                    "<rdf:type rdf:resource=\"http://profiles.catalyst.harvard.edu/ontology/prns#Network\" />" +
                                                    "<rdfs:label>Search Results</rdfs:label>" +
                                                    "<prns:numberOfConnections rdf:datatype=\"http://www.w3.org/2001/XMLSchema#int\">0</prns:numberOfConnections>" +
                                                    //"<prns:offset rdf:datatype=\"http://www.w3.org/2001/XMLSchema#int\">0</prns:offset>" +
                                                    //"<prns:limit rdf:datatype=\"http://www.w3.org/2001/XMLSchema#int\">15</prns:limit>" +
                                                    //"<prns:maxWeight rdf:datatype=\"http://www.w3.org/2001/XMLSchema#float\" />" +
                                                    //"<prns:minWeight rdf:datatype=\"http://www.w3.org/2001/XMLSchema#float\" />" +
                                                    "<vivo:overview rdf:parseType=\"Literal\">";
        private static string DisallowedSearchTxt_MID = "<SearchDetails>" +
                                                        "<SearchPhraseList>" +
                                                          "<SearchPhrase ID=\"1\" ThesaurusMatch=\"false\">";
        private static string DisallowedSearchTxt_POST = "</SearchPhrase>" +
                                                        "</SearchPhraseList>" +
                                                      "</SearchDetails>" +
                                                    "</vivo:overview>" +
                                                  "</rdf:Description>" +
                                                "</rdf:RDF>";

        public XmlDocument DisallowedSearchResults = new XmlDocument();

        public DisallowedSearchException(string message, XmlDocument searchoptions)
            : base(message)
        {
            // use searchoptions to build legitimate xml response
            DisallowedSearchResults.LoadXml(DisallowedSearchTxt_PRE + searchoptions.InnerText + DisallowedSearchTxt_MID + message + DisallowedSearchTxt_POST);
        }

        public XmlDocument GetDisallowedSearchResults()
        {
            return DisallowedSearchResults;
        }
    }
}