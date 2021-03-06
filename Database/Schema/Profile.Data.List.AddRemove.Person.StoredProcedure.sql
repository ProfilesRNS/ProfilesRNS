SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Data].[List.AddRemove.Person]
	@UserID INT,
	@PersonID INT,
	@Remove BIT=0,
	@Size INT=NULL OUTPUT
AS
BEGIN

	-- Get existing list info
	SELECT @Size = Size
		FROM [Profile.Data].[List.General]
		WHERE UserID = @UserID

	-- Determine if the person is in the list
	DECLARE @PersonInList BIT
	SELECT @PersonInList = 0
	SELECT @PersonInList = 1
		FROM [Profile.Data].[List.Member] 
		WHERE UserID=@UserID AND PersonID=@PersonID

	BEGIN TRANSACTION

	-- Add the person if needed
	IF (@Remove=0 AND @PersonInList=0)
	BEGIN
		INSERT INTO [Profile.Data].[List.Member] (UserID, PersonID)
			SELECT @UserID, @PersonID
		UPDATE [Profile.Data].[List.General]
			SET Size = Size+1
			WHERE UserID = @UserID
		SELECT @Size = @Size+1
	END

	-- Remove the person if needed
	IF (@Remove=1 AND @PersonInList=1)
	BEGIN
		DELETE FROM [Profile.Data].[List.Member]
			WHERE UserID=@UserID AND PersonID=@PersonID
		UPDATE [Profile.Data].[List.General]
			SET Size = Size-1
			WHERE UserID = @UserID
		SELECT @Size = @Size-1
	END

	COMMIT TRANSACTION

END


GO
