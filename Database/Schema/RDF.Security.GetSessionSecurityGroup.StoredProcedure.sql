SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RDF.Security].[GetSessionSecurityGroup]
	@SessionID uniqueidentifier = NULL,
	@SecurityGroupID bigint = -1 OUTPUT,
	@HasSpecialViewAccess bit = 0 OUTPUT,
	@HasSpecialEditAccess bit = 0 OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT	@SecurityGroupID = IsNull(MIN(g.SecurityGroupID),-1),
			@HasSpecialViewAccess = IsNull(MAX(CAST(g.HasSpecialViewAccess AS TINYINT)),0),
			@HasSpecialEditAccess = IsNull(MAX(CAST(g.HasSpecialEditAccess AS TINYINT)),0)
		FROM [User.Session].Session s, [RDF.Security].Member m, [RDF.Security].[Group] g
		WHERE s.SessionID = @SessionID AND s.UserID IS NOT NULL
			AND s.UserID = m.UserID AND m.SecurityGroupID = g.SecurityGroupID
			
	IF @SecurityGroupID > -20
		SELECT @SecurityGroupID = (case when UserID is not null then -20 when IsBot = 1 then -1 else -10 end)
			FROM [User.Session].Session
			WHERE SessionID = @SessionID

END
GO
