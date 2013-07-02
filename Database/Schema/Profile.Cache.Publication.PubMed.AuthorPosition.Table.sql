SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Profile.Cache].[Publication.PubMed.AuthorPosition](
	[PersonID] [int] NOT NULL,
	[PMID] [int] NOT NULL,
	[AuthorPosition] [char](1) NULL,
	[AuthorWeight] [float] NULL,
	[PubDate] [datetime] NULL,
	[PubYear] [int] NULL,
	[YearWeight] [float] NULL,
	[authorRank] [int] NULL,
	[numberOfAuthors] [int] NULL,
	[authorNameAsListed] [varchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC,
	[PMID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
