SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Search.].[History.Query](
	[SearchHistoryQueryID] [int] IDENTITY(0,1) NOT NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[DurationMS] [int] NULL,
	[SessionID] [uniqueidentifier] NULL,
	[IsBot] [bit] NULL,
	[NumberOfConnections] [int] NULL,
	[SearchOptions] [xml] NULL,
PRIMARY KEY CLUSTERED 
(
	[SearchHistoryQueryID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
