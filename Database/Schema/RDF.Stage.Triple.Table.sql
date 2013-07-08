SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [RDF.Stage].[Triple](
	[StageTripleID] [bigint] IDENTITY(0,1) NOT NULL,
	[sCategory] [tinyint] NULL,
	[sURI] [nvarchar](400) NULL,
	[sValueHash] [binary](20) NULL,
	[sNodeType] [nvarchar](400) NULL,
	[sInternalType] [nvarchar](100) NULL,
	[sInternalID] [nvarchar](100) NULL,
	[sTripleID] [bigint] NULL,
	[sStageTripleID] [bigint] NULL,
	[sNodeID] [bigint] NULL,
	[sViewSecurityGroup] [bigint] NULL,
	[sEditSecurityGroup] [bigint] NULL,
	[pCategory] [tinyint] NULL,
	[pProperty] [nvarchar](400) NULL,
	[pValueHash] [binary](20) NULL,
	[pNodeID] [bigint] NULL,
	[pViewSecurityGroup] [bigint] NULL,
	[pEditSecurityGroup] [bigint] NULL,
	[oCategory] [tinyint] NULL,
	[oValue] [nvarchar](max) NULL,
	[oLanguage] [nvarchar](255) NULL,
	[oDataType] [nvarchar](255) NULL,
	[oObjectType] [bit] NULL,
	[oValueHash] [binary](20) NULL,
	[oNodeType] [nvarchar](400) NULL,
	[oInternalType] [nvarchar](100) NULL,
	[oInternalID] [nvarchar](100) NULL,
	[oTripleID] [bigint] NULL,
	[oStageTripleID] [bigint] NULL,
	[oStartTime] [nvarchar](100) NULL,
	[oEndTime] [nvarchar](100) NULL,
	[oTimePrecision] [nvarchar](100) NULL,
	[oNodeID] [bigint] NULL,
	[oViewSecurityGroup] [bigint] NULL,
	[oEditSecurityGroup] [bigint] NULL,
	[TripleHash] [binary](20) NULL,
	[TripleID] [bigint] NULL,
	[tViewSecurityGroup] [bigint] NULL,
	[Weight] [float] NULL,
	[SortOrder] [int] NULL,
	[Reitification] [bigint] NULL,
	[DataMapID] [int] NULL,
	[DataMapLink] [nvarchar](400) NULL,
	[Status] [int] NULL,
	[Graph] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[StageTripleID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
