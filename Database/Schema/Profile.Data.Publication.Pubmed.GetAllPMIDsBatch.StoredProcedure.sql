SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Profile.Data].[Publication.Pubmed.GetAllPMIDsBatch]
	@BatchSize int = 1000
AS
BEGIN
	Create table #tmp(pmid int primary key, Filename varchar(50))
	insert into #tmp (pmid)
	SELECT pmid
		FROM [Profile.Data].[Publication.PubMed.Disambiguation]
		WHERE pmid IS NOT NULL 
		UNION   
	SELECT pmid
		FROM [Profile.Data].[Publication.Person.Include]
		WHERE pmid IS NOT NULL 

	update t set t.Filename = x.FileName from #tmp t join [Profile.Data].[Publication.PubMed.AllXML] x 
		on t.pmid = x.PMID

	--delete from #tmp where Filename is not null

	declare @c int
	select @c = count(1) from #tmp
	declare @batchID varchar(100)
	select @batchID = NEWID()
	select @batchID batchID, n, (
	select pmid "Publication/@PMID", filename "Publication/@Filename" FROM #tmp 
		order by pmid offset n * @BatchSize ROWS FETCH NEXT @BatchSize ROWS ONLY FOR XML path(''), ELEMENTS, ROOT('Publications')) x
		from [Utility.Math].N where n <= @c / @BatchSize
END
GO
