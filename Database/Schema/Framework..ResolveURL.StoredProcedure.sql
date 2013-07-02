SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Framework.].[ResolveURL]
	@ApplicationName varchar(1000) = '',
    @param1 varchar(1000) = '',
	@param2 varchar(1000) = '',
	@param3 varchar(1000) = '',
	@param4 varchar(1000) = '',
	@param5 varchar(1000) = '',
	@param6 varchar(1000) = '',
	@param7 varchar(1000) = '',
	@param8 varchar(1000) = '',
	@param9 varchar(1000) = '',
	@SessionID uniqueidentifier = NULL,	 
	@RestURL varchar(MAX) = NULL,
	@UserAgent varchar(255) = NULL,
	@ContentType varchar(255) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Log request
	DECLARE @HistoryID INT
	INSERT INTO [User.Session].[History.ResolveURL]	(RequestDate, ApplicationName, param1, param2, param3, param4, param5, param6, param7, param8, param9, SessionID, RestURL, UserAgent, ContentType)
		SELECT GetDate(), @ApplicationName, @param1, @param2, @param3, @param4, @param5, @param6, @param7, @param8, @param9, @SessionID, @RestURL, @UserAgent, @ContentType
	SELECT @HistoryID = @@IDENTITY		 

	-- For dynamic sql
	DECLARE @sql nvarchar(max)

	-- Define variables needed to construct the output XML
	DECLARE @Resolved bit
	DECLARE @ErrorDescription varchar(max)
	DECLARE @ResponseURL varchar(1000)
	DECLARE @ResponseContentType varchar(255)
	DECLARE @ResponseStatusCode int
	DECLARE @ResponseRedirect bit
	DECLARE @ResponseIncludePostData bit

	-- Determine if this application has a custom resolver
	DECLARE @CustomResolver varchar(1000)
	SELECT @CustomResolver = Resolver
		FROM [Framework.].RestPath
		WHERE ApplicationName = @ApplicationName

	-- Resolve the URL
	SELECT @Resolved = 0
	IF @CustomResolver IS NOT NULL
	BEGIN
		-- Use a custom resolver
		SELECT @sql = 'EXEC ' + @CustomResolver 
			+ ' @ApplicationName = ''' + replace(@ApplicationName,'''','''''') + ''', '
			+ ' @param1 = ''' + replace(@param1,'''','''''') + ''', '
			+ ' @param2 = ''' + replace(@param2,'''','''''') + ''', '
			+ ' @param3 = ''' + replace(@param3,'''','''''') + ''', '
			+ ' @param4 = ''' + replace(@param4,'''','''''') + ''', '
			+ ' @param5 = ''' + replace(@param5,'''','''''') + ''', '
			+ ' @param6 = ''' + replace(@param6,'''','''''') + ''', '
			+ ' @param7 = ''' + replace(@param7,'''','''''') + ''', '
			+ ' @param8 = ''' + replace(@param8,'''','''''') + ''', '
			+ ' @param9 = ''' + replace(@param9,'''','''''') + ''', '
			+ ' @SessionID = ' + IsNull('''' + replace(@SessionID,'''','''''') + '''','NULL') + ', '
			+ ' @ContentType = ' + IsNull('''' + replace(@ContentType,'''','''''') + '''','NULL') + ', '
			+ ' @Resolved = @Resolved_OUT OUTPUT, '
			+ ' @ErrorDescription = @ErrorDescription_OUT OUTPUT, '
			+ ' @ResponseURL = @ResponseURL_OUT OUTPUT, '
			+ ' @ResponseContentType = @ResponseContentType_OUT OUTPUT, '
			+ ' @ResponseStatusCode = @ResponseStatusCode_OUT OUTPUT, '
			+ ' @ResponseRedirect = @ResponseRedirect_OUT OUTPUT, '
			+ ' @ResponseIncludePostData = @ResponseIncludePostData_OUT OUTPUT '
		EXEC sp_executesql @sql, 
			N'
				@Resolved_OUT bit OUTPUT,
				@ErrorDescription_OUT varchar(max) OUTPUT,
				@ResponseURL_OUT varchar(1000) OUTPUT,
				@ResponseContentType_OUT varchar(255) OUTPUT,
				@ResponseStatusCode_OUT int OUTPUT,
				@ResponseRedirect_OUT bit OUTPUT,
				@ResponseIncludePostData_OUT bit OUTPUT',
			@Resolved_OUT = @Resolved OUTPUT,
			@ErrorDescription_OUT = @ErrorDescription OUTPUT,
			@ResponseURL_OUT = @ResponseURL OUTPUT,
			@ResponseContentType_OUT = @ResponseContentType OUTPUT,
			@ResponseStatusCode_OUT = @ResponseStatusCode OUTPUT,
			@ResponseRedirect_OUT = @ResponseRedirect OUTPUT,
			@ResponseIncludePostData_OUT = @ResponseIncludePostData OUTPUT
	END
	ELSE
	BEGIN
		-- Use the default resolver
		SELECT	@Resolved = 1,
				@ErrorDescription = '', 
				@ResponseURL = BaseURL,
				@ResponseContentType = @ContentType,
				@ResponseStatusCode = 200,
				@ResponseRedirect = 0,
				@ResponseIncludePostData = 0
		    FROM [Framework.Alias].ApplicationBaseURL
			WHERE ApplicationName = @ApplicationName
		SELECT @ResponseURL = @ResponseURL + (CASE WHEN CHARINDEX('?',@ResponseURL) > 0 THEN '' ELSE '?' END)
			+ '&param1=' + @param1
			+ '&param2=' + @param2
			+ '&param3=' + @param3
			+ '&param4=' + @param4
			+ '&param5=' + @param5
			+ '&param6=' + @param6
			+ '&param7=' + @param7
			+ '&param8=' + @param8
			+ '&param9=' + @param9
	END
	-- Add standard parameters
	IF (@Resolved = 1) AND (@ResponseRedirect = 0)
	BEGIN
		SELECT @ResponseURL = @ResponseURL + (CASE WHEN CHARINDEX('?',@ResponseURL) > 0 THEN '' ELSE '?' END)
		SELECT @ResponseURL = @ResponseURL + '&SessionID=' + IsNull(CAST(@SessionID AS varchar(50)),'')
	END
	SELECT @ErrorDescription = IsNull(@ErrorDescription,'URL could not be resolved.')

	-- Log results
	UPDATE [User.Session].[History.ResolveURL]
		SET CustomResolver = @CustomResolver,
			Resolved = @Resolved,
			ErrorDescription = @ErrorDescription,
			ResponseURL = @ResponseURL,
			ResponseContentType = @ResponseContentType,
			ResponseStatusCode = @ResponseStatusCode,
			ResponseRedirect = @ResponseRedirect,
			ResponseIncludePostData = @ResponseIncludePostData
		WHERE HistoryID = @HistoryID

	-- Return results 
	SELECT	@Resolved Resolved, 
			@ErrorDescription ErrorDescription, 
			@ResponseURL ResponseURL,
			@ResponseContentType ResponseContentType,
			@ResponseStatusCode ResponseStatusCode,
			@ResponseRedirect ResponseRedirect,
			@ResponseIncludePostData ResponseIncludePostData,
			@SessionID RedirectHeaderSessionID


	/*
		Examples:

		EXEC [Framework.].[ResolveURL] @ApplicationName='profile', @param1='12345', @ContentType='application/rdf+xml'
		EXEC [Framework.].[ResolveURL] @ApplicationName='profile', @param1='12345', @param2='12345.rdf'
		EXEC [Framework.].[ResolveURL] @ApplicationName='profile', @param1='12345'
		EXEC [Framework.].[ResolveURL] @ApplicationName='display', @param1='12345', @SessionID = '16A199ED-07C5-436F-AB7D-0214792630A6'
		EXEC [Framework.].[ResolveURL] @ApplicationName='profile', @param1='12345', @param2='12345.rdf', @SessionID = '16A199ED-07C5-436F-AB7D-0214792630A6'

	*/

END
GO
