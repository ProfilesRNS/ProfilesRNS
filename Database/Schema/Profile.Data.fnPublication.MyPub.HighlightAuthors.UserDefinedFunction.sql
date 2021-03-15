SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [Profile.Data].[fnPublication.MyPub.HighlightAuthors]	(
	@Authors varchar(max),
	@FirstName varchar(50),
	@Middlename varchar(50),
	@LastName varchar(50)
)
RETURNS NVARCHAR(MAX) 
AS 
BEGIN

	DECLARE @highlightedAuthors NVARCHAR(MAX)

	if @Authors like '%' + @LastName  + ' '+ SUBSTRING(@FirstName, 1, 1) + isnull(SUBSTRING(@Middlename, 1, 1), '') + '%'
		SET @highlightedAuthors = replace(@Authors, @LastName  + ' '+ SUBSTRING(@FirstName, 1, 1) + isnull(SUBSTRING(@Middlename, 1, 1), ''), '<b>' + @LastName + ' ' + SUBSTRING(@FirstName, 1, 1) + case when @Middlename = '' then '' else isnull(SUBSTRING(@Middlename, 1, 1), '') end + '</b>')

	else if @Authors like '%' + @LastName  + ' '+ SUBSTRING(@FirstName, 1, 1) + ',%' 
		SET @highlightedAuthors = replace(@Authors, @LastName  + ' '+ SUBSTRING(@FirstName, 1, 1) + ',', '<b>' + @LastName + ' ' + SUBSTRING(@FirstName, 1, 1) + '</b>,')

	else if @Authors like '%' + @LastName  + ' '+ SUBSTRING(@FirstName, 1, 1)
		SET @highlightedAuthors = SUBSTRING(@Authors, 1, len(@authors) - len (@Lastname) - 2) + '<b>' + @LastName  + ' '+ SUBSTRING(@FirstName, 1, 1) + '</b>'

	RETURN @highlightedAuthors

END
GO
