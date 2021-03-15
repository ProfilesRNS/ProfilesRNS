SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Profile.Import].[PRNSWebservice.CheckForErrors]
	@BatchID varchar(100)
AS
BEGIN
	DECLARE @ErrorCount int
	select @ErrorCount = count(*) from  [Profile.Import].[PRNSWebservice.Log] WHERE BatchID = @BatchID AND Success = 0
	UPDATE [Profile.Import].[PRNSWebservice.Log.Summary] set JobEnd = GETDATE(), ErrorCount = @ErrorCount WHERE BatchID = @BatchID
	IF @ErrorCount > 0
		RAISERROR('%i Errors recorded in [Profile.Import].[PRNSWebservice.Log] for BatchID %s',16,1, @ErrorCount, @BatchID);
END
GO
