SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Profile.Import].[GoogleWebservice.GetGeocodeAPIData]	 
AS
BEGIN
	SET NOCOUNT ON;	

	CREATE TABLE #tmp (LogID INT, BatchID VARCHAR(100), RowID INT IDENTITY, HttpMethod VARCHAR(10), URL VARCHAR(500), PostData VARCHAR(MAX)) 

	INSERT INTO #tmp(URL) 
	SELECT DISTINCT addressstring
	  FROM [Profile.Data].Person
	 WHERE (ISNULL(latitude ,0)=0
 			OR geoscore = 0)
	and addressstring<>''

	DECLARE @bid AS VARCHAR(100)
	SET @bid = NEWID()
	UPDATE t SET
		t.LogID = -1,
		t.BatchID = @bid, 
		t.HttpMethod = 'GET',
		t.URL = o.url + REPLACE(REPLACE(t.URL, '#', '' ), ' ', '+') + '&sensor=false' + isnull('&key=' + apikey, '') 
			FROM #tmp t
			JOIN [Profile.Import].[PRNSWebservice.Options] o ON o.job = 'geocode'

	IF EXISTS (SELECT 1 FROM [Profile.Import].[PRNSWebservice.Options] WHERE job = 'geocode' AND logLevel > 0)
	BEGIN
		DECLARE @LogIDTable TABLE (LogID int, RowID int)
		INSERT INTO [Profile.Import].[PRNSWebservice.Log] (Job, BatchID, RowID, HttpMethod, URL)
		OUTPUT inserted.LogID, Inserted.RowID into @LogIDTable
		SELECT 'Geocode', BatchID, RowID, HttpMethod, URL FROM #tmp

		UPDATE t SET t.LogID = l.LogID FROM #tmp t JOIN @LogIDTable l ON t.RowID = l.RowID
	END

	SELECT * FROM #tmp
END
GO
