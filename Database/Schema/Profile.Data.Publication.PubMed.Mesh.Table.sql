SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Profile.Data].[Publication.PubMed.Mesh](
	[PMID] [int] NOT NULL,
	[DescriptorName] [varchar](255) NOT NULL,
	[QualifierName] [varchar](255) NOT NULL,
	[MajorTopicYN] [char](1) NULL,
 CONSTRAINT [PK_pm_pubs_mesh] PRIMARY KEY CLUSTERED 
(
	[PMID] ASC,
	[DescriptorName] ASC,
	[QualifierName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [idx_dq] ON [Profile.Data].[Publication.PubMed.Mesh] 
(
	[DescriptorName] ASC,
	[QualifierName] ASC,
	[MajorTopicYN] ASC,
	[PMID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
ALTER TABLE [Profile.Data].[Publication.PubMed.Mesh]  WITH NOCHECK ADD  CONSTRAINT [FK_pm_pubs_mesh_pm_pubs_general] FOREIGN KEY([PMID])
REFERENCES [Profile.Data].[Publication.PubMed.General] ([PMID])
GO
ALTER TABLE [Profile.Data].[Publication.PubMed.Mesh] CHECK CONSTRAINT [FK_pm_pubs_mesh_pm_pubs_general]
GO
