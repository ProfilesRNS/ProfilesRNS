SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Edit.Module].[AddUpdateDataLog](
	[AddUpdateDataLogID] [int] IDENTITY(1,1) NOT NULL,
	[UpdateDate] [datetime] NOT NULL,
	[Subject] [bigint] NULL,
	[PropertyURI] [varchar](max) NULL,
	[Json] [nvarchar](max) NULL,
	[SessionID] [uniqueidentifier] NULL,
	[Status] [varchar](max) NULL,
	ViewSecurityGroup bigint NULL,
PRIMARY KEY CLUSTERED 
(
	[AddUpdateDataLogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
