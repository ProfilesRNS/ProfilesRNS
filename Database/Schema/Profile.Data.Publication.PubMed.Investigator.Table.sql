SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Profile.Data].[Publication.PubMed.Investigator](
	[PmPubsInvestigatorId] [int] IDENTITY(0,1) NOT NULL,
	[PMID] [int] NOT NULL,
	[LastName] [varchar](100) NULL,
	[FirstName] [varchar](100) NULL,
	[ForeName] [varchar](100) NULL,
	[Suffix] [varchar](20) NULL,
	[Initials] [varchar](20) NULL,
	[Affiliation] [varchar](1000) NULL,
PRIMARY KEY CLUSTERED 
(
	[PmPubsInvestigatorId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [Profile.Data].[Publication.PubMed.Investigator]  WITH NOCHECK ADD  CONSTRAINT [FK_pm_pubs_investigators_pm_pubs_general] FOREIGN KEY([PMID])
REFERENCES [Profile.Data].[Publication.PubMed.General] ([PMID])
GO
ALTER TABLE [Profile.Data].[Publication.PubMed.Investigator] CHECK CONSTRAINT [FK_pm_pubs_investigators_pm_pubs_general]
GO
