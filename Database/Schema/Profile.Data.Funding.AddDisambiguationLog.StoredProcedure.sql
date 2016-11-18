SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  [Profile.Data].[Funding.AddDisambiguationLog] (@logID BIGINT, 
												@action VARCHAR(200),
												@actionText varchar(max) = null,
												@newLogID BIGINT OUTPUT )
AS
BEGIN
	IF @action='StartService'
		BEGIN
			DECLARE @logIDtable TABLE (logID BIGINT)
			INSERT INTO [Profile.Data].[Funding.DisambiguationAudit]  (ServiceCallStart)
			OUTPUT inserted.logID into @logIDtable
			VALUES (GETDATE())
			select @newLogID = logID from @logIDtable
		END
	IF @action='EndService'
		BEGIN
			UPDATE [Profile.Data].[Funding.DisambiguationAudit] 
			   SET ServiceCallEnd = GETDATE()
			 WHERE LogID=@LogID
			 select @newLogID = @logID
		END
	IF @action='Error'
		BEGIN
			UPDATE [Profile.Data].[Funding.DisambiguationAudit] 
			   SET ErrorText = @actionText,
				   ProcessEnd  = GETDATE(),
				   Success=0
			 WHERE LogID=@LogID
			 select @newLogID = @logID
		END
END
GO
