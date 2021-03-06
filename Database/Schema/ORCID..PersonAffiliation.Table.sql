SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [ORCID.].[PersonAffiliation](
	[PersonAffiliationID] [int] IDENTITY(1,1) NOT NULL,
	[ProfilesID] [int] NOT NULL,
	[AffiliationTypeID] [tinyint] NOT NULL,
	[PersonID] [int] NOT NULL,
	[PersonMessageID] [int] NULL,
	[DecisionID] [tinyint] NOT NULL,
	[DepartmentName] [varchar](4000) NULL,
	[RoleTitle] [varchar](200) NULL,
	[StartDate] [smalldatetime] NULL,
	[EndDate] [smalldatetime] NULL,
	[OrganizationName] [varchar](4000) NOT NULL,
	[OrganizationCity] [varchar](4000) NULL,
	[OrganizationRegion] [varchar](2) NULL,
	[OrganizationCountry] [varchar](2) NULL,
	[DisambiguationID] [varchar](500) NULL,
	[DisambiguationSource] [varchar](500) NULL,
 CONSTRAINT [PK_PersonAffiliation] PRIMARY KEY CLUSTERED 
(
	[PersonAffiliationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [ORCID.].[PersonAffiliation]  WITH CHECK ADD  CONSTRAINT [FK_PersonAffiliation_Person] FOREIGN KEY([PersonID])
REFERENCES [ORCID.].[Person] ([PersonID])
GO
ALTER TABLE [ORCID.].[PersonAffiliation] CHECK CONSTRAINT [FK_PersonAffiliation_Person]
GO
ALTER TABLE [ORCID.].[PersonAffiliation]  WITH CHECK ADD  CONSTRAINT [FK_PersonAffiliation_PersonMessage] FOREIGN KEY([PersonMessageID])
REFERENCES [ORCID.].[PersonMessage] ([PersonMessageID])
GO
ALTER TABLE [ORCID.].[PersonAffiliation] CHECK CONSTRAINT [FK_PersonAffiliation_PersonMessage]
GO
ALTER TABLE [ORCID.].[PersonAffiliation]  WITH CHECK ADD  CONSTRAINT [FK_PersonAffiliation_REF_Decision] FOREIGN KEY([DecisionID])
REFERENCES [ORCID.].[REF_Decision] ([DecisionID])
GO
ALTER TABLE [ORCID.].[PersonAffiliation] CHECK CONSTRAINT [FK_PersonAffiliation_REF_Decision]
GO
