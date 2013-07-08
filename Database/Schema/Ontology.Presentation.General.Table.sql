SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Ontology.Presentation].[General](
	[PresentationID] [int] NOT NULL,
	[Type] [char](1) NOT NULL,
	[Subject] [nvarchar](400) NULL,
	[Predicate] [nvarchar](400) NULL,
	[Object] [nvarchar](400) NULL,
	[PageColumns] [int] NULL,
	[WindowName] [varchar](max) NULL,
	[PageTitle] [varchar](max) NULL,
	[PageBackLinkName] [varchar](max) NULL,
	[PageBackLinkURL] [varchar](max) NULL,
	[PageSubTitle] [varchar](max) NULL,
	[PageDescription] [varchar](max) NULL,
	[PanelTabType] [varchar](max) NULL,
	[ExpandRDFList] [xml] NULL,
PRIMARY KEY CLUSTERED 
(
	[PresentationID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
