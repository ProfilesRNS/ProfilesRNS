SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Ontology.Presentation].[Panel](
	[PresentationID] [int] NOT NULL,
	[Type] [varchar](100) NOT NULL,
	[TabSort] [int] NOT NULL,
	[TabType] [varchar](100) NULL,
	[Alias] [varchar](max) NULL,
	[Name] [varchar](max) NULL,
	[Icon] [varchar](max) NULL,
	[DisplayRule] [varchar](max) NULL,
	[ModuleXML] [xml] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
