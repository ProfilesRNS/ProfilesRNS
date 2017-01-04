SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [User.Account].[ResetPassword] (

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

		/* If there is an email address associated with the token reset the password for all accounts with that email and return 1.  Otherwise return 0. */
		IF @EmailAddressFromToken IS NOT NULL

			BEGIN

				/* Update password on all accounts associated with this email address. */
				UPDATE [User.Account].[User] SET Password = @NewPassword WHERE EmailAddr = @EmailAddressFromToken;

				/* Update the password reset request so it is marked with a reset date. */
				UPDATE [User.Account].PasswordResetRequest set ResetDate = GETDATE(), ResendRequestsRemaining = 0 WHERE ResetToken = @ResetToken;

				SET @ResetSuccess = 1;

			END

		ELSE
			
			SET @ResetSuccess = 0;


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
