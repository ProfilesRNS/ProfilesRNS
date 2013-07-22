SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Cache].[Concept.Mesh.Count](
	[MeshHeader] [nvarchar](255) NOT NULL,
	[NumPublications] [int] NULL,
	[NumFaculty] [int] NULL,
	[Weight] [float] NULL,
	[RawWeight] [float] NULL,
 CONSTRAINT [PK__MeshCount__2B3F6F97] PRIMARY KEY CLUSTERED 
(
	[MeshHeader] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
