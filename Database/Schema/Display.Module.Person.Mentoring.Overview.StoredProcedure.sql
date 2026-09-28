SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Display.Module].[Person.Mentoring.Overview]
	@Subject bigint,
	@Predicate bigint,
	@tagName varchar(max),
	@object bigint,
	@oValue nvarchar(max),
	@SessionID  UNIQUEIDENTIFIER = NULL,
	@json nvarchar(max) output
AS
BEGIN
	declare @personID int
	select @personID = personID from [Profile.Cache].Person where NodeID = @Subject
	select @json = JSON from [Profile.Data].[Person.Mentoring.Overview] where PersonID = @personID
	select @json = (select JSON_QUERY(@json, '$') as module_data for json path, WITHOUT_ARRAY_WRAPPER)
END
GO
