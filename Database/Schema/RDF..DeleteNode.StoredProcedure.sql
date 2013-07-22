SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [RDF.].[DeleteNode]
	@NodeID bigint = NULL,
	@NodeURI varchar(400) = NULL,
	@DeleteType tinyint = 1,
	@SessionID uniqueidentifier = NULL,
	-- Output variables
	@Error bit = NULL OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int,@proc VARCHAR(200),@date DATETIME,@auditid UNIQUEIDENTIFIER 
	SELECT @proc = OBJECT_NAME(@@PROCID),@date=GETDATE() 	
	EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessStartDate=@date,@insert_new_record=1
	
	SELECT @Error = 0
	
	SELECT @NodeID = NULL WHERE @NodeID = 0
 
	IF (@NodeID IS NULL) AND (@NodeURI IS NOT NULL)
		SELECT @NodeID = [RDF.].fnURI2NodeID(@NodeURI)
 
	IF (@NodeID IS NOT NULL)
	BEGIN TRY
	BEGIN TRANSACTION
	    
		IF @DeleteType = 0 -- True delete
		BEGIN
			EXEC [RDF.].[DeleteTriple] @DeleteType = @DeleteType, @SessionID = @SessionID, @Subject = @NodeID
			EXEC [RDF.].[DeleteTriple] @DeleteType = @DeleteType, @SessionID = @SessionID, @Predicate = @NodeID
			EXEC [RDF.].[DeleteTriple] @DeleteType = @DeleteType, @SessionID = @SessionID, @Object = @NodeID
			DELETE
				FROM [RDF.Stage].[InternalNodeMap]
				WHERE NodeID = @NodeID
			DELETE
				FROM [RDF.].[Node]
				WHERE NodeID = @NodeID
		END
 
		IF @DeleteType = 1 -- Change security groups
		BEGIN
			UPDATE [RDF.].[Node]
				SET ViewSecurityGroup = 0, EditSecurityGroup = -50
				WHERE NodeID = @NodeID
		END
  
	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		--Check success
		IF @@TRANCOUNT > 0  ROLLBACK
		SELECT @date=GETDATE()
		EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessEndDate=@date,@error = 1,@insert_new_record=0
		--Raise an error with the details of the exception
		SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY()
		RAISERROR(@ErrMsg, @ErrSeverity, 1)
	END CATCH
 
END
GO
