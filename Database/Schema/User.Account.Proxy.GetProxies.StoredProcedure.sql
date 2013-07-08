SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [User.Account].[Proxy.GetProxies] 
	@SessionID UNIQUEIDENTIFIER,
	@Operation VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET nocount  ON;


	/**************************************************************
	This stored procedure supports three operations:
	
	1) GetDefaultUsersWhoseNodesICanEdit
	2) GetDesignatedUsersWhoseNodesICanEdit
	3) GetAllUsersWhoCanEditMyNodes
	
	Operation #1 returns a list of organizations.
	Operations #2 and #3 return a list of user accounts, some of
	  which also have person profiles (PersonURI).
	Operation #3 also indicates which proxies can be deleted.
	**************************************************************/
	
	
	-- Get the UserID of the SessionID. Exit if not found.
	DECLARE @SessionUserID INT
	SELECT @SessionUserID = UserID
		FROM [User.Session].[Session]
		WHERE SessionID = @SessionID
	IF @SessionUserID IS NULL
		RETURN


	IF @Operation = 'GetDefaultUsersWhoseNodesICanEdit'
		SELECT Institution, Department, Division, MAX(IsVisible*1) IsVisible
			FROM (
				-- Default Proxies
				SELECT	(case when IsNull(ProxyForInstitution,'')='' then 'All' else ProxyForInstitution end) Institution,
						(case when IsNull(ProxyForDepartment,'')='' then 'All' else ProxyForDepartment end) Department,
						(case when IsNull(ProxyForDivision,'')='' then 'All' else ProxyForDivision end) Division,
						IsVisible
					FROM [User.Account].[DefaultProxy]
					WHERE UserID = @SessionUserID
				-- Security Groups with Special Edit Access
				UNION ALL
				SELECT 'All' Institution, 'All' Department, 'All' Division, m.IsVisible
					FROM [RDF.Security].[Member] m
						INNER JOIN [RDF.Security].[Group] g
							ON m.SecurityGroupID = g.SecurityGroupID
							AND g.HasSpecialEditAccess = 1
			) t
			GROUP BY Institution, Department, Division
			ORDER BY	(case when Institution = 'All' then 0 else 1 end), Institution,
						(case when Department = 'All' then 0 else 1 end), Department,
						(case when Division = 'All' then 0 else 1 end), Division


	IF @Operation = 'GetDesignatedUsersWhoseNodesICanEdit'
		SELECT u.UserID, u.DisplayName, u.Institution, u.Department, u.EmailAddr,
				o.Value+cast(p.NodeID as varchar(50)) PersonURI
			FROM [User.Account].[User] u
				INNER JOIN (
					-- Designated Proxies
					SELECT ProxyForUserID
						FROM [User.Account].[DesignatedProxy]
						WHERE UserID = @SessionUserID
				) x ON u.UserID = x.ProxyForUserID
				INNER JOIN [Framework.].Parameter o
					ON o.ParameterID = 'baseURI'
				LEFT OUTER JOIN [RDF.Stage].[InternalNodeMap] p
					ON u.PersonID IS NOT NULL
						AND cast(u.PersonID as varchar(50)) = p.InternalID
						AND p.Class = 'http://xmlns.com/foaf/0.1/Person'
						AND p.InternalType = 'Person'
						AND p.NodeID IS NOT NULL
			ORDER BY u.LastName, u.FirstName


	IF @Operation = 'GetAllUsersWhoCanEditMyNodes'
		SELECT u.UserID, u.DisplayName, u.Institution, u.Department, u.EmailAddr, 
				o.Value+cast(p.NodeID as varchar(50)) PersonURI, x.CanDelete
			FROM [User.Account].[User] u
				INNER JOIN (
					SELECT UserID, MIN(CanDelete) CanDelete
						FROM (
							-- Designated Proxies
							SELECT UserID, 1 CanDelete
								FROM [User.Account].[DesignatedProxy]
								WHERE ProxyForUserID = @SessionUserID
							-- Default Proxies
							UNION ALL
							SELECT x.UserID, 0 CanDelete
								FROM [User.Account].[DefaultProxy] x
									INNER JOIN [User.Account].[User] u
										ON ((IsNull(x.ProxyForInstitution,'') = '') 
												OR (IsNull(x.ProxyForInstitution,'') = IsNull(u.Institution,'')))
										AND ((IsNull(x.ProxyForDepartment,'') = '') 
												OR (IsNull(x.ProxyForDepartment,'') = IsNull(u.Department,'')))
										AND ((IsNull(x.ProxyForDivision,'') = '') 
												OR (IsNull(x.ProxyForDivision,'') = IsNull(u.Division,'')))
										AND u.UserID = @SessionUserID
										AND x.IsVisible = 1
							-- Security Groups with Special Edit Access
							UNION ALL
							SELECT m.UserID, 0 CanDelete
								FROM [RDF.Security].[Member] m
									INNER JOIN [RDF.Security].[Group] g
										ON m.SecurityGroupID = g.SecurityGroupID
										AND m.IsVisible = 1
										AND g.HasSpecialEditAccess = 1
						) t
						GROUP BY UserID
				) x ON u.UserID = x.UserID
				INNER JOIN [Framework.].Parameter o
					ON o.ParameterID = 'baseURI'
				LEFT OUTER JOIN [RDF.Stage].[InternalNodeMap] p
					ON u.PersonID IS NOT NULL
						AND cast(u.PersonID as varchar(50)) = p.InternalID
						AND p.Class = 'http://xmlns.com/foaf/0.1/Person'
						AND p.InternalType = 'Person'
						AND p.NodeID IS NOT NULL
			ORDER BY u.LastName, u.FirstName

END
GO
