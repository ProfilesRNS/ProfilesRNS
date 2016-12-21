USE [ProfilesRNS_Umass]

GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [User.Account].[UpdatePasswordResetRequestRequestsRemaining] (
	@ResetToken nvarchar(255),
	@ResendRequestsRemaining int,
	@ResetRequestSuccess bit = 0 OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON

	BEGIN TRY	
		
		
		UPDATE [User.Account].[PasswordResetRequest] 
		SET ResendRequestsRemaining = @ResendRequestsRemaining
		where
		ResetToken = @ResetToken;

		SET @ResetRequestSuccess = 1;


	END TRY
	BEGIN CATCH	
		--Check success		
		DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
		IF @@TRANCOUNT > 0  ROLLBACK
			--Raise an error with the details of the exception
		SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY()
		RAISERROR(@ErrMsg, @ErrSeverity, 1)
	END CATCH

END

GO
