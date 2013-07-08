SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [RDF.Stage].[Log.DataMap](
	[LogID] [bigint] IDENTITY(0,1) NOT NULL,
	[DataMapID] [int] NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[RunTimeMS] [int] NULL,
	[DataMapType] [tinyint] NULL,
	[NewNodes] [bigint] NULL,
	[UpdatedNodes] [bigint] NULL,
	[ExistingNodes] [bigint] NULL,
	[DeletedNodes] [bigint] NULL,
	[TotalNodes] [bigint] NULL,
	[NewTriples] [bigint] NULL,
	[UpdatedTriples] [bigint] NULL,
	[ExistingTriples] [bigint] NULL,
	[DeletedTriples] [bigint] NULL,
	[TotalTriples] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [missing_index_73290] ON [RDF.Stage].[Log.DataMap] 
(
	[DataMapID] ASC,
	[LogID] ASC
)
INCLUDE ( [RunTimeMS]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
