SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Profile.Data].[Publication.Type](
	[pubidtype_id] [varchar](20) NOT NULL,
	[name] [varchar](100) NULL,
	[sort_order] [int] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
