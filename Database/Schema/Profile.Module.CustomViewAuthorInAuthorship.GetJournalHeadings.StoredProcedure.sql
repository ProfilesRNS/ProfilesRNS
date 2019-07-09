SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Module].[CustomViewAuthorInAuthorship.GetJournalHeadings]
	@NodeID bigint = NULL,
	@SessionID uniqueidentifier = NULL
AS
BEGIN
	DECLARE @SecurityGroupID BIGINT, @HasSpecialViewAccess BIT
	EXEC [RDF.Security].GetSessionSecurityGroup @SessionID, @SecurityGroupID OUTPUT, @HasSpecialViewAccess OUTPUT
	CREATE TABLE #SecurityGroupNodes (SecurityGroupNode BIGINT PRIMARY KEY)
	INSERT INTO #SecurityGroupNodes (SecurityGroupNode) EXEC [RDF.Security].GetSessionSecurityGroupNodes @SessionID, @NodeID

	declare @class nvarchar(400)
	select @class = class from [RDF.Stage].InternalNodeMap where nodeid=@NodeID 

	create table #tmp(
		[Order] int,
		BroadJournalHeading varchar(100),
		[Weight] float,
		[Count] int,
		Color varchar(6)
	)

	if @class = 'http://xmlns.com/foaf/0.1/Person'
	BEGIN
		declare @AuthorInAuthorship bigint
		select @AuthorInAuthorship = [RDF.].fnURI2NodeID('http://vivoweb.org/ontology/core#authorInAuthorship') 
		declare @LinkedInformationResource bigint
		select @LinkedInformationResource = [RDF.].fnURI2NodeID('http://vivoweb.org/ontology/core#linkedInformationResource') 

		insert into #tmp
		select /*top 10*/ ROW_NUMBER() OVER (ORDER BY CASE isnull(h.BroadJournalHeading, 'Unknown') WHEN 'Unknown' THEN 1 ELSE 0 END, SUM(isnull(h.Weight, 1)) desc, count(*) desc) as [Order],
		 isnull(h.DisplayName, 'Unknown') BroadJournalHeading, SUM(isnull(h.Weight, 1)) as [Weight], count(*) as [Count], Color--, count(*) * 100.0 / sum (count(*)) over() as Percentage, Sum(isnull(h.Weight, 1))over() as Total
		from [RDF.].[Triple] t
			inner join [RDF.].[Node] a
				on t.subject = @NodeID and t.predicate = @AuthorInAuthorship
					and t.object = a.NodeID
					and ((t.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (t.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (t.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)))
					and ((a.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (a.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (a.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)))
			inner join [RDF.].[Node] i
				on t.object = i.NodeID
					and ((i.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (i.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (i.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)))
			inner join [RDF.Stage].[InternalNodeMap] m
				on i.NodeID = m.NodeID
			inner join [Profile.Data].[Publication.Entity.Authorship] e
				on m.InternalID = e.EntityID
			inner join [Profile.Data].[Publication.Entity.InformationResource] p
				on e.InformationResourceID = p.EntityID
			left join [Profile.Data].[Publication.Pubmed.Bibliometrics] b on p.PMID = b.PMID
			left join [Profile.Data].[Publication.Pubmed.JournalHeading] h on b.MedlineTA = H.MedlineTA
		--order by p.EntityDate desc
		GROUP BY isnull(h.BroadJournalHeading, 'Unknown'), DisplayName, Color
		ORDER BY CASE isnull(h.BroadJournalHeading, 'Unknown') WHEN 'Unknown' THEN 1 ELSE 0 END, SUM(isnull(h.Weight, 1)) desc, count(*) desc
	END
	ELSE if @class = 'http://xmlns.com/foaf/0.1/Group'
	BEGIN

		declare @AssociatedInformationResource bigint
		select @AssociatedInformationResource = [RDF.].fnURI2NodeID('http://profiles.catalyst.harvard.edu/ontology/prns#associatedInformationResource') 

		insert into #tmp
		select /*top 10*/ ROW_NUMBER() OVER (ORDER BY CASE isnull(h.BroadJournalHeading, 'Unknown') WHEN 'Unknown' THEN 1 ELSE 0 END, SUM(isnull(h.Weight, 1)) desc, count(*) desc) as [Order],
		 isnull(h.DisplayName, 'Unknown') BroadJournalHeading, SUM(isnull(h.Weight, 1)) as [Weight], count(*) as [Count], Color--, count(*) * 100.0 / sum (count(*)) over() as Percentage, Sum(isnull(h.Weight, 1))over() as Total
		from [RDF.].[Triple] t
			inner join [RDF.].[Node] a
				on t.subject = @NodeID and t.predicate = @AssociatedInformationResource
					and t.object = a.NodeID
					and ((t.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (t.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (t.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)))
					and ((a.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (a.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (a.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)))
			inner join [RDF.].[Node] i
				on t.object = i.NodeID
					and ((i.ViewSecurityGroup BETWEEN @SecurityGroupID AND -1) OR (i.ViewSecurityGroup > 0 AND @HasSpecialViewAccess = 1) OR (i.ViewSecurityGroup IN (SELECT * FROM #SecurityGroupNodes)))
			inner join [RDF.Stage].[InternalNodeMap] m
				on i.NodeID = m.NodeID
			inner join [Profile.Data].[Publication.Entity.InformationResource] p
				on m.InternalID = p.EntityID
			left join [Profile.Data].[Publication.Pubmed.Bibliometrics] b on p.PMID = b.PMID
			left join [Profile.Data].[Publication.Pubmed.JournalHeading] h on b.MedlineTA = H.MedlineTA
		--order by p.EntityDate desc
		GROUP BY isnull(h.BroadJournalHeading, 'Unknown'), DisplayName, Color
		ORDER BY CASE isnull(h.BroadJournalHeading, 'Unknown') WHEN 'Unknown' THEN 1 ELSE 0 END, SUM(isnull(h.Weight, 1)) desc, count(*) desc
	END
	--select * from #tmp ORDER BY [Weight] desc, [count]desc
	
	DECLARE @totalWeight float
	DECLARE @totalCount int
	SELECT @totalWeight = SUM(Weight), @totalCount = SUM(Count) from #tmp

	DELETE FROM #tmp WHERE BroadJournalHeading = 'Unknown' OR [Order] > 9

	INSERT INTO #tmp ([Order], BroadJournalHeading, [Weight], [Count], Color) 
	SELECT top 1 10, 'Other' as BroadJournalHeading, @totalWeight - (Select top 1 sum ([Weight]) over () from #tmp) AS [Weight], @totalCount - (Select top 1 sum ([Count]) over () from #tmp) AS [Count], 'BAB0AC' from #tmp

	UPDATE #tmp set color = '4E79A7' where [Order] = 1
	UPDATE #tmp set color = 'F28E2B' where [Order] = 2
	UPDATE #tmp set color = 'E15759' where [Order] = 3
	UPDATE #tmp set color = '76B7B2' where [Order] = 4
	UPDATE #tmp set color = '59A14F' where [Order] = 5
	UPDATE #tmp set color = 'EDC948' where [Order] = 6
	UPDATE #tmp set color = 'B07AA1' where [Order] = 7
	UPDATE #tmp set color = 'FF9DA7' where [Order] = 8
	UPDATE #tmp set color = '9C755F' where [Order] = 9
	UPDATE #tmp SET [Weight] = [Weight] / @totalWeight;

	select BroadJournalHeading, [Count], Weight, Color from #tmp
	ORDER BY [Order]
END
GO
