SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Profile.Data].[Publication.Person.Exclude](
	[PubID] [uniqueidentifier] NOT NULL,
	[PersonID] [int] NULL,
	[PMID] [int] NULL,
	[MPID] [nvarchar](50) NULL,
 CONSTRAINT [PK__publications_exc__3587F3E0] PRIMARY KEY CLUSTERED 
(
	[PubID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Profile.Data].[Publication.Person.Exclude]  WITH CHECK ADD  CONSTRAINT [FK_publications_exclude_person] FOREIGN KEY([PersonID])
REFERENCES [Profile.Data].[Person] ([PersonID])
GO
ALTER TABLE [Profile.Data].[Publication.Person.Exclude] CHECK CONSTRAINT [FK_publications_exclude_person]
GO
