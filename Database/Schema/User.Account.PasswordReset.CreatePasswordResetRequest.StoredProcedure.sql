USE [ProfilesRNS_Umass]

GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [User.Account].[CreatePasswordResetRequest] (
	@EmailAddr nvarchar(255),
	@ResetToken nvarchar(255),
	@RequestExpireDate datetime,
	@ResendRequestsRemaining int,
	@CreateRequestSuccess bit = 0 OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON

	BEGIN TRY	
		
		DECLARE @AcctCanBeReset bit = 0;
		DECLARE @ResetRequestExists bit = 0;

		SET @CreateRequestSuccess = 0;


		/* Account can only be reset if the account is active, there is at least one entry for the email address and
		the account has a non-empty, non-null username. */
		select @AcctCanBeReset = CASE When count(UserId) > 0 then 1 else 0 end from [User.Account].[User] 
		where EmailAddr = @EmailAddr and IsActive = 1 and ISNULL(UserName, '') <> '';

		/* Don't allow another reset request if one has already been sent which has not yet expired. */
		select @ResetRequestExists = CASE When COUNT(EmailAddr) > 0 then 1 else 0 end from [User.Account].[PasswordResetRequest] where
		EmailAddr = @EmailAddr and RequestExpireDate > GetDate();
		
		/* Only allow a new request if account can be reset and a valid request doesn't exist */
		IF @AcctCanBeReset > 0 and @ResetRequestExists = 0

			BEGIN 

				INSERT INTO [User.Account].[PasswordResetRequest] (ResetToken, EmailAddr, CreateDate, RequestExpireDate, ResendRequestsRemaining, ResetDate)
				VALUES (@ResetToken, @EmailAddr, GETDATE(), @RequestExpireDate, @ResendRequestsRemaining,  null)

				SET @CreateRequestSuccess = 1;

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
