SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Data].[Group.Member.GetMembers]
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

	-- Get the BaseURI
	DECLARE @baseURI NVARCHAR(400)
	SELECT @baseURI = value FROM [Framework.].Parameter WHERE ParameterID = 'baseURI'

	-- List the Members
	SELECT m.GroupID, u.UserID, u.PersonID, @baseURI+CAST(i.NodeID AS VARCHAR(50)) PersonURI, m.IsApproved, m.IsVisible, m.Title,
			p.FirstName, p.LastName, p.DisplayName, p.InstitutionName, p.DepartmentName, p.DivisionFullName, p.FacultyRank, p.FacultyRankSort
		FROM [Profile.Data].[Group.Member] m
			INNER JOIN [User.Account].[User] u
				ON m.UserID = u.UserID
			INNER JOIN [Profile.Cache].[Person] p
				ON u.PersonID = p.PersonID
			INNER JOIN [RDF.Stage].InternalNodeMap i
				ON i.Class = 'http://xmlns.com/foaf/0.1/Person' AND i.InternalType = 'Person' AND i.InternalID = u.PersonID
		WHERE m.GroupID = @GroupID AND m.IsActive = 1 AND m.IsApproved = 1 AND m.IsVisible = 1
		ORDER BY p.LastName, p.FirstName, p.DisplayName, p.UserID

END

GO
