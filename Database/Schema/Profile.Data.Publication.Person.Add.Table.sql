SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Data].[Publication.Person.Add](
	[PubID] [uniqueidentifier] NOT NULL,
	[PersonID] [int] NOT NULL,
	[PMID] [int] NULL,
	[MPID] [nvarchar](50) NULL,
 CONSTRAINT [PK__publications_add__37703C52] PRIMARY KEY CLUSTERED 
(
	[PubID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Profile.Data].[Publication.Person.Add]  WITH CHECK ADD  CONSTRAINT [FK_publications_add_person] FOREIGN KEY([PersonID])
REFERENCES [Profile.Data].[Person] ([PersonID])
GO
ALTER TABLE [Profile.Data].[Publication.Person.Add] CHECK CONSTRAINT [FK_publications_add_person]
GO
