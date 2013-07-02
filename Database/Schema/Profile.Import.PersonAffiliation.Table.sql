SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Profile.Import].[PersonAffiliation](
	[internalusername] [nvarchar](1000) NULL,
	[title] [nvarchar](1000) NULL,
	[emailaddr] [nvarchar](1000) NULL,
	[primaryaffiliation] [bit] NULL,
	[affiliationorder] [tinyint] NULL,
	[institutionname] [nvarchar](1000) NULL,
	[institutionabbreviation] [nvarchar](1000) NULL,
	[departmentname] [nvarchar](1000) NULL,
	[departmentvisible] [bit] NULL,
	[divisionname] [nvarchar](1000) NULL,
	[facultyrank] [varchar](1000) NULL,
	[facultyrankorder] [tinyint] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE NONCLUSTERED INDEX [missing_index_152] ON [Profile.Import].[PersonAffiliation] 
(
	[facultyrankorder] ASC
)
INCLUDE ( [facultyrank]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [missing_index_158] ON [Profile.Import].[PersonAffiliation] 
(
	[facultyrankorder] ASC
)
INCLUDE ( [facultyrank]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [missing_index_1811_1810] ON [Profile.Import].[PersonAffiliation] 
(
	[facultyrankorder] ASC
)
INCLUDE ( [facultyrank]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
