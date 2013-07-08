SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [User.Account].[Relationship.SetRelationship]
	@SessionID UNIQUEIDENTIFIER,
	@Subject BIGINT,
	@RelationshipType VARCHAR(50) = NULL,
	@SetToExists BIT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	-- Get the UserID of the SessionID. Exit if not found.
	DECLARE @SessionUserID INT
	SELECT @SessionUserID = UserID
		FROM [User.Session].[Session]
		WHERE SessionID = @SessionID
	IF @SessionUserID IS NULL
		RETURN


	-- Convert the Subject to a PersonID. Exit if not found.
	DECLARE @PersonID INT
	SELECT @PersonID = CAST(InternalID AS INT)
		FROM [RDF.Stage].[InternalNodeMap]
		WHERE @Subject IS NOT NULL
			AND NodeID = @Subject
			AND Class = 'http://xmlns.com/foaf/0.1/Person'
			AND InternalType = 'Person'
	IF @PersonID IS NULL
		RETURN


	-- Check that the RelationshipType is valid
	IF (@RelationshipType NOT IN ('Collaborator','CurrentAdvisor','PastAdvisor','CurrentAdvisee','PastAdvisee')) AND (@SetToExists = 1)
		RETURN


	-- Delete an existing relationship
	IF @SetToExists = 0
		DELETE
		FROM [User.Account].[Relationship]
		WHERE UserID = @SessionUserID
			AND PersonID = @PersonID
			AND RelationshipType = IsNull(@RelationshipType,RelationshipType)
	

	-- Add a relationship if it doesn't exist
	IF @SetToExists = 1
		INSERT INTO [User.Account].[Relationship] (UserID, PersonID, RelationshipType)
			SELECT @SessionUserID, @PersonID, @RelationshipType
			WHERE NOT EXISTS (
				SELECT *
				FROM [User.Account].[Relationship]
				WHERE UserID = @SessionUserID
					AND PersonID = @PersonID
					AND RelationshipType = @RelationshipType
			)

END
GO
