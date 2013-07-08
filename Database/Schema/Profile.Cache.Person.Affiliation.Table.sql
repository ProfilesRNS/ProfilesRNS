SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Profile.Cache].[Person.Affiliation](
	[PersonID] [int] NOT NULL,
	[SortOrder] [int] NOT NULL,
	[IsPrimary] [bit] NULL,
	[Title] [varchar](max) NULL,
	[InstititutionName] [varchar](200) NULL,
	[InstitutionAbbreviation] [varchar](100) NULL,
	[DepartmentName] [varchar](200) NULL,
	[DivisionName] [varchar](200) NULL,
	[FacultyRank] [varchar](200) NULL,
 CONSTRAINT [PK_cache_person_affiliations] PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC,
	[SortOrder] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
