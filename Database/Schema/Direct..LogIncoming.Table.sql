SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Direct.].[LogIncoming](
	[Details] [bit] NULL,
	[ReceivedDate] [datetime] NULL,
	[RequestIP] [varchar](16) NULL,
	[QueryString] [varchar](1000) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
