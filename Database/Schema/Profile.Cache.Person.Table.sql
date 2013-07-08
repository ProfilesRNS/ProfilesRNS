SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Profile.Cache].[Person](
	[PersonID] [int] NOT NULL,
	[UserID] [int] NULL,
	[InternalUsername] [nvarchar](100) NULL,
	[FirstName] [nvarchar](100) NULL,
	[LastName] [nvarchar](100) NULL,
	[DisplayName] [nvarchar](510) NULL,
	[AddressLine1] [nvarchar](255) NULL,
	[AddressLine2] [nvarchar](255) NULL,
	[AddressLine3] [nvarchar](255) NULL,
	[AddressLine4] [nvarchar](255) NULL,
	[AddressString] [nvarchar](2000) NULL,
	[Building] [nvarchar](510) NULL,
	[Room] [nvarchar](510) NULL,
	[Floor] [int] NULL,
	[Latitude] [decimal](18, 14) NULL,
	[Longitude] [decimal](18, 14) NULL,
	[Phone] [nvarchar](70) NULL,
	[Fax] [nvarchar](50) NULL,
	[EmailAddr] [nvarchar](510) NULL,
	[InstitutionName] [nvarchar](1000) NULL,
	[InstitutionAbbreviation] [nvarchar](100) NULL,
	[DepartmentName] [nvarchar](1000) NULL,
	[DivisionFullName] [nvarchar](1000) NULL,
	[FacultyRank] [varchar](100) NULL,
	[FacultyRankSort] [tinyint] NULL,
	[IsActive] [bit] NULL,
	[ShowAddress] [char](1) NULL,
	[ShowPhone] [char](1) NULL,
	[Showfax] [char](1) NULL,
	[ShowEmail] [char](1) NULL,
	[ShowPhoto] [char](1) NULL,
	[ShowAwards] [char](1) NULL,
	[ShowNarrative] [char](1) NULL,
	[ShowPublications] [char](1) NULL,
	[Visible] [bit] NULL,
	[NumPublications] [int] NULL,
	[PersonXML] [xml] NULL,
	[HasPublications] [bit] NULL,
	[HasSNA] [bit] NULL,
	[Reach1] [int] NULL,
	[Reach2] [int] NULL,
	[Closeness] [float] NULL,
	[Betweenness] [float] NULL,
 CONSTRAINT [PK_cache_person] PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [Person_Department] ON [Profile.Cache].[Person] 
(
	[DepartmentName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
