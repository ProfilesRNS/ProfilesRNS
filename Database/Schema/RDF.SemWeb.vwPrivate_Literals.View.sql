SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [RDF.SemWeb].[vwPrivate_Literals] AS
	SELECT 0 id, 'ver:1'+char(10)+'guid:c8bcf60e1d354ebf9d8cecd5c02a2182'+char(10) value, null language, null datatype, null hash
	UNION ALL
	SELECT n.NodeID id, n.value, n.language, n.datatype, b.SemWebHash hash
		FROM [RDF.].Node n, [RDF.SemWeb].[vwHash2Base64] b --WITH (NOEXPAND)
		WHERE n.NodeID = b.NodeID AND n.ObjectType = 1
GO
