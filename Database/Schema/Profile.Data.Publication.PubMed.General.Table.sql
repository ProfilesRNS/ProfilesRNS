SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Profile.Data].[Publication.PubMed.General](
	[PMID] [int] NOT NULL,
	[Owner] [varchar](50) NULL,
	[Status] [varchar](50) NULL,
	[PubModel] [varchar](50) NULL,
	[Volume] [varchar](255) NULL,
	[Issue] [varchar](255) NULL,
	[MedlineDate] [varchar](255) NULL,
	[JournalYear] [varchar](50) NULL,
	[JournalMonth] [varchar](50) NULL,
	[JournalDay] [varchar](50) NULL,
	[JournalTitle] [varchar](1000) NULL,
	[ISOAbbreviation] [varchar](100) NULL,
	[MedlineTA] [varchar](1000) NULL,
	[ArticleTitle] [varchar](4000) NULL,
	[MedlinePgn] [varchar](255) NULL,
	[AbstractText] [text] NULL,
	[ArticleDateType] [varchar](50) NULL,
	[ArticleYear] [varchar](10) NULL,
	[ArticleMonth] [varchar](10) NULL,
	[ArticleDay] [varchar](10) NULL,
	[Affiliation] [varchar](4000) NULL,
	[AuthorListCompleteYN] [varchar](1) NULL,
	[GrantListCompleteYN] [varchar](1) NULL,
	[PubDate] [datetime] NULL,
	[Authors] [varchar](4000) NULL,
PRIMARY KEY CLUSTERED 
(
	[PMID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
