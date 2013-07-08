SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Search.Cache].[Private.GetConnection]
	@SearchOptions XML,
	@NodeID BIGINT = NULL,
	@NodeURI VARCHAR(400) = NULL,
	@SessionID UNIQUEIDENTIFIER = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- start timer
	declare @d datetime
	select @d = GetDate()

	-- get the NodeID
	IF (@NodeID IS NULL) AND (@NodeURI IS NOT NULL)
		SELECT @NodeID = [RDF.].fnURI2NodeID(@NodeURI)
	IF @NodeID IS NULL
		RETURN
	SELECT @NodeURI = Value
		FROM [RDF.].Node
		WHERE NodeID = @NodeID

	-- get the search string
	declare @SearchString varchar(500)
	declare @DoExpandedSearch bit
	select	@SearchString = @SearchOptions.value('SearchOptions[1]/MatchOptions[1]/SearchString[1]','varchar(500)'),
			@DoExpandedSearch = (case when @SearchOptions.value('SearchOptions[1]/MatchOptions[1]/SearchString[1]/@ExactMatch','varchar(50)') = 'true' then 0 else 1 end)

	if @SearchString is null
		RETURN

	-- set constants
	declare @baseURI nvarchar(400)
	declare @typeID bigint
	declare @labelID bigint
	select @baseURI = value from [Framework.].Parameter where ParameterID = 'baseURI'
	select @typeID = [RDF.].fnURI2NodeID('http://www.w3.org/1999/02/22-rdf-syntax-ns#type')
	select @labelID = [RDF.].fnURI2NodeID('http://www.w3.org/2000/01/rdf-schema#label')

	-------------------------------------------------------
	-- Parse search string and convert to fulltext query
	-------------------------------------------------------
	
	declare @NumberOfPhrases INT
	declare @CombinedSearchString VARCHAR(8000)
	declare @SearchPhraseXML XML
	declare @SearchPhraseFormsXML XML
	declare @ParseProcessTime INT

		
	EXEC [Search.].[ParseSearchString]	@SearchString = @SearchString,
										@NumberOfPhrases = @NumberOfPhrases OUTPUT,
										@CombinedSearchString = @CombinedSearchString OUTPUT,
										@SearchPhraseXML = @SearchPhraseXML OUTPUT,
										@SearchPhraseFormsXML = @SearchPhraseFormsXML OUTPUT,
										@ProcessTime = @ParseProcessTime OUTPUT

	declare @PhraseList table (PhraseID int, Phrase varchar(max), ThesaurusMatch bit, Forms varchar(max))
	insert into @PhraseList (PhraseID, Phrase, ThesaurusMatch, Forms)
	select	x.value('@ID','INT'),
			x.value('.','VARCHAR(MAX)'),
			x.value('@ThesaurusMatch','BIT'),
			x.value('@Forms','VARCHAR(MAX)')
		from @SearchPhraseFormsXML.nodes('//SearchPhrase') as p(x)


	-------------------------------------------------------
	-- Find matching nodes connected to NodeID
	-------------------------------------------------------


	-- Get nodes that match separate phrases
	create table #PhraseNodeMap (
		PhraseID int not null,
		NodeID bigint not null,
		MatchedByNodeID bigint not null,
		Distance int,
		Paths int,
		MapWeight float,
		TextWeight float,
		Weight float
	)
	if (@DoExpandedSearch = 1)
	begin
		declare @PhraseSearchString varchar(8000)
		declare @loop int
		select @loop = 1
		while @loop <= @NumberOfPhrases
		begin
			select @PhraseSearchString = Forms
				from @PhraseList
				where PhraseID = @loop
			insert into #PhraseNodeMap (PhraseID, NodeID, MatchedByNodeID, Distance, Paths, MapWeight, TextWeight, Weight)
				select @loop, s.NodeID, s.MatchedByNodeID, s.Distance, s.Paths, s.Weight, m.Weight,
						(case when s.Weight*m.Weight > 0.999999 then 0.999999 else s.Weight*m.Weight end) Weight
					from [Search.Cache].[Private.NodeMap] s, (
						select [Key] NodeID, [Rank]*0.001 Weight
							from Containstable ([RDF.].Node, value, @PhraseSearchString) n
								inner join [RDF.].[Node] t on n.[Key] = t.NodeID and t.ObjectType = 1
					) m
					where s.MatchedByNodeID = m.NodeID and s.NodeID = @NodeID
			select @loop = @loop + 1
		end
	end
	else
	begin
		insert into #PhraseNodeMap (PhraseID, NodeID, MatchedByNodeID, Distance, Paths, MapWeight, TextWeight, Weight)
			select 1, s.NodeID, s.MatchedByNodeID, s.Distance, s.Paths, s.Weight, m.Weight,
					(case when s.Weight*m.Weight > 0.999999 then 0.999999 else s.Weight*m.Weight end) Weight
				from [Search.Cache].[Private.NodeMap] s, (
					select [Key] NodeID, [Rank]*0.001 Weight
						from Containstable ([RDF.].Node, value, @CombinedSearchString) n
							inner join [RDF.].[Node] t on n.[Key] = t.NodeID and t.ObjectType = 1
				) m
				where s.MatchedByNodeID = m.NodeID and s.NodeID = @NodeID
	end


	-------------------------------------------------------
	-- Get details on the matches
	-------------------------------------------------------
	

	;WITH m AS (
		SELECT 1 DirectMatch, NodeID, NodeID MiddleNodeID, MatchedByNodeID, 
				COUNT(DISTINCT PhraseID) Phrases, 1-exp(sum(log(1-Weight))) Weight
			FROM #PhraseNodeMap
			WHERE Distance = 1
			GROUP BY NodeID, MatchedByNodeID
		UNION ALL
		SELECT 0 DirectMatch, d.NodeID, y.NodeID MiddleNodeID, d.MatchedByNodeID,
				COUNT(DISTINCT d.PhraseID) Phrases, 1-exp(sum(log(1-d.Weight))) Weight
			FROM #PhraseNodeMap d
				INNER JOIN [Search.Cache].[Private.NodeMap] x
					ON x.NodeID = d.NodeID
						AND x.Distance = d.Distance - 1
				INNER JOIN [Search.Cache].[Private.NodeMap] y
					ON y.NodeID = x.MatchedByNodeID
						AND y.MatchedByNodeID = d.MatchedByNodeID
						AND y.Distance = 1
			WHERE d.Distance > 1
			GROUP BY d.NodeID, d.MatchedByNodeID, y.NodeID
	), w as (
		SELECT DISTINCT m.DirectMatch, m.NodeID, m.MiddleNodeID, m.MatchedByNodeID, m.Phrases, m.Weight,
			p._PropertyLabel PropertyLabel, p._PropertyNode PropertyNode
		FROM m
			INNER JOIN [Search.Cache].[Private.NodeClass] c
				ON c.NodeID = m.MiddleNodeID
			INNER JOIN [Ontology.].[ClassProperty] p
				ON p._ClassNode = c.Class
					AND p._NetworkPropertyNode IS NULL
					AND p.SearchWeight > 0
			INNER JOIN [RDF.].Triple t
				ON t.subject = m.MiddleNodeID
					AND t.predicate = p._PropertyNode
					AND t.object = m.MatchedByNodeID
	)
	SELECT w.DirectMatch, w.Phrases, w.Weight,
			n.NodeID, n.Value URI, c.ShortLabel Label, c.ClassName, 
			w.PropertyLabel Predicate, 
			w.MatchedByNodeID, o.value Value
		INTO #MatchDetails
		FROM w
			INNER JOIN [RDF.].Node n
				ON n.NodeID = w.MiddleNodeID
			INNER JOIN [Search.Cache].[Private.NodeSummary] c
				ON c.NodeID = w.MiddleNodeID
			INNER JOIN [RDF.].Node o
				ON o.NodeID = w.MatchedByNodeID

	UPDATE #MatchDetails
		SET Weight = (CASE WHEN Weight > 0.999999 THEN 999999 WHEN Weight < 0.000001 THEN 0.000001 ELSE Weight END)

	-------------------------------------------------------
	-- Build ConnectionDetailsXML
	-------------------------------------------------------

	DECLARE @ConnectionDetailsXML XML
	
	;WITH a AS (
		SELECT DirectMatch, NodeID, URI, Label, ClassName, 
				COUNT(*) NumberOfProperties, 1-exp(sum(log(1-Weight))) Weight,
				(
					SELECT	p.Predicate "Name",
							p.Phrases "NumberOfPhrases",
							p.Weight "Weight",
							p.Value "Value",
							(
								SELECT r.Phrase "MatchedPhrase"
								FROM #PhraseNodeMap q, @PhraseList r
								WHERE q.MatchedByNodeID = p.MatchedByNodeID
									AND r.PhraseID = q.PhraseID
								ORDER BY r.PhraseID
								FOR XML PATH(''), TYPE
							) "MatchedPhraseList"
						FROM #MatchDetails p
						WHERE p.DirectMatch = m.DirectMatch
							AND p.NodeID = m.NodeID
						ORDER BY p.Predicate
						FOR XML PATH('Property'), TYPE
				) PropertyList
			FROM #MatchDetails m
			GROUP BY DirectMatch, NodeID, URI, Label, ClassName
	)
	SELECT @ConnectionDetailsXML = (
		SELECT	(
					SELECT	NodeID "NodeID",
							URI "URI",
							Label "Label",
							ClassName "ClassName",
							NumberOfProperties "NumberOfProperties",
							Weight "Weight",
							PropertyList "PropertyList"
					FROM a
					WHERE DirectMatch = 1
					FOR XML PATH('Match'), TYPE
				) "DirectMatchList",
				(
					SELECT	NodeID "NodeID",
							URI "URI",
							Label "Label",
							ClassName "ClassName",
							NumberOfProperties "NumberOfProperties",
							Weight "Weight",
							PropertyList "PropertyList"
					FROM a
					WHERE DirectMatch = 0
					FOR XML PATH('Match'), TYPE
				) "IndirectMatchList"				
		FOR XML PATH(''), TYPE
	)
	
	--SELECT @ConnectionDetailsXML ConnectionDetails
	--SELECT * FROM #PhraseNodeMap


	-------------------------------------------------------
	-- Get RDF of the NodeID
	-------------------------------------------------------

	DECLARE @ObjectNodeRDF NVARCHAR(MAX)
	
	EXEC [RDF.].GetDataRDF	@subject = @NodeID,
							@showDetails = 0,
							@expand = 0,
							@SessionID = @SessionID,
							@returnXML = 0,
							@dataStr = @ObjectNodeRDF OUTPUT


	-------------------------------------------------------
	-- Form search results details RDF
	-------------------------------------------------------

	DECLARE @results NVARCHAR(MAX)

	SELECT @results = ''
			+'<rdf:Description rdf:nodeID="SearchResultsDetails">'
			+'<rdf:type rdf:resource="http://profiles.catalyst.harvard.edu/ontology/prns#Connection" />'
			+'<prns:connectionInNetwork rdf:NodeID="SearchResults" />'
			--+'<prns:connectionWeight>0.37744</prns:connectionWeight>'
			+'<prns:hasConnectionDetails rdf:NodeID="ConnectionDetails" />'
			+'<rdf:object rdf:resource="'+@NodeURI+'" />'
			+'<rdfs:label>Search Results Details</rdfs:label>'
			+'</rdf:Description>'
			+'<rdf:Description rdf:nodeID="SearchResults">'
			+'<rdf:type rdf:resource="http://profiles.catalyst.harvard.edu/ontology/prns#Network" />'
			+'<rdfs:label>Search Results</rdfs:label>'
			+'<vivo:overview rdf:parseType="Literal">'
			+CAST(@SearchOptions AS NVARCHAR(MAX))
			+IsNull('<SearchDetails>'+CAST(@SearchPhraseXML AS NVARCHAR(MAX))+'</SearchDetails>','')
			+'</vivo:overview>'
			+'<prns:hasConnection rdf:nodeID="SearchResultsDetails" />'
			+'</rdf:Description>'
			+IsNull(@ObjectNodeRDF,'')
			+'<rdf:Description rdf:NodeID="ConnectionDetails">'
			+'<rdf:type rdf:resource="http://profiles.catalyst.harvard.edu/ontology/prns#ConnectionDetails" />'
			+'<vivo:overview rdf:parseType="Literal">'
			+CAST(@ConnectionDetailsXML AS NVARCHAR(MAX))
			+'</vivo:overview>'
			+'</rdf:Description> '

	declare @x as varchar(max)
	select @x = '<rdf:RDF'
	select @x = @x + ' xmlns:'+Prefix+'="'+URI+'"' 
		from [Ontology.].Namespace
	select @x = @x + ' >' + @results + '</rdf:RDF>'
	select cast(@x as xml) RDF


END
GO
