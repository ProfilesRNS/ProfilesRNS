SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [User.Account].[AuthenticateExternal] (
	@UserName NVARCHAR(50),
	@UserID INT = NULL OUTPUT,
	@PersonID INT = NULL OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON

	BEGIN TRY	
		SELECT @UserID = UserID, @PersonID = PersonID
			FROM [User.Account].[User]
			WHERE UserName = @UserName

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
