SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Direct.].[Sites](
	[SiteID] [int] NOT NULL,
	[BootstrapURL] [varchar](255) NULL,
	[SiteName] [varchar](500) NULL,
	[QueryURL] [varchar](255) NULL,
	[SortOrder] [int] NULL,
	[IsActive] [bit] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
