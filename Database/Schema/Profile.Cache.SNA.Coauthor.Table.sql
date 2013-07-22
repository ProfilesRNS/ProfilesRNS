SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Cache].[SNA.Coauthor](
	[PersonID1] [int] NOT NULL,
	[PersonID2] [int] NOT NULL,
	[i] [smallint] NULL,
	[j] [smallint] NULL,
	[w] [float] NULL,
	[FirstPubDate] [datetime] NULL,
	[LastPubDate] [datetime] NULL,
	[n] [int] NULL,
 CONSTRAINT [PK_sna_coauthors] PRIMARY KEY CLUSTERED 
(
	[PersonID1] ASC,
	[PersonID2] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
