SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Profile.Data].[Publication.PubMed.Grant](
	[PMID] [int] NOT NULL,
	[GrantID] [varchar](50) NOT NULL,
	[Acronym] [varchar](50) NULL,
	[Agency] [varchar](1000) NULL,
 CONSTRAINT [PK_pm_pubs_grants] PRIMARY KEY CLUSTERED 
(
	[PMID] ASC,
	[GrantID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [Profile.Data].[Publication.PubMed.Grant]  WITH NOCHECK ADD  CONSTRAINT [FK_pm_pubs_grants_pm_pubs_general] FOREIGN KEY([PMID])
REFERENCES [Profile.Data].[Publication.PubMed.General] ([PMID])
GO
ALTER TABLE [Profile.Data].[Publication.PubMed.Grant] CHECK CONSTRAINT [FK_pm_pubs_grants_pm_pubs_general]
GO
