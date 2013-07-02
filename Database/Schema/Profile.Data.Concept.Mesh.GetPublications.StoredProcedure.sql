SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
