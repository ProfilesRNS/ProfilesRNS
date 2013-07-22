SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Profile.Data].[Publication.ISI.PubGeneral](
	[RecID] [int] NOT NULL,
	[InstId] [int] NULL,
	[Hot] [varchar](3) NULL,
	[SortKey] [bigint] NULL,
	[TimesCited] [int] NULL,
	[ItemIssue] [int] NULL,
	[CoverDate] [varchar](10) NULL,
	[RefKey] [int] NULL,
	[DBYear] [int] NULL,
	[Ut] [varchar](20) NULL,
	[ICKey] [varchar](50) NULL,
	[ICID] [varchar](20) NULL,
	[SourceTitle] [varchar](1000) NULL,
	[SourceAbbrev] [varchar](100) NULL,
	[ItemTitle] [varchar](4000) NULL,
	[BibId] [varchar](100) NULL,
	[BibPagesBegin] [varchar](20) NULL,
	[BibPagesEnd] [varchar](20) NULL,
	[BibPagesPages] [int] NULL,
	[BibPages] [varchar](255) NULL,
	[BibIssueYear] [int] NULL,
	[BibIssueVol] [varchar](10) NULL,
	[DocTypeCode] [varchar](3) NULL,
	[DocType] [varchar](100) NULL,
	[EditionsFull] [varchar](50) NULL,
	[LanguagesCount] [int] NULL,
	[AuthorsCount] [int] NULL,
	[EmailsCount] [int] NULL,
	[KeywordsCount] [int] NULL,
	[KeywordsPlusCount] [int] NULL,
	[RPAuthor] [varchar](100) NULL,
	[RPAddress] [varchar](1000) NULL,
	[RPOrganization] [varchar](1000) NULL,
	[RPCity] [varchar](255) NULL,
	[RPState] [varchar](50) NULL,
	[RPCountry] [varchar](50) NULL,
	[RPZipsCount] [int] NULL,
	[ResearchAddrsCount] [int] NULL,
	[AbstractAvail] [varchar](1) NULL,
	[AbstractCount] [int] NULL,
	[Abstract] [varchar](max) NULL,
	[RefsCount] [int] NULL,
	[PubDate] [datetime] NULL,
	[Authors] [varchar](4000) NULL,
	[DOI] [varchar](100) NULL,
 CONSTRAINT [PK__isi_pubs_general__6FF8854A] PRIMARY KEY CLUSTERED 
(
	[RecID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
