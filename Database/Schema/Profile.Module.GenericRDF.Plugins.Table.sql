SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Module].[GenericRDF.Plugins](
	[Name] [varchar](55) NOT NULL,
	[EnabledForPerson] [bit] NOT NULL,
	[EnabledForGroup] [bit] NOT NULL,
	[Label] [varchar](55) NOT NULL,
	[PropertyGroupURI] [varchar](400) NULL,
	[CustomDisplayModule] [varchar](max) NULL,
	[CustomEditModule] [varchar](max) NULL,
	[CustomDisplayModuleXML] [xml] NULL,
	[CustomEditModuleXML] [xml] NULL,
PRIMARY KEY CLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
