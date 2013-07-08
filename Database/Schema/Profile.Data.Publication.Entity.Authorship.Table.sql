SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Profile.Data].[Publication.Entity.Authorship](
	[EntityID] [int] IDENTITY(1,1) NOT NULL,
	[EntityName] [varchar](4000) NULL,
	[EntityDate] [datetime] NULL,
	[authorRank] [int] NULL,
	[numberOfAuthors] [int] NULL,
	[authorNameAsListed] [varchar](255) NULL,
	[authorWeight] [float] NULL,
	[authorPosition] [varchar](1) NULL,
	[PubYear] [int] NULL,
	[YearWeight] [float] NULL,
	[PersonID] [int] NULL,
	[InformationResourceID] [int] NULL,
	[SummaryXML] [xml] NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK__Publication.Enti__6B6EFF16] PRIMARY KEY CLUSTERED 
(
	[EntityID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [idx_PIR] ON [Profile.Data].[Publication.Entity.Authorship] 
(
	[PersonID] ASC,
	[InformationResourceID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_PublicationEntityAuthorshipIsActive] ON [Profile.Data].[Publication.Entity.Authorship] 
(
	[IsActive] ASC
)
INCLUDE ( [EntityID],
[EntityName],
[EntityDate],
[authorPosition],
[authorRank],
[PersonID],
[numberOfAuthors],
[authorWeight],
[YearWeight],
[InformationResourceID]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [missing_index_73175] ON [Profile.Data].[Publication.Entity.Authorship] 
(
	[IsActive] ASC
)
INCLUDE ( [EntityID],
[EntityName],
[EntityDate],
[authorPosition],
[authorRank],
[PersonID],
[numberOfAuthors],
[authorWeight],
[YearWeight],
[InformationResourceID]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
