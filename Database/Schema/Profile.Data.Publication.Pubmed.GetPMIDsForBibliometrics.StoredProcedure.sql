SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Data].[Publication.Pubmed.GetPMIDsforBibliometrics]
	@BatchSize int = 10000
AS
BEGIN
	Create table #tmp(pmid int primary key)
	insert into #tmp
	SELECT pmid
		FROM [Profile.Data].[Publication.PubMed.Disambiguation]
		WHERE pmid IS NOT NULL 
		UNION   
	SELECT pmid
		FROM [Profile.Data].[Publication.Person.Include]
		WHERE pmid IS NOT NULL 

	declare @c int
	select @c = count(1) from #tmp
	declare @batchID varchar(100)
	select @batchID = NEWID()
	select @batchID batchID, n, (
	select pmid "PMID" FROM #tmp order by pmid offset n * @BatchSize ROWS FETCH NEXT @BatchSize ROWS ONLY FOR XML path(''), ELEMENTS, ROOT('PMIDS')) x
	from [Utility.Math].N where n <= @c / @BatchSize
END
GO
