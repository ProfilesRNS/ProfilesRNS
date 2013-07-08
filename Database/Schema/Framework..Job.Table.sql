SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Framework.].[Job](
	[JobID] [int] NOT NULL,
	[JobGroup] [int] NULL,
	[Step] [int] NULL,
	[IsActive] [bit] NULL,
	[Script] [nvarchar](max) NULL,
	[Status] [varchar](50) NULL,
	[LastStart] [datetime] NULL,
	[LastEnd] [datetime] NULL,
	[ErrorCode] [int] NULL,
	[ErrorMsg] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[JobID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
