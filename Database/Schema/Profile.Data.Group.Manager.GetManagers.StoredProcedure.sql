SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Data].[Group.Manager.GetManagers]
	@GroupID INT=NULL, 
	@GroupNodeID BIGINT=NULL,
	@GroupURI VARCHAR(400)=NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Convert URIs and NodeIDs to GroupID
 	IF (@GroupNodeID IS NULL) AND (@GroupURI IS NOT NULL)
		SELECT @GroupNodeID = [RDF.].fnURI2NodeID(@GroupURI)
 	IF (@GroupID IS NULL) AND (@GroupNodeID IS NOT NULL)
		SELECT @GroupID = CAST(m.InternalID AS INT)
			FROM [RDF.Stage].[InternalNodeMap] m, [RDF.].Node n
			WHERE m.Status = 3 AND m.ValueHash = n.ValueHash AND n.NodeID = @GroupNodeID
	
	-- Validate GroupID
	IF (@GroupID IS NULL)
		RETURN;

	-- List the Managers
	SELECT m.GroupID, u.UserID, u.PersonID, u.FirstName, u.LastName, u.DisplayName, u.Institution, u.Department, u.Division, u.EmailAddr
		FROM [Profile.Data].[Group.Manager] m
			INNER JOIN [User.Account].[User] u
				ON m.UserID = u.UserID
		WHERE m.GroupID = @GroupID
		ORDER BY u.LastName, u.FirstName, u.DisplayName, u.UserID

END

GO
