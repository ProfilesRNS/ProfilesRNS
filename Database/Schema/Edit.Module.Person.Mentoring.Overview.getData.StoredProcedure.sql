SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Edit.Module].[Person.Mentoring.Overview.getData]
	@Subject bigint=NULL
	, @PropertyURI [varchar](100)=NULL
	, @SessionID  UNIQUEIDENTIFIER = NULL
	, @JSON nvarchar(max) OUTPUT
AS
BEGIN
	declare @personID int
	select @personID = personID from [Profile.Cache].Person where NodeID = @Subject
	if exists (select 1 from [Profile.Data].[Person.Mentoring.Overview] where PersonID = @PersonID )
		select @json = JSON from [Profile.Data].[Person.Mentoring.Overview] where PersonID = @personID
	else
		select @json = '{}'
END
GO
