SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
