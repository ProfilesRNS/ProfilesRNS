SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [ORCID.].[PersonToken](
	[PersonTokenID] [int] IDENTITY(1,1) NOT NULL,
	[PersonID] [int] NOT NULL,
	[PermissionID] [tinyint] NOT NULL,
	[AccessToken] [varchar](50) NOT NULL,
	[TokenExpiration] [smalldatetime] NOT NULL,
	[RefreshToken] [varchar](50) NULL,
 CONSTRAINT [PK_PersonToken] PRIMARY KEY CLUSTERED 
(
	[PersonTokenID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [ORCID.].[PersonToken]  WITH CHECK ADD  CONSTRAINT [FK_PersonToken_Permissions] FOREIGN KEY([PermissionID])
REFERENCES [ORCID.].[REF_Permission] ([PermissionID])
GO
ALTER TABLE [ORCID.].[PersonToken] CHECK CONSTRAINT [FK_PersonToken_Permissions]
GO
ALTER TABLE [ORCID.].[PersonToken]  WITH CHECK ADD  CONSTRAINT [FK_PersonToken_Person] FOREIGN KEY([PersonID])
REFERENCES [ORCID.].[Person] ([PersonID])
GO
ALTER TABLE [ORCID.].[PersonToken] CHECK CONSTRAINT [FK_PersonToken_Person]
GO
