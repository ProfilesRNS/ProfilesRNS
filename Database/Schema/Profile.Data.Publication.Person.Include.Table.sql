SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Data].[Publication.Person.Include](
	[PubID] [uniqueidentifier] NOT NULL,
	[PersonID] [int] NULL,
	[PMID] [int] NULL,
	[MPID] [nvarchar](50) NULL,
 CONSTRAINT [PK__publications_inc__339FAB6E] PRIMARY KEY CLUSTERED 
(
	[PubID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_mu] ON [Profile.Data].[Publication.Person.Include] 
(
	[MPID] ASC,
	[PersonID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_pu] ON [Profile.Data].[Publication.Person.Include] 
(
	[PMID] ASC,
	[PersonID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_u] ON [Profile.Data].[Publication.Person.Include] 
(
	[PersonID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
ALTER TABLE [Profile.Data].[Publication.Person.Include]  WITH NOCHECK ADD  CONSTRAINT [FK_publications_include_my_pubs_general] FOREIGN KEY([MPID])
REFERENCES [Profile.Data].[Publication.MyPub.General] ([MPID])
GO
ALTER TABLE [Profile.Data].[Publication.Person.Include] CHECK CONSTRAINT [FK_publications_include_my_pubs_general]
GO
ALTER TABLE [Profile.Data].[Publication.Person.Include]  WITH NOCHECK ADD  CONSTRAINT [FK_publications_include_person] FOREIGN KEY([PersonID])
REFERENCES [Profile.Data].[Person] ([PersonID])
GO
ALTER TABLE [Profile.Data].[Publication.Person.Include] CHECK CONSTRAINT [FK_publications_include_person]
GO
ALTER TABLE [Profile.Data].[Publication.Person.Include]  WITH NOCHECK ADD  CONSTRAINT [FK_publications_include_pm_pubs_general] FOREIGN KEY([PMID])
REFERENCES [Profile.Data].[Publication.PubMed.General] ([PMID])
GO
ALTER TABLE [Profile.Data].[Publication.Person.Include] CHECK CONSTRAINT [FK_publications_include_pm_pubs_general]
GO
