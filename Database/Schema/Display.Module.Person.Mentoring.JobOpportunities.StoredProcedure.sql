SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Display.Module].[Person.Mentoring.JobOpportunities]
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

	select @json = (Select OpportunityID as opportunityID, title as title, Description as jobDescription, URL as jobURL, Students as categoryStudents, Faculty as categoryFaculty, Fellows as categoryFellowsAndPostDocs, Staff as categoryResearchStaff from  [Profile.Data].[Person.Mentoring.JobOpportunities] where PersonID = @PersonID for json path, ROOT ('module_data'))
END
GO
