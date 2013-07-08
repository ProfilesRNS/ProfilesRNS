SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RDF.Security].[GetSessionSecurityGroupNodes]
@SessionID UNIQUEIDENTIFIER=NULL, @Subject BIGINT=NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	/*

	This procedure returns Security Group nodes to which
	the given session has access. However, it only returns
	the NodeID of the session itself if the subject is that
	session node; otherwise, there is no need to include
	node in the result set.

	*/

	-- Get the session's NodeID
	SELECT NodeID SecurityGroupNode
		FROM [User.Session].Session
		WHERE NodeID IS NOT NULL
			AND SessionID = @SessionID
	-- Get the user's NodeID
	UNION
	SELECT m.NodeID SecurityGroupNode
		FROM [User.Session].Session s 
			INNER JOIN [RDF.Stage].InternalNodeMap m
				ON	s.SessionID = @SessionID
					AND s.UserID IS NOT NULL
					AND m.Class = 'http://profiles.catalyst.harvard.edu/ontology/prns#User'
					AND m.InternalType = 'User'
					AND m.InternalID = CAST(s.UserID AS VARCHAR(50))
	-- Get designated proxy NodeIDs
	UNION
	SELECT m.NodeID SecurityGroupNode
		FROM [User.Session].Session s
			INNER JOIN [User.Account].[DesignatedProxy] x
				ON	s.SessionID = @SessionID
					AND s.UserID IS NOT NULL
					AND @Subject IS NOT NULL
					AND x.UserID = s.UserID
			INNER JOIN [RDF.Stage].InternalNodeMap m
				ON	m.Class = 'http://profiles.catalyst.harvard.edu/ontology/prns#User'
					AND m.InternalType = 'User'
					AND m.InternalID = CAST(x.ProxyForUserID AS VARCHAR(50))
			INNER JOIN [RDF.].[Node] n
				ON	n.NodeID = @Subject
					AND m.NodeID IN (@Subject, n.ViewSecurityGroup, n.EditSecurityGroup)
	/*
	SELECT m.NodeID SecurityGroupNode
		FROM [User.Session].Session s
			INNER JOIN [RDF.].[Node] n
				ON	s.SessionID = @SessionID
					AND s.UserID IS NOT NULL
					AND @Subject IS NOT NULL
					AND n.NodeID = @Subject
			INNER JOIN [User.Account].[DesignatedProxy] x
				ON	x.UserID = s.UserID
					AND x.ProxyForUserID IN (@Subject, n.ViewSecurityGroup, n.EditSecurityGroup)
			INNER JOIN [RDF.Stage].InternalNodeMap m
				ON	m.Class = 'http://profiles.catalyst.harvard.edu/ontology/prns#User'
					AND m.InternalType = 'User'
					AND m.InternalID = CAST(x.ProxyForUserID AS VARCHAR(50))
	*/
	-- Get default proxy NodeIDs
	UNION
	SELECT m.NodeID SecurityGroupNode
		FROM [User.Session].Session s
			INNER JOIN [RDF.].[Node] n
				ON	s.SessionID = @SessionID
					AND s.UserID IS NOT NULL
					AND @Subject IS NOT NULL
					AND n.NodeID = @Subject
			INNER JOIN [User.Account].[DefaultProxy] x
				ON	x.UserID = s.UserID
			INNER JOIN [User.Account].[User] u
				ON	((IsNull(x.ProxyForInstitution,'') = '') 
							OR (IsNull(x.ProxyForInstitution,'') = IsNull(u.Institution,'')))
					AND ((IsNull(x.ProxyForDepartment,'') = '') 
							OR (IsNull(x.ProxyForDepartment,'') = IsNull(u.Department,'')))
					AND ((IsNull(x.ProxyForDivision,'') = '') 
							OR (IsNull(x.ProxyForDivision,'') = IsNull(u.Division,'')))
			INNER JOIN [RDF.Stage].InternalNodeMap m
				ON	m.Class = 'http://profiles.catalyst.harvard.edu/ontology/prns#User'
					AND m.InternalType = 'User'
					AND m.InternalID = CAST(u.UserID AS VARCHAR(50))
					AND m.NodeID IN (@Subject, n.ViewSecurityGroup, n.EditSecurityGroup)
					
	/*
	SELECT m.NodeID SecurityGroupNode
		FROM [User.Session].Session s
			INNER JOIN [RDF.].[Node] n
				ON	s.SessionID = @SessionID
					AND s.UserID IS NOT NULL
					AND @Subject IS NOT NULL
					AND n.NodeID = @Subject
			INNER JOIN [User.Account].[DefaultProxy] x
				ON	x.UserID = s.UserID
			INNER JOIN [User.Account].[User] u
				ON	u.UserID IN (@Subject, n.ViewSecurityGroup, n.EditSecurityGroup)
					AND ((IsNull(x.ProxyForInstitution,'') = '') 
							OR (IsNull(x.ProxyForInstitution,'') = IsNull(u.Institution,'')))
					AND ((IsNull(x.ProxyForDepartment,'') = '') 
							OR (IsNull(x.ProxyForDepartment,'') = IsNull(u.Department,'')))
					AND ((IsNull(x.ProxyForDivision,'') = '') 
							OR (IsNull(x.ProxyForDivision,'') = IsNull(u.Division,'')))
			INNER JOIN [RDF.Stage].InternalNodeMap m
				ON	m.Class = 'http://profiles.catalyst.harvard.edu/ontology/prns#User'
					AND m.InternalType = 'User'
					AND m.InternalID = CAST(u.UserID AS VARCHAR(50))
	*/

	/*
	This will later be expanded to include all nodes to which a
	session's users is connected through a membership predicate.
	*/


END
GO
