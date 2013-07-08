SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [RDF.Stage].[ProcessTriples]
	@ProcessAll bit = 1,
	@ShowCounts bit = 0,
	@ProcessLimit bigint = 1000000,
	@IsRunningInLoop bit = 0
AS

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 
	/* 
 
	This stored procedure converts triples defined in [RDF.Stage].Triple into 
	records in [RDF.].Node and [RDF.].Triple and updates IsPublic and other attributes
	on existing records.
 
	The subject, predicate, and object of a triple can be defined in different ways:
		Subject
			Cat 0: sNodeID (from [RDF.].Node)
			Cat 1: sURI
			Cat 2: sNodeType (primary VIVO type, http://xmlns.com/foaf/0.1/Person), sInternalType (Profiles10 type, such as "Person"), sInternalID (personID=32213)
			Cat 3: sTripleID (from [RDF.].Triple -- a reitification)
			Cat 4: sStageTripleID (from [RDF.Stage.].Triple -- a reitification of a triple not yet loaded)
		Predicate
			Cat 0: pNodeID (from [RDF.].Node)
			Cat 1: pProperty (a VIVO property, such as http://www.w3.org/1999/02/22-rdf-syntax-ns#type or http://xmlns.com/foaf/0.1/firstName)
		Object
			Cat 0: oNodeID (from [RDF.].Node)
			Cat 1: oValue, oLanguage, oDataType, oObjectType (standard RDF literal [oObjectType=1], or just oValue if URI [oObjectType=0])
			Cat 2: oNodeType (primary VIVO type, http://xmlns.com/foaf/0.1/Person), oInternalType (Profiles10 type, such as "Person"), oInternalID (personID=32213)
			Cat 3: oTripleID (from [RDF.].Triple -- a reitification)
			Cat 4: oStageTripleID (from [RDF.Stage.].Triple -- a reitification of a triple not yet loaded)
			Cat 5: oStartTime, oEndTime, oTimePrecision (VIVO's DateTimeInterval, DateTimeValue, and DateTimeValuePrecision classes)
			Cat 6: oStartTime, oTimePrecision (VIVO's DateTimeValue, and DateTimeValuePrecision classes)
 
	The following are also related to a triple:
		sIsPublic = 1 (security of subject)
		pIsPublic = 1 (security of predicate)
		oIsPublic = 1 (security of object)
		tIsPublic = 1 (security of triple)
		Weight = 1 (float, strength of connection)
		SortOrder = 1 (should be a row_number() over (partition by subject, predicate order by ...))
 
	These field s are to help with processing:
		StageTripleID
		sValueHash
		pValueHash
		oValueHash
		TripleID
		TripleHash
		Reitification
		Status
 
	1. Determine the input categories for subject, predicate, and object in [RDF.Stage].Triple
	2. Create a distinct list of node definitions from [RDF.Stage].Triple
	3. Map each node definition to an existing NodeID or create a new node and get its NodeID
	4. Lookup the NodeID for each node definition in [RDF.Stage].Triple
	5. Update or insert triples
	6. Update node attributes
	7. Save a list of which stage triples were processed
 
	*/
 

	-- Turn off real-time indexing
	IF @IsRunningInLoop = 0
		ALTER FULLTEXT INDEX ON [RDF.].Node SET CHANGE_TRACKING OFF 


	--*******************************************************************************************
	--*******************************************************************************************
	-- Iterate through multiple calls to this procedure until all triples are processed
	--*******************************************************************************************
	--*******************************************************************************************


	if @ProcessAll = 1
	begin

		truncate table [RDF.Stage].[Triple.Map]
		
		declare @IterationResults table (NewNodes bigint, NewTriples bigint, FoundRecords bigint, ProcessedRecords bigint)
		declare @IterationCount int
		declare @IterationStart datetime
		declare @IterationMax int
		select @IterationCount = 0, @IterationMax = 1000
		while @IterationCount < @IterationMax
		begin
			select @IterationStart = getdate()
			insert into @IterationResults
				exec [RDF.Stage].[ProcessTriples] @ProcessAll = 0, @ShowCounts = 1, @ProcessLimit = @ProcessLimit, @IsRunningInLoop = 1
			if @ShowCounts = 1
				select * from @IterationResults
			if ((select count(*) from @IterationResults) = 0) or ((select ProcessedRecords from @IterationResults) = 0)
				select @IterationCount = @IterationMax
			insert into [rdf.stage].[Log.Triple] (CompleteDate, NewNodes, NewTriples, FoundRecords, ProcessedRecords, TimeElapsed)
				select getdate(), *, datediff(ms,@IterationStart,getdate())/1000.00000 from @IterationResults
			delete from @IterationResults
			set @IterationCount = @IterationCount + 1
		end

		-- Turn on real-time indexing
		ALTER FULLTEXT INDEX ON [RDF.].Node SET CHANGE_TRACKING AUTO;
		-- Kick off population FT Catalog and index
		ALTER FULLTEXT INDEX ON [RDF.].Node START FULL POPULATION 

		return

	end


	--*******************************************************************************************
	--*******************************************************************************************
	-- Start a single iteration
	--*******************************************************************************************
	--*******************************************************************************************

	declare @NewNodes bigint
	declare @NewTriples bigint
	declare @FoundRecords bigint
	declare @ProcessedRecords bigint
	select @NewNodes = 0, @NewTriples = 0, @FoundRecords = 0, @ProcessedRecords = 0
 
	create table #Debug (i int identity(0,1) primary key, x varchar(100), d datetime)

	--*******************************************************************************************
	--*******************************************************************************************
	-- 1. Determine the input categories for subject, predicate, and object in [RDF.Stage].Triple
	--*******************************************************************************************
	--*******************************************************************************************

	insert into #Debug (x,d) select '1',GetDate()

	select top (@ProcessLimit)
			t.StageTripleID,
				(case	when sNodeID is not null then 0
						when sURI is not null then 1
						when sNodeType is not null and sInternalType is not null and sInternalID is not null then 2
						when sTripleID is not null then 3
						when sStageTripleID is not null then 4
						else null end) sCategory,
				(case	when pNodeID is not null then 0
						when pProperty is not null then 1
						else null end) pCategory,
				(case	when oNodeID is not null then 0
						when oValue is not null and oObjectType is not null then 1
						when oNodeType is not null and oInternalType is not null and oInternalID is not null then 2
						when oTripleID is not null then 3
						when oStageTripleID is not null then 4
						when oStartTime is not null and oEndTime is not null and oTimePrecision is not null then 5
						when oStartTime is not null and oTimePrecision is not null then 6
						else null end) oCategory,
				(case	when sNodeID is not null then null
						when sURI is not null then CONVERT(binary(20),HASHBYTES('sha1',CONVERT(nvarchar(4000),N'"'+replace(isnull(sURI,N''),N'"',N'\"')+N'"'))) 
						when sNodeType is not null and sInternalType is not null and sInternalID is not null then CONVERT(binary(20),HASHBYTES('sha1',CONVERT(nvarchar(4000),N'"'+replace(isnull(sNodeType+'^^'+sInternalType+'^^'+sInternalID,N''),N'"',N'\"')+N'"'))) 
						when sTripleID is not null then CONVERT(binary(20),HASHBYTES('sha1',CONVERT(nvarchar(4000),N'"'+replace(isnull('#TRIPLE'+cast(sTripleID as varchar(50)),N''),N'"',N'\"')+N'"')))
						when sStageTripleID is not null then CONVERT(binary(20),HASHBYTES('sha1',CONVERT(nvarchar(4000),N'"'+replace(isnull('#STAGETRIPLE'+cast(sStageTripleID as varchar(50)),N''),N'"',N'\"')+N'"')))
						else null end) sValueHash,
				(case	when pNodeID is not null then null
						when pProperty is not null then CONVERT(binary(20),HASHBYTES('sha1',CONVERT(nvarchar(4000),N'"'+replace(isnull(pProperty,N''),N'"',N'\"')+N'"')))
						else null end) pValueHash,
				(case	when oNodeID is not null then null
						when oValue is not null and oObjectType is not null then CONVERT(binary(20),HASHBYTES('sha1',CONVERT(nvarchar(4000),N'"'+replace(isnull(oValue,N''),N'"',N'\"')+'"'+IsNull(N'"@'+replace(oLanguage,N'@',N''),N'')+IsNull(N'"^^'+replace(oDataType,N'^',N''),N''))))
						when oNodeType is not null and oInternalType is not null and oInternalID is not null then CONVERT(binary(20),HASHBYTES('sha1',CONVERT(nvarchar(4000),N'"'+replace(isnull(oNodeType+'^^'+oInternalType+'^^'+oInternalID,N''),N'"',N'\"')+N'"'))) 
						when oTripleID is not null then CONVERT(binary(20),HASHBYTES('sha1',CONVERT(nvarchar(4000),N'"'+replace(isnull('#TRIPLE'+cast(oTripleID as varchar(50)),N''),N'"',N'\"')+N'"')))
						when oStageTripleID is not null then CONVERT(binary(20),HASHBYTES('sha1',CONVERT(nvarchar(4000),N'"'+replace(isnull('#STAGETRIPLE'+cast(oStageTripleID as varchar(50)),N''),N'"',N'\"')+N'"')))
						else null end) oValueHash,
			sNodeID, sViewSecurityGroup, sEditSecurityGroup,
			pNodeID, pViewSecurityGroup, pEditSecurityGroup,
			oNodeID, oViewSecurityGroup, oEditSecurityGroup,
			oObjectType, TripleHash, 
			TripleID, tViewSecurityGroup,
			Weight, SortOrder, Reitification, Graph, 0 Status
		into #TripleHash
		from [RDF.Stage].Triple t
		where status is null
		order by StageTripleID

	select @FoundRecords = @@ROWCOUNT
 
 
	--***************************************************************** **************************
	--*******************************************************************************************
	-- 2. Create a distinct list of node definitions from [RDF.Stage].Triple
	--*******************************************************************************************
	--*******************************************************************************************
 
	insert into #Debug (x,d) select '2',GetDate()

	create table #nodes (
		Category tinyint,
		NodeType nvarchar(400),
		InternalType nvarchar(100),
		InternalID nvarchar(100),
		InternalHash binary(20),
		Value nvarchar(max),
		Language nvarchar(255),
		DataType nvarchar(255),
		ObjectType bit,
		ValueHash binary(20),
		StartTime datetime,
		EndTime datetime,
		TimePrecision nvarchar(255),
		TripleID bigint,
		StageTripleID bigint,
		NodeID bigint,
		Status tinyint
	)

	select ValueHash, Category, StageTripleID, maxObjectType ObjectType, n
		into #ntemp
		from (
			select *, row_number() over (partition by ValueHash order by StageTripleID, n) k,
				max(ObjectType) over (partition by ValueHash) maxObjectType
			from (
				select (case when n in (0,1,2) then 1 when n in (3,4) then 2 when n in (5,6) then 3 when n in (7,8) then 4 else null end) Category,
					(case when n in (0,3,5,7) then sValueHash when n=1 then pValueHash when n in (2,4,6,8) then oValueHash else null end) ValueHash, 
					StageTripleID, 
					(case when n=2 then cast(oObjectType as tinyint) else 0 end) ObjectType,
					n
				from #TripleHash t, [Utility.Math].N n
				where n <= 8
					and (	(n=0 and sCategory=1) or 
							(n=1 and pCategory=1) or 
							(n=2 and oCategory=1) or
							(n=3 and sCategory=2) or
							(n=4 and oCategory=2) or
							(n=5 and sCategory=3) or
							(n=6 and oCategory=3) or
							(n=7 and sCategory=4) or
							(n=8 and oCategory=4)
						)
			) t
		) t
		where k = 1

	insert into #Debug (x,d) select '2.2',GetDate()

	-- Use the pointers to create a distinct list of nodes.
	insert into #nodes (Category, NodeType, InternalType, InternalID, InternalHash, Value, Language, DataType, ObjectType, ValueHash, TripleID, StageTripleID, Status)
		select n.Category, 
			(case when n=3 then sNodeType when n=4 then oNodeType else null end),
			(case when n=3 then sInternalType when n=4 then oInternalType else null end),
			(case when n=3 then sInternalID when n=4 then oInternalID else null end),
			n.ValueHash,
			(case when n=0 then sURI when n=1 then pProperty when n=2 then oValue else null end),
			(case when n=2 then oLanguage else null end),
			(case when n=2 then oDataType else null end),
			n.ObjectType, 
			(case when n.Category=1 then n.ValueHash else null end),
			(case when n=5 then sTripleID when n=6 then oTripleID else null end),
			(case when n=7 then sStageTripleID when n=8 then oStageTripleID else null end)m,
			0
		from [RDF.Stage].Triple t, #ntemp n
		where t.StageTripleID = n.StageTripleID
	--create nonclustered index idx_ValueHash on #nodes(Category,ValueHash) include (NodeID)
	--create nonclustered index idx_InternalHash on #nodes(Category,InternalHash) include (NodeID)

	insert into #Debug (x,d) select '2.3',GetDate()

	create nonclustered index idx_ValueHash on #nodes(Category,ValueHash)
	create nonclustered index idx_InternalHash on #nodes(Category,InternalHash)
	create nonclustered index idx_node on #nodes(Category,NodeID)
 
 
	--*******************************************************************************************
	--*******************************************************************************************
	-- 3. Map each node definition to an existing NodeID or create a new node and get its NodeID
	--*******************************************************************************************
	--*******************************************************************************************

	insert into #Debug (x,d) select '3',GetDate()

	-- Lookup the base URI
	declare @baseURI nvarchar(400)
	select @baseURI = value from [Framework.].Parameter where ParameterID = 'baseURI'
 
	--------------------------------------------------
	-- Category 1 (URI, Property, or Value)
	--------------------------------------------------

	insert into #Debug (x,d) select '3.1',GetDate()

	-- Find existing NodeIDs
	update n
		set n.NodeID = m.NodeID
		from #nodes n, [RDF.].Node m
		where n.Category = 1
			and n.ValueHash = m.ValueHash
 
	-- Create new nodes
	insert into [RDF.].Node (ViewSecurityGroup, EditSecurityGroup, ValueHash, Language, DataType, Value, ObjectType)
		select 0, 0, ValueHash, Language, DataType, Value, ObjectType
		from #nodes
		where Category = 1 and NodeID is null
	select @NewNodes = @NewNodes + @@ROWCOUNT
	update n
		set n.NodeID = m.NodeID
		from #nodes n, [RDF.].Node m
		where n.Category = 1 and n.NodeID is null
			and n.ValueHash = m.ValueHash
 
	--------------------------------------------------
	-- Category 2 (InternalID)
	--------------------------------------------------

	insert into #Debug (x,d) select '3.2',GetDate()
 
	-- Find existing NodeIDs
	update n
		set n.NodeID = m.NodeID
		from #nodes n, [RDF.Stage].InternalNodeMap m
		where n.Category = 2
			and n.InternalHash = m.InternalHash

	insert into #Debug (x,d) select '3.2.2',GetDate()
 
	-- Create new nodes for new internal IDs
	insert into [RDF.Stage].InternalNodeMap (Class, InternalType, InternalID, Status, InternalHash)
		select NodeType, InternalType, InternalID, 0, InternalHash
		from #nodes
		where Category = 2 and NodeID is null

	insert into #Debug (x,d) select '3.2.3',GetDate()

	update [RDF.Stage].InternalNodeMap
		set ValueHash = CONVERT(binary(20),HASHBYTES('sha1',CONVERT(nvarchar(4000),N'"#INM'+cast(InternalNodeMapID as nvarchar(50))+N'"'))), 
			status = 1
		where status = 0

	insert into #Debug (x,d) select '3.2.4',GetDate()

	insert into [RDF.].Node (ViewSecurityGroup, EditSecurityGroup, ValueHash, Value, InternalNodeMapID, ObjectType)
		select 0, 0, ValueHash,
			'#INM'+cast(InternalNodeMapID as nvarchar(50)),
			InternalNodeMapID, 0
		from [RDF.Stage].InternalNodeMap
		where status = 1
	select @NewNodes = @NewNodes + @@ROWCOUNT

	insert into #Debug (x,d) select '3.2.5',GetDate()

	update i
		set i.NodeID = n.NodeID, i.Status = 2,
			i.ValueHash = CONVERT(binary(20),HASHBYTES('sha1',CONVERT(nvarchar(4000),N'"'+@baseURI+cast(n.NodeID as nvarchar(50))+N'"'))) 
		from [RDF.Stage].InternalNodeMap i, [RDF.].Node n
		where i.Status = 1 and i.ValueHash = n.ValueHash

	insert into #Debug (x,d) select '3.2.6',GetDate()

	update n
		set n.Value = @baseURI+cast(n.NodeID as nvarchar(50)),
			n.ValueHash = i.ValueHash
		from [RDF.Stage].InternalNodeMap i, [RDF.].Node n
		where i.Status = 2 and i.NodeID = n.NodeID

	insert into #Debug (x,d) select '3.2.7',GetDate()

	update [RDF.Stage].InternalNodeMap
		set Status = 3
		where Status = 2

	insert into #Debug (x,d) select '3.2.8',GetDate()

	update n
		set n.NodeID = m.NodeID
		from #nodes n, [RDF.Stage].InternalNodeMap m
		where n.Category = 2 and n.NodeID is null
			and n.InternalHash = m.InternalHash

	--------------------------------------------------
	-- Category 4 (StageTripleID - Map to TripleID)
	--------------------------------------------------

	insert into #Debug (x,d) select '3.4',GetDate()
 
	update n
		set	n.TripleID = IsNull(m.TripleID,n.TripleID), 
			--n.InternalHash = (case when m.TripleID IS NULL then n.InternalHash else CONVERT(binary(20),HASHBYTES('sha1',CONVERT(nvarchar(4000),N'"#TRIPLE'+cast(m.TripleID as varchar(50))+N'"'))) end),
			n.Category = (case when m.TripleID IS NULL then 99 else 4 end)
		from #nodes n LEFT OUTER JOIN [RDF.Stage].[Triple.Map] m ON n.StageTripleID = m.StageTripleID
		where n.Category = 4

	--------------------------------------------------
	-- Category 3 (TripleID - Reitification)
	--------------------------------------------------

	insert into #Debug (x,d) select '3.3',GetDate()
 
	-- Find existing NodeIDs
	update n
		set n.NodeID = t.Reitification, n.Status = 2
		from #nodes n, [RDF.].Triple t
		where n.Category IN (3,4) and n.TripleID = t.TripleID and t.Reitification is not null

	insert into #Debug (x,d) select '3.3.2',GetDate()
 
	-- Create new nodes for new triples
	insert into [RDF.].Node (ViewSecurityGroup, EditSecurityGroup, ValueHash, Value, ObjectType)
		select 0, 0, InternalHash,
			'#TRIPLE'+cast(TripleID as nvarchar(50)),
			0
		from #nodes
		where Category IN (3,4) and Status = 0
	select @NewNodes = @NewNodes + @@ROWCOUNT

	insert into #Debug (x,d) select '3.3.3',GetDate()

	update i
		set i.NodeID = n.NodeID,
			i.ValueHash = CONVERT(binary(20),HASHBYTES('sha1',CONVERT(nvarchar(4000),N'"'+@baseURI+cast(n.NodeID as nvarchar(50))+N'"'))),
			i.Status = 1
		from #nodes i, [RDF.].Node n
		where i.Category IN (3,4) and i.Status = 0 and i.InternalHash = n.ValueHash

	insert into #Debug (x,d) select '3.3.4',GetDate()

	update n
		set n.Value = @baseURI+cast(n.NodeID as nvarchar(50)),
			n.ValueHash = i.ValueHash
		from #nodes i, [RDF.].Node n
		where i.Category IN (3,4) and i.Status = 1 and i.NodeID = n.NodeID

	insert into #Debug (x,d) select '3.3.5',GetDate()

	update t
		set t.Reitification = i.NodeID
		from #nodes i, [RDF.].Triple t
		where i.Category IN (3,4) and i.Status = 1 and i.TripleID = t.TripleID

	insert into #Debug (x,d) select '3.3.6',GetDate()

	update #nodes
		set Status = 2
		where Category IN (3,4) and Status = 1
 
 
	--*******************************************************************************************
	--*******************************************************************************************
	-- 4. Lookup the NodeID for each node definition
	--*******************************************************************************************
	--*******************************************************************************************

	insert into #Debug (x,d) select '4',GetDate()

	select t.StageTripleID,
			t.sCategory, t.sNodeID, t.sViewSecurityGroup, t.sEditSecurityGroup,
			t.pCategory, t.pNodeID, t.pViewSecurityGroup, t.pEditSecurityGroup,
			t.oCategory, t.oNodeID, t.oViewSecurityGroup, t.oEditSecurityGroup, t.oObjectType,
			convert(binary(20),NULL) TripleHash,
			t.TripleID, t.tViewSecurityGroup, t.Weight, t.SortOrder, t.Reitification,
			t.sValueHash, t.pValueHash, t.oValueHash, t.Graph,
			1 Status
		into #TripleCompact
		from #TripleHash t
	update t
		set t.sNodeID = IsNull(t.sNodeID,s.NodeID),
			t.pNodeID = IsNull(t.pNodeID,p.NodeID),
			t.oNodeID = IsNull(t.oNodeID,o.NodeID)
		from #TripleCompact t
			left outer join #nodes s on t.sNodeID is null and t.sCategory = s.Category and t.sValueHash = s.InternalHash
			left outer join #nodes p on t.pNodeID is null and t.pCategory = p.Category and t.pValueHash = p.InternalHash
			left outer join #nodes o on t.oNodeID is null and t.oCategory = o.Category and t.oValueHash = o.InternalHash
	delete
		from #TripleCompact
		where sNodeID IS NULL OR pNodeID IS NULL OR oNodeID IS NULL
	update #TripleCompact
		set TripleHash = 			
			convert(binary(20),HashBytes('sha1',
				convert(nvarchar(max),
					+N'"'
					+N'<#'+convert(nvarchar(max),sNodeID)+N'> '
					+N'<#'+convert(nvarchar(max),pNodeID)+N'> '
					+N'<#'+convert(nvarchar(max),oNodeID)+N'> .'
					+N'"'
					+N'^^http://www.w3.org/1999/02/22-rdf-syntax-ns#Statement'
				)
			))
	create nonclustered index idx_status on #TripleCompact (status)

 
	--*******************************************************************************************
	--*******************************************************************************************
	-- 5. Update or insert triples
	--*******************************************************************************************
	--*******************************************************************************************

	insert into #Debug (x,d) select '5',GetDate()

	-------------------------------------
	-- Existing triples
	-------------------------------------

	insert into #Debug (x,d) select '5.1',GetDate()

	-- Find existing TripleIDs
	update t
		set t.TripleID = v.TripleID, t.status = 2
		from #TripleCompact t, [RDF.].Triple v
		where t.TripleHash = v.TripleHash and t.status = 1
	-- Update attributes of existing TripleIDs
	update v
		set v.ViewSecurityGroup = t.ViewSecurityGroup, v.Weight = t.Weight, v.SortOrder = t.SortOrder
		from [RDF.].Triple v, (
			select TripleID, min(tViewSecurityGroup) ViewSecurityGroup, max(Weight) Weight, min(SortOrder) SortOrder
			from #TripleCompact
			where status = 2
			group by TripleID
		) t
		where v.TripleID = t.TripleID
			and (v.ViewSecurityGroup <> t.ViewSecurityGroup OR v.Weight <> t.Weight OR v.SortOrder <> t.SortOrder)

	-------------------------------------
	-- New triples without dependencies
	-------------------------------------

	insert into #Debug (x,d) select '5.2',GetDate()

	-- Create new triples
	insert into [RDF.].Triple (ViewSecurityGroup, Subject, Predicate, Object, TripleHash, Weight, ObjectType, SortOrder, Graph)
		select min(tViewSecurityGroup), sNodeID, pNodeID, oNodeID, TripleHash, max(Weight), max(cast(oObjectType as tinyint)), min(SortOrder), min(Graph)
			from #TripleCompact
			where status = 1
			group by sNodeID, pNodeID, oNodeID, TripleHash
	select @NewTriples = @NewTriples + @@ROWCOUNT

	insert into #Debug (x,d) select '5.2.1',GetDate()

	update t
		set t.TripleID = v.TripleID, t.status = 2
		from #TripleCompact t, [RDF.].Triple v
		where t.status = 1 and t.TripleHash = v.TripleHash


	--*******************************************************************************************
	--*******************************************************************************************
	-- 6. Update node attributes
	--*******************************************************************************************
	--*******************************************************************************************

	insert into #Debug (x,d) select '6',GetDate()
 
	create table #nAttributes (
		NodeID bigint primary key,
		ViewSecurityGroup bigint,
		EditSecurityGroup bigint,
		ObjectType bit
	)
	insert into #nAttributes (NodeID, ViewSecurityGroup, EditSecurityGroup, ObjectType)
		select NodeID, min(ViewSecurityGroup), min(EditSecurityGroup), max(ObjectType)
		from (
			select	(case when n=0 then sNodeID when n=1 then pNodeID else oNodeID end) NodeID, 
					(case when n=0 then sViewSecurityGroup when n=1 then pViewSecurityGroup else oViewSecurityGroup end) ViewSecurityGroup, 
					(case when n=0 then sEditSecurityGroup when n=1 then pEditSecurityGroup else oEditSecurityGroup end) EditSecurityGroup, 
					(case when n=2 then cast(oObjectType as tinyint) else 0 end) ObjectType
			from #TripleCompact t, [Utility.Math].N n
			where n <= 2
				and ((n=0 and sNodeID is not null) or (n=1 and pNodeID is not null) or (n=2 and oNodeID is not null))
		) t
		group by NodeID
	update n
		set n.ViewSecurityGroup = a.ViewSecurityGroup, n.EditSecurityGroup = a.EditSecurityGroup, n.ObjectType = a.ObjectType
		from [RDF.].Node n, #nAttributes a
		where n.NodeID = a.NodeID
			and (n.ViewSecurityGroup <> a.ViewSecurityGroup OR n.EditSecurityGroup <> a.EditSecurityGroup OR n.ObjectType <> a.ObjectType)
	update t
		set t.ObjectType = a.ObjectType
		from [RDF.].Triple t, #nAttributes a
		where t.Object = a.NodeID 
			and (t.ObjectType <> a.ObjectType)


	--*******************************************************************************************
	--*******************************************************************************************
	-- 7. Save a list of which stage triples were processed
	--*******************************************************************************************
	--*******************************************************************************************

	insert into #Debug (x,d) select '7.1',GetDate()

	insert into [RDF.Stage].[Triple.Map] (StageTripleID, TripleID)
		select StageTripleID, TripleID
			from #TripleCompact
			where status = 2

	insert into #Debug (x,d) select '7.2',GetDate()

	update t
		set t.Status = (case when c.status = 2 then 2 else null end)
		from [rdf.stage].triple t
			INNER JOIN #TripleHash p ON t.StageTripleID = p.StageTripleID
			LEFT OUTER JOIN #TripleCompact c ON t.StageTripleID = c.StageTripleID


	--*******************************************************************************************
	--*******************************************************************************************
	-- Wrap up
	--*******************************************************************************************
	--*******************************************************************************************

	insert into #Debug (x,d) select 'X',GetDate()

	/*
		select q.*, datediff(ms,q.d,r.d)
		from #Debug q, #Debug r
		where q.i = r.i-1
	*/

	if @ShowCounts = 1
	begin
		select @ProcessedRecords = (select count(*) from #TripleCompact where status = 2)
		select @NewNodes NewNodes, @NewTriples NewTriples, @FoundRecords FoundRecords, @ProcessedRecords RecordsProcessed
	end

	IF @IsRunningInLoop = 0
	BEGIN
		-- Turn on real-time indexing
		ALTER FULLTEXT INDEX ON [RDF.].Node SET CHANGE_TRACKING AUTO;
	 
		-- Kick off population FT Catalog and index
		ALTER FULLTEXT INDEX ON [RDF.].Node START FULL POPULATION 
	END
	 
END
GO
