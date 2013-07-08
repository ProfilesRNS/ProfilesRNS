SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Profile.Data].[Publication.PubMed.Accession](
	[PMID] [int] NOT NULL,
	[DataBankName] [varchar](100) NOT NULL,
	[AccessionNumber] [varchar](50) NOT NULL,
 CONSTRAINT [PK_pm_pubs_accessions] PRIMARY KEY CLUSTERED 
(
	[PMID] ASC,
	[DataBankName] ASC,
	[AccessionNumber] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [Profile.Data].[Publication.PubMed.Accession]  WITH NOCHECK ADD  CONSTRAINT [FK_pm_pubs_accessions_pm_pubs_general] FOREIGN KEY([PMID])
REFERENCES [Profile.Data].[Publication.PubMed.General] ([PMID])
GO
ALTER TABLE [Profile.Data].[Publication.PubMed.Accession] CHECK CONSTRAINT [FK_pm_pubs_accessions_pm_pubs_general]
GO
