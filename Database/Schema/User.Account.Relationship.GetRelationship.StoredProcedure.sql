SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [User.Account].[Relationship.GetRelationship]
	@SessionID UNIQUEIDENTIFIER,
	@Details BIT = 0,
	@Subject BIGINT = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	/***********************************************************************
	This procedure does one of five things, based on the input parameters:
	
	1) If the Session is not logged in (i.e. not a user), then..
		Nothing is returned.
		
	2) If a Subject is provided and it is not a person, then...
		Nothing is returned.
	
	3) If a Subject is provided and it is a person, then...
		A list of relationship types is returned, with a flag "DoesExist"
		that indicates whether the Session user has a relationship with
		the Subject person.
	
	4) If a Subject is not provided and Details = 0, then...
		A list of all people who have at least one relationship with the
		Session user is returned.
	
	5) If a Subject is not provided and Details = 1, then...
		A list of all people who have a relationship with the Session user
		is returned, grouped by relationship type.
		
	***********************************************************************/

	-- Get the UserID of the SessionID. Exit if not found.
	DECLARE @SessionUserID INT
	SELECT @SessionUserID = UserID
		FROM [User.Session].[Session]
		WHERE SessionID = @SessionID
	IF @SessionUserID IS NULL
		RETURN


	-- Convert the Subject to a PersonID
	DECLARE @PersonID INT
	SELECT @PersonID = NULL
	SELECT @PersonID = CAST(InternalID AS INT)
		FROM [RDF.Stage].[InternalNodeMap]
		WHERE @Subject IS NOT NULL
			AND NodeID = @Subject
			AND Class = 'http://xmlns.com/foaf/0.1/Person'
			AND InternalType = 'Person'
	IF (@Subject IS NOT NULL) AND (@PersonID IS NULL)
		RETURN


	-- Build a list of relationship types
	DECLARE @r TABLE (
		RelationshipType varchar(50),
		RelationshipName varchar(50),
		SortOrder int
	)
	INSERT INTO @r (RelationshipType, RelationshipName, SortOrder)
		SELECT 'Collaborator', 'Collaborator', 0 
		UNION ALL
		SELECT 'CurrentAdvisor', 'Advisor (Current)', 1 
		UNION ALL
		SELECT 'PastAdvisor', 'Advisor (Past)', 2 
		UNION ALL 
		SELECT 'CurrentAdvisee', 'Advisee (Current)', 3 
		UNION ALL
		SELECT 'PastAdvisee', 'Advisee (Past)', 4
	
	
	-- Return the relationships between the session user and the PersonID
	IF (@PersonID IS NOT NULL)
		SELECT r.RelationshipType, r.RelationshipName, r.SortOrder, 
				(CASE WHEN u.PersonID IS NULL THEN 0 ELSE 1 END) DoesExist
			FROM @r r
				LEFT OUTER JOIN [User.Account].[Relationship] u
					ON u.UserID = @SessionUserID
						AND u.PersonID = @PersonID
						AND r.RelationshipType = u.RelationshipType
			ORDER BY r.SortOrder

	-- Create a temp table to store a list of PersonIDs before converting to NodeIDs
	DECLARE @p AS TABLE (
		RelationshipType VARCHAR(50),
		RelationshipName VARCHAR(100),
		SortOrder INT,
		PersonID INT,
		Name NVARCHAR(100)
	)

	-- Return a list of people who have at least one relationship to the session user
	IF (@PersonID IS NULL) AND (@Details = 0)
	BEGIN
		INSERT INTO @p (PersonID, Name)
			SELECT PersonID,
				LastName + (CASE WHEN LastName<>'' AND FirstName<>'' THEN ', ' ELSE '' END) + FirstName AS Name
			FROM [Profile.Data].[Person] p
			WHERE p.PersonID IN (
					SELECT PersonID
						FROM [User.Account].[Relationship]
						WHERE UserID = @SessionUserID
				) AND p.IsActive = 1

		SELECT	p.PersonID,
				p.Name,
				m.NodeID,
				o.Value + CAST(m.NodeID AS VARCHAR(50)) URI
			FROM @p p
				INNER JOIN [RDF.Stage].[InternalNodeMap] m
					ON m.Class = 'http://xmlns.com/foaf/0.1/Person'
						AND m.InternalType = 'Person'
						AND m.InternalID = CAST(p.PersonID as VARCHAR(50))
				INNER JOIN [Framework.].[Parameter] o
					ON o.ParameterID = 'baseURI'
			ORDER BY p.Name
	END


	-- Return people who have a relationship to the session user, grouped by relationship type
	IF (@PersonID IS NULL) AND (@Details = 1)
	BEGIN
		;WITH a AS (
			SELECT r.RelationshipType, r.RelationshipName, r.SortOrder,
					p.PersonID,
					p.LastName + (CASE WHEN p.LastName<>'' AND p.FirstName<>'' THEN ', ' ELSE '' END) + p.FirstName AS Name
				FROM @r r
					INNER JOIN [User.Account].[Relationship] u
						ON u.UserID = @SessionUserID
							AND r.RelationshipType = u.RelationshipType
					INNER JOIN [Profile.Data].[Person] p
						ON u.PersonID = p.PersonID AND p.IsActive = 1
		), b AS (
			SELECT RelationshipType, COUNT(*) N
				FROM a
				GROUP BY RelationshipType
		)
		INSERT INTO @p (RelationshipType, RelationshipName, SortOrder, PersonID, Name)
			SELECT a.*
				FROM a INNER JOIN b ON a.RelationshipType = b.RelationshipType

		SELECT	p.RelationshipType, 
				p.RelationshipName, 
				p.SortOrder, 
				p.PersonID,
				p.Name,
				m.NodeID,
				o.Value + CAST(m.NodeID AS VARCHAR(50)) URI
			FROM @p p
				INNER JOIN [RDF.Stage].[InternalNodeMap] m
					ON m.Class = 'http://xmlns.com/foaf/0.1/Person'
						AND m.InternalType = 'Person'
						AND m.InternalID = CAST(p.PersonID as VARCHAR(50))
				INNER JOIN [Framework.].[Parameter] o
					ON o.ParameterID = 'baseURI'
			ORDER BY p.SortOrder, p.Name, p.PersonID
	END


END
GO
