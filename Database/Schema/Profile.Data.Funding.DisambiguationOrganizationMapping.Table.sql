SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [Profile.Data].[Funding.DisambiguationOrganizationMapping](
	[InstitutionID] [int] NULL,
	[Organization] [varchar](1000) NOT NULL
) ON [PRIMARY]

GO

