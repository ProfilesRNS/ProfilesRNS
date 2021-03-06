SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [ORCID.].[FieldLevelAuditTrail](
	[FieldLevelAuditTrailID] [bigint] IDENTITY(1,1) NOT NULL,
	[RecordLevelAuditTrailID] [bigint] NOT NULL,
	[MetaFieldID] [int] NOT NULL,
	[ValueBefore] [varchar](50) NULL,
	[ValueAfter] [varchar](50) NULL,
 CONSTRAINT [PK_FieldLevelAuditTrail] PRIMARY KEY CLUSTERED 
(
	[FieldLevelAuditTrailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [ORCID.].[FieldLevelAuditTrail]  WITH CHECK ADD  CONSTRAINT [FK_FieldLevelAuditTrail_RecordLevelAuditTrail] FOREIGN KEY([RecordLevelAuditTrailID])
REFERENCES [ORCID.].[RecordLevelAuditTrail] ([RecordLevelAuditTrailID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [ORCID.].[FieldLevelAuditTrail] CHECK CONSTRAINT [FK_FieldLevelAuditTrail_RecordLevelAuditTrail]
GO
