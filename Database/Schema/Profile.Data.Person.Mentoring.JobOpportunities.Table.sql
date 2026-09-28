SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Profile.Data].[Person.Mentoring.JobOpportunities]
(
	PersonID int not null,
	SortOrder int not null,
	OpportunityID uniqueIdentifier not null,
	Title nvarchar(max),
	Description nvarchar(max),
	URL varchar(max),
	Students bit,
	Faculty bit,
	Fellows bit,
	Staff bit
)
GO
