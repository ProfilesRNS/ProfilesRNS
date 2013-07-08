SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Search.Cache].[History.UpdateTopSearchPhrase]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	CREATE TABLE #TopSearchPhrase (
		TimePeriod CHAR(1) NOT NULL,
		Phrase VARCHAR(100) NOT NULL,
		NumberOfQueries INT
	)

	-- Get top day, week, and month phrases
	
	INSERT INTO #TopSearchPhrase (TimePeriod, Phrase, NumberOfQueries)
		SELECT TOP 10 'd', Phrase, COUNT(*) n
			FROM [Search.].[History.Phrase]
			WHERE NumberOfConnections > 0
				AND LEN(Phrase) <= 100
				AND IsBot = 0
				AND EndDate >= DATEADD(DAY,-1,GETDATE())
			GROUP BY Phrase
			ORDER BY n DESC

	INSERT INTO #TopSearchPhrase (TimePeriod, Phrase, NumberOfQueries)
		SELECT TOP 10 'w', Phrase, COUNT(*) n
			FROM [Search.].[History.Phrase]
			WHERE NumberOfConnections > 0
				AND LEN(Phrase) <= 100
				AND IsBot = 0
				AND EndDate >= DATEADD(WEEK,-1,GETDATE())
			GROUP BY Phrase
			ORDER BY n DESC

	INSERT INTO #TopSearchPhrase (TimePeriod, Phrase, NumberOfQueries)
		SELECT TOP 10 'm', Phrase, COUNT(*) n
			FROM [Search.].[History.Phrase]
			WHERE NumberOfConnections > 0
				AND LEN(Phrase) <= 100
				AND IsBot = 0
				AND EndDate >= DATEADD(MONTH,-1,GETDATE())
			GROUP BY Phrase
			ORDER BY n DESC

	-- Add phrases to try to get to 10 phrases per time period

	DECLARE @n INT
	
	SELECT @n = 10 - (SELECT COUNT(*) FROM #TopSearchPhrase WHERE TimePeriod = 'd')
	IF @n > 0
		INSERT INTO #TopSearchPhrase (TimePeriod, Phrase, NumberOfQueries)
			SELECT TOP(@n) 'd', Phrase, NumberOfQueries
				FROM #TopSearchPhrase
				WHERE TimePeriod = 'w'
					AND Phrase NOT IN (SELECT Phrase FROM #TopSearchPhrase WHERE TimePeriod = 'd')
				ORDER BY NumberOfQueries DESC

	SELECT @n = 10 - (SELECT COUNT(*) FROM #TopSearchPhrase WHERE TimePeriod = 'd')
	IF @n > 0
		INSERT INTO #TopSearchPhrase (TimePeriod, Phrase, NumberOfQueries)
			SELECT TOP(@n) 'd', Phrase, NumberOfQueries
				FROM #TopSearchPhrase
				WHERE TimePeriod = 'm'
					AND Phrase NOT IN (SELECT Phrase FROM #TopSearchPhrase WHERE TimePeriod = 'd')
				ORDER BY NumberOfQueries DESC

	SELECT @n = 10 - (SELECT COUNT(*) FROM #TopSearchPhrase WHERE TimePeriod = 'w')
	IF @n > 0
		INSERT INTO #TopSearchPhrase (TimePeriod, Phrase, NumberOfQueries)
			SELECT TOP(@n) 'w', Phrase, NumberOfQueries
				FROM #TopSearchPhrase
				WHERE TimePeriod = 'm'
					AND Phrase NOT IN (SELECT Phrase FROM #TopSearchPhrase WHERE TimePeriod = 'w')
				ORDER BY NumberOfQueries DESC

	-- Update the cache table

	TRUNCATE TABLE [Search.Cache].[History.TopSearchPhrase]
	INSERT INTO [Search.Cache].[History.TopSearchPhrase] (TimePeriod, Phrase, NumberOfQueries)
		SELECT TimePeriod, Phrase, NumberOfQueries 
			FROM #TopSearchPhrase

	--DROP TABLE #TopSearchPhrase
	--SELECT * FROM [Search.Cache].[History.TopSearchPhrase]
	
END
GO
