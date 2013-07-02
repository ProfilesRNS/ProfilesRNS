SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Search.].[LookupNodes]
	@SearchOptions XML,
	@SessionID UNIQUEIDENTIFIER = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	/********************************************************************
	
	This procedure provides secure, real-time search for editing and
	administrative functions. It gets called in the same way as the
	main GetNodes search procedure, but it has several differences:
	
	1) All nodes, including non-public nodes, are searched. The
		user's SessionID determines which non-public nodes are
		returned.
	2) No cache tables are used. Changes to Nodes and Triples are
		immediately available to this procedure. Though, there could
		be a delay caused by the time it takes fulltext search indexes
		to be updated.
	3) Only node labels (not the full content of a profile) are 
		searched. As a result, fewer nodes are matched by a search
		string.
	4) There are fewer search options. In particular, class group,
		search filters, and sort options are not supported.
	5) Data is returned as XML, not RDF.
	
	Below are examples:

	-- Return all people named "Smith"
	EXEC [Search.].[LookupNodes] @SearchOptions = '
		<SearchOptions>
			<MatchOptions>
				<SearchString>Smith</SearchString>
				<ClassURI>http://xmlns.com/foaf/0.1/Person</ClassURI>
			</MatchOptions>
			<OutputOptions>
				<Offset>0</Offset>
				<Limit>5</Limit>
			</OutputOptions>	
		</SearchOptions>
		'

	-- Return publications about "lung cancer"
	EXEC [Search.].[LookupNodes] @SearchOptions = '
		<SearchOptions>
			<MatchOptions>
				<SearchString>lung cancer</SearchString>
				<ClassURI>http://purl.org/ontology/bibo/AcademicArticle</ClassURI>
			</MatchOptions>
			<OutputOptions>
				<Offset>5</Offset>
				<Limit>10</Limit>
			</OutputOptions>	
		</SearchOptions>
		'

	-- Return all departments
	EXEC [Search.].[LookupNodes] @SearchOptions = '
		<SearchOptions>
			<MatchOptions>
				<ClassURI>http://vivoweb.org/ontology/core#Department</ClassURI>
			</MatchOptions>
			<OutputOptions>
				<Offset>0</Offset>
				<Limit>25</Limit>
			</OutputOptions>	
		</SearchOptions>
		'

	********************************************************************/

	-- start timer
	declare @d datetime
	select @d = GetDate()

	-- declare variables
	declare @MatchOptions xml
	declare @OutputOptions xml
	declare @SearchString varchar(500)
	declare @ClassURI varchar(400)
	declare @offset bigint
	declare @limit bigint
	declare @baseURI nvarchar(400)
	declare @typeID bigint
	declare @labelID bigint
	declare @classID bigint
	declare @CombinedSearchString VARCHAR(8000)

	-- set constants
	select @baseURI = value from [Framework.].Parameter where ParameterID = 'baseURI'
	select @typeID = [RDF.].fnURI2NodeID('http://www.w3.org/1999/02/22-rdf-syntax-ns#type')
	select @labelID = [RDF.].fnURI2NodeID('http://www.w3.org/2000/01/rdf-schema#label')

	-- parse input
	select	@MatchOptions = @SearchOptions.query('SearchOptions[1]/MatchOptions[1]'),
			@OutputOptions = @SearchOptions.query('SearchOptions[1]/OutputOptions[1]')
	select	@SearchString = @MatchOptions.value('MatchOptions[1]/SearchString[1]','varchar(500)'),
			@ClassURI = @MatchOptions.value('MatchOptions[1]/ClassURI[1]','varchar(400)'),
			@offset = @OutputOptions.value('OutputOptions[1]/Offset[1]','bigint'),
			@limit = @OutputOptions.value('OutputOptions[1]/Limit[1]','bigint')
	if @ClassURI is not null
		select @classID = [RDF.].fnURI2NodeID(@ClassURI)
	if @SearchString is not null
		EXEC [Search.].[ParseSearchString]	@SearchString = @SearchString,
											@CombinedSearchString = @CombinedSearchString OUTPUT

	-- get security information
	DECLARE @SecurityGroupID BIGINT, @HasSpecialViewAccess BIT
	EXEC [RDF.Security].GetSessionSecurityGroup @SessionID, @SecurityGroupID OUTPUT, @HasSpecialViewAccess OUTPUT
	CREATE TABLE #SecurityGroupNodes (SecurityGroupNode BIGINT PRIMARY KEY)
	INSERT INTO #SecurityGroupNodes (SecurityGroupNode) EXEC [RDF.Security].GetSessionSecurityGroupNodes @SessionID


	-- get a list of possible classes
	create table #c (ClassNode bigint primary key, TreeDepth int, ClassName varchar(400))
	insert into #c (ClassNode, TreeDepth, ClassName)
		select _ClassNode, _TreeDepth, _ClassName
		from [Ontology.].ClassTreeDepth
		where _ClassNode = IsNull(@classID,_ClassNode)

	
	-- CASE 1: A search string was provided
	IF IsNull(@CombinedSearchString,'') <> ''
	BEGIN
		;with a as (
			select NodeID, Label, ClassName, URI, ConnectionWeight,
					row_number() over (order by Label, NodeID) SortOrder
				from (
					select (case when len(m.Value)>500 then left(m.Value,497)+'...' else m.Value end) Label, 
						n.NodeID, n.value URI, c.ClassName ClassName, x.[Rank]*0.001 ConnectionWeight,
						row_number() over (partition by n.NodeID order by c.TreeDepth desc) k
					from Containstable ([RDF.].Node, value, @CombinedSearchString) x
						inner join [RDF.].Node m -- text node
							on x.[Key] = m.NodeID
								and ((m.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (m.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (m.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)))
						inner join [RDF.].Triple t -- match label
							on t.object = m.NodeID
								and t.predicate = @labelID
								and ((t.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (t.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (t.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)))
						inner join [RDF.].Node n -- match node
							on n.NodeID = t.subject
								and ((n.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (n.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (n.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)))
						inner join [RDF.].Triple v -- class
							on v.subject = n.NodeID
								and v.predicate = @typeID
								and ((v.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (v.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (v.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)))
						inner join #c c -- class name
							on c.ClassNode = v.object
				) t
				where k = 1
		)
		select (
				select	@SearchString "SearchString",
						@ClassURI "ClassURI",
						@offset "offset",
						@limit "limit",
						(select count(*) from a) "NumberOfConnections",
						(
							select	SortOrder "Connection/@SortOrder",
									NodeID "Connection/@NodeID",
									ClassName "Connection/@ClassName", 
									URI "Connection/@URI",
									ConnectionWeight "Connection/@ConnectionWeight",
									Label "Connection"
							from a
							where SortOrder >= (IsNull(@offset,0) + 1) AND SortOrder <= (IsNull(@offset,0) + IsNull(@limit,SortOrder))
							order by SortOrder
							for xml path(''), type
						) "Network"
					for xml path('SearchResults'), type
			) SearchResults
	END


	-- CASE 2: A Class, but no search string, was provided
	IF (IsNull(@CombinedSearchString,'') = '') AND (@classID IS NOT NULL)
	BEGIN
		;with a as (
			select NodeID, Label, ClassName, URI, 1 ConnectionWeight,
					row_number() over (order by Label, NodeID) SortOrder
				from (
					select (case when len(m.Value)>500 then left(m.Value,497)+'...' else m.Value end) Label, 
						n.NodeID, n.value URI, c.ClassName ClassName,
						row_number() over (partition by n.NodeID order by m.NodeID desc) k
					from #c c
						inner join [RDF.].Triple v -- class
							on v.object = c.ClassNode
								and v.predicate = @typeID
								and ((v.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (v.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (v.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)))
						inner join [RDF.].Node n -- match node
							on n.NodeID = v.subject
								and ((n.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (n.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (n.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)))
						inner join [RDF.].Triple t -- match label
							on t.subject = n.NodeID
								and t.predicate = @labelID
								and ((t.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (t.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (t.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)))
						inner join [RDF.].Node m -- text node
							on m.NodeID = t.object
								and ((m.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (m.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (m.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)))
				) t
				where k = 1
		)
		select (
				select	@SearchString "SearchString",
						@ClassURI "ClassURI",
						@offset "offset",
						@limit "limit",
						(select count(*) from a) "NumberOfConnections",
						(
							select	SortOrder "Connection/@SortOrder",
									NodeID "Connection/@NodeID",
									ClassName "Connection/@ClassName", 
									URI "Connection/@URI",
									ConnectionWeight "Connection/@ConnectionWeight",
									Label "Connection"
							from a
							where SortOrder >= (IsNull(@offset,0) + 1) AND SortOrder <= (IsNull(@offset,0) + IsNull(@limit,SortOrder))
							order by SortOrder
							for xml path(''), type
						) "Network"
					for xml path('SearchResults'), type
			) SearchResults	
	END


END
GO
