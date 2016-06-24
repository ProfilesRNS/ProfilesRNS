SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

CREATE TABLE [Profile.Data].[Funding.Agreement](
	[FundingAgreementID] [varchar](50) NOT NULL,
	[FundingID] [varchar](50) NULL,
	[AgreementLabel] [varchar](2000) NULL,
	[GrantAwardedBy] [varchar](1000) NULL,
	[StartDate] [date] NULL,
	[EndDate] [date] NULL,
	[PrincipalInvestigatorName] [varchar](100) NULL,
	[Abstract] [varchar](max) NULL,
	[Source] [varchar](20) NULL,
	[FundingID2] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[FundingAgreementID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
