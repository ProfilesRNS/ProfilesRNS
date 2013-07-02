SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [User.Session].[History.ResolveURL](
	[HistoryID] [int] IDENTITY(0,1) NOT NULL,
	[RequestDate] [datetime] NULL,
	[ApplicationName] [varchar](1000) NULL,
	[param1] [varchar](1000) NULL,
	[param2] [varchar](1000) NULL,
	[param3] [varchar](1000) NULL,
	[param4] [varchar](1000) NULL,
	[param5] [varchar](1000) NULL,
	[param6] [varchar](1000) NULL,
	[param7] [varchar](1000) NULL,
	[param8] [varchar](1000) NULL,
	[param9] [varchar](1000) NULL,
	[SessionID] [uniqueidentifier] NULL,
	[RestURL] [varchar](max) NULL,
	[UserAgent] [varchar](255) NULL,
	[ContentType] [varchar](255) NULL,
	[CustomResolver] [varchar](1000) NULL,
	[Resolved] [bit] NULL,
	[ErrorDescription] [varchar](max) NULL,
	[ResponseURL] [varchar](1000) NULL,
	[ResponseContentType] [varchar](255) NULL,
	[ResponseStatusCode] [int] NULL,
	[ResponseRedirect] [bit] NULL,
	[ResponseIncludePostData] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[HistoryID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [IDX_Session_Date] ON [User.Session].[History.ResolveURL] 
(
	[SessionID] ASC,
	[RequestDate] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
