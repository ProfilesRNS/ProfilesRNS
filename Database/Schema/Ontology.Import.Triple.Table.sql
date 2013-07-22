SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Ontology.Import].[Triple](
	[OntologyTripleID] [int] IDENTITY(1,1) NOT NULL,
	[OWL] [nvarchar](100) NULL,
	[Graph] [bigint] NULL,
	[Subject] [nvarchar](max) NULL,
	[Predicate] [nvarchar](max) NULL,
	[Object] [nvarchar](max) NULL,
	[_SubjectNode] [bigint] NULL,
	[_PredicateNode] [bigint] NULL,
	[_ObjectNode] [bigint] NULL,
	[_TripleID] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[OntologyTripleID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
