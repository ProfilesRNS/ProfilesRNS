SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Profile.Import].[Beta.DisplayPreference](
	[PersonID] [int] NOT NULL,
	[ShowPhoto] [char](1) NULL,
	[ShowPublications] [char](1) NULL,
	[ShowAwards] [char](1) NULL,
	[ShowNarrative] [char](1) NULL,
	[ShowAddress] [char](1) NULL,
	[ShowEmail] [char](1) NULL,
	[ShowPhone] [char](1) NULL,
	[ShowFax] [char](1) NULL,
	[PhotoPreference] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
