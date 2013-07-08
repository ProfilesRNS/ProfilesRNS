SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Ontology.].[DataMap](
	[DataMapID] [int] NOT NULL,
	[DataMapGroup] [int] NULL,
	[IsAutoFeed] [bit] NULL,
	[Graph] [bigint] NULL,
	[Class] [varchar](400) NULL,
	[NetworkProperty] [varchar](400) NULL,
	[Property] [varchar](1000) NULL,
	[MapTable] [varchar](max) NULL,
	[sInternalType] [varchar](1000) NULL,
	[sInternalID] [varchar](1000) NULL,
	[cClass] [varchar](400) NULL,
	[cInternalType] [varchar](1000) NULL,
	[cInternalID] [varchar](1000) NULL,
	[oClass] [varchar](400) NULL,
	[oInternalType] [varchar](1000) NULL,
	[oInternalID] [varchar](1000) NULL,
	[oValue] [varchar](1000) NULL,
	[oDataType] [varchar](1000) NULL,
	[oLanguage] [varchar](1000) NULL,
	[oStartDate] [varchar](1000) NULL,
	[oStartDatePrecision] [varchar](1000) NULL,
	[oEndDate] [varchar](1000) NULL,
	[oEndDatePrecision] [varchar](1000) NULL,
	[oObjectType] [bit] NULL,
	[Weight] [varchar](1000) NULL,
	[OrderBy] [varchar](1000) NULL,
	[ViewSecurityGroup] [varchar](1000) NULL,
	[EditSecurityGroup] [varchar](1000) NULL,
	[_ClassNode] [bigint] NULL,
	[_NetworkPropertyNode] [bigint] NULL,
	[_PropertyNode] [bigint] NULL,
 CONSTRAINT [PK__DataMap__966C304141713BA7] PRIMARY KEY CLUSTERED 
(
	[DataMapID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_cnps] ON [Ontology.].[DataMap] 
(
	[Class] ASC,
	[NetworkProperty] ASC,
	[Property] ASC,
	[sInternalType] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
