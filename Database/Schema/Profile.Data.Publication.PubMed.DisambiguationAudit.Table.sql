SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Profile.Data].[Publication.PubMed.DisambiguationAudit](
	[BatchID] [uniqueidentifier] NULL,
	[BatchCount] [int] NULL,
	[PersonID] [int] NULL,
	[ServiceCallStart] [datetime] NULL,
	[ServiceCallEnd] [datetime] NULL,
	[ServiceCallPubsFound] [int] NULL,
	[ServiceCallNewPubs] [int] NULL,
	[ServiceCallExistingPubs] [int] NULL,
	[ServiceCallPubsAdded] [int] NULL,
	[ProcessEnd] [datetime] NULL,
	[Success] [bit] NULL,
	[ErrorText] [varchar](max) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
