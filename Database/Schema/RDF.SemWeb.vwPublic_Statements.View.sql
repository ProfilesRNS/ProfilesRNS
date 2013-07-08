SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [RDF.SemWeb].[vwPublic_Statements] AS
	SELECT t.subject, t.predicate, t.objecttype, t.object, 1 meta
	FROM [RDF.].Triple t, [RDF.].Node s, [RDF.].Node p, [RDF.].Node o
	WHERE t.ViewSecurityGroup = -1
		AND t.Subject=s.NodeID AND t.Predicate=p.NodeID AND t.Object=o.NodeID
		AND s.ViewSecurityGroup = -1 AND p.ViewSecurityGroup = -1 AND o.ViewSecurityGroup = -1
GO
