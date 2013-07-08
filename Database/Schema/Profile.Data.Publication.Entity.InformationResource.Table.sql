SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Profile.Data].[Publication.Entity.InformationResource](
	[EntityID] [int] IDENTITY(1,1) NOT NULL,
	[PMID] [int] NULL,
	[MPID] [nvarchar](50) NULL,
	[EntityName] [varchar](4000) NULL,
	[EntityDate] [datetime] NULL,
	[Reference] [varchar](max) NULL,
	[Source] [varchar](25) NULL,
	[URL] [varchar](2000) NULL,
	[PubYear] [int] NULL,
	[YearWeight] [float] NULL,
	[SummaryXML] [xml] NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK__Publication.Enti__6892926B] PRIMARY KEY CLUSTERED 
(
	[EntityID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [idx_mpid] ON [Profile.Data].[Publication.Entity.InformationResource] 
(
	[MPID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_pmid] ON [Profile.Data].[Publication.Entity.InformationResource] 
(
	[PMID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_PublicationEntityInformationResourceIsActive] ON [Profile.Data].[Publication.Entity.InformationResource] 
(
	[IsActive] ASC
)
INCLUDE ( [EntityID],
[PubYear],
[PMID],
[EntityDate],
[Reference]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [missing_index_73031] ON [Profile.Data].[Publication.Entity.InformationResource] 
(
	[IsActive] ASC
)
INCLUDE ( [EntityID],
[PubYear],
[PMID],
[EntityDate],
[Reference]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
