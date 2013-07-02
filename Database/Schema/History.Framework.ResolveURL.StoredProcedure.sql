SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [History.Framework].[ResolveURL]
@ApplicationName VARCHAR (1000)='', @param1 VARCHAR (1000)='', @param2 VARCHAR (1000)='', @param3 VARCHAR (1000)='', @param4 VARCHAR (1000)='', @param5 VARCHAR (1000)='', @param6 VARCHAR (1000)='', @param7 VARCHAR (1000)='', @param8 VARCHAR (1000)='', @param9 VARCHAR (1000)='', @SessionID UNIQUEIDENTIFIER=null, @ContentType VARCHAR (255)=null, @Resolved BIT OUTPUT, @ErrorDescription VARCHAR (MAX) OUTPUT, @ResponseURL VARCHAR (1000) OUTPUT, @ResponseContentType VARCHAR (255) OUTPUT, @ResponseStatusCode INT OUTPUT, @ResponseRedirect BIT OUTPUT, @ResponseIncludePostData BIT OUTPUT
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
	
	SELECT @REDIRECTPAGE = '~/history/default.aspx'

	-- Return results
	IF (@ErrorDescription IS NULL)
	BEGIN
	
		if(@Param1='list')
		BEGIN
			SELECT @Resolved = 1,
				@ErrorDescription = '',
				@ResponseURL = @REDIRECTPAGE + '?tab=list'
		END						

		if(@Param1='type')
		BEGIN
			SELECT @Resolved = 1,
				@ErrorDescription = '',
				@ResponseURL = @REDIRECTPAGE  + '?tab=type'									
		END		
	

set	@ResponseContentType =''
set	@ResponseStatusCode  =''
set	@ResponseRedirect =0
set	@ResponseIncludePostData =0



				
	END





END
GO
