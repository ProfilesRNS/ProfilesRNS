SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
