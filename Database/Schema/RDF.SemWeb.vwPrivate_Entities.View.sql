SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [RDF.SemWeb].[vwPrivate_Entities] AS
	SELECT NodeID id, Value value
	FROM [RDF.].Node
	WHERE ObjectType = 0
GO
