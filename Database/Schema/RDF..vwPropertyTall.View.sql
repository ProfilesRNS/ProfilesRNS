SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [RDF.].[vwPropertyTall] as
	with a as (
		select s.Value Property, s.NodeID, s.NodeID PropertyNode
		from [RDF.].Triple t, [RDF.].Node s
		where t.predicate = [RDF.].fnURI2NodeID('http://www.w3.org/1999/02/22-rdf-syntax-ns#type')
			and (t.object = [RDF.].fnURI2NodeID('http://www.w3.org/2002/07/owl#DatatypeProperty')
					or t.object = [RDF.].fnURI2NodeID('http://www.w3.org/2002/07/owl#ObjectProperty')
				)
			and t.subject = s.NodeID
	), b as (
		select t.subject, v.object
		from [RDF.].Triple t, [RDF.].Triple v
		where t.predicate = [RDF.].fnURI2NodeID('http://www.w3.org/1999/02/22-rdf-syntax-ns#type')
			and t.object = [RDF.].fnURI2NodeID('http://www.w3.org/2002/07/owl#Restriction')
			and t.subject = v.subject
			and v.predicate = [RDF.].fnURI2NodeID('http://www.w3.org/2002/07/owl#onProperty')
	), c as (
		select *
			from a
		union
		select a.property, b.subject, b.object
			from a, b
			where a.NodeID = b.object
	), d as (
		select 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type' Predicate
		union all select 'http://www.w3.org/2002/07/owl#minCardinality'
		union all select 'http://www.w3.org/2002/07/owl#maxCardinality'
		union all select 'http://www.w3.org/2000/01/rdf-schema#label'
		union all select 'http://www.w3.org/2000/01/rdf-schema#range'
		union all select 'http://www.w3.org/2002/07/owl#allValuesFrom'
		union all select 'http://www.w3.org/2002/07/owl#someValuesFrom'
		union all select 'http://www.w3.org/2000/01/rdf-schema#domain'
	), e as (
		select Predicate, [RDF.].fnURI2NodeID(Predicate) ActualPredicateNode
		from d
	), f as (
		select (case when Predicate in ('http://www.w3.org/2002/07/owl#allValuesFrom','http://www.w3.org/2002/07/owl#someValuesFrom')
					then 'http://www.w3.org/2000/01/rdf-schema#range' else Predicate end) Predicate,
				ActualPredicateNode,
				(case when Predicate in ('http://www.w3.org/2002/07/owl#allValuesFrom','http://www.w3.org/2002/07/owl#someValuesFrom')
					then [RDF.].fnURI2NodeID('http://www.w3.org/2000/01/rdf-schema#range') else ActualPredicateNode end) PredicateNode
		from e
	)
	select distinct c.Property, f.Predicate, n.Value, c.PropertyNode, f.PredicateNode, n.NodeID ValueNode
		from c, f, [RDF.].Triple t, [RDF.].Node n
		where t.subject = c.NodeID and t.predicate = f.ActualPredicateNode and t.object = n.NodeID
GO
