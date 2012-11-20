/*
Run this script on:

       Profiles Version 1.0.1    -  This database will be modified

to upgrade its schema to:

       Profiles Version 1.0.2

You are recommended to back up your database before running this script

*/
SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
IF EXISTS (SELECT * FROM tempdb..sysobjects WHERE id=OBJECT_ID('tempdb..#tmpErrors')) DROP TABLE #tmpErrors
GO
CREATE TABLE #tmpErrors (Error int)
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO
BEGIN TRANSACTION
GO
PRINT N'Creating [Profile.Module].[Support.Map]'
GO
CREATE TABLE [Profile.Module].[Support.Map]
(
[SupportMapID] [int] NOT NULL,
[SupportID] [int] NULL,
[Institution] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Department] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK__Support.__EB1F5421EDF59217] on [Profile.Module].[Support.Map]'
GO
ALTER TABLE [Profile.Module].[Support.Map] ADD PRIMARY KEY CLUSTERED  ([SupportMapID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [Profile.Module].[Support.HTML]'
GO
CREATE TABLE [Profile.Module].[Support.HTML]
(
[SupportID] [int] NOT NULL,
[HTML] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating primary key [PK__Support.__D82DBC6CCAA7AB1D] on [Profile.Module].[Support.HTML]'
GO
ALTER TABLE [Profile.Module].[Support.HTML] ADD PRIMARY KEY CLUSTERED  ([SupportID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [Profile.Module].[Support.GetHTML]'
GO


CREATE PROCEDURE [Profile.Module].[Support.GetHTML]
	@NodeID BIGINT,
	@EditMode BIT = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @str VARCHAR(MAX)

	DECLARE @PersonID INT
 	SELECT @PersonID = CAST(m.InternalID AS INT)
		FROM [RDF.Stage].[InternalNodeMap] m, [RDF.].Node n
		WHERE m.Status = 3 AND m.ValueHash = n.ValueHash AND n.NodeID = @NodeID
			AND m.Class = 'http://xmlns.com/foaf/0.1/Person' AND m.InternalType = 'Person'

	IF @PersonID IS NOT NULL
	BEGIN

		if @editMode = 0
			set @str = 'Local representatives can answer questions about the Profiles website or help with editing a profile or issues with profile data. For assistance with this profile:'
		else
			set @str = 'Local representatives can help you modify your basic information above, including title and contact information, or answer general questions about Profiles. For assistance with this profile:'

		select @str = @str + (
				select ' '+s.html
					from [Profile.Module].[Support.HTML] s, (
						select m.SupportID, min(SortOrder) x 
							from [Profile.Cache].[Person.Affiliation] a, [Profile.Module].[Support.Map] m
							where a.instititutionname = m.institution and (a.departmentname = m.department or m.department = '')
								and a.PersonID = 176
							group by m.SupportID
					) t
					where s.SupportID = t.SupportID
					order by t.x
					for xml path(''), type
			).value('(./text())[1]','nvarchar(max)')

	END

	SELECT @str HTML WHERE @str IS NOT NULL

END
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [Profile.Module].[ConnectionDetails.Person.HasResearchArea.GetData]'
GO


CREATE PROCEDURE [Profile.Module].[ConnectionDetails.Person.HasResearchArea.GetData]
	@subject BIGINT,
	@object BIGINT,
	@SessionID UNIQUEIDENTIFIER=NULL
AS
BEGIN
 
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 
	DECLARE @PersonID INT
 	SELECT @PersonID = CAST(m.InternalID AS INT)
		FROM [RDF.Stage].[InternalNodeMap] m, [RDF.].Node n
		WHERE m.Status = 3 AND m.ValueHash = n.ValueHash AND n.NodeID = @subject

	DECLARE @MeshHeader NVARCHAR(255)
 	SELECT @MeshHeader = d.DescriptorName
		FROM [RDF.Stage].[InternalNodeMap] m, [RDF.].Node n,
			[Profile.Data].[Concept.Mesh.Descriptor] d
		WHERE m.Status = 3 AND m.ValueHash = n.ValueHash AND n.NodeID = @object
			AND m.InternalID = d.DescriptorUI
	
	;with a as (
		select m.meshheader, m.pmid, m.topicweight, m.authorweight, m.yearweight, m.uniquenessweight, m.meshweight overallweight,
			cast([Profile.Cache].[fnPublication.Pubmed.General2Reference](g.pmid, ArticleDay, ArticleMonth, ArticleYear, ArticleTitle, Authors, AuthorListCompleteYN, Issue, JournalDay, JournalMonth, JournalYear, MedlineDate, MedlinePgn, MedlineTA, Volume, 0) as varchar(8000)) Reference,
			'This phrase is used in ' 
				+ cast(c.numpublications as varchar(10)) 
				+ ' publication' + (case when c.numpublications = 1 then '' else 's' end)
				+ ' by '
				+ cast(c.numfaculty as varchar(10))
				+ ' author' + (case when c.numfaculty = 1 then '' else 's' end)
				+ '.' as UniquenessWeightStr,
			(case when m.topicweight = 1 then 'MeSH major topic' else 'MeSH minor topic' end) TopicWeightStr,
			(case when m.authorweight = 1 then 'First or senior author' when authorweight = 0.25 then 'Middle author' else 'Default author weight' end) AuthorWeightStr,
			(case when g.pubdate < '1/1/1902' then 'Unknown publication date' else 'Published in '+cast(year(g.pubdate) as varchar(10)) end) YearWeightStr
		from [Profile.Cache].[Concept.Mesh.PersonPublication] m, [Profile.Data].[Publication.PubMed.General] g, [Profile.Cache].[Concept.Mesh.Count] c
		where m.personid = @PersonID and m.meshheader = @MeshHeader and m.pmid = g.pmid and m.meshheader = c.meshheader
	), b as (
		select count(*) PublicationCount, sum(overallweight) TotalOverallWeight
		from a
	)
	select *
	from a, b
	order by overallweight desc, pmid

END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [Profile.Module].[ConnectionDetails.Person.CoAuthorOf.GetData]'
GO


CREATE PROCEDURE [Profile.Module].[ConnectionDetails.Person.CoAuthorOf.GetData]
	@subject BIGINT,
	@object BIGINT,
	@SessionID UNIQUEIDENTIFIER=NULL
AS
BEGIN
 
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 
	DECLARE @PersonID INT
 	SELECT @PersonID = CAST(m.InternalID AS INT)
		FROM [RDF.Stage].[InternalNodeMap] m, [RDF.].Node n
		WHERE m.Status = 3 AND m.ValueHash = n.ValueHash AND n.NodeID = @subject
 
	DECLARE @PersonID2 INT
 	SELECT @PersonID2 = CAST(m.InternalID AS INT)
		FROM [RDF.Stage].[InternalNodeMap] m, [RDF.].Node n
		WHERE m.Status = 3 AND m.ValueHash = n.ValueHash AND n.NodeID = @object

	;with c as (
		select a.pmid, a.authorweight a1, b.authorweight a2, a.YearWeight y, a.pubyear d, (a.authorweight * b.authorweight * a.YearWeight) w,
			a.authorposition ap1, b.authorposition ap2
		from [Profile.Cache].[Publication.PubMed.AuthorPosition] a, [Profile.Cache].[Publication.PubMed.AuthorPosition] b
		where a.pmid = b.pmid and a.personid = @PersonID and b.personid = @PersonID2
	), d as (
		select count(*) n, max(d) d, sum(w) tw
		from c
	)
	select @PersonID PersonID1, @PersonID2 PersonID2,
		d.n PublicationCount, d.tw TotalOverallWeight,
		c.a1 AuthorWeight1, c.a2 AuthorWeight2, c.y YearWeight, c.d ArticleYear, c.w OverallWeight, c.pmid PMID,
		(case c.ap1 when 'F' then 'First author' when 'S' then 'First Author' when 'L' then 'Senior Author' when 'M' then 'Middle Author' else 'Default author weight' end) AuthorWeight1Str,
		(case c.ap2 when 'F' then 'First author' when 'S' then 'First Author' when 'L' then 'Senior Author' when 'M' then 'Middle Author' else 'Default author weight' end) AuthorWeight2Str,
		(case when g.pubdate < '1/1/1902' then 'Unknown publication date' else 'Published in '+cast(year(g.pubdate) as varchar(10)) end) YearWeightStr,
		[Profile.Cache].[fnPublication.Pubmed.General2Reference](g.pmid, ArticleDay, ArticleMonth, ArticleYear, ArticleTitle, Authors, AuthorListCompleteYN, Issue, JournalDay, JournalMonth, JournalYear, MedlineDate, MedlinePgn, MedlineTA, Volume, 0) Reference
	from c, d, [Profile.Data].[Publication.PubMed.General] g
	where c.pmid = g.pmid
	order by c.w desc

END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [Profile.Module].[ConnectionDetails.Person.SimilarTo.GetData]'
GO


CREATE PROCEDURE [Profile.Module].[ConnectionDetails.Person.SimilarTo.GetData]
	@subject BIGINT,
	@object BIGINT,
	@SessionID UNIQUEIDENTIFIER=NULL
AS
BEGIN
 
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 
	DECLARE @PersonID INT
 	SELECT @PersonID = CAST(m.InternalID AS INT)
		FROM [RDF.Stage].[InternalNodeMap] m, [RDF.].Node n
		WHERE m.Status = 3 AND m.ValueHash = n.ValueHash AND n.NodeID = @subject
 
	DECLARE @PersonID2 INT
 	SELECT @PersonID2 = CAST(m.InternalID AS INT)
		FROM [RDF.Stage].[InternalNodeMap] m, [RDF.].Node n
		WHERE m.Status = 3 AND m.ValueHash = n.ValueHash AND n.NodeID = @object

	DECLARE @baseURI NVARCHAR(400)
	SELECT @baseURI = value FROM [Framework.].Parameter WHERE ParameterID = 'baseURI'

	DECLARE @hasResearchAreaID BIGINT
	SELECT @hasResearchAreaID = [RDF.].fnURI2NodeID('http://vivoweb.org/ontology/core#hasResearchArea')

	;with a as (
		select a.PersonID PersonID1, b.PersonID PersonID2, a.MeshHeader, 
			a.NumPubsThis PublicationCount1, b.NumPubsThis PublicationCount2,
			a.Weight KeywordWeight1, b.Weight KeywordWeight2,
			a.Weight*b.Weight OverallWeight
		from [Profile.Cache].[Concept.Mesh.Person] a, [Profile.Cache].[Concept.Mesh.Person] b
		where a.personid = @PersonID and b.personid = @PersonID2
			and a.meshheader = b.meshheader
	), b as (
		select count(*) SharedKeywords, sum(OverallWeight) TotalOverallWeight 
		from a
	)
	select a.*, b.*, @baseURI + cast(m.NodeID as varchar(50)) ObjectURI,
		@baseURI + cast(@subject as varchar(50)) + '/' + cast(@hasResearchAreaID as varchar(50)) + '/' + cast(m.NodeID as varchar(50)) ConnectionURI1,
		@baseURI + cast(@object as varchar(50)) + '/' + cast(@hasResearchAreaID as varchar(50)) + '/' + cast(m.NodeID as varchar(50)) ConnectionURI2
	from a, b, [Profile.Data].[Concept.Mesh.Descriptor] d, [RDF.Stage].[InternalNodeMap] m
	where a.MeshHeader = d.DescriptorName and d.DescriptorUI = m.InternalID
		and m.Class = 'http://www.w3.org/2004/02/skos/core#Concept' and m.InternalType = 'MeshDescriptor'
	order by OverallWeight desc, MeshHeader

END


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [Profile.Data].[Concept.Mesh.GetPublications]'
GO

CREATE PROCEDURE [Profile.Data].[Concept.Mesh.GetPublications]
	@NodeID BIGINT,
	@ListType varchar(50) = NULL,
	@LastDate datetime = '1/1/1900'
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @DescriptorName NVARCHAR(255)
 	SELECT @DescriptorName = d.DescriptorName
		FROM [RDF.Stage].[InternalNodeMap] m, [RDF.].Node n,
			[Profile.Data].[Concept.Mesh.Descriptor] d
		WHERE m.Status = 3 AND m.ValueHash = n.ValueHash AND n.NodeID = @NodeID
			AND m.InternalID = d.DescriptorUI

	if @ListType = 'Newest' or @ListType IS NULL
	begin

		select *
		from (
			select top 10 g.pmid, g.pubdate, [Profile.Cache].[fnPublication.Pubmed.General2Reference](g.pmid, ArticleDay, ArticleMonth, ArticleYear, ArticleTitle, Authors, AuthorListCompleteYN, Issue, JournalDay, JournalMonth, JournalYear, MedlineDate, MedlinePgn, MedlineTA, Volume, 0) reference
			from [Profile.Data].[Publication.PubMed.General] g, (
				select m.pmid, max(MajorTopicYN) MajorTopicYN
				from [Profile.Data].[Publication.Person.Include] i, [Profile.Data].[Publication.PubMed.Mesh] m
				where i.pmid = m.pmid and i.pmid is not null and m.descriptorname = @DescriptorName
				group by m.pmid
			) m
			where g.pmid = m.pmid
			order by g.pubdate desc
		) t
		order by pubdate desc

	end

	if @ListType = 'Oldest' or @ListType IS NULL
	begin

		select *
		from (
			select top 10 g.pmid, g.pubdate, [Profile.Cache].[fnPublication.Pubmed.General2Reference](g.pmid, ArticleDay, ArticleMonth, ArticleYear, ArticleTitle, Authors, AuthorListCompleteYN, Issue, JournalDay, JournalMonth, JournalYear, MedlineDate, MedlinePgn, MedlineTA, Volume, 0) reference
			from [Profile.Data].[Publication.PubMed.General] g, (
				select m.pmid, max(MajorTopicYN) MajorTopicYN
				from [Profile.Data].[Publication.Person.Include] i, [Profile.Data].[Publication.PubMed.Mesh] m
				where i.pmid = m.pmid and i.pmid is not null and m.descriptorname = @DescriptorName
				group by m.pmid
			) m
			where g.pmid = m.pmid --and g.pubdate < @LastDate
			order by g.pubdate
		) t
		order by pubdate

	end


	if @ListType = 'Cited' or @ListType IS NULL
	begin

		;with pm_citation_count as (
			select pmid, 0 n
			from [Profile.Data].[Publication.PubMed.General]
		)
		select *
		from (
			select top 10 g.pmid, g.pubdate, c.n, [Profile.Cache].[fnPublication.Pubmed.General2Reference](g.pmid, ArticleDay, ArticleMonth, ArticleYear, ArticleTitle, Authors, AuthorListCompleteYN, Issue, JournalDay, JournalMonth, JournalYear, MedlineDate, MedlinePgn, MedlineTA, Volume, 0) reference
			from [Profile.Data].[Publication.PubMed.General] g, (
				select m.pmid, max(MajorTopicYN) MajorTopicYN
				from [Profile.Data].[Publication.Person.Include] i, [Profile.Data].[Publication.PubMed.Mesh] m
				where i.pmid = m.pmid and i.pmid is not null and m.descriptorname = @DescriptorName
				group by m.pmid
			) m, pm_citation_count c
			where g.pmid = m.pmid and m.pmid = c.pmid
			order by c.n desc, g.pubdate desc
		) t
		order by n desc, pubdate desc

	end

END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [Profile.Data].[Concept.Mesh.GetJournals]'
GO


CREATE PROCEDURE [Profile.Data].[Concept.Mesh.GetJournals]
	@NodeID BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @DescriptorName NVARCHAR(255)
 	SELECT @DescriptorName = d.DescriptorName
		FROM [RDF.Stage].[InternalNodeMap] m, [RDF.].Node n,
			[Profile.Data].[Concept.Mesh.Descriptor] d
		WHERE m.Status = 3 AND m.ValueHash = n.ValueHash AND n.NodeID = @NodeID
			AND m.InternalID = d.DescriptorUI

	select top 10 Journal, JournalTitle, Weight, NumJournals TotalRecords
		from [Profile.Cache].[Concept.Mesh.Journal]
		where meshheader = @DescriptorName

END


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [Profile.Data].[Concept.Mesh.GetSimilarMesh]'
GO
CREATE PROCEDURE [Profile.Data].[Concept.Mesh.GetSimilarMesh]
	@NodeID BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @DescriptorName NVARCHAR(255)
 	SELECT @DescriptorName = d.DescriptorName
		FROM [RDF.Stage].[InternalNodeMap] m, [RDF.].Node n,
			[Profile.Data].[Concept.Mesh.Descriptor] d
		WHERE m.Status = 3 AND m.ValueHash = n.ValueHash AND n.NodeID = @NodeID
			AND m.InternalID = d.DescriptorUI

 	DECLARE @baseURI NVARCHAR(400)
	SELECT @baseURI = value FROM [Framework.].Parameter WHERE ParameterID = 'baseURI'

	;with a as (
		select SimilarConcept DescriptorName, Weight, SortOrder
		from [Profile.Cache].[Concept.Mesh.SimilarConcept]
		where meshheader = @DescriptorName
	), b as (
		select top 10 DescriptorName, Weight, (select count(*) from a) TotalRecords, SortOrder
		from a
	)
	 SELECT b.*, @baseURI + cast(m.NodeID as varchar(50)) ObjectURI
		 FROM [RDF.Stage].[InternalNodeMap] m, [Profile.Data].[Concept.Mesh.Descriptor] d, b
		 WHERE m.Class = 'http://www.w3.org/2004/02/skos/core#Concept' AND m.InternalType = 'MeshDescriptor'
			AND m.InternalID = d.DescriptorUI AND d.DescriptorName = b.DescriptorName

END
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [Profile.Module].[NetworkAuthorshipTimeline.Person.GetData]'
GO



CREATE PROCEDURE [Profile.Module].[NetworkAuthorshipTimeline.Person.GetData]
	@NodeID BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @PersonID INT
 	SELECT @PersonID = CAST(m.InternalID AS INT)
		FROM [RDF.Stage].[InternalNodeMap] m, [RDF.].Node n
		WHERE m.Status = 3 AND m.ValueHash = n.ValueHash AND n.NodeID = @NodeID
 
    -- Insert statements for procedure here
	declare @gc varchar(max)

	declare @y table (
		y int,
		A int,
		B int,
		C int
	)

	insert into @y (y,A,B,C)
		select n.n y, coalesce(t.A,0) A, coalesce(t.B,0) B, coalesce(t.C,0) C 
		from [Utility.Math].[N] left outer join (
			select (case when y < 1970 then 1970 else y end) y,
				sum(case when r in ('F','S') then 1 else 0 end) A,
				sum(case when r not in ('F','S','L') then 1 else 0 end) B,
				sum(case when r in ('L') then 1 else 0 end) C
			from (
				select coalesce(p.AuthorPosition,'U') r, year(coalesce(p.pubdate,m.publicationdt,'1/1/1970')) y
				from [Profile.Data].[Publication.Person.Include] a
					left outer join [Profile.Cache].[Publication.PubMed.AuthorPosition] p on a.pmid = p.pmid and p.personid = a.personid
					left outer join [Profile.Data].[Publication.MyPub.General] m on a.mpid = m.mpid
				where a.personid = @PersonID
			) t
			group by y
		) t on n.n = t.y
		where n.n between 1980 and year(getdate())

	declare @x int

	select @x = max(A+B+C)
		from @y

	if coalesce(@x,0) > 0
	begin
		declare @v varchar(1000)
		declare @z int
		declare @k int
		declare @i int

		set @z = power(10,floor(log(@x)/log(10)))
		set @k = floor(@x/@z)
		if @x > @z*@k
			select @k = @k + 1
		if @k > 5
			select @k = floor(@k/2.0+0.5), @z = @z*2

		set @v = ''
		set @i = 0
		while @i <= @k
		begin
			set @v = @v + '|' + cast(@z*@i as varchar(50))
			set @i = @i + 1
		end
		set @v = '|0|'+cast(@x as varchar(50))
		--set @v = '|0|50|100'

		declare @h varchar(1000)
		set @h = ''
		select @h = @h + '|' + (case when y % 2 = 1 then '' else ''''+right(cast(y as varchar(50)),2) end)
			from @y
			order by y 

		declare @w float
		--set @w = @k*@z
		set @w = @x

		declare @d varchar(max)
		set @d = ''
		select @d = @d + cast(floor(0.5 + 100*A/@w) as varchar(50)) + ','
			from @y
			order by y
		set @d = left(@d,len(@d)-1) + '|'
		select @d = @d + cast(floor(0.5 + 100*B/@w) as varchar(50)) + ','
			from @y
			order by y
		set @d = left(@d,len(@d)-1) + '|'
		select @d = @d + cast(floor(0.5 + 100*C/@w) as varchar(50)) + ','
			from @y
			order by y
		set @d = left(@d,len(@d)-1)

		declare @c varchar(50)
		set @c = 'FB8072,B3DE69,80B1D3'
		--set @c = 'F96452,a8dc4f,68a4cc'
		--set @c = 'fea643,76cbbd,b56cb5'

		--select @v, @h, @d

		--set @gc = 'http://chart.apis.google.com/chart?chs=605x150&amp;chf=bg,s,ffffff|c,s,ffffff&amp;chxt=x,y&amp;chxl=0:|99|00|01|02|03|1:|0|10|20|30|40|50&amp;cht=bvs&amp;chd=t:70.00,42.00,34.00,38.00,82.00|30.00,18.00,8.00,6.00,4.00&amp;chdl=First+Author|Middle+Author&amp;chco=0000ff,cc3300&amp;chbh=50'
		--set @gc = 'http://chart.apis.google.com/chart?chxs=0,333333,10&amp;chs=605x80&amp;chf=bg,s,ffffff|c,s,ffffff&amp;chxt=x,y&amp;chxl=0:' + @h + '|1:' + @v + '&amp;cht=bvs&amp;chd=t:' + @d + '&amp;chdl=First+Author|Middle or Unkown|Last+Author&amp;chco=0000ff,009900,cc3300&amp;chbh=10'
		--set @gc = 'http://chart.apis.google.com/chart?chs=595x100&amp;chf=bg,s,ffffff|c,s,ffffff&amp;chxt=x,y&amp;chxl=0:' + @h + '|1:' + @v + '&amp;cht=bvs&amp;chd=t:' + @d + '&amp;chdl=First+Author|Middle or Unkown|Last+Author&amp;chco='+@c+'&amp;chbh=10'
		set @gc = 'http://chart.apis.google.com/chart?chs=595x100&chf=bg,s,ffffff|c,s,ffffff&chxt=x,y&chxl=0:' + @h + '|1:' + @v + '&cht=bvs&chd=t:' + @d + '&chdl=First+Author|Middle or Unkown|Last+Author&chco='+@c+'&chbh=10'

		select @gc gc --, @w w

		--select * from @y order by y

	end

END


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [Profile.Module].[NetworkAuthorshipTimeline.Concept.GetData]'
GO


CREATE PROCEDURE [Profile.Module].[NetworkAuthorshipTimeline.Concept.GetData]
	@NodeID BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @DescriptorName NVARCHAR(255)
 	SELECT @DescriptorName = d.DescriptorName
		FROM [RDF.Stage].[InternalNodeMap] m, [RDF.].Node n,
			[Profile.Data].[Concept.Mesh.Descriptor] d
		WHERE m.Status = 3 AND m.ValueHash = n.ValueHash AND n.NodeID = @NodeID
			AND m.InternalID = d.DescriptorUI

    -- Insert statements for procedure here
	declare @gc varchar(max)

	declare @y table (
		y int,
		A int,
		B int
	)

	insert into @y (y,A,B)
		select n.n y, coalesce(t.A,0) A, coalesce(t.B,0) B
		from [Utility.Math].[N] left outer join (
			select (case when y < 1970 then 1970 else y end) y,
				sum(A) A,
				sum(B) B
			from (
				select pmid, pubyear y, (case when w = 1 then 1 else 0 end) A, (case when w < 1 then 1 else 0 end) B
				from (
					select distinct pmid, pubyear, topicweight w
					from [Profile.Cache].[Concept.Mesh.PersonPublication]
					where meshheader = @DescriptorName
				) t
			) t
			group by y
		) t on n.n = t.y
		where n.n between 1980 and year(getdate())

	declare @x int

	select @x = max(A+B)
		from @y

	if coalesce(@x,0) > 0
	begin
		declare @v varchar(1000)
		declare @z int
		declare @k int
		declare @i int

		set @z = power(10,floor(log(@x)/log(10)))
		set @k = floor(@x/@z)
		if @x > @z*@k
			select @k = @k + 1
		if @k > 5
			select @k = floor(@k/2.0+0.5), @z = @z*2

		set @v = ''
		set @i = 0
		while @i <= @k
		begin
			set @v = @v + '|' + cast(@z*@i as varchar(50))
			set @i = @i + 1
		end
		set @v = '|0|'+cast(@x as varchar(50))
		--set @v = '|0|50|100'

		declare @h varchar(1000)
		set @h = ''
		select @h = @h + '|' + (case when y % 2 = 1 then '' else ''''+right(cast(y as varchar(50)),2) end)
			from @y
			order by y 

		declare @w float
		--set @w = @k*@z
		set @w = @x

		declare @d varchar(max)
		set @d = ''
		select @d = @d + cast(floor(0.5 + 100*A/@w) as varchar(50)) + ','
			from @y
			order by y
		set @d = left(@d,len(@d)-1) + '|'
		select @d = @d + cast(floor(0.5 + 100*B/@w) as varchar(50)) + ','
			from @y
			order by y
		set @d = left(@d,len(@d)-1)

		declare @c varchar(50)
		set @c = 'FB8072,80B1D3'
		--set @c = 'FB8072,B3DE69,80B1D3'
		--set @c = 'F96452,a8dc4f,68a4cc'
		--set @c = 'fea643,76cbbd,b56cb5'

		--select @v, @h, @d

		--set @gc = 'http://chart.apis.google.com/chart?chs=595x100&chf=bg,s,ffffff|c,s,ffffff&chxt=x,y&chxl=0:' + @h + '|1:' + @v + '&cht=bvs&chd=t:' + @d + '&chdl=First+Author|Middle or Unkown|Last+Author&chco='+@c+'&chbh=10'
		set @gc = 'http://chart.apis.google.com/chart?chs=595x100&chf=bg,s,ffffff|c,s,ffffff&chxt=x,y&chxl=0:' + @h + '|1:' + @v + '&cht=bvs&chd=t:' + @d + '&chdl=Major+Topic|Minor+Topic&chco='+@c+'&chbh=10'

		select @gc gc --, @w w

		--select * from @y order by y

	end

END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [Profile.Module].[NetworkTimeline.Person.HasResearchArea.GetData]'
GO


CREATE PROCEDURE [Profile.Module].[NetworkTimeline.Person.HasResearchArea.GetData]
	@NodeID BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @PersonID INT
 	SELECT @PersonID = CAST(m.InternalID AS INT)
		FROM [RDF.Stage].[InternalNodeMap] m, [RDF.].Node n
		WHERE m.Status = 3 AND m.ValueHash = n.ValueHash AND n.NodeID = @NodeID
 
 	DECLARE @baseURI NVARCHAR(400)
	SELECT @baseURI = value FROM [Framework.].Parameter WHERE ParameterID = 'baseURI'

	;with a as (
		select t.*, g.pubdate
		from (
			select top 20 *, 
				--numpubsthis/sqrt(numpubsall+100)/sqrt((LastPublicationYear+1 - FirstPublicationYear)*1.00000) w
				--numpubsthis/sqrt(numpubsall+100)/((LastPublicationYear+1 - FirstPublicationYear)*1.00000) w
				--WeightNTA/((LastPublicationYear+2 - FirstPublicationYear)*1.00000) w
				weight w
			from [Profile.Cache].[Concept.Mesh.Person]
			where personid = @PersonID
			order by w desc, meshheader
		) t, [Profile.Cache].[Concept.Mesh.PersonPublication] m, [Profile.Data].[Publication.PubMed.General] g
		where t.meshheader = m.meshheader and t.personid = m.personid and m.pmid = g.pmid and year(g.pubdate) > 1900
	), b as (
		select min(firstpublicationyear)-1 a, max(lastpublicationyear)+1 b,
			cast(cast('1/1/'+cast(min(firstpublicationyear)-1 as varchar(10)) as datetime) as float) f,
			cast(cast('1/1/'+cast(max(lastpublicationyear)+1 as varchar(10)) as datetime) as float) g
		from a
	), c as (
		select a.*, (cast(pubdate as float)-f)/(g-f) x, a, b, f, g
		from a, b
	), d as (
		select meshheader, min(x) MinX, max(x) MaxX, avg(x) AvgX
				--, (select avg(cast(g.pubdate as float))
				--from resnav_people_hmsopen.dbo.pm_pubs_general g, (
				--	select distinct pmid
				--	from resnav_people_hmsopen.dbo.cache_pub_mesh m
				--	where m.meshheader = c.meshheader
				--) t
				--where g.pmid = t.pmid) AvgAllX
		from c
		group by meshheader
	)
	select c.*, d.MinX, d.MaxX, d.AvgX,	c.meshheader label, (select count(distinct meshheader) from a) n,
		@baseURI + cast(m.NodeID as varchar(50)) ObjectURI
		 --, (d.AvgAllX - c.f)/(c.g-c.f) AvgAllX
	from c, d, [Profile.Data].[Concept.Mesh.Descriptor] p, [RDF.Stage].[InternalNodeMap] m
	where c.meshheader = d.meshheader and d.meshheader = p.DescriptorName and p.DescriptorUI = m.InternalID
		and m.Class = 'http://www.w3.org/2004/02/skos/core#Concept' and m.InternalType = 'MeshDescriptor'
	order by AvgX, firstpublicationyear, lastpublicationyear, meshheader, pubdate

END


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Refreshing [Profile.Data].[vwPublication.Pubmed.Mesh.Descriptor]'
GO
EXEC sp_refreshview N'[Profile.Data].[vwPublication.Pubmed.Mesh.Descriptor]'
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating [Profile.Module].[NetworkTimeline.Person.CoAuthorOf.GetData]'
GO


CREATE PROCEDURE [Profile.Module].[NetworkTimeline.Person.CoAuthorOf.GetData]
	@NodeID BIGINT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @PersonID INT
 	SELECT @PersonID = CAST(m.InternalID AS INT)
		FROM [RDF.Stage].[InternalNodeMap] m, [RDF.].Node n
		WHERE m.Status = 3 AND m.ValueHash = n.ValueHash AND n.NodeID = @NodeID
 
 	DECLARE @baseURI NVARCHAR(400)
	SELECT @baseURI = value FROM [Framework.].Parameter WHERE ParameterID = 'baseURI'

	;with e as (
		select top 20 s.PersonID1, s.PersonID2, s.n PublicationCount, 
			year(s.FirstPubDate) FirstPublicationYear, year(s.LastPubDate) LastPublicationYear, 
			p.DisplayName DisplayName2, ltrim(rtrim(p.FirstName+' '+p.LastName)) FirstLast2, s.w OverallWeight
		from [Profile.Cache].[SNA.Coauthor] s, [Profile.Cache].[Person] p
		where personid1 = @PersonID and personid2 = p.personid
		order by w desc, personid2
	), f as (
		select e.*, g.pubdate
		from [Profile.Data].[Publication.Person.Include] a, 
			[Profile.Data].[Publication.Person.Include] b, 
			[Profile.Data].[Publication.PubMed.General] g,
			e
		where a.personid = e.personid1 and b.personid = e.personid2 and a.pmid = b.pmid and a.pmid = g.pmid
			and g.pubdate > '1/1/1900'
	), g as (
		select min(year(pubdate))-1 a, max(year(pubdate))+1 b,
			cast(cast('1/1/'+cast(min(year(pubdate))-1 as varchar(10)) as datetime) as float) f,
			cast(cast('1/1/'+cast(max(year(pubdate))+1 as varchar(10)) as datetime) as float) g
		from f
	), h as (
		select f.*, (cast(pubdate as float)-f)/(g-f) x, a, b, f, g
		from f, g
	), i as (
		select personid2, min(x) MinX, max(x) MaxX, avg(x) AvgX
		from h
		group by personid2
	)
	select h.*, MinX, MaxX, AvgX, h.FirstLast2 label, (select count(distinct personid2) from i) n,
		@baseURI + cast(m.NodeID as varchar(50)) ObjectURI
	from h, i, [RDF.Stage].[InternalNodeMap] m
	where h.personid2 = i.personid2 and cast(i.personid2 as varchar(50)) = m.InternalID
		and m.Class = 'http://xmlns.com/foaf/0.1/Person' and m.InternalType = 'Person'
	order by AvgX, firstpublicationyear, lastpublicationyear, personid2, pubdate

END




GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering [RDF.].[GetDataRDF]'
GO
ALTER PROCEDURE [RDF.].[GetDataRDF]
	@subject BIGINT=NULL,
	@predicate BIGINT=NULL,
	@object BIGINT=NULL,
	@offset BIGINT=NULL,
	@limit BIGINT=NULL,
	@showDetails BIT=1,
	@expand BIT=1,
	@SessionID UNIQUEIDENTIFIER=NULL,
	@NodeListXML XML=NULL,
	@ExpandRDFListXML XML=NULL,
	@returnXML BIT=1,
	@returnXMLasStr BIT=0,
	@dataStr NVARCHAR (MAX)=NULL OUTPUT,
	@dataStrDataType NVARCHAR (255)=NULL OUTPUT,
	@dataStrLanguage NVARCHAR (255)=NULL OUTPUT,
	@RDF XML=NULL OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	/*

	This stored procedure returns the data for a node in RDF format.

	Input parameters:
		@subject		The NodeID whose RDF should be returned.
		@predicate		The predicate NodeID for a network.
		@object			The object NodeID for a connection.
		@offset			Pagination - The first object node to return.
		@limit			Pagination - The number of object nodes to return.
		@showDetails	If 1, then additional properties will be returned.
		@expand			If 1, then object properties will be expanded.
		@SessionID		The SessionID of the user requesting the data.

	There are two ways to call this procedure. By default, @returnXML = 1,
	and the RDF is returned as XML. When @returnXML = 0, the data is instead
	returned as the strings @dataStr, @dataStrDataType, and @dataStrLanguage.
	This second method of calling this procedure is used by other procedures
	and is generally not called directly by the website.

	The RDF returned by this procedure is not equivalent to what is
	returned by SPARQL. This procedure applies security rules, expands
	nodes as defined by [Ontology.].[RDFExpand], and calculates network
	information on-the-fly.

	*/

	declare @d datetime

	declare @baseURI nvarchar(400)
	select @baseURI = value from [Framework.].Parameter where ParameterID = 'baseURI'

	select @subject = null where @subject = 0
	select @predicate = null where @predicate = 0
	select @object = null where @object = 0
		
	declare @firstURI nvarchar(400)
	select @firstURI = @baseURI+cast(@subject as varchar(50))

	declare @firstValue nvarchar(400)
	select @firstValue = null
	
	declare @typeID bigint
	select @typeID = [RDF.].fnURI2NodeID('http://www.w3.org/1999/02/22-rdf-syntax-ns#type')

	declare @labelID bigint
	select @labelID = [RDF.].fnURI2NodeID('http://www.w3.org/2000/01/rdf-schema#label')	

	--*******************************************************************************************
	--*******************************************************************************************
	-- Define temp tables
	--*******************************************************************************************
	--*******************************************************************************************

	/*
		drop table #subjects
		drop table #types
		drop table #expand
		drop table #properties
		drop table #connections
	*/

	create table #subjects (
		subject bigint primary key,
		showDetail bit,
		expanded bit,
		uri nvarchar(400)
	)
	
	create table #types (
		subject bigint not null,
		object bigint not null,
		predicate bigint,
		showDetail bit,
		uri nvarchar(400)
	)
	create unique clustered index idx_sop on #types (subject,object,predicate)

	create table #expand (
		subject bigint not null,
		predicate bigint not null,
		uri nvarchar(400),
		property nvarchar(400),
		tagName nvarchar(1000),
		propertyLabel nvarchar(400),
		IsDetail bit,
		limit bigint,
		showStats bit,
		showSummary bit
	)
	alter table #expand add primary key (subject,predicate)

	create table #properties (
		uri nvarchar(400),
		subject bigint,
		predicate bigint,
		object bigint,
		showSummary bit,
		property nvarchar(400),
		tagName nvarchar(1000),
		propertyLabel nvarchar(400),
		Language nvarchar(255),
		DataType nvarchar(255),
		Value nvarchar(max),
		ObjectType bit,
		SortOrder int
	)

	create table #connections (
		subject bigint,
		subjectURI nvarchar(400),
		predicate bigint,
		predicateURI nvarchar(400),
		object bigint,
		Language nvarchar(255),
		DataType nvarchar(255),
		Value nvarchar(max),
		ObjectType bit,
		SortOrder int,
		Weight float,
		Reitification bigint,
		ReitificationURI nvarchar(400),
		connectionURI nvarchar(400)
	)
	
	create table #ClassPropertyCustom (
		ClassPropertyID int primary key,
		IncludeProperty bit,
		Limit int,
		IncludeNetwork bit,
		IncludeDescription bit
	)

	--*******************************************************************************************
	--*******************************************************************************************
	-- Setup variables used for security
	--*******************************************************************************************
	--*******************************************************************************************

	DECLARE @SecurityGroupID BIGINT, @HasSpecialViewAccess BIT, @HasSecurityGroupNodes BIT
	EXEC [RDF.Security].GetSessionSecurityGroup @SessionID, @SecurityGroupID OUTPUT, @HasSpecialViewAccess OUTPUT
	CREATE TABLE #SecurityGroupNodes (SecurityGroupNode BIGINT PRIMARY KEY)
	INSERT INTO #SecurityGroupNodes (SecurityGroupNode) EXEC [RDF.Security].GetSessionSecurityGroupNodes @SessionID, @Subject
	SELECT @HasSecurityGroupNodes = (CASE WHEN EXISTS (SELECT * FROM #SecurityGroupNodes) THEN 1 ELSE 0 END)


	--*******************************************************************************************
	--*******************************************************************************************
	-- Get subject information when it is a literal
	--*******************************************************************************************
	--*******************************************************************************************

	select @dataStr = Value, @dataStrDataType = DataType, @dataStrLanguage = Language
		from [RDF.].Node
		where NodeID = @subject and ObjectType = 1
			and ( (ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)) )


	--*******************************************************************************************
	--*******************************************************************************************
	-- Seed temp tables
	--*******************************************************************************************
	--*******************************************************************************************

	---------------------------------------------------------------------------------------------
	-- Profile [seed with the subject(s)]
	---------------------------------------------------------------------------------------------
	if (@subject is not null) and (@predicate is null) and (@object is null)
	begin
		insert into #subjects(subject,showDetail,expanded,URI)
			select NodeID, @showDetails, 0, Value
				from [RDF.].Node
				where NodeID = @subject
					and ((ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)))
		select @firstValue = URI
			from #subjects s, [RDF.].Node n
			where s.subject = @subject
				and s.subject = n.NodeID and n.ObjectType = 0
	end
	if (@NodeListXML is not null)
	begin
		insert into #subjects(subject,showDetail,expanded,URI)
			select n.NodeID, t.ShowDetails, 0, n.Value
			from [RDF.].Node n, (
				select NodeID, MAX(ShowDetails) ShowDetails
				from (
					select x.value('@ID','bigint') NodeID, IsNull(x.value('@ShowDetails','tinyint'),0) ShowDetails
					from @NodeListXML.nodes('//Node') as N(x)
				) t
				group by NodeID
				having NodeID not in (select subject from #subjects)
			) t
			where n.NodeID = t.NodeID and n.ObjectType = 0
	end
	
	---------------------------------------------------------------------------------------------
	-- Get all connections
	---------------------------------------------------------------------------------------------
	insert into #connections (subject, subjectURI, predicate, predicateURI, object, Language, DataType, Value, ObjectType, SortOrder, Weight, Reitification, ReitificationURI, connectionURI)
		select	s.NodeID subject, s.value subjectURI, 
				p.NodeID predicate, p.value predicateURI,
				t.object, o.Language, o.DataType, o.Value, o.ObjectType,
				t.SortOrder, t.Weight, 
				r.NodeID Reitification, r.Value ReitificationURI,
				@baseURI+cast(@subject as varchar(50))+'/'+cast(@predicate as varchar(50))+'/'+cast(object as varchar(50)) connectionURI
			from [RDF.].Triple t
				inner join [RDF.].Node s
					on t.subject = s.NodeID
				inner join [RDF.].Node p
					on t.predicate = p.NodeID
				inner join [RDF.].Node o
					on t.object = o.NodeID
				left join [RDF.].Node r
					on t.reitification = r.NodeID
						and t.reitification is not null
						and ((r.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (r.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (r.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)))
			where @subject is not null and @predicate is not null
				and s.NodeID = @subject 
				and p.NodeID = @predicate 
				and o.NodeID = IsNull(@object,o.NodeID)
				and ((t.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (t.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (t.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)))
				and ((s.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (s.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (s.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)))
				and ((p.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (p.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (p.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)))
				and ((o.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (o.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (o.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)))

	---------------------------------------------------------------------------------------------
	-- Network [seed with network statistics and connections]
	---------------------------------------------------------------------------------------------
	if (@subject is not null) and (@predicate is not null) and (@object is null)
	begin
		select @firstURI = @baseURI+cast(@subject as varchar(50))+'/'+cast(@predicate as varchar(50))
		-- Basic network properties
		;with networkProperties as (
			select 1 n, 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type' property, 'rdf:type' tagName, 'type' propertyLabel, 0 ObjectType
			union all select 2, 'http://profiles.catalyst.harvard.edu/ontology/prns#numberOfConnections', 'prns:numberOfConnections', 'number of connections', 1
			union all select 3, 'http://profiles.catalyst.harvard.edu/ontology/prns#maxWeight', 'prns:maxWeight', 'maximum connection weight', 1
			union all select 4, 'http://profiles.catalyst.harvard.edu/ontology/prns#minWeight', 'prns:minWeight', 'minimum connection weight', 1
			union all select 5, 'http://profiles.catalyst.harvard.edu/ontology/prns#predicateNode', 'prns:predicateNode', 'predicate node', 0
			union all select 6, 'http://www.w3.org/1999/02/22-rdf-syntax-ns#predicate', 'rdf:predicate', 'predicate', 0
			union all select 7, 'http://www.w3.org/2000/01/rdf-schema#label', 'rdfs:label', 'label', 1
			union all select 8, 'http://www.w3.org/1999/02/22-rdf-syntax-ns#subject', 'rdf:subject', 'subject', 0
		), networkStats as (
			select	cast(isnull(count(*),0) as varchar(50)) numberOfConnections,
					cast(isnull(max(Weight),1) as varchar(50)) maxWeight,
					cast(isnull(min(Weight),1) as varchar(50)) minWeight,
					max(predicateURI) predicateURI
				from #connections
		), subjectLabel as (
			select IsNull(Max(o.Value),'') Label
			from [RDF.].Triple t, [RDF.].Node o
			where t.subject = @subject
				and t.predicate = @labelID
				and t.object = o.NodeID
				and ((t.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (t.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (t.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)))
				and ((o.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (o.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (o.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)))
		)
		insert into #properties (uri,predicate,property,tagName,propertyLabel,Value,ObjectType,SortOrder)
			select	@firstURI,
					[RDF.].fnURI2NodeID(p.property), p.property, p.tagName, p.propertyLabel,
					(case p.n when 1 then 'http://profiles.catalyst.harvard.edu/ontology/prns#Network'
								when 2 then n.numberOfConnections
								when 3 then n.maxWeight
								when 4 then n.minWeight
								when 5 then @baseURI+cast(@predicate as varchar(50))
								when 6 then n.predicateURI
								when 7 then l.Label
								when 8 then @baseURI+cast(@subject as varchar(50))
								end),
					p.ObjectType,
					1
				from networkStats n, networkProperties p, subjectLabel l
		-- Remove connections not within offset-limit window
		delete from #connections
			where (SortOrder < 1+IsNull(@offset,0)) or (SortOrder > IsNull(@limit,SortOrder) + (case when IsNull(@offset,0)<1 then 0 else @offset end))
		-- Add hasConnection properties
		insert into #properties (uri,predicate,property,tagName,propertyLabel,Value,ObjectType,SortOrder)
			select	@baseURI+cast(@subject as varchar(50))+'/'+cast(@predicate as varchar(50)),
					[RDF.].fnURI2NodeID('http://profiles.catalyst.harvard.edu/ontology/prns#hasConnection'), 
					'http://profiles.catalyst.harvard.edu/ontology/prns#hasConnection', 'prns:hasConnection', 'has connection',
					connectionURI,
					0,
					SortOrder
				from #connections
	end

	---------------------------------------------------------------------------------------------
	-- Connection [seed with connection]
	---------------------------------------------------------------------------------------------
	if (@subject is not null) and (@predicate is not null) and (@object is not null)
	begin
		select @firstURI = @baseURI+cast(@subject as varchar(50))+'/'+cast(@predicate as varchar(50))+'/'+cast(@object as varchar(50))
	end

	---------------------------------------------------------------------------------------------
	-- Expanded Connections [seed with statistics, subject, object, and connectionDetails]
	---------------------------------------------------------------------------------------------
	if (@expand = 1 or @object is not null) and exists (select * from #connections)
	begin
		-- Connection statistics
		;with connectionProperties as (
			select 1 n, 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type' property, 'rdf:type' tagName, 'type' propertyLabel, 0 ObjectType
			union all select 2, 'http://profiles.catalyst.harvard.edu/ontology/prns#connectionWeight', 'prns:connectionWeight', 'connection weight', 1
			union all select 3, 'http://profiles.catalyst.harvard.edu/ontology/prns#sortOrder', 'prns:sortOrder', 'sort order', 1
			union all select 4, 'http://www.w3.org/1999/02/22-rdf-syntax-ns#object', 'rdf:object', 'object', 0
			union all select 5, 'http://profiles.catalyst.harvard.edu/ontology/prns#hasConnectionDetails', 'prns:hasConnectionDetails', 'connection details', 0
			union all select 6, 'http://profiles.catalyst.harvard.edu/ontology/prns#predicateNode', 'prns:predicateNode', 'predicate node', 0
			union all select 7, 'http://www.w3.org/1999/02/22-rdf-syntax-ns#predicate', 'rdf:predicate', 'predicate', 0
			union all select 8, 'http://www.w3.org/2000/01/rdf-schema#label', 'rdfs:label', 'label', 1
			union all select 9, 'http://www.w3.org/1999/02/22-rdf-syntax-ns#subject', 'rdf:subject', 'subject', 0
			union all select 10, 'http://profiles.catalyst.harvard.edu/ontology/prns#connectionInNetwork', 'prns:connectionInNetwork', 'connection in network', 0
		)
		insert into #properties (uri,predicate,property,tagName,propertyLabel,Value,ObjectType,SortOrder)
			select	connectionURI,
					[RDF.].fnURI2NodeID(p.property), p.property, p.tagName, p.propertyLabel,
					(case p.n	when 1 then 'http://profiles.catalyst.harvard.edu/ontology/prns#Connection'
								when 2 then cast(c.Weight as varchar(50))
								when 3 then cast(c.SortOrder as varchar(50))
								when 4 then c.value
								when 5 then c.ReitificationURI
								when 6 then @baseURI+cast(@predicate as varchar(50))
								when 7 then c.predicateURI
								when 8 then l.value
								when 9 then c.subjectURI
								when 10 then c.subjectURI+'/'+cast(@predicate as varchar(50))
								end),
					(case p.n when 4 then c.ObjectType else p.ObjectType end),
					1
				from #connections c, connectionProperties p
					left outer join (
						select o.value
							from [RDF.].Triple t, [RDF.].Node o
							where t.subject = @subject 
								and t.predicate = @labelID
								and t.object = o.NodeID
								and ((t.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (t.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (t.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)))
								and ((o.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (o.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (o.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)))
					) l on p.n = 8
				where (p.n < 5) 
					or (p.n = 5 and c.ReitificationURI is not null)
					or (p.n > 5 and @object is not null)
		if (@expand = 1)
		begin
			-- Connection subject
			insert into #subjects (subject, showDetail, expanded, URI)
				select NodeID, 0, 0, Value
					from [RDF.].Node
					where NodeID = @subject
			-- Connection objects
			insert into #subjects (subject, showDetail, expanded, URI)
				select object, 0, 0, value
					from #connections
					where ObjectType = 0 and object not in (select subject from #subjects)
			-- Connection details (reitifications)
			insert into #subjects (subject, showDetail, expanded, URI)
				select Reitification, 0, 0, ReitificationURI
					from #connections
					where Reitification is not null and Reitification not in (select subject from #subjects)
		end
	end

	--*******************************************************************************************
	--*******************************************************************************************
	-- Get property values
	--*******************************************************************************************
	--*******************************************************************************************

	-- Get custom settings to override the [Ontology.].[ClassProperty] default values
	insert into #ClassPropertyCustom (ClassPropertyID, IncludeProperty, Limit, IncludeNetwork, IncludeDescription)
		select p.ClassPropertyID, t.IncludeProperty, t.Limit, t.IncludeNetwork, t.IncludeDescription
			from [Ontology.].[ClassProperty] p
				inner join (
					select	x.value('@Class','varchar(400)') Class,
							x.value('@NetworkProperty','varchar(400)') NetworkProperty,
							x.value('@Property','varchar(400)') Property,
							(case x.value('@IncludeProperty','varchar(5)') when 'true' then 1 when 'false' then 0 else null end) IncludeProperty,
							x.value('@Limit','int') Limit,
							(case x.value('@IncludeNetwork','varchar(5)') when 'true' then 1 when 'false' then 0 else null end) IncludeNetwork,
							(case x.value('@IncludeDescription','varchar(5)') when 'true' then 1 when 'false' then 0 else null end) IncludeDescription
					from @ExpandRDFListXML.nodes('//ExpandRDF') as R(x)
				) t
				on p.Class=t.Class and p.Property=t.Property
					and ((p.NetworkProperty is null and t.NetworkProperty is null) or (p.NetworkProperty = t.NetworkProperty))

	-- Get properties and loop if objects need to be expanded
	declare @numLoops int
	declare @maxLoops int
	declare @actualLoops int
	declare @NewSubjects int
	select @numLoops = 0, @maxLoops = 10, @actualLoops = 0
	while (@numLoops < @maxLoops)
	begin
		-- Get the types of each subject that hasn't been expanded
		truncate table #types
		insert into #types(subject,object,predicate,showDetail,uri)
			select s.subject, t.object, null, s.showDetail, s.uri
				from #subjects s 
					inner join [RDF.].Triple t on s.subject = t.subject 
						and t.predicate = @typeID 
					inner join [RDF.].Node n on t.object = n.NodeID
						and ((n.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (n.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (1 = CASE WHEN @HasSecurityGroupNodes = 0 THEN 0 WHEN n.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes) THEN 1 ELSE 0 END))
						and ((t.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (t.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (1 = CASE WHEN @HasSecurityGroupNodes = 0 THEN 0 WHEN t.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes) THEN 1 ELSE 0 END))
				where s.expanded = 0				   
		-- Get the subject types of each reitification that hasn't been expanded
		insert into #types(subject,object,predicate,showDetail,uri)
		select distinct s.subject, t.object, r.predicate, s.showDetail, s.uri
			from #subjects s 
				inner join [RDF.].Triple r on s.subject = r.reitification
				inner join [RDF.].Triple t on r.subject = t.subject 
					and t.predicate = @typeID 
				inner join [RDF.].Node n on t.object = n.NodeID
					and ((n.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (n.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (1 = CASE WHEN @HasSecurityGroupNodes = 0 THEN 0 WHEN n.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes) THEN 1 ELSE 0 END))
					and ((t.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (t.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (1 = CASE WHEN @HasSecurityGroupNodes = 0 THEN 0 WHEN t.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes) THEN 1 ELSE 0 END))
					and ((r.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (r.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (1 = CASE WHEN @HasSecurityGroupNodes = 0 THEN 0 WHEN r.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes) THEN 1 ELSE 0 END))
			where s.expanded = 0
		-- Get the items that should be expanded
		truncate table #expand
		insert into #expand(subject, predicate, uri, property, tagName, propertyLabel, IsDetail, limit, showStats, showSummary)
			select p.subject, o._PropertyNode, max(p.uri) uri, o.property, o._TagName, o._PropertyLabel, min(o.IsDetail*1) IsDetail, 
					(case when min(o.IsDetail*1) = 0 then max(case when o.IsDetail=0 then IsNull(c.limit,o.limit) else null end) else max(IsNull(c.limit,o.limit)) end) limit,
					(case when min(o.IsDetail*1) = 0 then max(case when o.IsDetail=0 then IsNull(c.IncludeNetwork,o.IncludeNetwork)*1 else 0 end) else max(IsNull(c.IncludeNetwork,o.IncludeNetwork)*1) end) showStats,
					(case when min(o.IsDetail*1) = 0 then max(case when o.IsDetail=0 then IsNull(c.IncludeDescription,o.IncludeDescription)*1 else 0 end) else max(IsNull(c.IncludeDescription,o.IncludeDescription)*1) end) showSummary
				from #types p
					inner join [Ontology.].ClassProperty o
						on p.object = o._ClassNode 
						and ((p.predicate is null and o._NetworkPropertyNode is null) or (p.predicate = o._NetworkPropertyNode))
						and o.IsDetail <= p.showDetail
					left outer join #ClassPropertyCustom c
						on o.ClassPropertyID = c.ClassPropertyID
				where IsNull(c.IncludeProperty,1) = 1
				group by p.subject, o.property, o._PropertyNode, o._TagName, o._PropertyLabel
		-- Get the values for each property that should be expanded
		insert into #properties (uri,subject,predicate,object,showSummary,property,tagName,propertyLabel,Language,DataType,Value,ObjectType,SortOrder)
			select e.uri, e.subject, t.predicate, t.object, e.showSummary,
					e.property, e.tagName, e.propertyLabel, 
					o.Language, o.DataType, o.Value, o.ObjectType, t.SortOrder
			from #expand e
				inner join [RDF.].Triple t
					on t.subject = e.subject and t.predicate = e.predicate
						and (e.limit is null or t.sortorder <= e.limit)
						and ((t.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (t.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (1 = CASE WHEN @HasSecurityGroupNodes = 0 THEN 0 WHEN t.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes) THEN 1 ELSE 0 END))
				inner join [RDF.].Node p
					on t.predicate = p.NodeID
						and ((p.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (p.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (1 = CASE WHEN @HasSecurityGroupNodes = 0 THEN 0 WHEN p.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes) THEN 1 ELSE 0 END))
				inner join [RDF.].Node o
					on t.object = o.NodeID
						and ((o.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (o.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (1 = CASE WHEN @HasSecurityGroupNodes = 0 THEN 0 WHEN o.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes) THEN 1 ELSE 0 END))
		-- Get network properties
		if (@numLoops = 0)
		begin
			-- Calculate network statistics
			select e.uri, e.subject, t.predicate, e.property, e.tagName, e.PropertyLabel, 
					cast(isnull(count(*),0) as varchar(50)) numberOfConnections,
					cast(isnull(max(t.Weight),1) as varchar(50)) maxWeight,
					cast(isnull(min(t.Weight),1) as varchar(50)) minWeight,
					@baseURI+cast(e.subject as varchar(50))+'/'+cast(t.predicate as varchar(50)) networkURI
				into #networks
				from #expand e
					inner join [RDF.].Triple t
						on t.subject = e.subject and t.predicate = e.predicate
							and (e.showStats = 1)
							and ((t.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (t.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (1 = CASE WHEN @HasSecurityGroupNodes = 0 THEN 0 WHEN t.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes) THEN 1 ELSE 0 END))
					inner join [RDF.].Node p
						on t.predicate = p.NodeID
							and ((p.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (p.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (1 = CASE WHEN @HasSecurityGroupNodes = 0 THEN 0 WHEN p.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes) THEN 1 ELSE 0 END))
					inner join [RDF.].Node o
						on t.object = o.NodeID
							and ((o.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (o.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (1 = CASE WHEN @HasSecurityGroupNodes = 0 THEN 0 WHEN o.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes) THEN 1 ELSE 0 END))
				group by e.uri, e.subject, t.predicate, e.property, e.tagName, e.PropertyLabel
			-- Create properties from network statistics
			;with networkProperties as (
				select 1 n, 'http://profiles.catalyst.harvard.edu/ontology/prns#hasNetwork' property, 'prns:hasNetwork' tagName, 'has network' propertyLabel, 0 ObjectType
				union all select 2, 'http://profiles.catalyst.harvard.edu/ontology/prns#numberOfConnections', 'prns:numberOfConnections', 'number of connections', 1
				union all select 3, 'http://profiles.catalyst.harvard.edu/ontology/prns#maxWeight', 'prns:maxWeight', 'maximum connection weight', 1
				union all select 4, 'http://profiles.catalyst.harvard.edu/ontology/prns#minWeight', 'prns:minWeight', 'minimum connection weight', 1
				union all select 5, 'http://profiles.catalyst.harvard.edu/ontology/prns#predicateNode', 'prns:predicateNode', 'predicate node', 0
				union all select 6, 'http://www.w3.org/1999/02/22-rdf-syntax-ns#predicate', 'rdf:predicate', 'predicate', 0
				union all select 7, 'http://www.w3.org/2000/01/rdf-schema#label', 'rdfs:label', 'label', 1
				union all select 8, 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type', 'rdf:type', 'type', 0
			)
			insert into #properties (uri,subject,predicate,property,tagName,propertyLabel,Value,ObjectType,SortOrder)
				select	(case p.n when 1 then n.uri else n.networkURI end),
						(case p.n when 1 then subject else null end),
						[RDF.].fnURI2NodeID(p.property), p.property, p.tagName, p.propertyLabel,
						(case p.n when 1 then n.networkURI 
									when 2 then n.numberOfConnections
									when 3 then n.maxWeight
									when 4 then n.minWeight
									when 5 then @baseURI+cast(n.predicate as varchar(50))
									when 6 then n.property
									when 7 then n.PropertyLabel
									when 8 then 'http://profiles.catalyst.harvard.edu/ontology/prns#Network'
									end),
						p.ObjectType,
						1
					from #networks n, networkProperties p
					where p.n = 1 or @expand = 1
		end
		-- Mark that all previous subjects have been expanded
		update #subjects set expanded = 1 where expanded = 0
		-- See if there are any new subjects that need to be expanded
		insert into #subjects(subject,showDetail,expanded,uri)
			select distinct object, 0, 0, value
				from #properties
				where showSummary = 1
					and ObjectType = 0
					and object not in (select subject from #subjects)
		select @NewSubjects = @@ROWCOUNT		
		insert into #subjects(subject,showDetail,expanded,uri)
			select distinct predicate, 0, 0, property
				from #properties
				where predicate is not null
					and predicate not in (select subject from #subjects)
		-- If no subjects need to be expanded, then we are done
		if @NewSubjects + @@ROWCOUNT = 0
			select @numLoops = @maxLoops
		select @numLoops = @numLoops + 1 + @maxLoops * (1 - @expand)
		select @actualLoops = @actualLoops + 1
	end
	-- Add tagName as a property of DatatypeProperty and ObjectProperty classes
	insert into #properties (uri, subject, showSummary, property, tagName, propertyLabel, Value, ObjectType, SortOrder)
		select p.uri, p.subject, 0, 'http://profiles.catalyst.harvard.edu/ontology/prns#tagName', 'prns:tagName', 'tag name', 
				n.prefix+':'+substring(p.uri,len(n.uri)+1,len(p.uri)), 1, 1
			from #properties p, [Ontology.].Namespace n
			where p.property = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#type'
				and p.value in ('http://www.w3.org/2002/07/owl#DatatypeProperty','http://www.w3.org/2002/07/owl#ObjectProperty')
				and p.uri like n.uri+'%'
	--select @actualLoops
	--select * from #properties order by (case when uri = @firstURI then 0 else 1 end), uri, tagName, value


	--*******************************************************************************************
	--*******************************************************************************************
	-- Handle the special case where a local node is storing a copy of an external URI
	--*******************************************************************************************
	--*******************************************************************************************

	if (@firstValue IS NOT NULL) AND (@firstValue <> @firstURI)
		insert into #properties (uri, subject, predicate, object, 
				showSummary, property, 
				tagName, propertyLabel, 
				Language, DataType, Value, ObjectType, SortOrder
			)
			select @firstURI uri, @subject subject, predicate, object, 
					showSummary, property, 
					tagName, propertyLabel, 
					Language, DataType, Value, ObjectType, 1 SortOrder
				from #properties
				where uri = @firstValue
					and not exists (select * from #properties where uri = @firstURI)
			union all
			select @firstURI uri, @subject subject, null predicate, null object, 
					0 showSummary, 'http://www.w3.org/2002/07/owl#sameAs' property,
					'owl:sameAs' tagName, 'same as' propertyLabel, 
					null Language, null DataType, @firstValue Value, 0 ObjectType, 1 SortOrder

	--*******************************************************************************************
	--*******************************************************************************************
	-- Generate an XML string from the node properties table
	--*******************************************************************************************
	--*******************************************************************************************

	declare @description nvarchar(max)
	select @description = ''
	-- sort the tags
	select *, 
			row_number() over (partition by uri order by i) j, 
			row_number() over (partition by uri order by i desc) k 
		into #propertiesSorted
		from (
			select *, row_number() over (order by (case when uri = @firstURI then 0 else 1 end), uri, tagName, SortOrder, value) i
				from #properties
		) t
	create unique clustered index idx_i on #propertiesSorted(i)
	-- handle special xml characters in the uri and value strings
	update #propertiesSorted
		set uri = replace(replace(replace(uri,'&','&amp;'),'<','&lt;'),'>','&gt;')
		where uri like '%[&<>]%'
	update #propertiesSorted
		set value = replace(replace(replace(value,'&','&amp;'),'<','&lt;'),'>','&gt;')
		where value like '%[&<>]%'
	-- concatenate the tags
	select @description = (
			select (case when j=1 then '<rdf:Description rdf:about="' + uri + '">' else '' end)
					+'<'+tagName
					+(case when ObjectType = 0 then ' rdf:resource="'+value+'"/>' else '>'+value+'</'+tagName+'>' end)
					+(case when k=1 then '</rdf:Description>' else '' end)
			from #propertiesSorted
			order by i
			for xml path(''), type
		).value('(./text())[1]','nvarchar(max)')
	-- default description if none exists
	if @description IS NULL
		select @description = '<rdf:Description rdf:about="' + @firstURI + '"'
			+IsNull(' xml:lang="'+@dataStrLanguage+'"','')
			+IsNull(' rdf:datatype="'+@dataStrDataType+'"','')
			+IsNull(' >'+replace(replace(replace(@dataStr,'&','&amp;'),'<','&lt;'),'>','&gt;')+'</rdf:Description>',' />')


	--*******************************************************************************************
	--*******************************************************************************************
	-- Return as a string or as XML
	--*******************************************************************************************
	--*******************************************************************************************

	select @dataStr = IsNull(@dataStr,@description)

	declare @x as varchar(max)
	select @x = '<rdf:RDF'
	select @x = @x + ' xmlns:'+Prefix+'="'+URI+'"' 
		from [Ontology.].Namespace
	select @x = @x + ' >' + @description + '</rdf:RDF>'

	if @returnXML = 1 and @returnXMLasStr = 0
		select cast(replace(@x,char(13),'&#13;') as xml) RDF

	if @returnXML = 1 and @returnXMLasStr = 1
		select @x RDF

	/*	
		declare @d datetime
		select @d = getdate()
		select datediff(ms,@d,getdate())
	*/
		
END


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering [RDF.].[GetStoreNode]'
GO
ALTER PROCEDURE [RDF.].[GetStoreNode]
	-- Cat0
	@ExistingNodeID bigint = null,
	-- Cat1
	@Value nvarchar(max) = null,
	@Language nvarchar(255) = null,
	@DataType nvarchar(255) = null,
	@ObjectType bit = null,
	-- Cat2
	@Class nvarchar(400) = null,
	@InternalType nvarchar(100) = null,
	@InternalID nvarchar(100) = null,
	-- Cat3
	@TripleID bigint = null,
	-- Cat5, Cat6
	@StartTime nvarchar(100) = null,
	@EndTime nvarchar(100) = null,
	@TimePrecision nvarchar(100) = null,
	-- Cat7
	@DefaultURI bit = null,
	-- Cat8
	@EntityClassID bigint = null,
	@EntityClassURI varchar(400) = null,
	@Label nvarchar(max) = null,
	@ForceNewEntity bit = 0,
	-- Cat9
	@SubjectID bigint = null,
	@PredicateID bigint = null,
	@SortOrder int = null,
	-- Attributes
	@ViewSecurityGroup bigint = null,
	@EditSecurityGroup bigint = null,
	-- Security
	@SessionID uniqueidentifier = NULL,
	-- Output variables
	@Error bit = NULL OUTPUT,
	@NodeID bigint = NULL OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 
	/* 
	The node can be defined in different ways:
		Cat 0: ExistingNodeID (a NodeID from [RDF.].Node)
		Cat 1: Value, Language, DataType, ObjectType (standard RDF literal [ObjectType=1], or just Value if URI [ObjectType=0])
		Cat 2: NodeType (primary VIVO type, http://xmlns.com/foaf/0.1/Person), InternalType (Profiles10 type, such as "Person"), InternalID (personID=32213)
		Cat 3: TripleID (from [RDF.].Triple -- a reitification)
		Cat 5: StartTime, EndTime, TimePrecision (VIVO's DateTimeInterval, DateTimeValue, and DateTimeValuePrecision classes)
		Cat 6: StartTime, TimePrecision (VIVO's DateTimeValue, and DateTimeValuePrecision classes)
		Cat 7: The default URI: baseURI+NodeID
		Cat 8: New entity with class (by node ID or URI) and label; ForceNewEntity=1 always creates a new node
		Cat 9: The object node of a triple given the SubjectID node, PredicateID node, and the triple sort order
	*/

	SELECT @Error = 0
	
	SELECT @ExistingNodeID = NULL WHERE @ExistingNodeID = 0
	SELECT @TripleID = NULL WHERE @TripleID = 0
 
 	IF (@EntityClassID IS NULL) AND (@EntityClassURI IS NOT NULL)
		SELECT @EntityClassID = [RDF.].fnURI2NodeID(@EntityClassURI)
 
	-- Determine the category
	DECLARE @Category INT
	SELECT @Category = (
		CASE
			WHEN (@ExistingNodeID IS NOT NULL) THEN 0
			WHEN (@Value IS NOT NULL) THEN 1
			WHEN ((@Class IS NOT NULL) AND (@InternalType IS NOT NULL) AND (@InternalID IS NOT NULL)) THEN 2
			WHEN (@TripleID IS NOT NULL) THEN 3
			WHEN ((@StartTime IS NOT NULL) AND (@EndTime IS NOT NULL) AND (@TimePrecision IS NOT NULL)) THEN 5
			WHEN ((@StartTime IS NOT NULL) AND (@TimePrecision IS NOT NULL)) THEN 6
			WHEN (@DefaultURI = 1) THEN 7
			WHEN ((@EntityClassID IS NOT NULL) AND (IsNull(@Label,'')<>'')) THEN 8
			WHEN ((@SubjectID IS NOT NULL) AND (@PredicateID IS NOT NULL) AND (@SortOrder IS NOT NULL)) THEN 9
			ELSE NULL END)

	IF @Category IS NULL
	BEGIN
		SELECT @Error = 1
		RETURN
	END
	
	-- Determine if the node already exists
	SELECT @NodeID = (CASE
		WHEN @Category = 0 THEN (
				SELECT NodeID
				FROM [RDF.].[Node]
				WHERE NodeID = @ExistingNodeID
			)
		WHEN @Category = 1 THEN (
				SELECT NodeID
				FROM [RDF.].[Node]
				WHERE ValueHash = [RDF.].[fnValueHash](@Language,@DataType,@Value)
			)
		WHEN @Category = 2 THEN (
				SELECT NodeID
				FROM [RDF.Stage].InternalNodeMap
				WHERE Class = @Class AND InternalType = @InternalType AND InternalID = @InternalID
			)
		WHEN @Category = 8 THEN (
				SELECT NodeID
				FROM [RDF.].Triple t, [RDF.].Triple v, [RDF.].Node n
				WHERE t.subject = v.subject
					AND t.predicate = [RDF.].fnURI2NodeID('http://www.w3.org/1999/02/22-rdf-syntax-ns#type')
					AND t.object = @EntityClassID
					AND v.predicate = [RDF.].fnURI2NodeID('http://www.w3.org/2000/01/rdf-schema#label')
					AND v.object = n.NodeID
					AND n.ValueHash = [RDF.].[fnValueHash](null,null,@Label)
					AND @ForceNewEntity = 0
			)
		WHEN @Category = 9 THEN (
				SELECT t.Object
				FROM [RDF.].[Triple] t
				WHERE t.subject = @SubjectID
					AND t.predicate = @PredicateID
					AND t.SortOrder = @SortOrder
			)
		ELSE NULL END)

	-- Update attributes of an existing node
	IF (@NodeID IS NOT NULL) AND (IsNull(@ViewSecurityGroup,@EditSecurityGroup) IS NOT NULL)
	BEGIN
		UPDATE [RDF.].Node
			SET ViewSecurityGroup = IsNull(@ViewSecurityGroup,ViewSecurityGroup),
				EditSecurityGroup = IsNull(@EditSecurityGroup,EditSecurityGroup)
			WHERE NodeID = @NodeID
	END
	
	-- Check that if a new node is needed, then all attributes are defined
	IF (@NodeID IS NULL)
	BEGIN
		SELECT	@ViewSecurityGroup = IsNull(@ViewSecurityGroup,-1),
				@EditSecurityGroup = IsNull(@EditSecurityGroup,-40)
		SELECT	@ObjectType = (CASE WHEN @Value LIKE 'http://%' or @Value LIKE 'https://%' THEN 0 ELSE 1 END)
			WHERE (@Category=1 AND @ObjectType IS NULL)
	END

	-- Create a new node if needed
	IF (@NodeID IS NULL)	
	BEGIN
		BEGIN TRY 
		BEGIN TRANSACTION
		
		-- Lookup the base URI
		DECLARE @baseURI NVARCHAR(400)
		SELECT @baseURI = Value FROM [Framework.].Parameter WHERE ParameterID = 'baseURI'

		-- Create node based on category
		IF @Category = 1
			BEGIN
				INSERT INTO [RDF.].[Node] (ViewSecurityGroup, EditSecurityGroup, Language, DataType, Value, ObjectType, ValueHash)
					SELECT @ViewSecurityGroup, @EditSecurityGroup, @Language, @DataType, @Value, @ObjectType,
						[RDF.].[fnValueHash](@Language,@DataType,@Value)
				SET @NodeID = @@IDENTITY
			END
		IF @Category = 2
			BEGIN
				-- Create the InternalNodeMap record
				DECLARE @InternalNodeMapID BIGINT
				INSERT INTO [RDF.Stage].[InternalNodeMap] (InternalType, InternalID, NodeType, Status, InternalHash)
					SELECT @InternalType, @InternalID, @Class, 4, 
						[R DF.].fnValueHash(null,null,@Class+'^^'+@InternalType+'^^'+@InternalID)
				SET @InternalNodeMapID = @@IDENTITY
				-- Create the Node
				INSERT INTO [RDF.].[Node] (ViewSecurityGroup, EditSecurityGroup, InternalNodeMapID, ObjectType, Value, ValueHash)
					SELECT @ViewSecurityGroup, @EditSecurityGroup, @InternalNodeMapID, 0,
						'#INM'+cast(@InternalNodeMapID as nvarchar(50)),
						[RDF.].fnValueHash(null,null,'#INM'+cast(@InternalNodeMapID as nvarchar(50)))
				SET @NodeID = @@IDENTITY
				-- Update the InternalNodeMap, given the NodeID
				UPDATE [RDF.Stage].[InternalNodeMap]
					SET NodeID = @NodeID, Status = 0,
						ValueHash = [RDF.].fnValueHash(null,null,@baseURI+cast(@NodeID as nvarchar(50)))
					WHERE InternalNodeMapID = @InternalNodeMapID
				-- Update the Node, given the NodeID
				UPDATE [RDF.].[Node]
					SET Value = @baseURI+cast(@NodeID as nvarchar(50)),
						ValueHash = [RDF.].fnValueHash(null,null,@baseURI+cast(@NodeID as nvarchar(50)))
					WHERE NodeID = @NodeID
			END
		IF @Category = 7
			BEGIN
				-- Create the Node
				DECLARE @TempValue varchar(50)
				SELECT @TempValue = '#NODE'+cast(NewID() as varchar(50))
				INSERT INTO [RDF.].[Node] (ViewSecurityGroup, EditSecurityGroup, Value, ObjectType, ValueHash)
					SELECT @ViewSecurityGroup, @EditSecurityGroup, @TempValue, 0, [RDF.].[fnValueHash](NULL,NULL,@TempValue)
				SET @NodeID = @@IDENTITY
				-- Update the Node, given the NodeID
				UPDATE [RDF.].[Node]
					SET Value = @baseURI+cast(@NodeID as nvarchar(50)),
						ValueHash = [RDF.].fnValueHash(null,null,@baseURI+cast(@NodeID as nvarchar(50)))
					WHERE NodeID = @NodeID
			END
		IF @Category = 8
			BEGIN
				-- Create the new node
				EXEC [RDF.].GetStoreNode	@DefaultURI = 1,
											@ViewSecurityGroup = @ViewSecurityGroup,
											@EditSecurityGroup = @EditSecurityGroup,
											@SessionID = @SessionID,
											@Error = @Error OUTPUT,
											@NodeID = @NodeID OUTPUT
				IF @Error = 1
				BEGIN
					RETURN
				END
				-- Convert URIs to NodeIDs
				DECLARE @TypeID BIGINT
				DECLARE @LabelID BIGINT
				DECLARE @ClassID BIGINT
				DECLARE @SubClassID BIGINT
				SELECT	@TypeID = [RDF.].fnURI2NodeID('http://www.w3.org/1999/02/22-rdf-syntax-ns#type'),
						@LabelID = [RDF.].fnURI2NodeID('http://www.w3.org/2000/01/rdf-schema#label'),
						@ClassID = [RDF.].fnURI2NodeID('http://www.w3.org/2002/07/owl#Class'),
						@SubClassID = [RDF.].fnURI2NodeID('http://www.w3.org/2000/01/rdf-schema#subClassOf')
				-- Add class(es) to new node
				DECLARE @TempClassID BIGINT
				SELECT @TempClassID = @EntityClassID
				WHILE (@TempClassID IS NOT NULL)
				BEGIN
					EXEC [RDF.].GetStoreTriple	@SubjectID = @NodeID,
												@PredicateID = @TypeID,
												@ObjectID = @TempClassID,
												@ViewSecurityGroup = -1,
												@Weight = 1,
												@SessionID = @SessionID,
												@Error = @Error OUTPUT
					IF @Error = 1
					BEGIN
						RETURN
					END
					-- Determine if there is a parent class
					SELECT @TempClassID = (
							SELECT TOP 1 t.object
							FROM [RDF.].Triple t, [RDF.].Triple c
							WHERE t.subject = @TempClassID
								AND t.predicate = @SubClassID
								AND c.subject = t.object
								AND c.predicate = @TypeID
								AND c.object = @ClassID
								AND NOT EXISTS (
									SELECT *
									FROM [RDF.].Triple v
									WHERE v.subject = @NodeID
										AND v.predicate = @TypeID
										AND v.object = t.object
								)
						)
				END
				-- Get node ID for label
				DECLARE @LabelNodeID BIGINT
				EXEC [RDF.].GetStoreNode	@Value = @Label,
											@ObjectType = 1,
											@ViewSecurityGroup = -1,
											@EditSecurityGroup = -40,
											@SessionID = @SessionID,
											@Error = @Error OUTPUT,
											@NodeID = @LabelNodeID OUTPUT
				IF @Error = 1
				BEGIN
					RETURN
				END
				-- Add label to new node
				EXEC [RDF.].GetStoreTriple	@SubjectID = @NodeID,
											@PredicateID = @LabelID,
											@ObjectID = @LabelNodeID,
											@ViewSecurityGroup = -1,
											@Weight = 1,
											@SortOrder = 1,
											@SessionID = @SessionID,
											@Error = @Error OUTPUT
				IF @Error = 1
				BEGIN
					RETURN
				END
			END
		IF @Category = 9
			BEGIN
				-- We can't create a new node in this case, so throw an error
				SELECT @Error = 1
			END
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
		--Check success
		IF @@TRANCOUNT > 0  ROLLBACK
 
		-- Raise an error with the details of the exception
		SELECT @ErrMsg =  ERROR_MESSAGE(),
					 @ErrSeverity = ERROR_SEVERITY()
 
		RAISERROR(@ErrMsg, @ErrSeverity, 1)
			 
	END CATCH		
	END

END
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering [Ontology.Import].[ConvertTriple2OWL]'
GO
ALTER PROCEDURE [Ontology.Import].[ConvertTriple2OWL]
	@OWL varchar(50),
	@Graph bigint = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- This stored procedure is currently only intended for use with @OWL = 'PRNS_1.0' (and @Graph = 3)

	select t.subject, n.prefix+':'+right(t.predicate,len(t.predicate)-len(n.uri)) predicate, t.object
		into #t
		from [Ontology.Import].Triple t, [Ontology.].Namespace n
		where t.OWL = @OWL and t.Predicate like n.URI+'%'
		order by t.subject, predicate, t.object
	 
	declare @z as varchar(max)

	select @z =
		(select 
				'<rdf:Description rdf:about="'+subject+'">'
				+(
					select '<'+v.predicate+' rdf:resource="'+v.object+'"/>' 
					from #t v 
					where v.subject = t.subject 
					order by v.predicate, v.object
					for xml path(''), type
				).value('(./text())[1]','nvarchar(max)')
				+'</rdf:Description>'
			from (select distinct subject from #t) t
			order by t.subject
			for xml path(''), type
		).value('(./text())[1]','nvarchar(max)')

	declare @x as varchar(max)
	select @x = '<rdf:RDF'
	select @x = @x + ' xmlns:'+Prefix+'="'+URI+'"' 
		from [Ontology.].Namespace
	select @x = @x + ' >' + @z + '</rdf:RDF>'

	-- select cast(@x as xml) RDF
	BEGIN TRY
		begin transaction

			delete 
				from [Ontology.Import].[OWL] 
				where Name = @OWL

			insert into [Ontology.Import].[OWL] (Name, Data, Graph)
				select @OWL, cast(@x as xml), @Graph

		commit transaction
	END TRY
	BEGIN CATCH
		DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
		--Check success
		IF @@TRANCOUNT > 0  ROLLBACK
 
		-- Raise an error with the details of the exception
		SELECT @ErrMsg =  ERROR_MESSAGE(),
					 @ErrSeverity = ERROR_SEVERITY()
 
		RAISERROR(@ErrMsg, @ErrSeverity, 1)
			 
	END CATCH		


	-- select * from [Ontology.Import].[OWL]

END
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Altering [RDF.].[GetPropertyList]'
GO
ALTER PROCEDURE [RDF.].[GetPropertyList]
	@RDF xml = NULL,
	@RDFStr nvarchar(max) = NULL,
	@PresentationXML xml,
	@RootPath nvarchar(max) = 'rdf:RDF[1]/rdf:Description[1]',
	@ShowAllProperties bit = 0,
	@CountsOnly bit = 0,
	@PropertyGroupURI varchar(400) = NULL,
	@PropertyURI varchar(400) = NULL,
	@returnTable bit = 0,
	@returnXML bit = 1,
	@returnXMLasStr bit = 0,
	@PropertyListXML xml = NULL OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-----------------------------------------------------
	-- Copy the @RDFStr value to the @RDF variable
	-----------------------------------------------------

	if (@RDF is null and @RDFStr is not null)
		select @RDF = cast(replace(@RDFStr,char(13),'&#13;') as xml)

	-----------------------------------------------------
	-- Define temp tables and variables
	-----------------------------------------------------
		
	create table #RDFData (
		ItemSortOrder int identity(0,1) primary key,
		TagName varchar(400),
		ObjectValue nvarchar(max),
		ObjectURI varchar(400),
		ObjectClass varchar(400),
		ObjectClassName varchar(max)
	)

	declare @sql nvarchar(max)



	-----------------------------------------------------
	-- Parse the RDF data
	-----------------------------------------------------

	select @sql = ''
	select @sql = @sql + ' '''+URI+''' as '+Prefix+','
		from [Ontology.].Namespace
	select @sql = left(@sql,len(@sql)-1)
		
	select @sql = '
		;WITH XMLNAMESPACES (
			'+@sql+'
		), RDFDescriptions as (
			select	z.value(''@rdf:about'',''varchar(max)'') About,
					z.value(''rdfs:label[1]'',''varchar(max)'') Label,
					(select top 1 t.ClassURI
						from (select x.value(''@rdf:resource[1]'',''varchar(max)'') ClassURI
								from z.nodes(''rdf:type'') as t(x)
							) t
							left outer join [Ontology.].ClassTreeDepth d
							on t.ClassURI = d.Class
						order by (case when d._TreeDepth is null then 1 else 0 end), d._TreeDepth desc
					) Class
			from (select @RDF as x) t cross apply x.nodes(''rdf:RDF[1]/rdf:Description'') as R(z)
		), RDFTagsTemp as (
			select	z.value(''namespace-uri(.)'',''varchar(max)'') NamespaceURI,
					z.value(''local-name(.)'',''varchar(max)'') LocalName,
					z.value(''@rdf:resource'',''varchar(max)'') Resource,
					z.value(''.'',''nvarchar(max)'') Value
			from (select @RDF.query('''+@RootPath+''') as x) t cross apply x.nodes(''rdf:Description/*'') as R(z)
		)
		select	o.Prefix+'':''+b.LocalName TagName, 
					Coalesce(a.Label,b.Resource,b.Value) ObjectValue, 
					b.Resource ObjectURI,
					a.Class ObjectClass,
					c.Label ObjectClassName
			from RDFTagsTemp b 
				inner join [Ontology.].[Namespace] o on o.URI = b.NamespaceURI
				left outer join RDFDescriptions a on b.Resource = a.About
				left outer join RDFDescriptions c on a.Class = c.About
		'
		
	insert into #RDFData (TagName, ObjectValue, ObjectURI, ObjectClass, ObjectClassName)
			EXEC sp_executesql @sql, N'@RDF xml', @RDF = @RDF

	--create nonclustered index idx_TagName on #RDFData(TagName)

	-----------------------------------------------------
	-- Parse the PresentationXML
	-----------------------------------------------------

	select p.*, s.Label ViewSecurityGroupLabel
		into #Properties
		from (
			select	R.p.value('../@URI','varchar(400)') PropertyGroupURI,
					R.p.value('../@Label','varchar(max)') PropertyGroupLabel,
					R.p.value('../@SortOrder','int') PropertyGroupSortOrder,
					R.p.value('@URI','varchar(400)') PropertyURI,
					R.p.value('@Label','varchar(max)') PropertyLabel,
					R.p.value('@SortOrder','int') PropertySortOrder,
					R.p.value('@TagName','varchar(400)') TagName,
					R.p.value('@CustomDisplay','varchar(max)') CustomDisplay,
					R.p.value('@CustomEdit','varchar(max)') CustomEdit,
					R.p.value('@ViewSecurityGroup','bigint') ViewSecurityGroup,
					R.p.value('@EditPermissions','varchar(max)') EditPermissions,
					R.p.value('@EditExisting','varchar(max)') EditExisting,
					R.p.value('@EditAddNew','varchar(max)') EditAddNew,
					R.p.value('@EditAddExisting','varchar(max)') EditAddExisting,
					R.p.value('@EditDelete','varchar(max)') EditDelete,
					R.p.value('@MinCardinality','varchar(max)') MinCardinality,
					R.p.value('@MaxCardinality','varchar(max)') MaxCardinality,
					R.p.value('@ObjectType','bit') ObjectType,
					R.p.value('@HasDataFeed','varchar(max)') HasDataFeed,
					(case when cast(R.p.query('./*') as nvarchar(max))='' then null else R.p.query('./*') end) CustomModule
				from (select @PresentationXML x) t cross apply t.x.nodes('Presentation/PropertyList/PropertyGroup/Property') as R(p)
		) p left outer join (
			select	R.p.value('@ID','bigint') ID,
					R.p.value('@Label','varchar(max)') Label
				from (select @PresentationXML x) t cross apply t.x.nodes('Presentation/SecurityGroupList/SecurityGroup') as R(p)
		) s on p.ViewSecurityGroup = s.ID
		where PropertyGroupURI = IsNull(@PropertyGroupURI,PropertyGroupURI)
			and PropertyURI = IsNull(@PropertyURI,PropertyURI)
			and (@ShowAllProperties = 1 or (TagName in (select TagName from #RDFData)))

	--create nonclustered index idx_TagName on #Properties(TagName)
	--create nonclustered index idx_PropertyGroupURI on #Properties(PropertyGroupURI)
	--create nonclustered index idx_PropertyURI on #Properties(PropertyURI)

	-----------------------------------------------------
	-- Create the Property List
	-----------------------------------------------------

	if @returnTable = 1 and @CountsOnly = 0
		select	p.PropertyGroupURI, p.PropertyGroupLabel, p.PropertyGroupSortOrder, IsNull(gn.Items,0) NumberOfPropertyGroupConnections,
				p.PropertyURI, p.PropertyLabel, p.PropertySortOrder, p.TagName, IsNull(pn.Items,0) NumberOfPropertyConnections,
				r.ItemSortOrder, r.ObjectValue, r.ObjectURI, r.ObjectClass, r.ObjectClassName,
				p.CustomDisplay, p.ViewSecurityGroup, p.ViewSecurityGroupLabel, p.CustomEdit,
				p.EditPermissions, p.EditExisting, p.EditAddNew, p.EditAddExisting, p.EditDelete,
				p.MinCardinality, p.MaxCardinality, p.OjbectType, p.HasDataFeed,
				p.CustomModule
			from #Properties p
				left outer join (
					select p.PropertyGroupURI, count(*) Items
						from #Properties p inner join #RDFData r
							on p.TagName = r.TagName
					group by p.PropertyGroupURI
				) gn on gn.PropertyGroupURI = p.PropertyGroupURI
				left outer join (
					select p.PropertyURI, count(*) Items
						from #Properties p inner join #RDFData r
							on p.TagName = r.TagName
					group by p.PropertyURI
				) pn on pn.PropertyURI = p.PropertyURI
				left outer join #RDFData r
					on p.TagName = r.TagName
			where (@ShowAllProperties = 1 or r.ItemSortOrder is not null)
			order by p.PropertyGroupSortOrder, p.PropertySortOrder, r.ItemSortOrder


	if @returnTable = 1 and @CountsOnly = 1
		select	p.PropertyGroupURI, p.PropertyGroupLabel, p.PropertyGroupSortOrder, IsNull(gn.Items,0) NumberOfPropertyGroupConnections,
				p.PropertyURI, p.PropertyLabel, p.PropertySortOrder, p.TagName, IsNull(pn.Items,0) NumberOfPropertyConnections,
				p.CustomDisplay, p.ViewSecurityGroup, p.ViewSecurityGroupLabel, p.CustomEdit,
				p.EditPermissions, p.EditExisting, p.EditAddNew, p.EditAddExisting, p.EditDelete,
				p.MinCardinality, p.MaxCardinality, p.ObjectType, p.HasDataFeed,
				p.CustomModule
			from #Properties p
				left outer join (
					select p.PropertyGroupURI, count(*) Items
						from #Properties p inner join #RDFData r
							on p.TagName = r.TagName
					group by p.PropertyGroupURI
				) gn on gn.PropertyGroupURI = p.PropertyGroupURI
				left outer join (
					select p.PropertyURI, count(*) Items
						from #Properties p inner join #RDFData r
							on p.TagName = r.TagName
					group by p.PropertyURI
				) pn on pn.PropertyURI = p.PropertyURI
			where (@ShowAllProperties = 1 or pn.PropertyURI is not null)
			order by p.PropertyGroupSortOrder, p.PropertySortOrder


	if (@returnTable = 0 or @returnXML = 1)
		select @PropertyListXML = (
			select (
				select	g.PropertyGroupURI "@URI",
						g.PropertyGroupLabel "@Label",
						g.PropertyGroupSortOrder "@SortOrder",
						(select	count(*)
							from #Properties p, #RDFData r
							where p.PropertyGroupURI = g.PropertyGroupURI and r.TagName = p.TagName
						) "@NumberOfConnections",
						(
							select	p.PropertyURI "@URI",
									p.PropertyLabel "@Label",
									p.PropertySortOrder "@SortOrder",
									p.TagName "@TagName",
									(select	count(*)
										from #RDFData r
										where r.TagName = p.TagName
									) "@NumberOfConnections",
									p.CustomDisplay "@CustomDisplay",
									p.ViewSecurityGroup "@ViewSecurityGroup",
									p.ViewSecurityGroupLabel "@ViewSecurityGroupLabel",
									p.CustomEdit "@CustomEdit",
									p.EditPermissions "@EditPermissions",
									p.EditExisting "@EditExisting",
									p.EditAddNew "@EditAddNew",
									p.EditAddExisting "@EditAddExisting",
									p.EditDelete "@EditDelete",
									p.MinCardinality "@MinCardinality",
									p.MaxCardinality "@MaxCardinality",
									p.ObjectType "@ObjectType",
									p.HasDataFeed "@HasDataFeed",
									p.CustomModule "CustomModule",
									(case when @CountsOnly = 1 then null else (
											select	row_number() over (order by r.ItemSortOrder) "Connection/@SortOrder",
													r.ObjectURI "Connection/@ResourceURI",
													r.ObjectClass "Connection/@ClassURI",
													r.ObjectClassName "Connection/@ClassName",
													r.ObjectValue "Connection"
												from #RDFData r
												where r.TagName = p.TagName
												order by r.ItemSortOrder
												for xml path(''), type
										) end) "Network"
								from #Properties p
								where p.PropertyGroupURI = g.PropertyGroupURI
								order by p.PropertySortOrder
								for xml path('Property'), type
						)
					from (select distinct PropertyGroupURI, PropertyGroupLabel, PropertyGroupSortOrder from #Properties) g
					order by g.PropertyGroupSortOrder
					for xml path('PropertyGroup'), type
			) "PropertyList"
			for xml path(''), type
		)
		
	if @PropertyListXML is null or (cast(@PropertyListXML as nvarchar(max)) = '')
		select @PropertyListXML = cast('<PropertyList />' as xml)
	
	if @returnXML = 1 and @returnXMLasStr = 0
		select @PropertyListXML PropertyList

	if @returnXML = 1 and @returnXMLasStr = 1
		select cast(@PropertyListXML as nvarchar(max)) PropertyList

END
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [idx_ump] on [Profile.Cache].[Concept.Mesh.PersonPublication]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_ump] ON [Profile.Cache].[Concept.Mesh.PersonPublication] ([PersonID], [MeshHeader], [PMID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [idx_pmid] on [Profile.Cache].[Concept.Mesh.PersonPublication]'
GO
CREATE NONCLUSTERED INDEX [idx_pmid] ON [Profile.Cache].[Concept.Mesh.PersonPublication] ([PMID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [idx_mu] on [Profile.Data].[Publication.Person.Include]'
GO
CREATE NONCLUSTERED INDEX [idx_mu] ON [Profile.Data].[Publication.Person.Include] ([MPID], [PersonID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [idx_u] on [Profile.Data].[Publication.Person.Include]'
GO
CREATE NONCLUSTERED INDEX [idx_u] ON [Profile.Data].[Publication.Person.Include] ([PersonID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [idx_pu] on [Profile.Data].[Publication.Person.Include]'
GO
CREATE NONCLUSTERED INDEX [idx_pu] ON [Profile.Data].[Publication.Person.Include] ([PMID], [PersonID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
PRINT N'Creating index [idx_dq] on [Profile.Data].[Publication.PubMed.Mesh]'
GO
CREATE NONCLUSTERED INDEX [idx_dq] ON [Profile.Data].[Publication.PubMed.Mesh] ([DescriptorName], [QualifierName], [MajorTopicYN], [PMID])
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #tmpErrors (Error) SELECT 1 BEGIN TRANSACTION END
GO
IF EXISTS (SELECT * FROM #tmpErrors) ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT>0 BEGIN
PRINT 'The database update succeeded'
COMMIT TRANSACTION
END
ELSE PRINT 'The database update failed'
GO
DROP TABLE #tmpErrors
GO