SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Framework.].[Log.Job](
	[LogID] [int] IDENTITY(0,1) NOT NULL,
	[JobID] [int] NULL,
	[JobGroup] [int] NULL,
	[Step] [int] NULL,
	[Script] [nvarchar](max) NULL,
	[JobStart] [datetime] NULL,
	[JobEnd] [datetime] NULL,
	[Status] [varchar](50) NULL,
	[ErrorCode] [int] NULL,
	[ErrorMsg] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
