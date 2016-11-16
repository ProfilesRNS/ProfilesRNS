SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [Profile.Data].[Funding.DisambiguationResults](
	[PersonID] [int] NOT NULL,
	[FundingID] [varchar](50) NOT NULL,
	[FundingID2] [varchar](50) NULL,
	[Source] [varchar](50) NOT NULL,
	[GrantAwardedBy] [varchar](50) NULL,
	[StartDate] [date] NULL,
	[EndDate] [date] NULL,
	[PrincipalInvestigatorName] [varchar](100) NULL,
	[AgreementLabel] [varchar](500) NULL,
	[Abstract] [varchar](max) NULL,
	[RoleLabel] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC,
	[FundingID] ASC,
	[Source] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
