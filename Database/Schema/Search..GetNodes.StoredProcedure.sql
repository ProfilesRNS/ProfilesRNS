SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Search.].[GetNodes]
	@SearchOptions XML,
	@SessionID UNIQUEIDENTIFIER = NULL,
	@Lookup BIT = 0,
	@UseCache VARCHAR(50) = 'Public'
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	/*
	
	EXEC [Search.].[GetNodes] @SearchOptions = '
	<SearchOptions>
		<MatchOptions>
			<SearchString ExactMatch="false">options for "lung cancer" treatment</SearchString>
			<ClassURI>http://xmlns.com/foaf/0.1/Person</ClassURI>
			<SearchFiltersList>
				<SearchFilter Property="http://xmlns.com/foaf/0.1/lastName" MatchType="Left">Smit</SearchFilter>
			</SearchFiltersList>
		</MatchOptions>
		<OutputOptions>
			<Offset>0</Offset>
			<Limit>5</Limit>
			<SortByList>
				<SortBy IsDesc="1" Property="http://xmlns.com/foaf/0.1/firstName" />
				<SortBy IsDesc="0" Property="http://xmlns.com/foaf/0.1/lastName" />
			</SortByList>
		</OutputOptions>	
	</SearchOptions>
	'
		
	*/
	
	-- Select either a lookup or a full search
	IF @Lookup = 1
	BEGIN
		-- Run a lookup
		EXEC [Search.].[LookupNodes] @SearchOptions = @SearchOptions, @SessionID = @SessionID
	END
	ELSE
	BEGIN
		-- Run a full search
		-- Determine the cache type if set to auto
		IF IsNull(@UseCache,'Auto') IN ('','Auto')
		BEGIN
			DECLARE @SecurityGroupID BIGINT, @HasSpecialViewAccess BIT
			EXEC [RDF.Security].GetSessionSecurityGroup @SessionID, @SecurityGroupID OUTPUT, @HasSpecialViewAccess OUTPUT
			SELECT @UseCache = (CASE WHEN @SecurityGroupID <= -30 THEN 'Private' ELSE 'Public' END)
		END
		-- Run the search based on the cache type
		IF @UseCache = 'Public'
			EXEC [Search.Cache].[Public.GetNodes] @SearchOptions = @SearchOptions, @SessionID = @SessionID
		ELSE IF @UseCache = 'Private'
			EXEC [Search.Cache].[Private.GetNodes] @SearchOptions = @SearchOptions, @SessionID = @SessionID
	END

END
GO
