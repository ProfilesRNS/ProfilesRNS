SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Profile.Data].[Publication.DSpace.PubGeneral](
	[DashId] [int] NOT NULL,
	[Label] [varchar](max) NULL,
	[IssueDate] [smallint] NULL,
	[BibliographicCitation] [varchar](max) NULL,
	[Abstract] [varchar](max) NULL,
 CONSTRAINT [PK_dash_pubs_general] PRIMARY KEY CLUSTERED 
(
	[DashId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
