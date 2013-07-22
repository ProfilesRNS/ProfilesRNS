SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Profile.Cache].[Concept.Mesh.Journal](
	[MeshHeader] [nvarchar](255) NOT NULL,
	[SortOrder] [int] NOT NULL,
	[Journal] [varchar](1000) NULL,
	[JournalTitle] [varchar](1000) NULL,
	[Weight] [float] NULL,
	[NumJournals] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[MeshHeader] ASC,
	[SortOrder] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
