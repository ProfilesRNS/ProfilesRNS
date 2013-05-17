---------------------------------------------------------------------------------------------------------------------
--
--	Create Schema
--
---------------------------------------------------------------------------------------------------------------------

CREATE SCHEMA ORNG
GO

/****** Object:  Table [ORNG].[Visibility]    Script Date: 05/17/2013 13:23:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [ORNG].[Visibility](
	[visibility] [nvarchar](50) NOT NULL,
	[description] [nvarchar](255) NULL,
 CONSTRAINT [PK_ORNG.Visibility] PRIMARY KEY CLUSTERED 
(
	[visibility] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

---------------------------------------------------------------------------------------------------------------------
--
--	Create Tables and Indexes
--
---------------------------------------------------------------------------------------------------------------------
/****** Object:  Table [ORNG].[Apps]    Script Date: 05/17/2013 13:22:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [ORNG].[Apps](
	[appId] [int] NOT NULL,
	[name] [nvarchar](255) NOT NULL,
	[url] [nvarchar](255) NULL,
	[PersonFilterID] [int] NULL,
	[enabled] [bit] NOT NULL,
 CONSTRAINT [PK__app] PRIMARY KEY CLUSTERED 
(
	[appId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [ORNG].[Apps] ADD  CONSTRAINT [DF_orng_apps_enabled]  DEFAULT ((1)) FOR [enabled]
GO

/****** Object:  Table [ORNG].[AppViews]    Script Date: 05/17/2013 13:23:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [ORNG].[AppViews](
	[appId] [int] NOT NULL,
	[page] [nvarchar](50) NULL,
	[view] [nvarchar](50) NULL,
	[chromeId] [nvarchar](50) NULL,
	[visibility] [nvarchar](50) NULL,
	[display_order] [int] NULL,
	[opt_params] [nvarchar](255) NULL
) ON [PRIMARY]

GO

ALTER TABLE [ORNG].[AppViews]  WITH CHECK ADD  CONSTRAINT [FK_orng_app_views_apps] FOREIGN KEY([appId])
REFERENCES [ORNG].[Apps] ([appId])
GO

ALTER TABLE [ORNG].[AppViews] CHECK CONSTRAINT [FK_orng_app_views_apps]
GO

/****** Object:  Table [ORNG].[AppRegistry]    Script Date: 05/17/2013 13:23:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [ORNG].[AppRegistry](
	[appId] [int] NOT NULL,
	[personId] [nvarchar](255) NOT NULL,
	[createdDT] [datetime] NULL,
	[visibility] [nvarchar](50) NULL
) ON [PRIMARY]

GO

ALTER TABLE [ORNG].[AppRegistry]  WITH CHECK ADD  CONSTRAINT [FK_AppRegistry_Visibility] FOREIGN KEY([visibility])
REFERENCES [ORNG].[Visibility] ([visibility])
GO

ALTER TABLE [ORNG].[AppRegistry] CHECK CONSTRAINT [FK_AppRegistry_Visibility]
GO

ALTER TABLE [ORNG].[AppRegistry] ADD  CONSTRAINT [DF_orng_app_registry_createdDT]  DEFAULT (getdate()) FOR [createdDT]
GO

/****** Object:  Index [IX_AppRegistry_personId]    Script Date: 05/17/2013 13:26:51 ******/
CREATE CLUSTERED INDEX [IX_AppRegistry_personId] ON [ORNG].[AppRegistry] 
(
	[personId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

/****** Object:  Table [ORNG].[AppData]    Script Date: 05/17/2013 13:24:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [ORNG].[AppData](
	[userId] [nvarchar](255) NOT NULL,
	[appId] [int] NOT NULL,
	[keyname] [nvarchar](255) NOT NULL,
	[value] [nvarchar](4000) NULL,
	[createdDT] [datetime] NULL,
	[updatedDT] [datetime] NULL
) ON [PRIMARY]

GO

ALTER TABLE [ORNG].[AppData] ADD  CONSTRAINT [DF_orng_appdata_createdDT]  DEFAULT (getdate()) FOR [createdDT]
GO

ALTER TABLE [ORNG].[AppData] ADD  CONSTRAINT [DF_orng_appdata_updatedDT]  DEFAULT (getdate()) FOR [updatedDT]
GO

/****** Object:  Index [IDX_PersonApp]    Script Date: 05/17/2013 13:27:31 ******/
CREATE NONCLUSTERED INDEX [IDX_PersonApp] ON [ORNG].[AppData] 
(
	[userId] ASC,
	[appId] ASC
)
INCLUDE ( [keyname],
[value]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

/****** Object:  Table [ORNG].[Activity]    Script Date: 05/17/2013 13:24:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [ORNG].[Activity](
	[activityId] [int] IDENTITY(1,1) NOT NULL,
	[userId] [nvarchar](255) NULL,
	[appId] [int] NULL,
	[createdDT] [datetime] NULL,
	[activity] [xml] NULL,
 CONSTRAINT [PK__activity] PRIMARY KEY CLUSTERED 
(
	[activityId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [ORNG].[Activity] ADD  CONSTRAINT [DF_orng_activity_createdDT]  DEFAULT (getdate()) FOR [createdDT]
GO

/****** Object:  Table [ORNG].[Messages]    Script Date: 05/17/2013 13:25:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [ORNG].[Messages](
	[msgId] [nvarchar](255) NOT NULL,
	[senderId] [nvarchar](255) NULL,
	[recipientId] [nvarchar](255) NULL,
	[coll] [nvarchar](255) NULL,
	[title] [nvarchar](255) NULL,
	[body] [nvarchar](4000) NULL,
	[createdDT] [datetime] NULL
) ON [PRIMARY]

GO

ALTER TABLE [ORNG].[Messages] ADD  CONSTRAINT [DF_orng_messages_createdDT]  DEFAULT (getdate()) FOR [createdDT]
GO

---------------------------------------------------------------------------------------------------------------------
--
--	Create Stored Procedures
--
---------------------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [ORNG].[RegisterAppPerson]    Script Date: 05/17/2013 13:29:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  StoredProcedure [ORNG].[RegisterAppPerson]    Script Date: 09/23/2010 09:52:53 ******/
CREATE PROCEDURE [ORNG].[RegisterAppPerson](@userid nvarchar(255),@appId INT, @visibility nvarchar(50))
As
BEGIN
	SET NOCOUNT ON
		BEGIN TRAN		
			DECLARE @PERSON_FILTER_ID INT
			DECLARE @PROFILE_ID INT
			SELECT @PERSON_FILTER_ID = (SELECT PersonFilterID FROM Apps WHERE appId = @appId)
			SELECT @PROFILE_ID = cast(InternalID as INT) from [RDF.Stage].InternalNodeMap where
				NodeID = cast(RIGHT(@userid, CHARINDEX('/', REVERSE(@userId))-1) as INT)

			IF ((SELECT COUNT(*) FROM AppRegistry WHERE appId = @appId AND personId = @userId) = 0)
				INSERT [ORNG].[AppRegistry](appId, personId, [visibility]) values (@appId, @userId, @visibility)
			ELSE 
				UPDATE [ORNG].[AppRegistry] set [visibility] = @visibility where appId = @appId and personId =  @userId
								
			IF (@PERSON_FILTER_ID IS NOT NULL) 
				BEGIN
					IF (@visibility = 'Public') 
						INSERT [Profile.Data].[Person.FilterRelationship](personID, personFilterId) values (@PROFILE_ID, @PERSON_FILTER_ID)
					ELSE						
						DELETE FROM [Profile.Data].[Person.FilterRelationship] WHERE personId = @PROFILE_ID AND personFilterId = @PERSON_FILTER_ID
				END
		COMMIT
END

/****** Object:  StoredProcedure [ORNG].[UpsertAppData]    Script Date: 08/31/2011 14:35:13 ******/
SET ANSI_NULLS ON
GO

/****** Object:  StoredProcedure [ORNG].[UpsertAppData]    Script Date: 05/17/2013 13:30:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




/****** Object:  StoredProcedure [ORNG].[UpsertAppData]    Script Date: 09/23/2010 09:53:03 ******/
CREATE PROCEDURE [ORNG].[UpsertAppData](@userid nvarchar(255),@appId INT, @keyname nvarchar(255),@value nvarchar(4000))
As
BEGIN
	SET NOCOUNT ON
		BEGIN TRAN				 
			IF (SELECT COUNT(*) FROM AppData WHERE userId = @userId AND appId = @appId and keyname = @keyName) > 0
				UPDATE [ORNG].[AppData] set [value] = @value, updatedDT = GETDATE() WHERE userId = @userId AND appId = @appId and keyname = @keyName
			ELSE
				INSERT [ORNG].[AppData] (userId, appId, keyname, [value]) values (@userId, @appId, @keyname, @value)
		COMMIT
END								

/****** Object:  StoredProcedure [ORNG].[DeleteAppData]    Script Date: 08/31/2011 14:35:55 ******/
SET ANSI_NULLS ON
GO

/****** Object:  StoredProcedure [ORNG].[DeleteAppData]    Script Date: 05/17/2013 13:30:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  StoredProcedure [ORNG].[DeleteAppData]    Script Date: 09/23/2010 09:53:12 ******/
CREATE PROCEDURE [ORNG].[DeleteAppData](@userid nvarchar(255),@appId INT, @keyname nvarchar(255))
As
BEGIN
	SET NOCOUNT ON
		BEGIN TRAN				 
			DELETE [ORNG].[AppData] WHERE userId = @userId AND appId = @appId and keyname = @keyName
			-- if keyname is VISIBLE, do more
			IF (@keyname = 'VISIBLE' ) 
				EXEC [ORNG].[RegisterAppPerson] @userid, @appId, 0
		COMMIT
END		

GO

---------------------------------------------------------------------------------------------------------------------
--
--	Create Required Data
--
---------------------------------------------------------------------------------------------------------------------
INSERT [ORNG].[Visibility] VALUES('IsRegistered','Visible if the viewer has an entry for this gadget in the AppRegistry table. Useful for powerful "limited use" gadgets.');
INSERT [ORNG].[Visibility] VALUES('Nobody','Visible to nobody, not even the owner or proxies.');
INSERT [ORNG].[Visibility] VALUES('Private','Visible only to the owner, their proxies and default proxies.');
INSERT [ORNG].[Visibility] VALUES('Public','Visible to any viewer, including robots and anonymous.');
INSERT [ORNG].[Visibility] VALUES('RegistryDefined','Visibility is determined by the owner, as defined by the visibility column in the AppRegistry table.');
INSERT [ORNG].[Visibility] VALUES('Users','Only visible to logged in users.');


