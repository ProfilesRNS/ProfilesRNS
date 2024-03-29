SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Data].[List.AddRemove.Filter]
	@UserID INT,
	@Institution VARCHAR(1000)=NULL,
	@FacultyRank VARCHAR(100)=NULL,
	@Remove BIT=0,
	@Size INT=NULL OUTPUT
AS
BEGIN

	SELECT @FacultyRank = CASE WHEN @FacultyRank = '--' THEN '' ELSE @FacultyRank END

	-- Get existing list info
	SELECT @Size = Size
		FROM [Profile.Data].[List.General]
		WHERE UserID = @UserID

	-- Get the list of people
	CREATE TABLE #p (PersonID INT PRIMARY KEY)
	INSERT INTO #p
		SELECT l.PersonID
			FROM [Profile.Data].[List.Member] l
				LEFT OUTER JOIN [Profile.Cache].[Person] p
					ON l.PersonID=p.PersonID
			WHERE l.UserID=@UserID AND
				(CASE WHEN @Institution IS NULL THEN 1
					WHEN @Institution = p.InstitutionName THEN 1
					ELSE 0 END)
				+(CASE WHEN @FacultyRank IS NULL THEN 1
					WHEN @FacultyRank = p.FacultyRank THEN 1
					ELSE 0 END)
				=2

	BEGIN TRANSACTION
		-- Remove
		IF (@Remove=1)
		BEGIN
			DELETE FROM [Profile.Data].[List.Member]
				WHERE UserID=@UserID AND PersonID IN (SELECT PersonID FROM #p)
		END
		-- Update list size
		UPDATE [Profile.Data].[List.General]
			SET Size = (SELECT COUNT(*) FROM [Profile.Data].[List.Member] WHERE UserID=@UserID)
			WHERE UserID = @UserID
		SELECT @Size = Size
			FROM [Profile.Data].[List.General]
			WHERE UserID=@UserID
	COMMIT TRANSACTION

END

GO
