SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Profile.Data].[Concept.Mesh.Qualifier](
	[DescriptorUI] [varchar](10) NOT NULL,
	[QualifierUI] [varchar](10) NOT NULL,
	[DescriptorName] [varchar](255) NULL,
	[QualifierName] [varchar](255) NULL,
	[Abbreviation] [varchar](2) NULL,
 CONSTRAINT [pk_mesh_qualifiers] PRIMARY KEY CLUSTERED 
(
	[DescriptorUI] ASC,
	[QualifierUI] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
