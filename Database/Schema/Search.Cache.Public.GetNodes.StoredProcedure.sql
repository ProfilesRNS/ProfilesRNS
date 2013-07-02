SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Search.Cache].[Public.GetNodes]
	@SearchOptions XML,
	@SessionID UNIQUEIDENTIFIER = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

	/*
	
	EXEC [Search.].[GetNodes] @SearchOptions = '
	<SearchOptions>
		<MatchOptions>
			<SearchString ExactMatch="false">options for "lung cancer" treatment</SearchString>
			<ClassURI>http://xmlns.com/foaf/0.1/Person</ClassURI>
			<SearchFiltersList>
				<SearchFilter Property="http://xmlns.com/foaf/0.1/lastName" MatchType="Left">Smit</SearchFilter>
			</SearchFiltersList>
		</MatchOptions>
		<OutputOptions>
			<Offset>0</Offset>
			<Limit>5</Limit>
			<SortByList>
				<SortBy IsDesc="1" Property="http://xmlns.com/foaf/0.1/firstName" />
				<SortBy IsDesc="0" Property="http://xmlns.com/foaf/0.1/lastName" />
			</SortByList>
		</OutputOptions>	
	</SearchOptions>
	'
		
	*/

	declare @MatchOptions xml
	declare @OutputOptions xml
	declare @SearchString varchar(500)
	declare @ClassGroupURI varchar(400)
	declare @ClassURI varchar(400)
	declare @SearchFiltersXML xml
	declare @offset bigint
	declare @limit bigint
	declare @SortByXML xml
	declare @DoExpandedSearch bit
	
	select	@MatchOptions = @SearchOptions.query('SearchOptions[1]/MatchOptions[1]'),
			@OutputOptions = @SearchOptions.query('SearchOptions[1]/OutputOptions[1]')
	
	select	@SearchString = @MatchOptions.value('MatchOptions[1]/SearchString[1]','varchar(500)'),
			@DoExpandedSearch = (case when @MatchOptions.value('MatchOptions[1]/SearchString[1]/@ExactMatch','varchar(50)') = 'true' then 0 else 1 end),
			@ClassGroupURI = @MatchOptions.value('MatchOptions[1]/ClassGroupURI[1]','varchar(400)'),
			@ClassURI = @MatchOptions.value('MatchOptions[1]/ClassURI[1]','varchar(400)'),
			@SearchFiltersXML = @MatchOptions.query('MatchOptions[1]/SearchFiltersList[1]'),
			@offset = @OutputOptions.value('OutputOptions[1]/Offset[1]','bigint'),
			@limit = @OutputOptions.value('OutputOptions[1]/Limit[1]','bigint'),
			@SortByXML = @OutputOptions.query('OutputOptions[1]/SortByList[1]')

	declare @baseURI nvarchar(400)
	select @baseURI = value from [Framework.].Parameter where ParameterID = 'baseURI'

	declare @d datetime
	select @d = GetDate()
	
	declare @IsBot bit
	if @SessionID is not null
		select @IsBot = IsBot
			from [User.Session].[Session]
			where SessionID = @SessionID
	select @IsBot = IsNull(@IsBot,0)

	select @limit = 100
		where (@limit is null) or (@limit > 100)
	
	declare @SearchHistoryQueryID int
	insert into [Search.].[History.Query] (StartDate, SessionID, IsBot, SearchOptions)
		select GetDate(), @SessionID, @IsBot, @SearchOptions
	select @SearchHistoryQueryID = @@IDENTITY

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

	--SELECT @NumberOfPhrases, @CombinedSearchString, @SearchPhraseXML, @SearchPhraseFormsXML, @ParseProcessTime
	--SELECT * FROM @PhraseList
	--select datediff(ms,@d,GetDate())


	-------------------------------------------------------
	-- Parse search filters
	-------------------------------------------------------

	create table #SearchFilters (
		SearchFilterID int identity(0,1) primary key,
		IsExclude bit,
		PropertyURI varchar(400),
		PropertyURI2 varchar(400),
		MatchType varchar(100),
		Value varchar(750),
		Predicate bigint,
		Predicate2 bigint
	)
	
	insert into #SearchFilters (IsExclude, PropertyURI, PropertyURI2, MatchType, Value, Predicate, Predicate2)	
		select t.IsExclude, t.PropertyURI, t.PropertyURI2, t.MatchType, t.Value,
				--left(t.Value,750)+(case when t.MatchType='Left' then '%' else '' end),
				t.Predicate, t.Predicate2
			from (
				select IsNull(IsExclude,0) IsExclude, PropertyURI, PropertyURI2, MatchType, Value,
					[RDF.].fnURI2NodeID(PropertyURI) Predicate,
					[RDF.].fnURI2NodeID(PropertyURI2) Predicate2
				from (
					select distinct S.x.value('@IsExclude','bit') IsExclude,
							S.x.value('@Property','varchar(400)') PropertyURI,
							S.x.value('@Property2','varchar(400)') PropertyURI2,
							S.x.value('@MatchType','varchar(100)') MatchType,
							--S.x.value('.','nvarchar(max)') Value
							(case when cast(S.x.query('./*') as nvarchar(max)) <> '' then cast(S.x.query('./*') as nvarchar(max)) else S.x.value('.','nvarchar(max)') end) Value
					from @SearchFiltersXML.nodes('//SearchFilter') as S(x)
				) t
			) t
			where t.Value IS NOT NULL and t.Value <> ''
			
	declare @NumberOfIncludeFilters int
	select @NumberOfIncludeFilters = IsNull((select count(*) from #SearchFilters where IsExclude=0),0)

	-------------------------------------------------------
	-- Parse sort by options
	-------------------------------------------------------

	create table #SortBy (
		SortByID int identity(1,1) primary key,
		IsDesc bit,
		PropertyURI varchar(400),
		PropertyURI2 varchar(400),
		PropertyURI3 varchar(400),
		Predicate bigint,
		Predicate2 bigint,
		Predicate3 bigint
	)
	
	insert into #SortBy (IsDesc, PropertyURI, PropertyURI2, PropertyURI3, Predicate, Predicate2, Predicate3)	
		select IsNull(IsDesc,0), PropertyURI, PropertyURI2, PropertyURI3,
				[RDF.].fnURI2NodeID(PropertyURI) Predicate,
				[RDF.].fnURI2NodeID(PropertyURI2) Predicate2,
				[RDF.].fnURI2NodeID(PropertyURI3) Predicate3
			from (
				select S.x.value('@IsDesc','bit') IsDesc,
						S.x.value('@Property','varchar(400)') PropertyURI,
						S.x.value('@Property2','varchar(400)') PropertyURI2,
						S.x.value('@Property3','varchar(400)') PropertyURI3
				from @SortByXML.nodes('//SortBy') as S(x)
			) t

	-------------------------------------------------------
	-- Get initial list of matching nodes (before filters)
	-------------------------------------------------------

	create table #FullNodeMatch (
		NodeID bigint not null,
		Paths bigint,
		Weight float
	)

	if @CombinedSearchString <> ''
	begin

		-- Get nodes that match separate phrases
		create table #PhraseNodeMatch (
			PhraseID int not null,
			NodeID bigint not null,
			Paths bigint,
			Weight float
		)
		if (@NumberOfPhrases > 1) and (@DoExpandedSearch = 1)
		begin
			declare @PhraseSearchString varchar(8000)
			declare @loop int
			select @loop = 1
			while @loop <= @NumberOfPhrases
			begin
				select @PhraseSearchString = Forms
					from @PhraseList
					where PhraseID = @loop
				-- New code replacing commented out section below.
				select [Key] NodeID, [Rank]*0.000999+0.001 Weight
					into #NodeRankTemp
					from Containstable ([RDF.].Node, value, @PhraseSearchString) n
						inner join [RDF.].[Node] t on n.[Key] = t.NodeID and t.ObjectType = 1
				alter table #NodeRankTemp add primary key (NodeID)
				insert into #PhraseNodeMatch (PhraseID, NodeID, Paths, Weight)
					select @loop, s.NodeID, count(*) Paths, 1-exp(sum(log(case when s.Weight*m.Weight > 0.999999 then 0.000001 else 1-s.Weight*m.Weight end))) Weight
						from [Search.Cache].[Public.NodeMap] s, #NodeRankTemp m
						where s.MatchedByNodeID = m.NodeID
						group by s.NodeID
				drop table #NodeRankTemp
				/*
				insert into #PhraseNodeMatch (PhraseID, NodeID, Paths, Weight)
					select @loop, s.NodeID, count(*) Paths, 1-exp(sum(log(case when s.Weight*m.Weight > 0.999999 then 0.000001 else 1-s.Weight*m.Weight end))) Weight
						from [Search.Cache].[Public.NodeMap] s, (
							select [Key] NodeID, [Rank]*0.001 Weight
								from Containstable ([RDF.].Node, value, @PhraseSearchString) n
						) m
						where s.MatchedByNodeID = m.NodeID
						group by s.NodeID
				*/
				select @loop = @loop + 1
			end
			--create clustered index idx_n on #PhraseNodeMatch(NodeID)
		end

		create table #TempMatchNodes (
			NodeID bigint,
			MatchedByNodeID bigint,
			Distance int,
			Paths int,
			Weight float,
			mWeight float
		)
		-- New code replacing commented out section below.
		select [Key] NodeID, [Rank]*0.000999+0.001 Weight
			into #NodeRankTemp2
			from Containstable ([RDF.].Node, value, @CombinedSearchString) n
				inner join [RDF.].[Node] t on n.[Key] = t.NodeID and t.ObjectType = 1
		alter table #NodeRankTemp2 add primary key (NodeID)
		insert into #TempMatchNodes (NodeID, MatchedByNodeID, Distance, Paths, Weight, mWeight)
			select s.*, m.Weight mWeight
				from [Search.Cache].[Public.NodeMap] s, #NodeRankTemp2 m
				where s.MatchedByNodeID = m.NodeID
		drop table #NodeRankTemp2
		/*
		insert into #TempMatchNodes (NodeID, MatchedByNodeID, Distance, Paths, Weight, mWeight)
			select s.*, m.Weight mWeight
				from [Search.Cache].[Public.NodeMap] s, (
					select [Key] NodeID, [Rank]*0.001 Weight
						from Containstable ([RDF.].Node, value, @CombinedSearchString) n
				) m
				where s.MatchedByNodeID = m.NodeID
		*/

		insert into #FullNodeMatch (NodeID, Paths, Weight)
			select IsNull(a.NodeID,b.NodeID) NodeID, IsNull(a.Paths,b.Paths) Paths,
					(case when a.weight is null or b.weight is null then IsNull(a.Weight,b.Weight) else 1-(1-a.Weight)*(1-b.Weight) end) Weight
				from (
					select NodeID, exp(sum(log(Paths))) Paths, exp(sum(log(Weight))) Weight
						from #PhraseNodeMatch
						group by NodeID
						having count(*) = @NumberOfPhrases
				) a full outer join (
					select NodeID, count(*) Paths, 1-exp(sum(log(case when Weight*mWeight > 0.999999 then 0.000001 else 1-Weight*mWeight end))) Weight
						from #TempMatchNodes
						group by NodeID
				) b on a.NodeID = b.NodeID
		--select 'Text Matches Found', datediff(ms,@d,getdate())
	end
	else if (@NumberOfIncludeFilters > 0)
	begin
		insert into #FullNodeMatch (NodeID, Paths, Weight)
			select t1.Subject, 1, 1
				from #SearchFilters f
					inner join [RDF.].Triple t1
						on f.Predicate is not null
							and t1.Predicate = f.Predicate 
							and t1.ViewSecurityGroup = -1
					left outer join [Search.Cache].[Public.NodePrefix] n1
						on n1.NodeID = t1.Object
					left outer join [RDF.].Triple t2
						on f.Predicate2 is not null
							and t2.Subject = n1.NodeID
							and t2.Predicate = f.Predicate2
							and t2.ViewSecurityGroup = -1
					left outer join [Search.Cache].[Public.NodePrefix] n2
						on n2.NodeID = t2.Object
				where f.IsExclude = 0
					and 1 = (case	when (f.Predicate2 is not null) then
										(case	when f.MatchType = 'Left' then
													(case when n2.Prefix like f.Value+'%' then 1 else 0 end)
												when f.MatchType = 'In' then
													(case when n2.Prefix in (select r.x.value('.','varchar(max)') v from (select cast(f.Value as xml) x) t cross apply x.nodes('//Item') as r(x)) then 1 else 0 end)
												else
													(case when n2.Prefix = f.Value then 1 else 0 end)
												end)
									else
										(case	when f.MatchType = 'Left' then
													(case when n1.Prefix like f.Value+'%' then 1 else 0 end)
												when f.MatchType = 'In' then
													(case when n1.Prefix in (select r.x.value('.','varchar(max)') v from (select cast(f.Value as xml) x) t cross apply x.nodes('//Item') as r(x)) then 1 else 0 end)
												else
													(case when n1.Prefix = f.Value then 1 else 0 end)
												end)
									end)
					--and (case when f.Predicate2 is not null then n2.Prefix else n1.Prefix end)
					--	like f.Value
				group by t1.Subject
				having count(distinct f.SearchFilterID) = @NumberOfIncludeFilters
		delete from #SearchFilters where IsExclude = 0
		select @NumberOfIncludeFilters = 0
	end
	else if (IsNull(@ClassGroupURI,'') <> '' or IsNull(@ClassURI,'') <> '')
	begin
		insert into #FullNodeMatch (NodeID, Paths, Weight)
			select distinct n.NodeID, 1, 1
				from [Search.Cache].[Public.NodeClass] n, [Ontology.].ClassGroupClass c
				where n.Class = c._ClassNode
					and ((@ClassGroupURI is null) or (c.ClassGroupURI = @ClassGroupURI))
					and ((@ClassURI is null) or (c.ClassURI = @ClassURI))
		select @ClassGroupURI = null, @ClassURI = null
	end

	-------------------------------------------------------
	-- Run the actual search
	-------------------------------------------------------
	create table #Node (
		SortOrder bigint identity(0,1) primary key,
		NodeID bigint,
		Paths bigint,
		Weight float
	)

	insert into #Node (NodeID, Paths, Weight)
		select s.NodeID, s.Paths, s.Weight
			from #FullNodeMatch s
				inner join [Search.Cache].[Public.NodeSummary] n on
					s.NodeID = n.NodeID
					and ( IsNull(@ClassGroupURI,@ClassURI) is null or s.NodeID in (
							select NodeID
								from [Search.Cache].[Public.NodeClass] x, [Ontology.].ClassGroupClass c
								where x.Class = c._ClassNode
									and c.ClassGroupURI = IsNull(@ClassGroupURI,c.ClassGroupURI)
									and c.ClassURI = IsNull(@ClassURI,c.ClassURI)
						) )
					and ( @NumberOfIncludeFilters =
							(select count(distinct f.SearchFilterID)
								from #SearchFilters f
									inner join [RDF.].Triple t1
										on f.Predicate is not null
											and t1.Subject = s.NodeID
											and t1.Predicate = f.Predicate 
											and t1.ViewSecurityGroup = -1
									left outer join [Search.Cache].[Public.NodePrefix] n1
										on n1.NodeID = t1.Object
									left outer join [RDF.].Triple t2
										on f.Predicate2 is not null
											and t2.Subject = n1.NodeID
											and t2.Predicate = f.Predicate2
											and t2.ViewSecurityGroup = -1
									left outer join [Search.Cache].[Public.NodePrefix] n2
										on n2.NodeID = t2.Object
								where f.IsExclude = 0
									and 1 = (case	when (f.Predicate2 is not null) then
														(case	when f.MatchType = 'Left' then
																	(case when n2.Prefix like f.Value+'%' then 1 else 0 end)
																when f.MatchType = 'In' then
																	(case when n2.Prefix in (select r.x.value('.','varchar(max)') v from (select cast(f.Value as xml) x) t cross apply x.nodes('//Item') as r(x)) then 1 else 0 end)
																else
																	(case when n2.Prefix = f.Value then 1 else 0 end)
																end)
													else
														(case	when f.MatchType = 'Left' then
																	(case when n1.Prefix like f.Value+'%' then 1 else 0 end)
																when f.MatchType = 'In' then
																	(case when n1.Prefix in (select r.x.value('.','varchar(max)') v from (select cast(f.Value as xml) x) t cross apply x.nodes('//Item') as r(x)) then 1 else 0 end)
																else
																	(case when n1.Prefix = f.Value then 1 else 0 end)
																end)
													end)
									--and (case when f.Predicate2 is not null then n2.Prefix else n1.Prefix end)
									--	like f.Value
							)
						)
					and not exists (
							select *
								from #SearchFilters f
									inner join [RDF.].Triple t1
										on f.Predicate is not null
											and t1.Subject = s.NodeID
											and t1.Predicate = f.Predicate 
											and t1.ViewSecurityGroup = -1
									left outer join [Search.Cache].[Public.NodePrefix] n1
										on n1.NodeID = t1.Object
									left outer join [RDF.].Triple t2
										on f.Predicate2 is not null
											and t2.Subject = n1.NodeID
											and t2.Predicate = f.Predicate2
											and t2.ViewSecurityGroup = -1
									left outer join [Search.Cache].[Public.NodePrefix] n2
										on n2.NodeID = t2.Object
								where f.IsExclude = 1
									and 1 = (case	when (f.Predicate2 is not null) then
														(case	when f.MatchType = 'Left' then
																	(case when n2.Prefix like f.Value+'%' then 1 else 0 end)
																when f.MatchType = 'In' then
																	(case when n2.Prefix in (select r.x.value('.','varchar(max)') v from (select cast(f.Value as xml) x) t cross apply x.nodes('//Item') as r(x)) then 1 else 0 end)
																else
																	(case when n2.Prefix = f.Value then 1 else 0 end)
																end)
													else
														(case	when f.MatchType = 'Left' then
																	(case when n1.Prefix like f.Value+'%' then 1 else 0 end)
																when f.MatchType = 'In' then
																	(case when n1.Prefix in (select r.x.value('.','varchar(max)') v from (select cast(f.Value as xml) x) t cross apply x.nodes('//Item') as r(x)) then 1 else 0 end)
																else
																	(case when n1.Prefix = f.Value then 1 else 0 end)
																end)
													end)
									--and (case when f.Predicate2 is not null then n2.Prefix else n1.Prefix end)
									--	like f.Value
						)
				outer apply (
					select	max(case when SortByID=1 then AscSortBy else null end) AscSortBy1,
							max(case when SortByID=2 then AscSortBy else null end) AscSortBy2,
							max(case when SortByID=3 then AscSortBy else null end) AscSortBy3,
							max(case when SortByID=1 then DescSortBy else null end) DescSortBy1,
							max(case when SortByID=2 then DescSortBy else null end) DescSortBy2,
							max(case when SortByID=3 then DescSortBy else null end) DescSortBy3
						from (
							select	SortByID,
									(case when f.IsDesc = 1 then null
											when f.Predicate3 is not null then n3.Value
											when f.Predicate2 is not null then n2.Value
											else n1.Value end) AscSortBy,
									(case when f.IsDesc = 0 then null
											when f.Predicate3 is not null then n3.Value
											when f.Predicate2 is not null then n2.Value
											else n1.Value end) DescSortBy
								from #SortBy f
									inner join [RDF.].Triple t1
										on f.Predicate is not null
											and t1.Subject = s.NodeID
											and t1.Predicate = f.Predicate 
											and t1.ViewSecurityGroup = -1
									left outer join [RDF.].Node n1
										on n1.NodeID = t1.Object
											and n1.ViewSecurityGroup = -1
									left outer join [RDF.].Triple t2
										on f.Predicate2 is not null
											and t2.Subject = n1.NodeID
											and t2.Predicate = f.Predicate2
											and t2.ViewSecurityGroup = -1
									left outer join [RDF.].Node n2
										on n2.NodeID = t2.Object
											and n2.ViewSecurityGroup = -1
									left outer join [RDF.].Triple t3
										on f.Predicate3 is not null
											and t3.Subject = n2.NodeID
											and t3.Predicate = f.Predicate3
											and t3.ViewSecurityGroup = -1
									left outer join [RDF.].Node n3
										on n3.NodeID = t3.Object
											and n3.ViewSecurityGroup = -1
							) t
					) o
			order by	(case when o.AscSortBy1 is null then 1 else 0 end),
						o.AscSortBy1,
						(case when o.DescSortBy1 is null then 1 else 0 end),
						o.DescSortBy1 desc,
						(case when o.AscSortBy2 is null then 1 else 0 end),
						o.AscSortBy2,
						(case when o.DescSortBy2 is null then 1 else 0 end),
						o.DescSortBy2 desc,
						(case when o.AscSortBy3 is null then 1 else 0 end),
						o.AscSortBy3,
						(case when o.DescSortBy3 is null then 1 else 0 end),
						o.DescSortBy3 desc,
						s.Weight desc,
						n.ShortLabel,
						n.NodeID


	--select 'Search Nodes Found', datediff(ms,@d,GetDate())

	-------------------------------------------------------
	-- Get network counts
	-------------------------------------------------------

	declare @NumberOfConnections as bigint
	declare @MaxWeight as float
	declare @MinWeight as float

	select @NumberOfConnections = count(*), @MaxWeight = max(Weight), @MinWeight = min(Weight) 
		from #Node

	-------------------------------------------------------
	-- Get matching class groups and classes
	-------------------------------------------------------

	declare @MatchesClassGroups nvarchar(max)

