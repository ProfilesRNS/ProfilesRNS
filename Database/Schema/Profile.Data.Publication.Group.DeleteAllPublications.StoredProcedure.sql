SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Data].[Publication.Group.DeleteAllPublications]
	@GroupID INT,
	@deletePMID BIT = 0,
	@deleteMPID BIT = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRY 
	BEGIN TRANSACTION
			delete from [Profile.Data].[Publication.Group.Include] 
				where GroupID = @GroupID AND (
						( (@deletePMID = 1) AND (@deleteMPID = 0) AND (pmid is not null) )
					or	( (@deletePMID = 0) AND (@deleteMPID = 1) AND (pmid is null) AND (mpid is not null) )
					or	( (@deletePMID = 1) AND (@deleteMPID = 1) )
				)

	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
		--Check success
		IF @@TRANCOUNT > 0  ROLLBACK
 
		-- Raise an error with the details of the exception
		SELECT @ErrMsg =  ERROR_MESSAGE(),
					 @ErrSeverity = ERROR_SEVERITY()
 
		RAISERROR(@ErrMsg, @ErrSeverity, 1)
			 
	END CATCH		

END

GO
