SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [RDF.].[vwTripleValue] as
	select t.TripleID, t.ViewSecurityGroup, t.Subject, t.Predicate, t.Object, t.TripleHash, 
		t.SortOrder, t.Weight, t.Reitification, 
		s.value SubjectValue, p.value PredicateValue, 
		o.value ObjectValue, o.Language, o.DataType, 
		s.ViewSecurityGroup sViewSecurityGroup, p.ViewSecurityGroup pViewSecurityGroup, o.ViewSecurityGroup oViewSecurityGroup
	from [RDF.].Triple t, [RDF.].Node s, [RDF.].Node p, [RDF.].Node o
	where t.subject=s.nodeid and t.predicate=p.nodeid and t.object=o.nodeid
GO
