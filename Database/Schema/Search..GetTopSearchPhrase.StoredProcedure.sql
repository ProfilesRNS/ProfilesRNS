SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Search.].[GetTopSearchPhrase]
	@TimePeriod CHAR(1)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT *
		FROM [Search.Cache].[History.TopSearchPhrase]
		WHERE TimePeriod = @TimePeriod
		ORDER BY NumberOfQueries DESC

END
GO
