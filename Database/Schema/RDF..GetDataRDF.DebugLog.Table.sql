SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [RDF.].[GetDataRDF.DebugLog](
	[LogID] [int] IDENTITY(1,1) NOT NULL,
	[subject] [bigint] NULL,
	[predicate] [bigint] NULL,
	[object] [bigint] NULL,
	[offset] [bigint] NULL,
	[limit] [bigint] NULL,
	[showDetails] [bit] NULL,
	[expand] [bit] NULL,
	[SessionID] [uniqueidentifier] NULL,
	[StartDate] [datetime] NULL,
	[DurationMS] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
