SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [User.Session].[UpdateSession]
	@SessionID UNIQUEIDENTIFIER, 
	@UserID INT=NULL, 
	@LastUsedDate DATETIME=NULL, 
	@LogoutDate DATETIME=NULL,
	@SessionPersonNodeID BIGINT = NULL OUTPUT,
	@SessionPersonURI VARCHAR(400) = NULL OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	-- See if there is a PersonID associated with this session	
	DECLARE @PersonID INT
	SELECT @PersonID = PersonID
		FROM [User.Session].[Session]
		WHERE SessionID = @SessionID
	IF @PersonID IS NULL AND @UserID IS NOT NULL
		SELECT @PersonID = PersonID
			FROM [User.Account].[User]
			WHERE UserID = @UserID

	-- Get the NodeID and URI of the PersonID
	IF @PersonID IS NOT NULL
	BEGIN
		SELECT @SessionPersonNodeID = m.NodeID, @SessionPersonURI = p.Value + CAST(m.NodeID AS VARCHAR(50))
			FROM [RDF.Stage].InternalNodeMap m, [Framework.].[Parameter] p
			WHERE m.InternalID = @PersonID
				AND m.InternalType = 'person'
				AND m.Class = 'http://xmlns.com/foaf/0.1/Person'
				AND p.ParameterID = 'baseURI'
	END

	-- Update the session data
    IF EXISTS (SELECT * FROM [User.Session].[Session] WHERE SessionID = @SessionID)
		UPDATE [User.Session].[Session]
			SET	UserID = IsNull(@UserID,UserID),
				UserNode = IsNull((SELECT NodeID FROM [User.Account].[User] WHERE UserID = @UserID AND @UserID IS NOT NULL),UserNode),
				PersonID = IsNull(@PersonID,PersonID),
				LastUsedDate = IsNull(@LastUsedDate,LastUsedDate),
				LogoutDate = IsNull(@LogoutDate,LogoutDate)
			WHERE SessionID = @SessionID

END
GO
