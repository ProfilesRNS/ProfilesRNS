SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Search.].[GetConnection]
	@SearchOptions XML,
	@NodeID BIGINT = NULL,
	@NodeURI VARCHAR(400) = NULL,
	@SessionID UNIQUEIDENTIFIER = NULL,
	@UseCache VARCHAR(50) = 'Public'
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Determine the cache type if set to auto
	IF IsNull(@UseCache,'Auto') IN ('','Auto')
	BEGIN
		DECLARE @SecurityGroupID BIGINT, @HasSpecialViewAccess BIT
		EXEC [RDF.Security].GetSessionSecurityGroup @SessionID, @SecurityGroupID OUTPUT, @HasSpecialViewAccess OUTPUT
		SELECT @UseCache = (CASE WHEN @SecurityGroupID <= -30 THEN 'Private' ELSE 'Public' END)
	END

	-- Get connection based on the cache type
	IF @UseCache = 'Public'
		EXEC [Search.Cache].[Public.GetConnection] @SearchOptions = @SearchOptions, @NodeID = @NodeID, @NodeURI = @NodeURI, @SessionID = @SessionID
	ELSE IF @UseCache = 'Private'
		EXEC [Search.Cache].[Private.GetConnection] @SearchOptions = @SearchOptions, @NodeID = @NodeID, @NodeURI = @NodeURI, @SessionID = @SessionID

END
GO
