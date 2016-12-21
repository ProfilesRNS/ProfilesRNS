USE [ProfilesRNS_Umass]

GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [User.Account].[ResetPassword] (
	@EmailAddr nvarchar(255),
	@ResetToken nvarchar(255),
	@NewPassword nvarchar(128),
	@ResetSuccess bit = 0 OUTPUT
	
)
AS
BEGIN
	SET NOCOUNT ON

	BEGIN TRY	
		
		DECLARE @EmailAddressFromToken nvarchar(255);

		/* Get the email address for the token provided. */
		select @EmailAddressFromToken = EmailAddr from [User.Account].[PasswordResetRequest] where
		ResetToken = @ResetToken and RequestExpireDate > GetDate() and ResetDate is null;

		/* Make sure the email the user entered matches the address associated with the token. */
		IF @EmailAddressFromToken = @EmailAddr
		BEGIN
			/* Update password on all accounts associated with this email address. */
			UPDATE [User.Account].[User] SET Password = @NewPassword WHERE EmailAddr = @EmailAddressFromToken;

			SET @ResetSuccess = 1;
		END


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
