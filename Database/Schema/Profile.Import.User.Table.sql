SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Import].[User](
	[internalusername] [nvarchar](1000) NULL,
	[firstname] [nvarchar](1000) NULL,
	[lastname] [nvarchar](1000) NULL,
	[displayname] [nvarchar](1000) NULL,
	[institution] [nvarchar](1000) NULL,
	[department] [nvarchar](1000) NULL,
	[emailaddr] [nvarchar](1000) NULL,
	[canbeproxy] [bit] NULL
) ON [PRIMARY]
GO
