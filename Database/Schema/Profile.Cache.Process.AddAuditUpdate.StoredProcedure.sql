SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Cache].[Process.AddAuditUpdate]	(@insert_new_record BIT=1,
																								 @ProcessName varchar(1000),
																								 @ProcessStartDate datetime=NULL,
																								 @ProcessEnddate datetime=NULL,
																								 @ProcessedRows INT=NULL,
																								 @Error BIT=0,
																								 @AuditID UNIQUEIDENTIFIER=NULL OUTPUT)
as 
begin
SET NOCOUNT ON 

 

 
	IF @insert_new_record=1
		BEGIN
				SELECT @AuditID = NEWID()
				INSERT INTO [Profile.Cache].[Process.Audit]
				   (AuditID,ProcessName,ProcessStartDate) VALUES(@AuditID,@ProcessName,@ProcessStartDate)
		END
	ELSE
		UPDATE [Profile.Cache].[Process.Audit]
			 SET ProcessEndDate = ISNULL(@ProcessEnddate,GETDATE()),
				   ProcessedRows=@ProcessedRows,
					 Error=@Error
	   WHERE AuditID = @AuditID

end
GO
