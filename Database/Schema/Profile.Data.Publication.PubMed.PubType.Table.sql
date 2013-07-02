SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Profile.Data].[Publication.PubMed.PubType](
	[PMID] [int] NOT NULL,
	[PublicationType] [varchar](100) NOT NULL,
 CONSTRAINT [PK_pm_pubs_pubtypes] PRIMARY KEY CLUSTERED 
(
	[PMID] ASC,
	[PublicationType] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [Profile.Data].[Publication.PubMed.PubType]  WITH NOCHECK ADD  CONSTRAINT [FK_pm_pubs_pubtypes_pm_pubs_general] FOREIGN KEY([PMID])
REFERENCES [Profile.Data].[Publication.PubMed.General] ([PMID])
GO
ALTER TABLE [Profile.Data].[Publication.PubMed.PubType] CHECK CONSTRAINT [FK_pm_pubs_pubtypes_pm_pubs_general]
GO
