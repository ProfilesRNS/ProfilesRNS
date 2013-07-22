SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [RDF.SemWeb].[vwPublic_Entities] AS
	SELECT NodeID id, value
	FROM [RDF.].Node
	WHERE ObjectType = 0 AND ViewSecurityGroup = -1
GO
