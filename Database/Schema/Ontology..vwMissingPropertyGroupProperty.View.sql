SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [Ontology.].[vwMissingPropertyGroupProperty] as
	with a as (
		select max(SortOrder) StartID
		from [ontology.].PropertyGroupProperty
		where PropertyGroupURI = 'http://profiles.catalyst.harvard.edu/ontology/prns#PropertyGroupOverview'
	), b as (
		select distinct Property
		from [RDF.].vwPropertyTall
		where Property not in (select PropertyURI from [ontology.].PropertyGroupProperty)
	)
	select 'http://profiles.catalyst.harvard.edu/ontology/prns#PropertyGroupOverview' PropertyGroupURI,
			Property PropertyURI,
			row_number() over (order by Property) + StartID SortOrder
		from a, b
GO
