SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Framework].[ResolveURL]
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
	@SessionID uniqueidentifier = null,
	@ContentType varchar(255) = null,
	@Resolved bit = NULL OUTPUT,
	@ErrorDescription varchar(max) = NULL OUTPUT,
	@ResponseURL varchar(1000) = NULL OUTPUT,
	@ResponseContentType varchar(255) = NULL OUTPUT,
	@ResponseStatusCode int = NULL OUTPUT,
	@ResponseRedirect bit = NULL OUTPUT,
	@ResponseIncludePostData bit = NULL OUTPUT,
	@subject BIGINT = NULL OUTPUT,
	@predicate BIGINT = NULL OUTPUT,
	@object BIGINT = NULL OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- URL Pattern String:
	-- domainname	/{profile | display}	/{sNodeID | sAliasType/sAliasID}	/{pNodeID | pAliasType/pAliasID | sTab}	/{oNodeID | oAliasType/oAliasID | pTab}	/oTab	/sNodeID_pNodeID_oNodeID.rdf

	DECLARE @SessionHistory XML

	-- By default we were not able to resolve the URL
	SELECT @Resolved = 0

	-- Load param values into a table
	DECLARE @params TABLE (id int, val varchar(1000))
	INSERT INTO @params (id, val) VALUES (1, @param1)
	INSERT INTO @params (id, val) VALUES (2, @param2)
	INSERT INTO @params (id, val) VALUES (3, @param3)
	INSERT INTO @params (id, val) VALUES (4, @param4)
	INSERT INTO @params (id, val) VALUES (5, @param5)
	INSERT INTO @params (id, val) VALUES (6, @param6)
	INSERT INTO @params (id, val) VALUES (7, @param7)
	INSERT INTO @params (id, val) VALUES (8, @param8)
	INSERT INTO @params (id, val) VALUES (9, @param9)

	DECLARE @MaxParam int
	SELECT @MaxParam = 0
	SELECT @MaxParam = MAX(id) FROM @params WHERE val > ''

	DECLARE @Tab VARCHAR(1000)
	DECLARE @File VARCHAR(1000)
	DECLARE @ViewAs VARCHAR(50)
	
	SELECT @subject=NULL, @predicate=NULL, @object=NULL, @Tab=NULL, @File=NULL
	
	SELECT @File = val, @MaxParam = @MaxParam-1
		FROM @params
		WHERE id = @MaxParam and val like '%.%'

	DECLARE @pointer INT
	SELECT @pointer=1
	
	DECLARE @aliases INT
	SELECT @aliases = 0
	
	-- subject
	IF (@MaxParam >= @pointer)
	BEGIN
		SELECT @subject = CAST(val AS BIGINT), @pointer = @pointer + 1
			FROM @params 
			WHERE id=@pointer AND val NOT LIKE '%[^0-9]%'
		IF @subject IS NULL AND @MaxParam > @pointer
			SELECT @subject = NodeID, @pointer = @pointer + 2, @aliases = @aliases + 1
				FROM [RDF.].Alias 
				WHERE AliasType = (SELECT val FROM @params WHERE id = @pointer)
					AND AliasID = (SELECT val FROM @params WHERE id = @pointer+1)
		IF @subject IS NULL
			SELECT @ErrorDescription = 'The subject cannot be found.'
	END

	-- predicate
	IF (@MaxParam >= @pointer) AND (@subject IS NOT NULL)
	BEGIN
		SELECT @predicate = CAST(val AS BIGINT), @pointer = @pointer + 1
			FROM @params 
			WHERE id=@pointer AND val NOT LIKE '%[^0-9]%'
		IF @predicate IS NULL AND @MaxParam > @pointer
			SELECT @predicate = NodeID, @pointer = @pointer + 2, @aliases = @aliases + 1
				FROM [RDF.].Alias 
				WHERE AliasType = (SELECT val FROM @params WHERE id = @pointer)
					AND AliasID = (SELECT val FROM @params WHERE id = @pointer+1)
		IF @predicate IS NULL AND @MaxParam = @pointer
			SELECT @Tab=(SELECT val FROM @params WHERE id = @pointer)
		IF @predicate IS NULL AND @Tab IS NULL
			SELECT @ErrorDescription = 'The predicate cannot be found.'
	END
	
	-- object
	IF (@MaxParam >= @pointer) AND (@predicate IS NOT NULL)
	BEGIN
		SELECT @object = CAST(val AS BIGINT), @pointer = @pointer + 1
			FROM @params 
			WHERE id=@pointer AND val NOT LIKE '%[^0-9]%'
		IF @object IS NULL AND @MaxParam > @pointer
			SELECT @object = NodeID, @pointer = @pointer + 2, @aliases = @aliases + 1
				FROM [RDF.].Alias 
				WHERE AliasType = (SELECT val FROM @params WHERE id = @pointer)
					AND AliasID = (SELECT val FROM @params WHERE id = @pointer+1)
		IF @object IS NULL AND @MaxParam = @pointer
			SELECT @Tab=(SELECT val FROM @params WHERE id = @pointer)
		IF @object IS NULL AND @Tab IS NULL
			SELECT @ErrorDescription = 'The object cannot be found.'
	END
	
	-- tab
	IF (@MaxParam = @pointer) AND (@object IS NOT NULL) AND (@Tab IS NULL)
		SELECT @Tab=(SELECT val FROM @params WHERE id = @pointer)
	
	-- Return results
	IF (@ErrorDescription IS NULL)
	BEGIN

		declare @basePath nvarchar(400)
		select @basePath = value from [Framework.].Parameter where ParameterID = 'basePath'

		-- Default
		SELECT	@Resolved = 1,
				@ErrorDescription = '',
				@ResponseContentType = @ContentType,
				@ResponseStatusCode = 200,
				@ResponseRedirect = 0,
				@ResponseIncludePostData = 0,
				@ResponseURL = '~/profile/Profile.aspx?'
					+ 'subject=' + IsNull(cast(@subject as varchar(50)),'')
					+ '&predicate=' + IsNull(cast(@predicate as varchar(50)),'')
					+ '&object=' + IsNull(cast(@object as varchar(50)),'')
					+ '&tab=' + IsNull(@tab,'')
					+ '&file=' + IsNull(@file,'')

		DECLARE @FileRDF varchar(1000)
		SELECT @FileRDF =	IsNull(cast(@subject as varchar(50)),'')
							+IsNull('_'+cast(@predicate as varchar(50)),'')
							+IsNull('_'+cast(@object as varchar(50)),'')+'.rdf'

		DECLARE @FilePresentationXML varchar(1000)
		SELECT @FilePresentationXML = 'presentation_'
							+IsNull(cast(@subject as varchar(50)),'')
							+IsNull('_'+cast(@predicate as varchar(50)),'')
							+IsNull('_'+cast(@object as varchar(50)),'')+'.xml'

		IF (@ApplicationName = 'profile') AND (@File = @FileRDF)
				-- Display as RDF
				SELECT	@ResponseContentType = 'application/rdf+xml',
						@ResponseURL = @ResponseURL + '&viewas=RDF'
		ELSE IF (@ApplicationName = 'profile') AND (@File = @FilePresentationXML)
				-- Display PresentationXML
				SELECT	@ResponseContentType = 'application/rdf+xml',
						@ResponseURL = @ResponseURL + '&viewas=PresentationXML'
		ELSE IF (@ApplicationName = 'profile') AND (@ContentType = 'application/rdf+xml')
				-- Redirect 303 to the RDF URL
				SELECT	@ResponseContentType = 'application/rdf+xml',
						@ResponseStatusCode = 303,
						@ResponseRedirect = 1,
						@ResponseIncludePostData = 1,
						@ResponseURL = @basePath + '/profile'
							+ IsNull('/'+cast(@subject as varchar(50)),'')
							+ IsNull('/'+cast(@predicate as varchar(50)),'')
							+ IsNull('/'+cast(@object as varchar(50)),'')
							+ '/' + @FileRDF
		ELSE IF (@ApplicationName = 'profile')
				-- Redirect 303 to the HTML URL
				SELECT	@ResponseContentType = @ContentType,
						@ResponseStatusCode = 303,
						@ResponseRedirect = 1,
						@ResponseIncludePostData = 1,
						@ResponseURL = @basePath + '/display'
							+ (CASE WHEN @Subject IS NULL THEN ''
									ELSE IsNull((SELECT TOP 1 '/'+Subject
											FROM (
												SELECT 1 k, AliasType+'/'+AliasID Subject
													FROM [RDF.].Alias
													WHERE NodeID = @Subject AND Preferred = 1
												UNION ALL
												SELECT 2, CAST(@Subject AS VARCHAR(50))
											) t
											ORDER BY k, Subject),'')
									END)
							+ (CASE WHEN @Predicate IS NULL THEN ''
									ELSE IsNull((SELECT TOP 1 '/'+Subject
											FROM (
												SELECT 1 k, AliasType+'/'+AliasID Subject
													FROM [RDF.].Alias
													WHERE NodeID = @Predicate AND Preferred = 1
												UNION ALL
												SELECT 2, CAST(@Predicate AS VARCHAR(50))
											) t
											ORDER BY k, Subject),'')
									END)
							+ (CASE WHEN @Object IS NULL THEN ''
									ELSE IsNull((SELECT TOP 1 '/'+Subject
											FROM (
												SELECT 1 k, AliasType+'/'+AliasID Subject
													FROM [RDF.].Alias
													WHERE NodeID = @Object AND Preferred = 1
												UNION ALL
												SELECT 2, CAST(@Object AS VARCHAR(50))
											) t
											ORDER BY k, Subject),'')
									END)
							+ (CASE WHEN @MaxParam >= 1 AND @Pointer <= 1 THEN '/'+@param1 ELSE '' END)
							+ (CASE WHEN @MaxParam >= 2 AND @Pointer <= 2 THEN '/'+@param2 ELSE '' END)
							+ (CASE WHEN @MaxParam >= 3 AND @Pointer <= 3 THEN '/'+@param3 ELSE '' END)
							+ (CASE WHEN @MaxParam >= 4 AND @Pointer <= 4 THEN '/'+@param4 ELSE '' END)
							+ (CASE WHEN @MaxParam >= 5 AND @Pointer <= 5 THEN '/'+@param5 ELSE '' END)
							+ (CASE WHEN @MaxParam >= 6 AND @Pointer <= 6 THEN '/'+@param6 ELSE '' END)
							+ (CASE WHEN @MaxParam >= 7 AND @Pointer <= 7 THEN '/'+@param7 ELSE '' END)
							+ (CASE WHEN @MaxParam >= 8 AND @Pointer <= 8 THEN '/'+@param8 ELSE '' END)
							+ (CASE WHEN @MaxParam >= 9 AND @Pointer <= 9 THEN '/'+@param9 ELSE '' END)
		ELSE IF (@ApplicationName = 'presentation')
				-- Display as HTML
				SELECT	@ResponseURL = @ResponseURL + '&viewas=PresentationXML'
		ELSE
				-- Display as HTML
				SELECT	@ResponseURL = replace(@ResponseURL,'~/Profile/Profile.aspx','~/Profile/Display.aspx') + '&viewas=HTML'


		IF @ResponseRedirect = 0
			SELECT @ResponseURL = @ResponseURL + '&ContentType='+IsNull(@ResponseContentType,'') + '&StatusCode='+IsNull(cast(@ResponseStatusCode as varchar(50)),'')

	END

	/*
		Valid Rest Paths (T=text, N=numeric):

		T
		T/N
			T/N/N
				T/N/N/N
					T/N/N/N/T
				T/N/N/T
				T/N/N/T/T
					T/N/N/T/T/T
			T/N/T
			T/N/T/T
				T/N/T/T/N
					T/N/T/T/N/T
				T/N/T/T/T
				T/N/T/T/T/T
					T/N/T/T/T/T/T
		T/T/T
			T/T/T/N
				T/T/T/N/N
					T/T/T/N/N/T
				T/T/T/N/T
				T/T/T/N/T/T
					T/T/T/N/T/T/T
			T/T/T/T
			T/T/T/T/T
				T/T/T/T/T/N
					T/T/T/T/T/N/T
				T/T/T/T/T/T
				T/T/T/T/T/T/T
					T/T/T/T/T/T/T/T
	*/

END
GO
