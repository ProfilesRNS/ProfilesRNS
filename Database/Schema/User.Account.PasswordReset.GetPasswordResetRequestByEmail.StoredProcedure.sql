SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [User.Account].[GetPasswordResetRequestByEmail] (

	@EmailAddr nvarchar(255),
	@PasswordResetRequestID int OUTPUT,
	@ResetToken nvarchar(255) OUTPUT,
	@CreateDate datetime OUTPUT,
	@RequestExpireDate datetime OUTPUT,
	@ResendRequestsRemaining int OUTPUT,
	@ResetDate datetime OUTPUT

)
AS
BEGIN
	SET NOCOUNT ON

	BEGIN TRY	
		
		/* Get an existing reset request if there is one, it hasn't expired and hasn't been used yet. */
		select @PasswordResetRequestID = PasswordResetRequestId, @ResetToken = ResetToken, @CreateDate = CreateDate, @RequestExpireDate = RequestExpireDate, 
		@ResendRequestsRemaining = ResendRequestsRemaining, @ResetDate = ResetDate  from [User.Account].[PasswordResetRequest] where
		EmailAddr = @EmailAddr and RequestExpireDate > GetDate() and ResetDate is null 


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
