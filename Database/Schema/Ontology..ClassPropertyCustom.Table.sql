SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Ontology.].[ClassPropertyCustom](
	[ClassPropertyCustomTypeID] [int] NOT NULL,
	[Class] [varchar](400) NOT NULL,
	[NetworkProperty] [varchar](400) NULL,
	[Property] [varchar](400) NOT NULL,
	[IncludeProperty] [bit] NULL,
	[Limit] [int] NULL,
	[IncludeNetwork] [bit] NULL,
	[IncludeDescription] [bit] NULL,
	[IsDetail] [bit] NULL,
	[_ClassPropertyID] [int] NOT NULL,
 CONSTRAINT [PK_ClassPropertyCustom] PRIMARY KEY CLUSTERED 
(
	[ClassPropertyCustomTypeID] ASC,
	[_ClassPropertyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
