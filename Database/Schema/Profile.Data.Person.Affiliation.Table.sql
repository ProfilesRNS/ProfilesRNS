SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Data].[Person.Affiliation](
	[PersonAffiliationID] [int] IDENTITY(1,1) NOT NULL,
	[PersonID] [int] NULL,
	[SortOrder] [int] NULL,
	[IsActive] [bit] NULL,
	[IsPrimary] [bit] NULL,
	[InstitutionID] [int] NULL,
	[DepartmentID] [int] NULL,
	[DivisionID] [int] NULL,
	[Title] [nvarchar](200) NULL,
	[EmailAddress] [nvarchar](200) NULL,
	[FacultyRankID] [int] NULL,
 CONSTRAINT [PK__person_affiliations] PRIMARY KEY CLUSTERED 
(
	[PersonAffiliationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UC_PrimaryAffiliation] UNIQUE NONCLUSTERED 
(
	[PersonID] ASC,
	[IsPrimary] ASC,
	[SortOrder] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
