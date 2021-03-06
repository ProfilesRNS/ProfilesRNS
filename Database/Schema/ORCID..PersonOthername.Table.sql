SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ORCID.].[PersonOthername](
	[PersonOthernameID] [int] IDENTITY(1,1) NOT NULL,
	[PersonID] [int] NOT NULL,
	[OtherName] [nvarchar](500) NULL,
	[PersonMessageID] [int] NULL,
 CONSTRAINT [PK_PersonOthername] PRIMARY KEY CLUSTERED 
(
	[PersonOthernameID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [ORCID.].[PersonOthername]  WITH CHECK ADD  CONSTRAINT [fk_PersonOthername_Personid] FOREIGN KEY([PersonID])
REFERENCES [ORCID.].[Person] ([PersonID])
GO
ALTER TABLE [ORCID.].[PersonOthername] CHECK CONSTRAINT [fk_PersonOthername_Personid]
GO
ALTER TABLE [ORCID.].[PersonOthername]  WITH CHECK ADD  CONSTRAINT [fk_PersonOthername_PersonMessageid] FOREIGN KEY([PersonMessageID])
REFERENCES [ORCID.].[PersonMessage] ([PersonMessageID])
GO
ALTER TABLE [ORCID.].[PersonOthername] CHECK CONSTRAINT [fk_PersonOthername_PersonMessageid]
GO
