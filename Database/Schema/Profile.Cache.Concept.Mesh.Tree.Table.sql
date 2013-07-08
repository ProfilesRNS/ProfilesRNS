SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Cache].[Concept.Mesh.Tree](
	[MeshCode] [nvarchar](255) NOT NULL,
	[MeshHeader] [nvarchar](255) NULL,
	[NumPublications] [int] NULL,
	[NumFaculty] [int] NULL,
	[Weight] [float] NULL,
	[TotPublications] [int] NULL,
	[TotWeight] [float] NULL,
PRIMARY KEY CLUSTERED 
(
	[MeshCode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
