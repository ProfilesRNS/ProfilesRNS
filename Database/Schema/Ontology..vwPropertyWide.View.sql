SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [Ontology.].[vwPropertyWide] as
	with x as (
		select * from [Ontology.].vwPropertyTall
	)
	select b.Value Domain, a.Property, a.Value Type, c.Value Range, d.Value MinCardinality, e.Value MaxCardinality, f.Value Label
	from x a
		left outer join x b
			on a.Property = b.Property and b.Predicate = 'http://www.w3.org/2000/01/rdf-schema#domain'
		left outer join x c
			on a.Property = c.Property and c.Predicate = 'http://www.w3.org/2000/01/rdf-schema#range'
		left outer join x d
			on a.Property = d.Property and d.Predicate = 'http://www.w3.org/2002/07/owl#minCardinality'
		left outer join x e
			on a.Property = e.Property and e.Predicate = 'http://www.w3.org/2002/07/owl#maxCardinality'
		left outer join x f
			on a.Property = f.Property and f.Predicate = 'http://www.w3.org/2000/01/rdf-schema#label'
	where a.Predicate = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type'
		and a.Value in ('http://www.w3.org/2002/07/owl#DatatypeProperty','http://www.w3.org/2002/07/owl#ObjectProperty')
GO