/*
	select c.ClassGroupURI, c.ClassURI, n.NodeID
		into #NodeClass
		from #Node n, [Search.Cache].[Public.NodeClass] s, [Ontology.].ClassGroupClass c
		where n.NodeID = s.NodeID and s.Class = c._ClassNode
*/

	select n.NodeID, s.Class
		into #NodeClassTemp
		from #Node n
			inner join [Search.Cache].[Public.NodeClass] s
				on n.NodeID = s.NodeID
	select c.ClassGroupURI, c.ClassURI, n.NodeID
		into #NodeClass
		from #NodeClassTemp n
			inner join [Ontology.].ClassGroupClass c
				on n.Class = c._ClassNode

	;with a as (
		select ClassGroupURI, count(distinct NodeID) NumberOfNodes
			from #NodeClass s
			group by ClassGroupURI
	), b as (
		select ClassGroupURI, ClassURI, count(distinct NodeID) NumberOfNodes
			from #NodeClass s
			group by ClassGroupURI, ClassURI
	)
	select @MatchesClassGroups = replace(cast((
			select	g.ClassGroupURI "@rdf_.._resource", 
				g._ClassGroupLabel "rdfs_.._label",
				'http://www.w3.org/2001/XMLSchema#int' "prns_.._numberOfConnections/@rdf_.._datatype",
				a.NumberOfNodes "prns_.._numberOfConnections",
				g.SortOrder "prns_.._sortOrder",
				(
					select	c.ClassURI "@rdf_.._resource",
							c._ClassLabel "rdfs_.._label",
							'http://www.w3.org/2001/XMLSchema#int' "prns_.._numberOfConnections/@rdf_.._datatype",
							b.NumberOfNodes "prns_.._numberOfConnections",
							c.SortOrder "prns_.._sortOrder"
						from b, [Ontology.].ClassGroupClass c
						where b.ClassGroupURI = c.ClassGroupURI and b.ClassURI = c.ClassURI
							and c.ClassGroupURI = g.ClassGroupURI
						order by c.SortOrder
						for xml path('prns_.._matchesClass'), type
				)
			from a, [Ontology.].ClassGroup g
			where a.ClassGroupURI = g.ClassGroupURI and g.IsVisible = 1
			order by g.SortOrder
			for xml path('prns_.._matchesClassGroup'), type
		) as nvarchar(max)),'_.._',':')

	-------------------------------------------------------
	-- Get RDF of search results objects
	-------------------------------------------------------

	declare @ObjectNodesRDF nvarchar(max)

	if @NumberOfConnections > 0
	begin
		/*
			-- Alternative methods that uses GetDataRDF to get the RDF
			declare @NodeListXML xml
			select @NodeListXML = (
					select (
							select NodeID "@ID"
							from #Node
							where SortOrder >= IsNull(@offset,0) and SortOrder < IsNull(IsNull(@offset,0)+@limit,SortOrder+1)
							order by SortOrder
							for xml path('Node'), type
							)
					for xml path('NodeList'), type
				)
			exec [RDF.].GetDataRDF @NodeListXML = @NodeListXML, @expand = 1, @showDetails = 0, @returnXML = 0, @dataStr = @ObjectNodesRDF OUTPUT
		*/
		create table #OutputNodes (
			NodeID bigint primary key,
			k int
		)
		insert into #OutputNodes (NodeID,k)
			SELECT DISTINCT  NodeID,0
			from #Node
			where SortOrder >= IsNull(@offset,0) and SortOrder < IsNull(IsNull(@offset,0)+@limit,SortOrder+1)
		declare @k int
		select @k = 0
		while @k < 10
		begin
			insert into #OutputNodes (NodeID,k)
				select distinct e.ExpandNodeID, @k+1
				from #OutputNodes o, [Search.Cache].[Public.NodeExpand] e
				where o.k = @k and o.NodeID = e.NodeID
					and e.ExpandNodeID not in (select NodeID from #OutputNodes)
			if @@ROWCOUNT = 0
				select @k = 10
			else
				select @k = @k + 1
		end
		select @ObjectNodesRDF = replace(replace(cast((
				select r.RDF + ''
				from #OutputNodes n, [Search.Cache].[Public.NodeRDF] r
				where n.NodeID = r.NodeID
				order by n.NodeID
				for xml path(''), type
			) as nvarchar(max)),'_TAGLT_','<'),'_TAGGT_','>')
	end


	-------------------------------------------------------
	-- Form search results RDF
	-------------------------------------------------------

	declare @results nvarchar(max)

	select @results = ''
			+'<rdf:Description rdf:nodeID="SearchResults">'
			+'<rdf:type rdf:resource="http://profiles.catalyst.harvard.edu/ontology/prns#Network" />'
			+'<rdfs:label>Search Results</rdfs:label>'
			+'<prns:numberOfConnections rdf:datatype="http://www.w3.org/2001/XMLSchema#int">'+cast(IsNull(@NumberOfConnections,0) as nvarchar(50))+'</prns:numberOfConnections>'
			+'<prns:offset rdf:datatype="http://www.w3.org/2001/XMLSchema#int"' + IsNull('>'+cast(@offset as nvarchar(50))+'</prns:offset>',' />')
			+'<prns:limit rdf:datatype="http://www.w3.org/2001/XMLSchema#int"' + IsNull('>'+cast(@limit as nvarchar(50))+'</prns:limit>',' />')
			+'<prns:maxWeight rdf:datatype="http://www.w3.org/2001/XMLSchema#float"' + IsNull('>'+cast(@MaxWeight as nvarchar(50))+'</prns:maxWeight>',' />')
			+'<prns:minWeight rdf:datatype="http://www.w3.org/2001/XMLSchema#float"' + IsNull('>'+cast(@MinWeight as nvarchar(50))+'</prns:minWeight>',' />')
			+'<vivo:overview rdf:parseType="Literal">'
			+IsNull(cast(@SearchOptions as nvarchar(max)),'')
			+'<SearchDetails>'+IsNull(cast(@SearchPhraseXML as nvarchar(max)),'')+'</SearchDetails>'
			+IsNull('<prns:matchesClassGroupsList>'+@MatchesClassGroups+'</prns:matchesClassGroupsList>','')
			+'</vivo:overview>'
			+IsNull((select replace(replace(cast((
					select '_TAGLT_prns:hasConnection rdf:nodeID="C'+cast(SortOrder as nvarchar(50))+'" /_TAGGT_'
					from #Node
					where SortOrder >= IsNull(@offset,0) and SortOrder < IsNull(IsNull(@offset,0)+@limit,SortOrder+1)
					order by SortOrder
					for xml path(''), type
				) as nvarchar(max)),'_TAGLT_','<'),'_TAGGT_','>')),'')
			+'</rdf:Description>'
			+IsNull((select replace(replace(cast((
					select ''
						+'_TAGLT_rdf:Description rdf:nodeID="C'+cast(x.SortOrder as nvarchar(50))+'"_TAGGT_'
						+'_TAGLT_prns:connectionWeight_TAGGT_'+cast(x.Weight as nvarchar(50))+'_TAGLT_/prns:connectionWeight_TAGGT_'
						+'_TAGLT_prns:sortOrder_TAGGT_'+cast(x.SortOrder as nvarchar(50))+'_TAGLT_/prns:sortOrder_TAGGT_'
						+'_TAGLT_rdf:object rdf:resource="'+replace(n.Value,'"','')+'"/_TAGGT_'
						+'_TAGLT_rdf:type rdf:resource="http://profiles.catalyst.harvard.edu/ontology/prns#Connection" /_TAGGT_'
						+'_TAGLT_rdfs:label_TAGGT_'+(case when s.ShortLabel<>'' then ltrim(rtrim(s.ShortLabel)) else 'Untitled' end)+'_TAGLT_/rdfs:label_TAGGT_'
						+IsNull(+'_TAGLT_vivo:overview_TAGGT_'+s.ClassName+'_TAGLT_/vivo:overview_TAGGT_','')
						+'_TAGLT_/rdf:Description_TAGGT_'
					from #Node x, [RDF.].Node n, [Search.Cache].[Public.NodeSummary] s
					where x.SortOrder >= IsNull(@offset,0) and x.SortOrder < IsNull(IsNull(@offset,0)+@limit,x.SortOrder+1)
						and x.NodeID = n.NodeID
						and x.NodeID = s.NodeID
					order by x.SortOrder
					for xml path(''), type
				) as nvarchar(max)),'_TAGLT_','<'),'_TAGGT_','>')),'')
			+IsNull(@ObjectNodesRDF,'')

	declare @x as varchar(max)
	select @x = '<rdf:RDF'
	select @x = @x + ' xmlns:'+Prefix+'="'+URI+'"' 
		from [Ontology.].Namespace
	select @x = @x + ' >' + @results + '</rdf:RDF>'
	select cast(@x as xml) RDF


	-------------------------------------------------------
	-- Log results
	-------------------------------------------------------

	update [Search.].[History.Query]
		set EndDate = GetDate(),
			DurationMS = datediff(ms,StartDate,GetDate()),
			NumberOfConnections = IsNull(@NumberOfConnections,0)
		where SearchHistoryQueryID = @SearchHistoryQueryID
	
	insert into [Search.].[History.Phrase] (SearchHistoryQueryID, PhraseID, ThesaurusMatch, Phrase, EndDate, IsBot, NumberOfConnections)
		select	@SearchHistoryQueryID,
				PhraseID,
				ThesaurusMatch,
				Phrase,
				GetDate(),
				@IsBot,
				IsNull(@NumberOfConnections,0)
			from @PhraseList

END
GO
