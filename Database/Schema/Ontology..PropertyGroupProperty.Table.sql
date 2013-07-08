SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Ontology.].[PropertyGroupProperty](
	[PropertyGroupURI] [varchar](400) NOT NULL,
	[PropertyURI] [nvarchar](400) NOT NULL,
	[SortOrder] [int] NULL,
	[CustomDisplayModule] [xml] NULL,
	[CustomEditModule] [xml] NULL,
	[_PropertyGroupNode] [bigint] NULL,
	[_PropertyNode] [bigint] NULL,
	[_TagName] [nvarchar](1000) NULL,
	[_PropertyLabel] [nvarchar](400) NULL,
	[_NumberOfNodes] [bigint] NULL,
 CONSTRAINT [PK__Property__1F57AE744D6D97C5] PRIMARY KEY CLUSTERED 
(
	[PropertyURI] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
