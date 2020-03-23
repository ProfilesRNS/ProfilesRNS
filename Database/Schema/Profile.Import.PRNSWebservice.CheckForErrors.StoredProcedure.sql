SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Profile.Import].[PRNSWebservice.CheckForErrors]
	@BatchID varchar(100)
AS
BEGIN
	IF EXISTS (SELECT 1 FROM [Profile.Import].[PRNSWebservice.Log] WHERE BatchID = @BatchID AND Success = 0)
	RAISERROR('Errors recorded in [Profile.Import].[PRNSWebservice.Log] for BatchID %s',16,1, @BatchID);
END
GO
