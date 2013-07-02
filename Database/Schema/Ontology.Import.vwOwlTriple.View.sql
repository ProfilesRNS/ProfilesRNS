SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Ontology.Import].[vwOwlTriple] AS
	WITH xmlnamespaces (
		'http://aims.fao.org/aos/geopolitical.owl#' AS geo,
		'http://www.w3.org/2004/02/skos/core#' AS skco,
		'http://purl.org/NET/c4dm/event.owl#' AS event,
		'http://vivoweb.org/ontology/provenance-support#' AS pvs,
		'http://purl.org/dc/elements/1.1/' AS dcelem,
		'http://www.w3.org/2006/12/owl2-xml#' AS owl2,
		'http://vivoweb.org/ontology/scientific-research-resource#' AS scirr,
		'http://vivoweb.org/ontology/core#' AS vivo,
		'http://purl.org/vocab/vann/' AS vann,
		'http://vitro.mannlib.cornell.edu/ns/vitro/0.7#' AS vitro,
		'http://www.w3.org/2008/05/skos#' AS skos,
		'http://www.w3.org/1999/02/22-rdf-syntax-ns#' AS rdf,
		'http://jena.hpl.hp.com/ARQ/function#' AS afn,
		'http://purl.org/ontology/bibo/' AS bibo,
		'http://xmlns.com/foaf/0.1/' AS foaf,
		'http://www.w3.org/2003/06/sw-vocab-status/ns#' AS swvs,
		'http://www.w3.org/2002/07/owl#' AS owl,
		'http://purl.org/dc/terms/' AS dcterms,
		'http://www.w3.org/2001/XMLSchema#' AS xsd,
		'http://www.w3.org/2000/01/rdf-schema#' AS rdfs
	), d as (
		SELECT x.name OWL, x.Graph, d.query('.') d, isnull(d.value('@rdf:about','nvarchar(max)'),'http://profiles.catalyst.harvard.edu/ontology/nodeID#'+d.value('@rdf:nodeID','nvarchar(max)')) a
		FROM [Ontology.Import].[OWL] x CROSS APPLY data.nodes('//rdf:Description') AS R(d)
	)
	SELECT d.OWL,
		d.Graph,
		d.a Subject,
		d.d.value('namespace-uri((/rdf:Description/*[sql:column("n.n")])[1])','nvarchar(max)') 
				+ d.d.value('local-name((/rdf:Description/*[sql:column("n.n")])[1])','nvarchar(max)') Predicate,
		coalesce(d.d.value('(/rdf:Description/*[sql:column("n.n")]/@rdf:resource)[1]','nvarchar(max)'), 
				'http://profiles.catalyst.harvard.edu/ontology/nodeID#'
					+d.d.value('(/rdf:Description/*[sql:column("n.n")]/@rdf:nodeID)[1]','nvarchar(max)'), 
				d.d.value('(/rdf:Description/*[sql:column("n.n")])[1]','nvarchar(max)')) Object,
		d.d.value('count(rdf:Description/*)','nvarchar(max)') n, 
		n.n i
	FROM d, [Utility.Math].N n
	WHERE n.n between 1 and cast(d.d.value('count(rdf:Description/*)','nvarchar(max)') as int)
GO
