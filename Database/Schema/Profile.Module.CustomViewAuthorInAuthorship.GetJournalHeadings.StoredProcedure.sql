SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Module].[CustomViewAuthorInAuthorship.GetJournalHeadings]
	@NodeID bigint = NULL,
	@SessionID uniqueidentifier = NULL
AS
BEGIN

--	drop table #SecurityGroupNodes
--	drop table #tmp
--	declare 	@NodeID bigint = 37496,
--	@SessionID uniqueidentifier = NULL

	DECLARE @SecurityGroupID BIGINT, @HasSpecialViewAccess BIT
	EXEC [RDF.Security].GetSessionSecurityGroup @SessionID, @SecurityGroupID OUTPUT, @HasSpecialViewAccess OUTPUT
	CREATE TABLE #SecurityGroupNodes (SecurityGroupNode BIGINT PRIMARY KEY)
	INSERT INTO #SecurityGroupNodes (SecurityGroupNode) EXEC [RDF.Security].GetSessionSecurityGroupNodes @SessionID, @NodeID


	declare @AuthorInAuthorship bigint
	select @AuthorInAuthorship = [RDF.].fnURI2NodeID('http://vivoweb.org/ontology/core#authorInAuthorship') 
	declare @LinkedInformationResource bigint
	select @LinkedInformationResource = [RDF.].fnURI2NodeID('http://vivoweb.org/ontology/core#linkedInformationResource') 


/*	select i.NodeID, p.EntityID, i.Value rdf_about, p.EntityName rdfs_label, 
		p.Reference prns_informationResourceReference, p.EntityDate prns_publicationDate,
		year(p.EntityDate) prns_year, p.pmid bibo_pmid, p.pmcid vivo_pmcid, p.mpid prns_mpid, p.URL vivo_webpage, isnull(b.NumCites, -1) as num_cites, isnull(b.BroadJournalHeading, '')*/
	select /*top 10*/ ROW_NUMBER() OVER (ORDER BY CASE isnull(h.BroadJournalHeading, 'Unknown') WHEN 'Unknown' THEN 1 ELSE 0 END, SUM(isnull(h.Weight, 1)) desc, count(*) desc) as [Order],
	 isnull(h.DisplayName, 'Unknown') BroadJournalHeading, SUM(isnull(h.Weight, 1)) as [Weight], count(*) as [Count], Color--, count(*) * 100.0 / sum (count(*)) over() as Percentage, Sum(isnull(h.Weight, 1))over() as Total
	into #tmp
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

	--select * from #tmp ORDER BY [Weight] desc, [count]desc
	
	DECLARE @totalWeight float
	DECLARE @totalCount int
	SELECT @totalWeight = SUM(Weight), @totalCount = SUM(Count) from #tmp

	DELETE FROM #tmp WHERE BroadJournalHeading = 'Unknown' OR [Order] > 9

	INSERT INTO #tmp ([Order], BroadJournalHeading, [Weight], [Count], Color) 
	SELECT top 1 10, 'Other' as BroadJournalHeading, @totalWeight - (Select top 1 sum ([Weight]) over () from #tmp) AS [Weight], @totalCount - (Select top 1 sum ([Count]) over () from #tmp) AS [Count], '999' from #tmp

	UPDATE #tmp SET [Weight] = [Weight] / @totalWeight;

	select BroadJournalHeading, [Count], Weight, Color from #tmp
	ORDER BY [Order]
END
GO
