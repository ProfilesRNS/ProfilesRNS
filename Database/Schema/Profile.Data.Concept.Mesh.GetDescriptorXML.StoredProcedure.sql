SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Data].[Concept.Mesh.GetDescriptorXML]
	@NodeID BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	declare @baseURI nvarchar(400)
	select @baseURI = value from [Framework.].Parameter where ParameterID = 'baseURI'


	------------------------------------------------------------
	-- Convert the NodeID to a DescriptorUI
	------------------------------------------------------------

	DECLARE @DescriptorUI VARCHAR(50)
	SELECT @DescriptorUI = m.InternalID
		FROM [RDF.Stage].[InternalNodeMap] m, [RDF.].Node n
		WHERE m.Status = 3 AND m.ValueHash = n.ValueHash AND n.NodeID = @NodeID
 
	IF @DescriptorUI IS NULL
	BEGIN
		SELECT cast(null as xml) DescriptorXML WHERE 1=0
		RETURN
	END


	------------------------------------------------------------
	-- Combine MeSH tables
	------------------------------------------------------------
	/*
	select r.TreeNumber FullTreeNumber, 
			(case when len(r.TreeNumber)=1 then '' else left(r.TreeNumber,len(r.TreeNumber)-4) end) ParentTreeNumber,
			r.DescriptorName, IsNull(t.TreeNumber,r.TreeNumber) TreeNumber, t.DescriptorUI, m.NodeID, f.Value+cast(m.NodeID as varchar(50)) NodeURI
		into #m
		from [Profile.Data].[Concept.Mesh.TreeTop] r
			left outer join [Profile.Data].[Concept.Mesh.Tree] t
				on t.TreeNumber = substring(r.TreeNumber,3,999)
			left outer join [RDF.Stage].[InternalNodeMap] m
				on m.Class = 'http://www.w3.org/2004/02/skos/core#Concept'
					and m.InternalType = 'MeshDescriptor'
					and m.InternalID = cast(t.DescriptorUI as varchar(50))
					and t.DescriptorUI is not null
					and m.Status = 3
			left outer join [Framework.].[Parameter] f
				on f.ParameterID = 'baseURI'
	
	create unique clustered index idx_f on #m(FullTreeNumber)
	create nonclustered index idx_d on #m(DescriptorUI)
	create nonclustered index idx_p on #m(ParentTreeNumber)
	*/

	------------------------------------------------------------
	-- Construct the DescriptorXML
	------------------------------------------------------------

	;with p0 as (
		select distinct b.*
		from [Profile.Cache].[Concept.Mesh.TreeTop] a, [Profile.Cache].[Concept.Mesh.TreeTop] b
		where a.DescriptorUI = @DescriptorUI
			and a.FullTreeNumber like b.FullTreeNumber+'%'
	), r0 as (
		select c.*, b.DescriptorName ParentName, 2 Depth
			from [Profile.Cache].[Concept.Mesh.TreeTop] a, [Profile.Cache].[Concept.Mesh.TreeTop] b, [Profile.Cache].[Concept.Mesh.TreeTop] c
			where a.DescriptorUI = @DescriptorUI
				and a.ParentTreeNumber = b.FullTreeNumber
				and c.ParentTreeNumber = b.FullTreeNumber
		union all
		select b.*, b.DescriptorName ParentName, 1 Depth
			from [Profile.Cache].[Concept.Mesh.TreeTop] a, [Profile.Cache].[Concept.Mesh.TreeTop] b
			where a.DescriptorUI = @DescriptorUI
				and a.ParentTreeNumber = b.FullTreeNumber
	), r1 as (
		select *
		from (
			select *, row_number() over (partition by DescriptorName, ParentName order by TreeNumber) k
			from r0
		) t
		where k = 1
	), c0 as (
		select top 1 DescriptorUI, TreeNumber, DescriptorName,FullTreeNumber
		from [Profile.Cache].[Concept.Mesh.TreeTop]
		where DescriptorUI = @DescriptorUI
		order by FullTreeNumber
	), c1 as (
		select b.DescriptorUI, b.TreeNumber, b.DescriptorName, 2 Depth
			from c0 a, [Profile.Cache].[Concept.Mesh.TreeTop] b
			where b.ParentTreeNumber = a.FullTreeNumber
		union all
		select DescriptorUI, TreeNumber, DescriptorName, 1 Depth
			from c0
	)
	select (
			select
				(
					select MeSH
					from [Profile.Data].[Concept.Mesh.XML]
					where DescriptorUI = @DescriptorUI
					for xml path(''), type
				).query('MeSH[1]/*'),
				(
					select DescriptorUI, TreeNumber, DescriptorName,
						len(FullTreeNumber)-len(replace(FullTreeNumber,'.',''))+1 Depth,
						m.NodeID, @baseURI+cast(m.NodeID as varchar(50)) NodeURI,
						row_number() over (order by FullTreeNumber) SortOrder
					from p0 x
						left outer join [RDF.Stage].[InternalNodeMap] m
							on m.Class = 'http://www.w3.org/2004/02/skos/core#Concept'
								and m.InternalType = 'MeshDescriptor'
								and m.InternalID = x.DescriptorUI
								and x.DescriptorUI is not null
								and m.Status = 3
					for xml path('Descriptor'), type
				) ParentDescriptors,
				(
					select DescriptorUI, TreeNumber, DescriptorName, Depth,
						m.NodeID, @baseURI+cast(m.NodeID as varchar(50)) NodeURI,
						row_number() over (order by ParentName, Depth, DescriptorName) SortOrder
					from r1 x
						left outer join [RDF.Stage].[InternalNodeMap] m
							on m.Class = 'http://www.w3.org/2004/02/skos/core#Concept'
								and m.InternalType = 'MeshDescriptor'
								and m.InternalID = x.DescriptorUI
								and x.DescriptorUI is not null
								and m.Status = 3
					for xml path('Descriptor'), type
				) SiblingDescriptors,
				(
					select DescriptorUI, TreeNumber, DescriptorName, Depth,
						m.NodeID, @baseURI+cast(m.NodeID as varchar(50)) NodeURI,
						row_number() over (order by Depth, DescriptorName) SortOrder
					from c1 x
						left outer join [RDF.Stage].[InternalNodeMap] m
							on m.Class = 'http://www.w3.org/2004/02/skos/core#Concept'
								and m.InternalType = 'MeshDescriptor'
								and m.InternalID = x.DescriptorUI
								and x.DescriptorUI is not null
								and m.Status = 3
					where (select count(*) from c1) > 1
					for xml path('Descriptor'), type
				) ChildDescriptors
			for xml path('DescriptorXML'), type
		) as DescriptorXML


END
GO
