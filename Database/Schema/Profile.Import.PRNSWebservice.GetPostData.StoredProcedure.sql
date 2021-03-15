SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Import].[PRNSWebservice.GetPostData]
	@Job varchar(55)
AS
BEGIN
	DECLARE @batchID UNIQUEIDENTIFIER, @logLevel int, @proc varchar(100)

	select @batchID = NEWID()
	select @proc = GetPostDataProc, @logLevel = logLevel from [Profile.Import].[PRNSWebservice.Options] where job = @job

  	IF @logLevel >= 0
	BEGIN
		INSERT INTO [Profile.Import].[PRNSWebservice.Log.Summary]  (Job, BatchID, JobStart)
		SELECT @Job, @BatchID, getdate()
	END

	if @proc is null
	BEGIN
		RAISERROR('Job doesn''t exist', 16, -1)
		return
	END

	exec @proc @Job=@Job, @BatchID=@BatchID
END
GO
