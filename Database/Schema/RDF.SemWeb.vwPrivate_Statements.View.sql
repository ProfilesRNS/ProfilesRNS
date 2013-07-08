SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [RDF.SemWeb].[vwPrivate_Statements] AS
	SELECT t.subject, t.predicate, t.objecttype, t.object, 1 meta
	FROM [RDF.].Triple t
GO
