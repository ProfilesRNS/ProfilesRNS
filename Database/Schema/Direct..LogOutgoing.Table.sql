SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Direct.].[LogOutgoing](
	[FSID] [uniqueidentifier] NULL,
	[SiteID] [int] NULL,
	[Details] [bit] NULL,
	[SentDate] [datetime] NULL,
	[ResponseTime] [float] NULL,
	[ResponseState] [int] NULL,
	[ResponseStatus] [int] NULL,
	[ResultText] [varchar](4000) NULL,
	[ResultCount] [varchar](10) NULL,
	[ResultDetailsURL] [varchar](1000) NULL,
	[QueryString] [varchar](1000) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
