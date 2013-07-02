SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Stored Procedure

CREATE PROCEDURE [Profile.Module].[NetworkCategory.Person.HasResearchArea.GetXML]
	@NodeID BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @baseURI NVARCHAR(400)
	SELECT @baseURI = value FROM [Framework.].Parameter WHERE ParameterID = 'baseURI'

	DECLARE @hasResearchAreaID BIGINT
	SELECT @hasResearchAreaID = [RDF.].fnURI2NodeID('http://vivoweb.org/ontology/core#hasResearchArea')	

	DECLARE @labelID BIGINT
	SELECT @labelID = [RDF.].fnURI2NodeID('http://www.w3.org/2000/01/rdf-schema#label')	

	DECLARE @meshSemanticGroupNameID BIGINT
	SELECT @meshSemanticGroupNameID = [RDF.].fnURI2NodeID('http://profiles.catalyst.harvard.edu/ontology/prns#meshSemanticGroupName')	

	SELECT *
		INTO #t
		FROM (
			SELECT t.SortOrder, t.Weight, @baseURI+CAST(t.Object AS VARCHAR(50)) URI, n.Value Concept, m.Value Category,
				ROW_NUMBER() OVER (PARTITION BY s.Object ORDER BY t.Weight DESC) CategoryRank
			FROM [RDF.].[Triple] t
				INNER JOIN [RDF.].[Triple] l
					ON t.Object = l.Subject AND l.Predicate = @labelID
				INNER JOIN [RDF.].[Node] n
					ON l.Object = n.NodeID
				INNER JOIN [RDF.].[Triple] s
					ON t.Object = s.Subject AND s.Predicate = @meshSemanticGroupNameID
				INNER JOIN [RDF.].[Node] m
					ON s.Object = m.NodeID
			WHERE t.Subject = @NodeID AND t.Predicate = @hasResearchAreaID
		) t
		WHERE CategoryRank <= 10

	SELECT (
		SELECT	'Concepts listed here are grouped according to their ''semantic'' categories. Within each category, up to ten concepts are shown, in decreasing order of relevance.' "@InfoCaption",
				(
					SELECT a.Category "DetailList/@Category",
						(SELECT	'' "Item/@ItemURLText",
								URI "Item/@URL",
								Concept "Item"
							FROM #t b
							WHERE b.Category = a.Category
							ORDER BY b.CategoryRank
							FOR XML PATH(''), TYPE
						) "DetailList"
					FROM (SELECT DISTINCT Category FROM #t) a
					ORDER BY a.Category
					FOR XML PATH(''), TYPE
				)
		FOR XML PATH('Items'), TYPE
	) ItemsXML

END
GO
