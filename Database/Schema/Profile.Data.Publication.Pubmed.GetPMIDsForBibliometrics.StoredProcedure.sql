SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Data].[Publication.Pubmed.GetPMIDsforBibliometrics]
	@Job varchar(55) = 'Bibliometrics',
	@BatchID varchar(100)
AS
BEGIN
	SET NOCOUNT ON;	

	CREATE TABLE #tmp (LogID INT, BatchID VARCHAR(100), RowID INT, HttpMethod VARCHAR(10), URL VARCHAR(500), PostData VARCHAR(MAX)) 

	Create table #tmp2(pmid int primary key)
	insert into #tmp2
	SELECT pmid
		FROM [Profile.Data].[Publication.PubMed.Disambiguation]
		WHERE pmid IS NOT NULL 
		UNION   
	SELECT pmid
		FROM [Profile.Data].[Publication.Person.Include]
		WHERE pmid IS NOT NULL 

	declare @c int,	@BatchSize int, @rowsCount int, @URL varchar(500), @logLevel int
	select @c = count(1) from #tmp2
	--select @batchID = NEWID()
	select @URL = URL, @BatchSize = batchSize, @logLevel = logLevel from [Profile.Import].[PRNSWebservice.Options] where job = @Job
	insert into #tmp(LogID, BatchID, RowID, HttpMethod, URL, PostData)
	select -1, @batchID batchID, n, 'POST', @URL, (
	select pmid "PMID" FROM #tmp2 order by pmid offset n * @BatchSize ROWS FETCH NEXT @BatchSize ROWS ONLY FOR XML path(''), ELEMENTS, ROOT('PMIDS')) x
	from [Utility.Math].N where n <= @c / @BatchSize

	select @rowsCount = @@ROWCOUNT

	Update [Profile.Import].[PRNSWebservice.Log.Summary]  set RecordsCount = @BatchSize, RowsCount = @rowsCount where BatchID = @BatchID

	DECLARE @LogIDTable TABLE (LogID int, RowID int)
	IF @logLevel = 1
	BEGIN
		INSERT INTO [Profile.Import].[PRNSWebservice.Log] (Job, BatchID, RowID, HttpMethod, URL)
		OUTPUT inserted.LogID, Inserted.RowID into @LogIDTable
		SELECT 'bibliometrics', BatchID, RowID, HttpMethod, URL FROM #tmp
		UPDATE t SET t.LogID = l.LogID FROM #tmp t JOIN @LogIDTable l ON t.RowID = l.RowID
	END
	ELSE IF @logLevel = 2
	BEGIN
		INSERT INTO [Profile.Import].[PRNSWebservice.Log] (Job, BatchID, RowID, HttpMethod, URL, PostData)
		OUTPUT inserted.LogID, Inserted.RowID into @LogIDTable
		SELECT 'bibliometrics', BatchID, RowID, HttpMethod, URL, PostData FROM #tmp
		UPDATE t SET t.LogID = l.LogID FROM #tmp t JOIN @LogIDTable l ON t.RowID = l.RowID
	END

	SELECT * FROM #tmp
END
GO
