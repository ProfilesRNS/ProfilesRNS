SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Profile.Cache].[Concept.Mesh.PersonPublication](
	[PersonID] [int] NOT NULL,
	[MeshHeader] [nvarchar](255) NOT NULL,
	[PMID] [int] NOT NULL,
	[NumPubsAll] [int] NOT NULL,
	[NumPubsThis] [int] NULL,
	[TopicWeight] [decimal](7, 5) NULL,
	[AuthorWeight] [decimal](7, 5) NULL,
	[YearWeight] [decimal](7, 5) NULL,
	[UniquenessWeight] [float] NULL,
	[MeshWeight] [float] NULL,
	[AuthorPosition] [char](1) NULL,
	[PubYear] [int] NULL,
	[NumPeopleAll] [int] NULL,
	[PubDate] [datetime] NULL,
 CONSTRAINT [PK_cache_pub_mesh] PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC,
	[MeshHeader] ASC,
	[PMID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [idx_pmid] ON [Profile.Cache].[Concept.Mesh.PersonPublication] 
(
	[PMID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_ump] ON [Profile.Cache].[Concept.Mesh.PersonPublication] 
(
	[PersonID] ASC,
	[MeshHeader] ASC,
	[PMID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
