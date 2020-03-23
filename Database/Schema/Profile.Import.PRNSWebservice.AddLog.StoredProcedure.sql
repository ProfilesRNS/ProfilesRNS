SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Import].[PRNSWebservice.AddLog]
	@logID BIGINT = -1,
	@batchID varchar(100) = null,
	@rowID int = -1,
	@Job varchar(55),
	@action VARCHAR(200),
	@actionText varchar(max) = null,
	@newLogID BIGINT OUTPUT
AS
BEGIN
	DECLARE @LogLevel INT
	SELECT @LogLevel = LogLevel FROM [Profile.Import].[PRNSWebservice.Options] WHERE Job=@Job

	IF @LogLevel > 0 OR @action = 'Error'
	BEGIN 
		IF @logID < 0
		BEGIN
			SELECT @logID = ISNULL(LogID, -1) FROM [Profile.Import].[PRNSWebservice.Log] WHERE BatchID = @batchID AND RowID = @rowID

			if @logID < 0
			BEGIN
				DECLARE @LogIDTable TABLE (logID BIGINT)
				INSERT INTO [Profile.Import].[PRNSWebservice.Log] (Job, BatchID, RowID)
				OUTPUT Inserted.LogID INTO @LogIDTable
				VALUES (@job, @batchID, @rowID)
				SELECT @logID = LogID from @LogIDTable
			END
		END

		IF @action='StartService'
			BEGIN
				UPDATE [Profile.Import].[PRNSWebservice.Log]
				   SET ServiceCallStart = GETDATE()
				 WHERE LogID = @logID
			END
		IF @action='EndService'
			BEGIN
				UPDATE [Profile.Import].[PRNSWebservice.Log]
				   SET ServiceCallEnd = GETDATE()
				 WHERE LogID = @logID
			END
		IF @action='RowComplete'
			BEGIN
				UPDATE [Profile.Import].[PRNSWebservice.Log]
				   SET ProcessEnd  =GETDATE(),
					   Success= isnull(Success, 1)
				 WHERE LogID = @logID
			END
		IF @action='Error'
			BEGIN
				UPDATE [Profile.Import].[PRNSWebservice.Log]
				   SET ErrorText = @actionText,
					   ProcessEnd  =GETDATE(),
					   Success=0
				 WHERE LogID = @logID
			END
	END
	Select @newLogID = @logID
END
GO
