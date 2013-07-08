SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Cache].[Concept.Mesh.Person](
	[PersonID] [int] NOT NULL,
	[MeshHeader] [nvarchar](255) NOT NULL,
	[NumPubsAll] [int] NULL,
	[NumPubsThis] [int] NULL,
	[Weight] [float] NULL,
	[FirstPublicationYear] [float] NULL,
	[LastPublicationYear] [float] NULL,
	[MaxAuthorWeight] [float] NULL,
	[WeightCategory] [tinyint] NULL,
	[FirstPubDate] [datetime] NULL,
	[LastPubDate] [datetime] NULL,
 CONSTRAINT [PK__UserMesh__5A846E65] PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC,
	[MeshHeader] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
