SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
declare @resolved bit
declare @t uniqueidentifier
set @t = '719491AF-F4B2-48C0-B264-465D46730AB1';
	declare @ErrorDescription varchar(max) 
	declare @ResponseURL varchar(1000) 
	declare @ResponseContentType varchar(255) 
	declare @ResponseStatusCode int 
	declare @ResponseRedirect bit 
	declare @ResponseIncludePostData bit 



exec [Direct.Framework].[ResolveDirectURL] 'direct','directservice.aspx', 'asdf','','','','','','','',@t,'', @resolved output, 
	 @ErrorDescription output,
	 @ResponseURL output,
	 @ResponseContentType output,
	 @ResponseStatusCode output,
	 @ResponseRedirect output,
	 @ResponseIncludePostData output



select @ResponseURL

*/
CREATE PROCEDURE [Direct.Framework].[ResolveURL]
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
	@Resolved bit OUTPUT,
	@ErrorDescription varchar(max) OUTPUT,
	@ResponseURL varchar(1000) OUTPUT,
	@ResponseContentType varchar(255) OUTPUT,
	@ResponseStatusCode int OUTPUT,
	@ResponseRedirect bit OUTPUT,
	@ResponseIncludePostData bit OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	
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

	DECLARE @TabParam int
	SELECT @TabParam = 3

	DECLARE @REDIRECTPAGE VARCHAR(255)
	
	SELECT @REDIRECTPAGE = '~/direct/default.aspx'

	-- Return results
	IF (@ErrorDescription IS NULL)
	BEGIN

		if(@ApplicationName = 'direct' and @param1 <> '' and @param2 = '')
		BEGIN
			SELECT @Resolved = 1,
				@ErrorDescription = '',
				@ResponseURL = @REDIRECTPAGE + '?queryid=' + @param1
					
		END


		if(@ApplicationName = 'direct' and @param1 <> '' and @param2 <> '')
		BEGIN
			SELECT @Resolved = 1,
				@ErrorDescription = '',
				@ResponseURL = @REDIRECTPAGE + '?queryid=' + @param1 + '&stop=true'
					
		END
	
		set	@ResponseContentType =''
		set	@ResponseStatusCode  =''
		set	@ResponseRedirect =0
		set	@ResponseIncludePostData =0
				
	END

END
GO
