SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Stored Procedure

CREATE PROCEDURE [Profile.Module].[NetworkCloud.Person.HasResearchArea.GetXML]
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

	SELECT (
		SELECT	'' "@Description",
				'In this concept ''cloud'', the sizes of the concepts are based not only on the number of corresponding publications, but also how relevant the concepts are to the overall topics of the publications, how long ago the publications were written, whether the person was the first or senior author, and how many other people have written about the same topic. The largest concepts are those that are most unique to this person.' "@InfoCaption",
				2 "@Columns",
				(
					SELECT	Value "@ItemURLText", 
							SortOrder "@sortOrder", 
							(CASE WHEN SortOrder <= 5 THEN 'big'
								WHEN Quintile = 1 THEN 'big'
								WHEN Quintile = 5 THEN 'small'
								ELSE 'med' END) "@Weight",
							URI "@ItemURL"
					FROM (
						SELECT t.SortOrder, t.Weight, @baseURI+CAST(t.Object AS VARCHAR(50)) URI, n.Value,
							NTILE(5) OVER (ORDER BY t.SortOrder) Quintile
						FROM [RDF.].[Triple] t
							INNER JOIN [RDF.].[Triple] l
								ON t.Object = l.Subject AND l.Predicate = @labelID
							INNER JOIN [RDF.].[Node] n
								ON l.Object = n.NodeID
						WHERE t.Subject = @NodeID AND t.Predicate = @hasResearchAreaID
					) t
					ORDER BY Value
					FOR XML PATH('Item'), TYPE
				)
		FOR XML PATH('ListView'), TYPE
	) ListViewXML

END
GO
