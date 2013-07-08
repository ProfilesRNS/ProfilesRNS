SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Profile.Data].[Concept.Mesh.Term](
	[DescriptorUI] [varchar](10) NOT NULL,
	[ConceptUI] [varchar](10) NOT NULL,
	[TermUI] [varchar](10) NOT NULL,
	[TermName] [varchar](255) NOT NULL,
	[DescriptorName] [varchar](255) NULL,
	[PreferredConceptYN] [varchar](1) NULL,
	[RelationName] [varchar](3) NULL,
	[ConceptName] [varchar](255) NULL,
	[ConceptPreferredTermYN] [varchar](1) NULL,
	[IsPermutedTermYN] [varchar](1) NULL,
	[LexicalTag] [varchar](3) NULL,
 CONSTRAINT [pk_mesh_terms] PRIMARY KEY CLUSTERED 
(
	[DescriptorUI] ASC,
	[ConceptUI] ASC,
	[TermUI] ASC,
	[TermName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
