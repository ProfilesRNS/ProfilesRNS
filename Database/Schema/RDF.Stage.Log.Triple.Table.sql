SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [RDF.Stage].[Log.Triple](
	[LogID] [bigint] IDENTITY(0,1) NOT NULL,
	[CompleteDate] [datetime] NULL,
	[NewNodes] [bigint] NULL,
	[NewTriples] [bigint] NULL,
	[FoundRecords] [bigint] NULL,
	[ProcessedRecords] [bigint] NULL,
	[TimeElapsed] [float] NULL,
PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
