SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Profile.Data].[Publication.PubMed.Keyword](
	[PMID] [int] NOT NULL,
	[Keyword] [varchar](255) NOT NULL,
	[MajorTopicYN] [char](1) NULL,
 CONSTRAINT [PK_pm_pubs_keywords] PRIMARY KEY CLUSTERED 
(
	[PMID] ASC,
	[Keyword] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [Profile.Data].[Publication.PubMed.Keyword]  WITH NOCHECK ADD  CONSTRAINT [FK_pm_pubs_keywords_pm_pubs_general] FOREIGN KEY([PMID])
REFERENCES [Profile.Data].[Publication.PubMed.General] ([PMID])
GO
ALTER TABLE [Profile.Data].[Publication.PubMed.Keyword] CHECK CONSTRAINT [FK_pm_pubs_keywords_pm_pubs_general]
GO
