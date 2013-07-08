SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Profile.Data].[Publication.PubMed.Databank](
	[PMID] [int] NOT NULL,
	[DataBankName] [varchar](100) NOT NULL,
 CONSTRAINT [PK_pm_pubs_databanks] PRIMARY KEY CLUSTERED 
(
	[PMID] ASC,
	[DataBankName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [Profile.Data].[Publication.PubMed.Databank]  WITH NOCHECK ADD  CONSTRAINT [FK_pm_pubs_databanks_pm_pubs_general] FOREIGN KEY([PMID])
REFERENCES [Profile.Data].[Publication.PubMed.General] ([PMID])
GO
ALTER TABLE [Profile.Data].[Publication.PubMed.Databank] CHECK CONSTRAINT [FK_pm_pubs_databanks_pm_pubs_general]
GO
