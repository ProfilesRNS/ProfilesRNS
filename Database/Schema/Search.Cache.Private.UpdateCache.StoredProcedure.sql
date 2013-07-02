SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Search.Cache].[Private.UpdateCache]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--------------------------------------------------
	-- Prepare lookup tables
	--------------------------------------------------

	-- Get a list of valid nodes
	create table #Node (
		NodeID bigint primary key
	)
	insert into #Node 
		select NodeID 
		from [RDF.].[Node] with (nolock)
		where ViewSecurityGroup between -30 and -1
	--[6776391 in 00:00:05]
	delete n
		from #Node n 
			inner join [RDF.].[Triple] t with (nolock)
				on n.NodeID = t.Reitification
	--[3186019 in 00:00:14]

	-- Get a list of valid classes
	create table #Class (
		ClassNode bigint primary key,
		TreeDepth int,
		ClassSort int,
		Searchable bit,
		ClassName varchar(400)
	)
	insert into #Class
		select c._ClassNode, c._TreeDepth,
				row_number() over (order by IsNull(c._TreeDepth,0) desc, c._ClassName),
				(case when c._ClassNode in (select _ClassNode from [Ontology.].ClassGroupClass) then 1 else 0 end),
				c._ClassName
			from [Ontology.].ClassTreeDepth c with (nolock)
				inner join #Node n
					on c._ClassNode = n.NodeID
			where c._ClassNode <> [RDF.].fnURI2NodeID('http://profiles.catalyst.harvard.edu/ontology/prns#Connection')
				and c._ClassNode <> [RDF.].fnURI2NodeID('http://profiles.catalyst.harvard.edu/ontology/prns#ConnectionDetails')
				and c._ClassNode <> [RDF.].fnURI2NodeID('http://profiles.catalyst.harvard.edu/ontology/prns#Network')

	-- Get a list of searchable properties
	create table #ClassPropertySearch (
		ClassNode bigint not null,
		PropertyNode bigint not null,
		SearchWeight float
	)
	alter table #ClassPropertySearch add primary key (ClassNode, PropertyNode)
	insert into #ClassPropertySearch
		select p._ClassNode ClassNode, p._PropertyNode PropertyNode, p.SearchWeight
			from [Ontology.].[ClassProperty] p with (nolock)
				inner join #Class c
					on p._ClassNode = c.ClassNode
				inner join #Node n
					on p._PropertyNode = n.NodeID
			where p._NetworkPropertyNode IS NULL
				and p.SearchWeight > 0

	-- Get a list of view properties
	create table #ClassPropertyView (
		ClassNode bigint not null,
		PropertyNode bigint not null,
		Limit int,
		IncludeDescription tinyint,
		TagName nvarchar(1000)
	)
	alter table #ClassPropertyView add primary key (ClassNode, PropertyNode)
	insert into #ClassPropertyView
		select p._ClassNode ClassNode, p._PropertyNode PropertyNode, p.Limit, p.IncludeDescription, p._TagName
			from [Ontology.].[ClassProperty] p with (nolock)
				inner join #Class c
					on p._ClassNode = c.ClassNode
				inner join #Node n
					on p._PropertyNode = n.NodeID
			where p._NetworkPropertyNode IS NULL
				and p.IsDetail = 0


	--------------------------------------------------
	-- NodeClass
	--------------------------------------------------

	create table #NodeClass (
		NodeID bigint not null,
		ClassNode bigint not null,
		ClassSort int,
		Searchable bit
	)
	alter table #NodeClass add primary key (NodeID, ClassNode)
	declare @typeID bigint
	select @typeID = [RDF.].fnURI2NodeID('http://www.w3.org/1999/02/22-rdf-syntax-ns#type')
	insert into #NodeClass
		select distinct n.NodeID, c.ClassNode, c.ClassSort, c.Searchable
			from [RDF.].[Triple] t with (nolock)
				inner join #Node n
					on t.Subject = n.NodeID
				inner join #Class c
					on t.Object = c.ClassNode
			where t.Predicate = @typeID
	--[2388097 in 00:00:06]
	create nonclustered index #c on #NodeClass (ClassNode) include (NodeID)
	--[00:00:02]
	create nonclustered index #s on #NodeClass (Searchable, ClassSort)
	--[00:00:05]


	--------------------------------------------------
	-- NodeMap
	--------------------------------------------------

	create table #NodeSearchProperty (
		NodeID bigint not null,
		PropertyNode bigint not null,
		SearchWeight float
	)
	alter table #NodeSearchProperty add primary key (NodeID, PropertyNode)
	insert into #NodeSearchProperty
		select n.NodeID, p.PropertyNode, max(p.SearchWeight) SearchWeight
			from #NodeClass n
				inner join #ClassPropertySearch p
					on n.ClassNode = p.ClassNode
			group by n.NodeID, p.PropertyNode
	--[7281981 in 00:00:17]

	create table #NodeMap (
		NodeID bigint not null,
		MatchedByNodeID bigint not null,
		Distance int,
		Paths int,
		Weight float
	)
	alter table #NodeMap add primary key (NodeID, MatchedByNodeID)

	insert into #NodeMap (NodeID, MatchedByNodeID, Distance, Paths, Weight)
		select x.NodeID, t.Object, 1, count(*), 1-exp(sum(log(case when x.SearchWeight*t.Weight > 0.999999 then 0.000001 else 1-x.SearchWeight*t.Weight end)))
			from [RDF.].[Triple] t with (nolock)
				inner join #NodeSearchProperty x
					on t.subject = x.NodeID
						and t.predicate = x.PropertyNode
				inner join #Node n
					on t.object = n.NodeID
			where x.SearchWeight*t.Weight > 0
				and t.ViewSecurityGroup between -30 and -1
			group by x.NodeID, t.object
	--[5540963 in 00:00:43]

	declare @i int
	select @i = 1
	while @i < 10
	begin
		insert into #NodeMap (NodeID, MatchedByNodeID, Distance, Paths, Weight)
			select s.NodeID, t.MatchedByNodeID, @i+1, count(*), 1-exp(sum(log(case when s.Weight*t.Weight > 0.999999 then 0.000001 else 1-s.Weight*t.Weight end)))
				from #NodeMap s, #NodeMap t
				where s.MatchedByNodeID = t.NodeID
					and s.Distance = @i
					and t.Distance = 1
					and t.NodeID <> s.NodeID
					and not exists (
						select *
						from #NodeMap u
						where u.NodeID = s.NodeID and u.MatchedByNodeID = t.MatchedByNodeID
					)
				group by s.NodeID, t.MatchedByNodeID
		if @@ROWCOUNT = 0
			select @i = 10
		select @i = @i + 1
	end
	--[11421133, 1542809, 0 in 00:02:28]


	--------------------------------------------------
	-- NodeSummary
	--------------------------------------------------

	create table #NodeSummaryTemp (
		NodeID bigint primary key,
		ShortLabel varchar(500)
	)
	declare @labelID bigint
	select @labelID = [RDF.].fnURI2NodeID('http://www.w3.org/2000/01/rdf-schema#label')
	insert into #NodeSummaryTemp
		select t.subject NodeID, min(case when len(n.Value)>500 then left(n.Value,497)+'...' else n.Value end) Label
			from [RDF.].Triple t with (nolock)
				inner join [RDF.].Node n with (nolock)
					on t.object = n.NodeID
						and t.predicate = @labelID
						and t.subject in (select NodeID from #NodeMap)
						and t.ViewSecurityGroup between -30 and -1
						and n.ViewSecurityGroup between -30 and -1
			group by t.subject
	--[1155480 in 00:00:19]

	create table #NodeSummary (
		NodeID bigint primary key,
		ShortLabel varchar(500),
		ClassName varchar(255),
		SortOrder bigint
	)
	insert into #NodeSummary
		select s.NodeID, s.ShortLabel, c.ClassName, row_number() over (order by s.ShortLabel, s.NodeID) SortOrder
		from (
				select NodeID, ClassNode, ShortLabel
				from (
					select c.NodeID, c.ClassNode, s.ShortLabel, row_number() over (partition by c.NodeID order by c.ClassSort) k
					from #NodeClass c
						inner join #NodeSummaryTemp s
							on c.NodeID = s.NodeID
					where c.Searchable = 1
				) s
				where k = 1
			) s
			inner join #Class c
				on s.ClassNode = c.ClassNode
	--[468900 in 00:00:04]


	--------------------------------------------------
	-- NodeRDF
	--------------------------------------------------

	create table #NodePropertyExpand (
		NodeID bigint not null,
		PropertyNode bigint not null,
		Limit int,
		IncludeDescription tinyint,
		TagName nvarchar(1000)
	)
	alter table #NodePropertyExpand add primary key (NodeID, PropertyNode)
	insert into #NodePropertyExpand
		select n.NodeID, p.PropertyNode, max(p.Limit) Limit, max(p.IncludeDescription) IncludeDescription, max(p.TagName) TagName
			from #NodeClass n
				inner join #ClassPropertyView p
					on n.ClassNode = p.ClassNode
			group by n.NodeID, p.PropertyNode
	--[7698214 in 00:00:21]

	create table #NodeTag (
		NodeID bigint not null,
		TagSort int not null,
		ExpandNodeID bigint not null,
		IncludeDescription tinyint,
		TagStart nvarchar(max),
		TagValue nvarchar(max),
		TagEnd nvarchar(max)
	)
	alter table #NodeTag add primary key (NodeID, TagSort)
	insert into #NodeTag
		select e.NodeID,
				row_number() over (partition by e.NodeID order by e.TagName, o.Value, o.NodeID),
				o.NodeID, e.IncludeDescription,
 				'_TAGLT_'+e.TagName
					+(case when o.ObjectType = 0 
							then ' rdf:resource="' 
							else IsNull(' xml:lang="'+o.Language+'"','')
								+IsNull(' rdf:datatype="'+o.DataType+'"','')
								+'_TAGGT_'
							end),
				o.Value,
				(case when o.ObjectType = 0 then '"/_TAGGT_' else '_TAGLT_/'+e.TagName+'_TAGGT_' end)
			from #NodePropertyExpand e
				inner join [RDF.].[Triple] t with (nolock)
					on e.NodeID = t.subject
						and e.PropertyNode = t.predicate
						and t.ViewSecurityGroup between -30 and -1
						and ((e.Limit is null) or (t.SortOrder <= e.Limit))
				inner join [RDF.].[Node] o with (nolock)
					on t.object = o.NodeID
						and o.ViewSecurityGroup between -30 and -1
	--[7991231 in 00:04:35]

	update #NodeTag
		set TagValue = (case when charindex(char(0),cast(TagValue as varchar(max))) > 0
						then replace(replace(replace(replace(cast(TagValue as varchar(max)),char(0),''),'&','&amp;'),'<','&lt;'),'>','&gt;')
						else replace(replace(replace(TagValue,'&','&amp;'),'<','&lt;'),'>','&gt;')
						end)
		where cast(TagValue as varchar(max)) like '%[&<>'+char(0)+']%'
	--[32573 in 00:00:31]

	create unique nonclustered index idx_sn on #NodeTag (TagSort, NodeID)
	--[00:00:07]

	create table #NodeRDF (
		NodeID bigint primary key,
		RDF nvarchar(max)
	)
	insert into #NodeRDF
		select t.NodeID, 
				'_TAGLT_rdf:Description rdf:about="' + replace(replace(replace(n.Value,'&','&amp;'),'<','&lt;'),'>','&gt;') + '"_TAGGT_'
				+ t.TagStart+t.TagValue+t.TagEnd
			from #NodeTag t
				inner join [RDF.].Node n with (nolock)
					on t.NodeID = n.NodeID
			where t.TagSort = 1
	--[1157272 in 00:00:24]

	declare @k int
	select @k = 2
	while (@k > 0) and (@k < 25)
	begin
		update r
			set r.RDF = r.RDF + t.TagStart+t.TagValue+t.TagEnd
			from #NodeRDF r
				inner join #NodeTag t
					on r.NodeID = t.NodeID and t.TagSort = @k
		if @@ROWCOUNT = 0
			select @k = -1
		else
			select @k = @k + 1			
	end
	--[1157247, 1102278, 1056348, 503981, 499321, 497457, 457981, 425030, 416171, 367566, 350579, 0]
	--[00:01:35]

	update #NodeRDF
		set RDF = RDF + '_TAGLT_/rdf:Description_TAGGT_'
	--[1157272 in 00:00:08]


	--------------------------------------------------
	-- NodeExpand
	--------------------------------------------------

	create table #NodeExpand (
		NodeID bigint not null,
		ExpandNodeID bigint not null
	)
	alter table #NodeExpand add primary key (NodeID, ExpandNodeID)
	insert into #NodeExpand
		select distinct NodeID, ExpandNodeID
		from #NodeTag
		where IncludeDescription = 1
	--[3601932 in 00:00:05]


	--------------------------------------------------
	-- NodePrefix
	--------------------------------------------------

	create table #NodePrefix (
		Prefix varchar(800) not null,
		NodeID bigint not null
	)
	alter table #NodePrefix add primary key (Prefix, NodeID)
	insert into #NodePrefix (Prefix,NodeID)
		select left(n.Value,800), n.NodeID
			from [RDF.].Node n with (nolock)
				inner join #Node m
					on n.NodeID = m.NodeID
	--[3590372 in 00:00:16]


	--------------------------------------------------
	-- Update actual tables
	--------------------------------------------------

	BEGIN TRY
		BEGIN TRAN
		
			truncate table [Search.Cache].[Private.NodeMap]
			insert into [Search.Cache].[Private.NodeMap] (NodeID, MatchedByNodeID, Distance, Paths, Weight)
				select NodeID, MatchedByNodeID, Distance, Paths, Weight
					from #NodeMap
			--[18504905 in 00:02:02]

			truncate table [Search.Cache].[Private.NodeSummary]
			insert into [Search.Cache].[Private.NodeSummary] (NodeID, ShortLabel, ClassName, SortOrder)
				select NodeID, ShortLabel, ClassName, SortOrder
					from #NodeSummary
			--[468900 in 00:00:03]

			truncate table [Search.Cache].[Private.NodeClass]
			insert into [Search.Cache].[Private.NodeClass] (NodeID, Class)
				select NodeID, ClassNode
					from #NodeClass
			--[2388097 in 00:00:05]

			truncate table [Search.Cache].[Private.NodeExpand]
			insert into [Search.Cache].[Private.NodeExpand] (NodeID, ExpandNodeID)
				select NodeID, ExpandNodeID
					from #NodeExpand
			--[3601932 in 00:00:08]

			truncate table [Search.Cache].[Private.NodeRDF]
			insert into [Search.Cache].[Private.NodeRDF] (NodeID, RDF)
				select NodeID, RDF
					from #NodeRDF
			--[1157272 in 00:00:36]

			truncate table [Search.Cache].[Private.NodePrefix]
			insert into [Search.Cache].[Private.NodePrefix] (Prefix, NodeID)
				select Prefix, NodeID
					from #NodePrefix
			--[3590372 in 00:00:34]

		COMMIT
	END TRY
	BEGIN CATCH
		--Check success
		IF @@TRANCOUNT > 0  ROLLBACK
		--Raise an error with the details of the exception
		DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
		SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY()
		RAISERROR(@ErrMsg, @ErrSeverity, 1)
	END CATCH
 

END
GO
