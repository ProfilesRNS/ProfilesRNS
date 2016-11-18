SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

CREATE TABLE [Profile.Data].[Funding.DisambiguationAudit](
	[LogID] [bigint] IDENTITY(0,1) NOT NULL,
	[ServiceCallStart] [datetime] NULL,
	[ServiceCallEnd] [datetime] NULL,
	[ProcessEnd] [datetime] NULL,
	[Success] [bit] NULL,
	[ErrorText] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
