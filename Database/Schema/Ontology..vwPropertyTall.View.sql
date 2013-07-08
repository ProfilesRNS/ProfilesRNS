SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [Ontology.].[vwPropertyTall] as
	with a as (
		select distinct Subject Property, cast(Subject as varbinary(max)) xProperty
			from [Ontology.Import].[Triple] b
			where Graph is not null
				and Predicate = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type'
				and Object in ('http://www.w3.org/2002/07/owl#DatatypeProperty','http://www.w3.org/2002/07/owl#ObjectProperty')
	), b as (
		select t.Subject Property, t.Predicate, t.Object Value, 
			t._SubjectNode PropertyNode, t._PredicateNode PredicateNode, t._ObjectNode ValueNode,
			a.xProperty
		from a, [Ontology.Import].[Triple] t
		where t.Graph is not null
			and a.xProperty = cast(t.Subject as varbinary(max))
	), c as (
		select m.Object Property, p.Predicate, p.Object Value,
				m._ObjectNode PropertyNode, p._PredicateNode PredicateNode, p._ObjectNode ValueNode,
				cast(m.Object as varbinary(max)) xProperty
			from [Ontology.Import].[Triple] t, [Ontology.Import].[Triple] m, [Ontology.Import].[Triple] p, a
			where t.Graph is not null
				and t.Predicate = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type'
				and t.Object = 'http://www.w3.org/2002/07/owl#Restriction'
				and m.Graph is not null
				and m.OWL = t.OWL
				and cast(m.Subject as varbinary(max)) = cast(t.Subject as varbinary(max))
				and m.Predicate = 'http://www.w3.org/2002/07/owl#onProperty'
				and p.Graph is not null
				and p.OWL = t.OWL
				and cast(p.Subject as varbinary(max)) = cast(t.Subject as varbinary(max))
				and not (p.Predicate = t.Predicate and p.Object = t.Object)
				and not (p.Predicate = m.Predicate and p.Object = m.Object)
				and cast(m.Object as varbinary(max)) = a.xProperty
	), d as (
		select * from b
		union all
		select * from c
	), e as (
		select distinct Property, 
			(case when Predicate in ('http://www.w3.org/2002/07/owl#someValuesFrom','http://www.w3.org/2002/07/owl#allValuesFrom') 
				then 'http://www.w3.org/2000/01/rdf-schema#range' 
				else Predicate end) Predicate,
			Value,
			PropertyNode,
			(case when Predicate in ('http://www.w3.org/2002/07/owl#someValuesFrom','http://www.w3.org/2002/07/owl#allValuesFrom') 
				then [RDF.].fnURI2NodeID('http://www.w3.org/2000/01/rdf-schema#range')
				else PredicateNode end) PredicateNode,
			ValueNode,
			xProperty
		from d
	)
	select Property, Predicate, Value, PropertyNode, PredicateNode, ValueNode
		from e
GO
