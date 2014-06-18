SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [User.Session].[DeleteOldSessionRDF]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	-- Get a list of nodes for sessions last used more than 24 hours ago
	CREATE TABLE #s (
		NodeID BIGINT PRIMARY KEY
	)
	INSERT INTO #s (NodeID)
		SELECT NodeID
			FROM [User.Session].[Session] WITH (NOLOCK)
			WHERE NodeID IS NOT NULL
				AND NodeID IN (SELECT NodeID FROM [RDF.].[Node] WITH (NOLOCK))
				AND DateDiff(hh,LastUsedDate,GetDate()) >= 24

	-- Delete triples associated with those nodes
	DELETE t
		FROM [RDF.].[Triple] t, #s s
		WHERE t.subject = s.NodeID

	-- Delete the nodes
	DELETE n
		FROM [RDF.].[Node] n, #s s
		WHERE n.NodeID = s.NodeID

	/*

	SELECT *
		FROM [User.Session].[Session] WITH (NOLOCK)
		WHERE NodeID IS NOT NULL
			AND NodeID IN (SELECT NodeID FROM [RDF.].[Node] WITH (NOLOCK))
			AND DateDiff(hh,LastUsedDate,GetDate()) >= 24
			--AND ((LogoutDate IS NOT NULL) OR (DateDiff(hh,LastUsedDate,GetDate()) >= 24))

	SELECT *
		FROM [RDF.].[Triple] t, #s s
		WHERE t.subject = s.NodeID

	SELECT *
		FROM [RDF.].[Node] n, #s s
		WHERE n.NodeID = s.NodeID

	*/

END