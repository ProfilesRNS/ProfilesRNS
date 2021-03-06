SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ORNG.].[AppData](
	[NodeID] [bigint] NOT NULL,
	[AppID] [int] NOT NULL,
	[Keyname] [nvarchar](255) NOT NULL,
	[Value] [nvarchar](4000) NULL,
	[CreatedDT] [datetime] NULL,
	[UpdatedDT] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING ON

GO
CREATE NONCLUSTERED INDEX [IDX_PersonApp] ON [ORNG.].[AppData]
(
	[NodeID] ASC,
	[AppID] ASC
)
INCLUDE ( 	[Keyname],
	[Value]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [ORNG.].[AppData] ADD  CONSTRAINT [DF_orng_appdata_createdDT]  DEFAULT (getdate()) FOR [CreatedDT]
GO
ALTER TABLE [ORNG.].[AppData] ADD  CONSTRAINT [DF_orng_appdata_updatedDT]  DEFAULT (getdate()) FOR [UpdatedDT]
GO
