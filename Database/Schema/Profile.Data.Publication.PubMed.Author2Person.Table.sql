SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Data].[Publication.PubMed.Author2Person](
	[PersonID] [int] NOT NULL,
	[PmPubsAuthorID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [Profile.Data].[Publication.PubMed.Author2Person]  WITH CHECK ADD  CONSTRAINT [FK_pm_authors2username_person] FOREIGN KEY([PersonID])
REFERENCES [Profile.Data].[Person] ([PersonID])
GO
ALTER TABLE [Profile.Data].[Publication.PubMed.Author2Person] CHECK CONSTRAINT [FK_pm_authors2username_person]
GO
ALTER TABLE [Profile.Data].[Publication.PubMed.Author2Person]  WITH NOCHECK ADD  CONSTRAINT [FK_pm_authors2username_pm_pubs_authors] FOREIGN KEY([PmPubsAuthorID])
REFERENCES [Profile.Data].[Publication.PubMed.Author] ([PmPubsAuthorID])
GO
ALTER TABLE [Profile.Data].[Publication.PubMed.Author2Person] CHECK CONSTRAINT [FK_pm_authors2username_pm_pubs_authors]
GO
