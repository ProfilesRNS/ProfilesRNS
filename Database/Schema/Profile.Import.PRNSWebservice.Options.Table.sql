SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Profile.Import].[PRNSWebservice.Options](
	[job] [varchar](100) NOT NULL,
	[url] [varchar](500) NULL,
	[options] [varchar](100) NULL,
	[apiKey] [varchar](100) NULL,
	[logLevel] [int] NULL,
	[batchSize] [int] NULL,
	[GetPostDataProc] [varchar](1000) NULL,
	[ImportDataProc] [varchar](1000) NULL,
PRIMARY KEY CLUSTERED 
(
	[job] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
