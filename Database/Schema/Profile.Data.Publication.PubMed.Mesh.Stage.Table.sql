SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Profile.Data].[Publication.PubMed.Mesh.Stage](
	[PMID] [int] NOT NULL,
	[DescriptorName] [varchar](255) NOT NULL,
	[QualifierName] [varchar](255) NOT NULL,
	[MajorTopicYN] [char](1) NULL,
 CONSTRAINT [PK_pm_pubs_mesh_stage] PRIMARY KEY CLUSTERED 
(
	[PMID] ASC,
	[DescriptorName] ASC,
	[QualifierName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
