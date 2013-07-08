SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Profile.Data].[Publication.PubMed.Chemical](
	[PMID] [int] NOT NULL,
	[NameOfSubstance] [varchar](255) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [Profile.Data].[Publication.PubMed.Chemical]  WITH NOCHECK ADD  CONSTRAINT [FK_pm_pubs_chemicals_pm_pubs_general] FOREIGN KEY([PMID])
REFERENCES [Profile.Data].[Publication.PubMed.General] ([PMID])
GO
ALTER TABLE [Profile.Data].[Publication.PubMed.Chemical] CHECK CONSTRAINT [FK_pm_pubs_chemicals_pm_pubs_general]
GO
