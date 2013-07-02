SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Ontology.].[ClassProperty](
	[ClassPropertyID] [int] NOT NULL,
	[Class] [varchar](400) NOT NULL,
	[NetworkProperty] [varchar](400) NULL,
	[Property] [varchar](400) NOT NULL,
	[IsDetail] [bit] NULL,
	[Limit] [int] NULL,
	[IncludeDescription] [bit] NULL,
	[IncludeNetwork] [bit] NULL,
	[SearchWeight] [float] NULL,
	[CustomDisplay] [bit] NULL,
	[CustomEdit] [bit] NULL,
	[ViewSecurityGroup] [bigint] NULL,
	[EditSecurityGroup] [bigint] NULL,
	[EditPermissionsSecurityGroup] [bigint] NULL,
	[EditExistingSecurityGroup] [bigint] NULL,
	[EditAddNewSecurityGroup] [bigint] NULL,
	[EditAddExistingSecurityGroup] [bigint] NULL,
	[EditDeleteSecurityGroup] [bigint] NULL,
	[MinCardinality] [int] NULL,
	[MaxCardinality] [int] NULL,
	[CustomDisplayModule] [xml] NULL,
	[CustomEditModule] [xml] NULL,
	[_ClassNode] [bigint] NULL,
	[_NetworkPropertyNode] [bigint] NULL,
	[_PropertyNode] [bigint] NULL,
	[_TagName] [nvarchar](1000) NULL,
	[_PropertyLabel] [nvarchar](400) NULL,
	[_ObjectType] [bit] NULL,
	[_NumberOfNodes] [bigint] NULL,
	[_NumberOfTriples] [bigint] NULL,
 CONSTRAINT [PK__ClassPro__D65A4C562D3171E7] PRIMARY KEY CLUSTERED 
(
	[ClassPropertyID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [idx__cndp] ON [Ontology.].[ClassProperty] 
(
	[_ClassNode] ASC,
	[_NetworkPropertyNode] ASC,
	[IsDetail] ASC,
	[_PropertyNode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx__cnp] ON [Ontology.].[ClassProperty] 
(
	[_ClassNode] ASC,
	[_NetworkPropertyNode] ASC,
	[_PropertyNode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_cndp] ON [Ontology.].[ClassProperty] 
(
	[Class] ASC,
	[NetworkProperty] ASC,
	[IsDetail] ASC,
	[Property] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
