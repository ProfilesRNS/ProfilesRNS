/****** Object:  StoredProcedure [User.Account].[Authenticate]    Script Date: 12/05/2013 14:00:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [User.Account].[Authenticate] (
	@UserName NVARCHAR(50),
	@Password VARCHAR(128),
	@UserID INT = NULL OUTPUT,
	@PersonID INT = NULL OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON

	BEGIN TRY	
		SELECT @UserID = UserID, @PersonID = PersonID
			FROM [User.Account].[User]
			WHERE UserName = HASHBYTES('SHA1 ', @UserName) 
				AND Password = HASHBYTES('SHA1 ', @Password) 	  

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


