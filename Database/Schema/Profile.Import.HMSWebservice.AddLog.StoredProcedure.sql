SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Import].[HMSWebservice.AddLog]
	@logID BIGINT = -1,
	@batchID varchar(100) = null,
	@rowID int = -1,
	@Job varchar(55),
	@action VARCHAR(200),
	@actionText varchar(max) = null,
	@newLogID BIGINT OUTPUT
AS
BEGIN
	IF @action='StartService'
		BEGIN
			DECLARE @LogIDTable TABLE (logID BIGINT)
			INSERT INTO [Profile.Import].[HMSWebservice.Log] (Job, BatchID, RowID, ServiceCallStart)
			OUTPUT Inserted.LogID INTO @LogIDTable
			VALUES (@job, @batchID, @rowID, GETDATE())
			select @logID = LogID from @LogIDTable
		END
	IF @action='EndService'
		BEGIN
			UPDATE [Profile.Import].[HMSWebservice.Log]
			   SET ServiceCallEnd = GETDATE()
			 WHERE LogID = @logID
		END
	IF @action='RowComplete'
		BEGIN
			UPDATE [Profile.Import].[HMSWebservice.Log]
			   SET ProcessEnd  =GETDATE(),
				   Success= 1
			 WHERE LogID = @logID
		END
	IF @action='Error'
		BEGIN
			UPDATE [Profile.Import].[HMSWebservice.Log]
			   SET ErrorText = @actionText,
				   ProcessEnd  =GETDATE(),
				   Success=0
			 WHERE LogID = @logID
		END

	Select @newLogID = @logID
END
GO
