SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Cache].[Person.PhysicalNeighbor](
	[PersonID] [int] NOT NULL,
	[NeighborID] [int] NOT NULL,
	[Distance] [tinyint] NULL,
	[DisplayName] [nvarchar](255) NULL,
	[MyNeighbors] [nvarchar](100) NULL,
 CONSTRAINT [PK__cache_physical_n__39D17EC3] PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC,
	[NeighborID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
