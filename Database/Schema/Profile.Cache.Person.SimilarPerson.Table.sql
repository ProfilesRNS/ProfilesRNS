SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Cache].[Person.SimilarPerson](
	[PersonID] [int] NOT NULL,
	[SimilarPersonID] [int] NOT NULL,
	[Weight] [float] NULL,
	[CoAuthor] [bit] NULL,
	[numberOfSubjectAreas] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC,
	[SimilarPersonID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
