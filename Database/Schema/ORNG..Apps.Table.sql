SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ORNG.].[Apps](
	[AppID] [int] NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[Url] [nvarchar](255) NULL,
	[PersonFilterID] [int] NULL,
	[RequiresRegistration] [bit] NOT NULL,
	[UnavailableMessage] [text] NULL,
	[OAuthSecret] [nvarchar](255) NULL,
	[Enabled] [bit] NOT NULL,
 CONSTRAINT [PK__app] PRIMARY KEY CLUSTERED 
(
	[AppID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
ALTER TABLE [ORNG.].[Apps] ADD  CONSTRAINT [DF_orng_apps_enabled]  DEFAULT ((1)) FOR [Enabled]
GO
