SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Cache].[Concept.Mesh.SimilarConcept](
	[MeshHeader] [nvarchar](255) NOT NULL,
	[SortOrder] [int] NOT NULL,
	[SimilarConcept] [nvarchar](255) NULL,
	[Weight] [float] NULL,
PRIMARY KEY CLUSTERED 
(
	[MeshHeader] ASC,
	[SortOrder] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
