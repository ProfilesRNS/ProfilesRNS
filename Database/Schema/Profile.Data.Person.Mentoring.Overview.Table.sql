SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
Create table [Profile.Data].[Person.Mentoring.Overview]
(
	PersonID int not null Primary key,
	JSON nvarchar(max),
	OverviewText nvarchar(max),
)
GO
