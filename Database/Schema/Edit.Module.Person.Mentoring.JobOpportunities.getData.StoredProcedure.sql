SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Edit.Module].[Person.Mentoring.JobOpportunities.getData]
	@Subject bigint=NULL
	, @PropertyURI [varchar](100)=NULL
	, @SessionID  UNIQUEIDENTIFIER = NULL
	, @JSON nvarchar(max) OUTPUT
AS
BEGIN
	declare @personID int
	select @personID = personID from [Profile.Cache].Person where NodeID = @Subject
	if exists (select 1 from [Profile.Data].[Person.Mentoring.JobOpportunities] where PersonID = @PersonID )
		select @json = (Select OpportunityID as opportunityId, title as title, Description as jobDescription, URL as jobURL, Students as categoryStudents, Faculty as categoryFaculty, Fellows as categoryFellowsAndPostDocs, Staff as categoryResearchStaff from  [Profile.Data].[Person.Mentoring.JobOpportunities] where PersonID = @PersonID order by SortOrder for json path)

	else
		select @json = '[]'
END
GO
