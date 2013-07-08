SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [Ontology.].[vwMissingClassProperty] as
	with a as (
		select max(ClassPropertyID) StartID
		from [Ontology.].ClassProperty
	), b as (
		select Class, min(HasType) HasType, min(HasLabel) HasLabel
		from (
			select Class, 0 HasType, 0 HasLabel
				from [RDF.].[vwClass]
				where Class not in (select class from [Ontology.].ClassProperty)
			union all
			select Class, 0 HasType, 1 HasLabel
				from [Ontology.].ClassProperty
				where Class not in (
					select Class 
					from [Ontology.].ClassProperty
					where Property = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type' and NetworkProperty is null
				)
			union all
			select Class, 1 HasType, 0 HasLabel
				from [Ontology.].ClassProperty
				where Class not in (
					select Class 
					from [Ontology.].ClassProperty
					where Property = 'http://www.w3.org/2000/01/rdf-schema#label' and NetworkProperty is null
				)
			) t
		group by Class
	), c as (
		select Class, null NetworkProperty, 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type' Property, 0 IsDetail, null Limit, 1 IncludeDescription, 0 IncludeNetwork,
				0 SearchWeight,
				1 CustomDisplay, 0 CustomEdit, -1 ViewSecurityGroup, 
				-40 EditSecurityGroup,
				-40 EditPermissionsSecurityGroup, -40 EditExistingSecurityGroup, -40 EditAddNewSecurityGroup, -40 EditAddExistingSecurityGroup, -40 EditDeleteSecurityGroup,
				1 MinCardinality, null MaxCardinality, cast(null as xml) CustomEditModule
			from b
			where HasType = 0
		union all
		select Class, null NetworkProperty, 'http://www.w3.org/2000/01/rdf-schema#label' Property, 0 IsDetail, null Limit, 0 IncludeDescription, 0 IncludeNetwork,
				1 SearchWeight,
				1 CustomDisplay, 0 CustomEdit, -1 ViewSecurityGroup, 
				-40 EditSecurityGroup,
				-40 EditPermissionsSecurityGroup, -40 EditExistingSecurityGroup, -40 EditAddNewSecurityGroup, -40 EditAddExistingSecurityGroup, -40 EditDeleteSecurityGroup,
				1 MinCardinality, null MaxCardinality, cast(null as xml) CustomEditModule
			from b
			where HasLabel = 0
		union all
		select p.Value Domain, null NetworkProperty, p.Property, 1 IsDetail, null Limit, 
				(case when t.Value = 'http://www.w3.org/2002/07/owl#ObjectProperty' then 1 else 0 end) IncludeDescription, 
				0 IncludeNetwork,
				(case when t.Value = 'http://www.w3.org/2002/07/owl#ObjectProperty' then 0 else 0.5 end) SearchWeight,
				0 CustomDisplay, 0 CustomEdit, -1 ViewSecurityGroup, 
				-40 EditSecurityGroup,
				-40 EditPermissionsSecurityGroup, -40 EditExistingSecurityGroup, -40 EditAddNewSecurityGroup, -40 EditAddExistingSecurityGroup, -40 EditDeleteSecurityGroup,
				0 MinCardinality, null MaxCardinality, cast(null as xml) CustomEditModule
			from [RDF.].vwPropertyTall p, [RDF.].vwPropertyTall t
			where p.Predicate = 'http://www.w3.org/2000/01/rdf-schema#domain'
				and p.Property = t.Property
				and t.Predicate = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type'
				and t.Value in ('http://www.w3.org/2002/07/owl#DatatypeProperty','http://www.w3.org/2002/07/owl#ObjectProperty')
				and not exists (
					select *
					from [Ontology.].ClassProperty c
					where c.Class = p.Value and c.Property = p.Property and c.NetworkProperty is null
				)
	)
	select row_number() over (order by c.Class, c.Property) + a.StartID ClassPropertyID, c.*
		from c, a
GO
