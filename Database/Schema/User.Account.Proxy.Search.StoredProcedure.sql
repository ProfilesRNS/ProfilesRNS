SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [User.Account].[Proxy.Search]
	@LastName nvarchar(100) = NULL,
	@FirstName nvarchar(100) = NULL,
	@Institution nvarchar(500) = NULL,
	@Department nvarchar(500) = NULL,
	@Division nvarchar(500) = NULL,
	@offset INT = 0,
	@limit INT = 20
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET nocount  ON;

	SELECT @offset = IsNull(@offset,0), @limit = IsNull(@limit,1000)
	SELECT @limit = 1000 WHERE @limit > 1000
	
	SELECT	@LastName = (CASE WHEN @LastName = '' THEN NULL ELSE @LastName END),
			@FirstName = (CASE WHEN @FirstName = '' THEN NULL ELSE @FirstName END),
			@Institution = (CASE WHEN @Institution = '' THEN NULL ELSE @Institution END),
			@Department = (CASE WHEN @Department = '' THEN NULL ELSE @Department END),
			@Division = (CASE WHEN @Division = '' THEN NULL ELSE @Division END)

	DECLARE @sql NVARCHAR(MAX)
	
	SELECT @sql = '
		SELECT UserID, DisplayName, Institution, Department, EmailAddr
			FROM (
				SELECT UserID, DisplayName, Institution, Department, EmailAddr, 
					row_number() over (order by LastName, FirstName, UserID) k
				FROM [User.Account].[User]
				WHERE IsActive = 1
					AND CanBeProxy = 1
					' + IsNull('AND FirstName LIKE '''+replace(@FirstName,'''','''''')+'%''','') + '
					' + IsNull('AND LastName LIKE '''+replace(@LastName,'''','''''')+'%''','') + '
					' + IsNull('AND Institution = '''+replace(@Institution,'''','''''')+'''','') + '
					' + IsNull('AND Department = '''+replace(@Department,'''','''''')+'''','') + '
					' + IsNull('AND Division = '''+replace(@Division,'''','''''')+'''','') + '
			) t
			WHERE (k >= ' + cast(@offset+1 as varchar(50)) + ') AND (k < ' + cast(@offset+@limit+1 as varchar(50)) + ')
			ORDER BY k
		'

	EXEC sp_executesql @sql

END
GO
