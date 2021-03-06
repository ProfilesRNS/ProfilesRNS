SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [ORCID.].[PersonWork](
	[PersonWorkID] [int] IDENTITY(1,1) NOT NULL,
	[PersonID] [int] NOT NULL,
	[PersonMessageID] [int] NULL,
	[DecisionID] [tinyint] NOT NULL,
	[WorkTitle] [varchar](max) NOT NULL,
	[ShortDescription] [varchar](max) NULL,
	[WorkCitation] [varchar](max) NULL,
	[WorkType] [varchar](500) NULL,
	[URL] [varchar](1000) NULL,
	[SubTitle] [varchar](max) NULL,
	[WorkCitationType] [varchar](500) NULL,
	[PubDate] [smalldatetime] NULL,
	[PublicationMediaType] [varchar](500) NULL,
	[PubID] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_PersonWork] PRIMARY KEY CLUSTERED 
(
	[PersonWorkID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [ORCID.].[PersonWork]  WITH CHECK ADD  CONSTRAINT [FK_PersonWork_Person] FOREIGN KEY([PersonID])
REFERENCES [ORCID.].[Person] ([PersonID])
GO
ALTER TABLE [ORCID.].[PersonWork] CHECK CONSTRAINT [FK_PersonWork_Person]
GO
ALTER TABLE [ORCID.].[PersonWork]  WITH CHECK ADD  CONSTRAINT [FK_PersonWork_PersonMessage] FOREIGN KEY([PersonMessageID])
REFERENCES [ORCID.].[PersonMessage] ([PersonMessageID])
GO
ALTER TABLE [ORCID.].[PersonWork] CHECK CONSTRAINT [FK_PersonWork_PersonMessage]
GO
ALTER TABLE [ORCID.].[PersonWork]  WITH CHECK ADD  CONSTRAINT [FK_PersonWork_REF_Decision] FOREIGN KEY([DecisionID])
REFERENCES [ORCID.].[REF_Decision] ([DecisionID])
GO
ALTER TABLE [ORCID.].[PersonWork] CHECK CONSTRAINT [FK_PersonWork_REF_Decision]
GO
